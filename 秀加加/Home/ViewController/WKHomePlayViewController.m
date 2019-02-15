//
//  WKHomePlayViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomePlayViewController.h"
#import "WKHomePlayBaseView.h"
#import "WKUserMessage.h"
#import "WKHomePlayModel.h"
#import "WKLiveViewController.h"
#import "WKUserMessageModel.h"
#import "WKMeViewController.h"
#import "NSObject+XWAdd.h"
#import "UIImage+Gif.h"
#import "WKAllWebViewController.h"

@interface WKHomePlayViewController ()

@property (strong, nonatomic) dispatch_source_t _timer;

@property (strong, nonatomic) WKHomePlayBaseView *homePlayView;

@property (strong, nonatomic) NSMutableArray * dataArr;

@property (assign, nonatomic) CGFloat count;

@property (strong, nonatomic) NSTimer * timer;

@property (assign, nonatomic) NSInteger timeCount;

@end

@implementation WKHomePlayViewController

-(WKHomePlayBaseView *)homePlayView{
    if (!_homePlayView) {
        WeakSelf(WKHomePlayViewController);
        _homePlayView = [[WKHomePlayBaseView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) andDataArr:self.dataArr cycle:NO block:^(NSInteger type, NSString *homeId) {
            if (type == -1) {
                [self loadingUserMessage:homeId];
            }else{
                WKHomePlayModel *model = self.dataArr[type];
                [self getShowInfoWith:model.MemberNo];
            }
        }];
        _homePlayView.requestBlock = ^(){
            [weakSelf loadingHotData];
        };
        
        _homePlayView.isOpenHeaderRefresh = YES;
        _homePlayView.scrollBlock = ^(CGFloat contentY){
            [weakSelf hiddenTabbarAndNavBar:contentY];
        };

        _homePlayView.endBlock = ^(){
            CGRect tabRect=weakSelf.tabBarController.tabBar.frame;
            CGRect navRect = weakSelf.navigationController.navigationBar.frame;
            if (tabRect.origin.y>WKScreenH-10 ) {
                tabRect.origin.y=WKScreenH+20;
                navRect.origin.y=-44;
                weakSelf.count = 0;
            }else{
                tabRect.origin.y=WKScreenH-49;
                navRect.origin.y=20;
                weakSelf.count = 64;
            }
            [UIView animateWithDuration:0.5f animations:^{
                [weakSelf.homePlayView setTabeViewFrame:CGRectMake(0, weakSelf.count, WKScreenW, WKScreenH-weakSelf.count)];
                weakSelf.tabBarController.tabBar.frame=tabRect;
                weakSelf.navigationController.navigationBar.frame = navRect;
            }completion:^(BOOL finished) {
                
            }];
        };
        
        _homePlayView.JumpBlock = ^(NSString *LinkURL)
        {
            [weakSelf JumpPage:LinkURL];
        };
    }
    return _homePlayView;
}

- (void)getShowInfoWith:(NSString *)memberNo{
    if ([memberNo isEqualToString:User.MemberNo]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMessage" object:nil];
        return;
    }
    
    [WKProgressHUD showLoadingGifText:@""];
    
    NSString *url = [NSString configUrl:WKMemberGetShowInfo With:@[@"MemberNo"] values:@[memberNo]];
    
    [WKHttpRequest getShowMemberInfo:HttpRequestMethodGet url:url model:NSStringFromClass([WKHomePlayModel class]) param:nil success:^(WKBaseResponse *response) {
        [WKProgressHUD dismiss];
        NSLog(@"response json : %@\n",response.json);
        
        if (response.Data) {
            WKLiveViewController *live = [[WKLiveViewController alloc] initWithHomeList:response.Data from:WKLiveFromHotSaler];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:live];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [WKProgressHUD showTopMessage:@"获取直播信息失败"];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

// 获得首页轮播图 1.进入页面 2.上拉刷新 3.退出直播间（暂时不加）
- (void)LoadScrollImage
{
    [WKHttpRequest getScrollImage:HttpRequestMethodGet url:GetScrollImage param:nil success:^(WKBaseResponse *response) {
        NSMutableArray *TempArray = [[NSMutableArray alloc]init];
        for (NSDictionary *item in response.Data) {
            WKScrollImageModel *imageModel =[WKScrollImageModel yy_modelWithDictionary:item];
            [TempArray addObject:imageModel];
        }
        _homePlayView.imageScrollList = TempArray;
        [_homePlayView reloadData];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

// 指定的连接地址跳转
-(void)JumpPage:(NSString *)LinkURL
{
    if(LinkURL!=nil && LinkURL.length>0)
    {
        WKAllWebViewController *actionVC = [[WKAllWebViewController alloc]init];
        actionVC.urlString = LinkURL;
        actionVC.titles = @"秀加加";
        [self.navigationController pushViewController:actionVC animated:YES];
    }
}

-(void)hiddenTabbarAndNavBar:(CGFloat)offSet{ //上滑+
    CGRect tabRect=self.tabBarController.tabBar.frame;
    tabRect.origin.y = tabRect.origin.y+offSet;
    CGRect navRect = self.navigationController.navigationBar.frame;
    navRect.origin.y = navRect.origin.y-offSet;
    if (tabRect.origin.y>WKScreenH+20) {
        tabRect.origin.y=WKScreenH+20;
    }
    if (tabRect.origin.y<=WKScreenH-49) {
        tabRect.origin.y=WKScreenH-49;
    }
    if (navRect.origin.y<-44) {
        navRect.origin.y=-44;
    }
    if (navRect.origin.y>=20) {
        navRect.origin.y=20;
    }
    self.count = self.count - offSet;
    if (self.count<0) {
        self.count = 0;
    }else if(self.count>64){
        self.count = 64;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.homePlayView setTabeViewFrame:CGRectMake(0, self.count, WKScreenW, WKScreenH-self.count)];
        self.tabBarController.tabBar.frame=tabRect;
        self.navigationController.navigationBar.frame = navRect;
    }completion:^(BOOL finished) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"searchType"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.count = 64;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.frame=CGRectMake(0, WKScreenH-49, WKScreenW, 49);
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, WKScreenW, 44);
    [self loadingHotData];
    [self.homePlayView setTabeViewFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64-49)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor redColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.homePlayView];
    [self xw_addNotificationForName:@"refreshHomeData" block:^(NSNotification * _Nonnull notification) {
        if ([[notification.userInfo objectForKey:@"type"] integerValue] == 1) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }];
    [self loadingHotData];
    [self LoadScrollImage];
    [self xw_addNotificationForName:@"hotNoti" block:^(NSNotification * _Nonnull notification) {
//        [self.homePlayView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self.homePlayView.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
    [self xw_addNotificationForName:@"TOFOLLOWVC" block:^(NSNotification * _Nonnull notification) {
        NSString *memberNo = notification.userInfo[@"MemberNo"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getShowInfoWith:memberNo];
        });
    }];
    
    

    [self checkToShowCash];
}

//MARK: 是否显示打赏信息
- (void)checkToShowCash{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKShowReward param:nil success:^(WKBaseResponse *response) {
        BOOL isShow = [response.Data integerValue];
        
        User.isReviewID = !isShow;
        
    } failure:^(WKBaseResponse *response) {
        User.isReviewID = YES;
    }];
}

//-(void)tapAction{
//    [WKHttpRequest jumpHome:HttpRequestMethodGet url:homeJump param:nil success:^(WKBaseResponse *response) {
//        WKAllWebViewController *actionVC = [[WKAllWebViewController alloc]init];
//        actionVC.urlString = response.Data;
//        actionVC.titles = @"秀加加";
//        [self.navigationController pushViewController:actionVC animated:YES];
//    } failure:^(WKBaseResponse *response) {
//        
//    }];
//}

-(void)loadingHotData{
    NSString *url = [NSString configUrl:WKHomeHotMessage With:@[@"SearchCondition"] values:@[@""]];
    [WKHttpRequest loadingHomeHotPlay:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [arr addObject:[WKHomePlayModel yy_modelWithDictionary:item]];
        }
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:arr];
        [self.homePlayView reloadDataWithArray:self.dataArr];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.homePlayView.tableView reloadData];
        });
        [self startTimer];
        BOOL pushTpye = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pushTouch"] boolValue];
        if (pushTpye) {
            [self xw_postNotificationWithName:@"pushTouch" userInfo:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"pushTouch"];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)loadingUserMessage:(NSString *)memberID{
    NSString *urlStr = [NSString configUrl:WKUserMessageDetails With:@[@"BPOID",@"VisitBPOID",@"LiveStatus"] values:@[User.BPOID,memberID,@"2"]];
    [WKHttpRequest UserDetailsMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKUserMessageModel *userMessageModel = [WKUserMessageModel yy_modelWithJSON:response.Data];
        if ([memberID isEqualToString:User.BPOID]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMessage" object:nil];
        }else{
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:emptyType :^(NSInteger type){
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)startTimer{
    self.timeCount = 0;
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
-(void)timerAction{
    self.timeCount ++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeCount" object:nil userInfo:@{@"timeCount":@(self.timeCount)}];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, WKScreenW, 44);
    [self.timer invalidate];
    self.timer = nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

@end
