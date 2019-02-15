//
//  WKHomeViewController.m
//  秀加加
//
//  Created by lin on 16/8/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomeViewController.h"
#import "WKLiveViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "WKMessageViewController.h"
#import "WKSearchViewController.h"
#import "WKHomePlayViewController.h"
#import "WKHomeGoodsBaseViewController.h"
#import "WKMeModel.h"
#import "AppDelegate.h"
#import "WKGetLocation.h"
#import "NSObject+XWAdd.h"
#import "JPUSHService.h"
#import <objc/message.h>
#import <RongIMKit/RongIMKit.h>

@interface WKHomeViewController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) WKGetLocation *location;
@property (nonatomic,strong) UIButton *leftButton;
@property (assign,nonatomic) NSInteger selectNum;
@property (strong, nonatomic) UIView * redPointView;

@end
@implementation WKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 用户 未直播 未观看 
    User.showStatus = WKShowStatusNormal;
    
       // 定位的类
    self.location = [[WKGetLocation alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.delegate = self;
    self.selectNum = 0;
    [self initUi];
    [self GetLoginMemberInfo];
    [self pushTouchNotification];
}

-(void)pushTouchNotification{
    WeakSelf(WKHomeViewController);
    [self xw_addNotificationForName:@"pushTouch" block:^(NSNotification * _Nonnull notification) {
        [weakSelf personMessage:1];
    }];
}

-(void)GetLoginMemberInfo
{
    [WKHttpRequest getPersonMessage:HttpRequestMethodGet url:WKGetPersonMessage model:nil param:nil success:^(WKBaseResponse *response) {
        //把登录用户的信息本地化
        NSLog(@"response %@",response);
        
        [User setValuesForKeysWithDictionary:(NSDictionary *)response.Data];
                
        //设置用户的头像
        [User.usericon sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoMinUrl] placeholderImage:[UIImage imageNamed:@"zanwutouxiang"]];
        
        //进行定位操作
        [self.location getLocationCompletion:^(id obj) {
            //获取本地存储的定位地址
            NSUserDefaults *localUser = [NSUserDefaults standardUserDefaults];
            NSString *localCity = [localUser objectForKey:MEMBERLOCATION];
            
            //获取系统返回的新定位地址
            WKAnnotationTest *newAddress = obj;
            NSString *newCity = newAddress.city;
            
            //定义是否需要更新系统定位地址
            BOOL NeedUpdate = false;
            
            //定位失败
            if(newCity.length == 0)
            {
                if(localCity.length == 0)
                {
                    //如果本地没有定位地址，更改成火星
                    newCity = @"火星";
                    NeedUpdate = true;
                }
                else
                {
                    //如果存在，更新为本地
                    newCity = localCity;
                }
            }
            else
            {
                //如果定位与本地定位不一致，更新
                if(![newCity isEqualToString:localCity])
                {
                    NeedUpdate = true;
                }
            }
            
            //更新本地存储文件
            [localUser setObject:newCity forKey:MEMBERLOCATION];
            [localUser synchronize];
            
            if(NeedUpdate)
            {
                [self uploadCityName:newCity];
            }
        }];
        
        //连接融云
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.RunRongCloud) {
            appDelegate.RunRongCloud();
        }
        //极光
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uploadPushMessage)
                                                     name:kJPFNetworkDidLoginNotification
                                                   object:nil];
    } failure:^(WKBaseResponse *response) {
//        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}
- (void)uploadPushMessage
{
    if ([JPUSHService registrationID])
    {
        NSString *str = [JPUSHService registrationID];
        NSString *urlStr = [NSString configUrl:WKUploadPush With:@[@"RegistrationID"] values:@[str]];
        [WKHttpRequest uploadMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
            NSLog(@"极光注册成功");
        } failure:^(WKBaseResponse *response) {
            NSLog(@"极光注册失败");
        }];
    }
}
- (void)uploadCityName:(NSString *)cityName{
    NSString *url = [NSString configUrl:WKUploadCityName With:@[@"Key",@"Value"] values:@[@"1",cityName]];
    [WKHttpRequest updateMemberInfo:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        NSLog(@"上传城市成功");
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)initUi
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"message-icon"] highImage:[UIImage imageNamed:@""] target:self action:@selector(personMessage:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search"] highImage:[UIImage imageNamed:@"search_select"] target:self action:@selector(searchMessage)];
    for (UIView *view in self.navigationItem.leftBarButtonItem.customView.subviews) {
        if (view.tag == 1000001) {
            self.redPointView = view;
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushPersonalCenter) name:@"MyMessage" object:nil];
    [self setRedPointViewHidden];
    [self xw_addNotificationForName:@"redCircle" block:^(NSNotification * _Nonnull notification) {
        [self setRedPointViewHidden];
    }];
}
-(void)pushPersonalCenter{
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2]; 
}
-(void)setRedPointViewHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount]>0) {
            self.redPointView.hidden = NO;
        }else{
            self.redPointView.hidden = YES;
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)personMessage:(NSInteger)type
{
    
    WKMessageViewController *messageVc = [[WKMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVc animated:YES];
}

-(void)searchMessage
{
    WKSearchViewController *searchVc = [[WKSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
//    [self test];
}
-(void)test{
    [WKHttpRequest loadingEvaluate:HttpRequestMethodPost url:@"/Order/AuctionStart" param:@{@"GoodsCode":@"0",@"GoodsName":@"test",@"GoodsPic":@"",@"StartPrice":@"100",@"Duration":@"40"} success:^(WKBaseResponse *response) {
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav = tabBarController.selectedViewController;
    
    if ([[nav.topViewController class] isEqual:[WKHomeViewController class]]) {
        self.selectNum++;
        NSLog(@"%lu",self.selectNum);
        if (self.selectNum>1) {
            NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchType"];
            NSString *notiName;
            if ([type integerValue] == 1) {
                notiName = @"hotNoti";
            }else{
                notiName = @"goodsNoti";
            }
            [self xw_postNotificationWithName:notiName userInfo:nil];
        }
        [self performSelector:@selector(timeReducte) withObject:nil afterDelay:0.5];
    }
    return YES;
}
-(void)timeReducte{
    if (self.selectNum>0) {
        self.selectNum --;
    }
}
@end
