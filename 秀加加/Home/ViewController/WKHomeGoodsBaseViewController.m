//
//  WKGoodsBaseViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomeGoodsBaseViewController.h"
#import "WKHomeGoodsBaseView.h"
#import "WKHomeGoodsModel.h"
#import "WKLiveViewController.h"
#import "NSObject+XWAdd.h"
#import "UIImage+Gif.h"
#import "WKAllWebViewController.h"
 
@interface WKHomeGoodsBaseViewController () <WKSelectGoodsDelegate>

@property (strong, nonatomic) WKHomeGoodsBaseView *homeGoodsView;

@property (strong, nonatomic) NSMutableArray * dataArr;

@property (assign, nonatomic) CGFloat count;

@property (strong, nonatomic) NSTimer * timer;

@property (assign, nonatomic) NSInteger timeCount;

@property (assign, nonatomic) BOOL isTimer;


@end

@implementation WKHomeGoodsBaseViewController

-(WKHomeGoodsBaseView *)homeGoodsView{
    if (!_homeGoodsView) {
        _homeGoodsView = [[WKHomeGoodsBaseView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) block:^(NSInteger type, NSString *homeId) {
            
        }];
        
        __weak WKHomeGoodsBaseViewController *weakSelf = self;
        _homeGoodsView.scrollBlock = ^(CGFloat contentY){
            [weakSelf hiddenTabbarAndNavBar:contentY];
        };
        _homeGoodsView.requestBlock = ^(){
            [weakSelf loadingGoodsData];
        };
        _homeGoodsView.endBlock = ^(){
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
                [weakSelf.homeGoodsView setTabeViewFrame:CGRectMake(0, weakSelf.count, WKScreenW, WKScreenH-weakSelf.count)];
                weakSelf.tabBarController.tabBar.frame=tabRect;
                weakSelf.navigationController.navigationBar.frame = navRect;
            }completion:^(BOOL finished) {
                
            }];
        };
        _homeGoodsView.delegate = self;
        _homeGoodsView.isOpenHeaderRefresh = YES;
    }
    return _homeGoodsView;
}
-(void)hiddenTabbarAndNavBar:(CGFloat)offSet{
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
        [self.homeGoodsView setTabeViewFrame:CGRectMake(0, self.count, WKScreenW, WKScreenH-self.count)];
        self.tabBarController.tabBar.frame=tabRect;
        self.navigationController.navigationBar.frame = navRect;
    }completion:^(BOOL finished) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadingGoodsData];
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
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"searchType"];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.count = 64;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.frame=CGRectMake(0, WKScreenH-49, WKScreenW, 49);
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, WKScreenW, 44);
    [self.homeGoodsView setTabeViewFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64-49)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isTimer = NO;
    [self.view addSubview:self.homeGoodsView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self xw_addNotificationForName:@"refreshHomeData" block:^(NSNotification * _Nonnull notification) {
        if ([[notification.userInfo objectForKey:@"type"] integerValue] == 1) {
            [self.timer invalidate];
            self.isTimer = NO;
        }else{
            [self loadingGoodsData];
        }
    }];
    [self xw_addNotificationForName:@"goodsNoti" block:^(NSNotification * _Nonnull notification) {
        [self.homeGoodsView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    
//    UIImageView *backIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.72, WKScreenH-49-WKScreenW*0.1, WKScreenW*0.25, WKScreenW*0.05)];
//    backIM.image = [UIImage imageNamed:@"touying"];
//    [self.view addSubview:backIM];
//    
//    UIImageView *gifIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.72, WKScreenH-49-WKScreenW*0.3, WKScreenW*0.25, WKScreenW*0.25)];
//    gifIM.backgroundColor = [UIColor clearColor];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Home" ofType:@"gif"];
//    UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
//    gifIM.image = image;
//    gifIM.userInteractionEnabled = YES;
//    [self.view addSubview:gifIM];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//    [gifIM addGestureRecognizer:tap];
    
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
-(void)loadingGoodsData{
    NSString *urlStr = [NSString configUrl:WKHotSaleMessage With:@[@"KeyWord"] values:@[@""]];
    [WKHttpRequest homeHotSaleMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        NSLog(@"goods list response : %@",response.json);
        [self.dataArr removeAllObjects];
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.dataArr addObject:[WKHomeGoodsModel yy_modelWithDictionary:item]];
        }
        [self.homeGoodsView reloadDataWithArray:self.dataArr];
        [self startTimer];
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(void)startTimer{
    self.timeCount = 0;
    if (!self.isTimer) {
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.isTimer = YES; 
    }
}
-(void)timerAction{
    self.timeCount ++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsCount" object:nil userInfo:@{@"goodsCount":@(self.timeCount)}];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.isTimer = NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, WKScreenW, 44);
}

- (void)selectGoodsWith:(WKHomeGoodsModel *)goodsModel{
    [self getShowInfoWith:goodsModel];
}

- (void)getShowInfoWith:(WKHomeGoodsModel *)goodsModel{
    if ([goodsModel.ShopOwnerNo isEqualToString:User.MemberNo]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMessage" object:nil];
        return;
    }
    [WKProgressHUD showLoadingGifText:@""];
    
    NSString *url = [NSString configUrl:WKMemberGetShowInfo With:@[@"MemberNo"] values:@[goodsModel.ShopOwnerNo]];
    
    [WKHttpRequest getShowMemberInfo:HttpRequestMethodGet url:url model:NSStringFromClass([WKHomePlayModel class]) param:nil success:^(WKBaseResponse *response) {
//        NSLog(@"response json : %@",response.json);
        
        [WKProgressHUD dismiss];
        
        if (response.Data) {
            WKLiveViewController *live = [[WKLiveViewController alloc] initWithHomeList:response.Data from:WKLiveFromHotGoods];
            WKHomePlayModel *md = response.Data;
            md.GoodsCode = goodsModel.GoodsCode;
            md.SaleType = goodsModel.SaleType;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:live];
            [self presentViewController:nav animated:YES completion:nil];
            live.playStop = ^(){
                [self loadingGoodsData];
            };
        }else{
            [WKProgressHUD showTopMessage:@"获取直播信息失败"];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.isTimer = NO;
}
-(void)dealloc{
    [self.timer invalidate];
}
@end
