//
//  AppDelegate.m
//  秀加加
//
//  Created by lin on 16/8/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "AppDelegate.h"
#import "WKMainViewController.h"
#import "UMMobClick/MobClick.h"
#import "JPUSHService.h"
#import "WKGuideViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WKLoginViewController.h"
#import "WKNavigationController.h"
#import <RongIMKit/RongIMKit.h>
#import "WKRongBPOIDModel.h"
#import <RongIMLib/RCIMClient.h>

#import "WXApi.h"
#import "WKPayTool.h"
#import "NSObject+XWAdd.h"

#import <Bugly/Bugly.h>
//#import <JSPatchPlatform/JSPatch.h>
#import "WKHomePlayModel.h"
#import "WKLiveViewController.h"
#import "WKSelectIndexView.h"

//用户信息提供者
@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,BuglyDelegate>

@property (nonatomic,strong) NSString *rongToken;

@property (nonatomic,strong) NSString *userId;

@property (strong, nonatomic) NSMutableArray * BPOIDArr;

@property (strong, nonatomic) NSMutableArray * RongIMArr;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 11.0, *)){//避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"pushTouch"];
    self.BPOIDArr = [NSMutableArray new];
    self.RongIMArr = [NSMutableArray new];
    //应用被杀死时接收通知
    [self killAppNotification:launchOptions];
    //键盘设置
    [self keyBoardManager];
    //自定义tabbarcontroller
//    [self customTabBar];
    //引导页设置
    [self guidePage];
    //友盟统计
    [self uMeng];
    //分享
    [self shareSdk];
    //crash
    [self setupBugly];
    //极光推送
    [self jPush:application launchOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logitOut) name:Unauthorized object:nil];
    
    //融云
    WeakSelf(AppDelegate);
    self.RunRongCloud = ^{
        [weakSelf rongSdk];
        [weakSelf RongData];
    };
    
    [self checkNetStatus];
    
    [WXApi registerApp:WXAPPID withDescription:@"show++_wxpay"];
    
    return YES;
}
-(void)killAppNotification:(NSDictionary *)launchOptions{
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *pushTitle = userInfo[@"CK1"];
    if([pushTitle isEqualToString:@"订单通知"]){
        [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isHidden":@false,@"type":@(1)}];
    }else if([pushTitle isEqualToString:@"发货通知"]){
        [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isHidden":@false,@"type":@(2)}];
    }
}
- (void)checkNetStatus{
    
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:{
                [WKPromptView showPromptView:@"连接失败,请检查网络!"];
                User.netStatus = NO;

            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                User.netStatus = YES;
                break;
                
            default:
                break;
        }
    }];
    
    [manger startMonitoring];
}

-(void)keyBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WKPayTool shareInstance]];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);

            NSNumber *resultCode = resultDic[@"resultStatus"];
            
            WKPayResultType resultType;
            
            switch (resultCode.integerValue) {
                case 9000:
                    resultType = WKPayResultTypeSuccess;
                    break;
                    
                default:
                    resultType = WKPayResultTypeFail;
                    break;
            }
            
            WKPayResult *payResult = [[WKPayResult alloc] init];
            payResult.payType = WKPayOfTypeAliPay;
            payResult.resultType = resultType;
            payResult.resultMsg = resultDic[@"memo"];
            
            if ([WKPayTool shareInstance].block) {
                [WKPayTool shareInstance].block(payResult);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else
        return [WXApi handleOpenURL:url delegate:[WKPayTool shareInstance]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
            NSNumber *resultCode = resultDic[@"resultStatus"];
            WKPayResultType resultType;
            
            switch (resultCode.integerValue) {
                case 9000:
                    resultType = WKPayResultTypeSuccess;
                    break;
                default:{
                    resultType = WKPayResultTypeFail;
                    [WKPromptView showPromptView:resultDic[@"memo"]];
                }
                    break;
            }
            
            WKPayResult *payResult = [[WKPayResult alloc] init];
            payResult.payType = WKPayOfTypeAliPay;
            payResult.resultType = resultType;
            payResult.resultMsg = resultDic[@"memo"];
            
            if ([WKPayTool shareInstance].block) {
                [WKPayTool shareInstance].block(payResult);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        return YES;

    }else{
        return [WXApi handleOpenURL:url delegate:[WKPayTool shareInstance]];
    }
}

-(void)customTabBar
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    if (token) {
        User.loginStatus = YES;
        [self uploadLoginLog];
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        WKMainViewController *tabBarVC = [[WKMainViewController alloc] init];
        self.window.rootViewController = tabBarVC;
    }else{
        WKLoginViewController *loginView = [[WKLoginViewController alloc] init];
        WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:loginView];
        self.window.rootViewController = nav;
    }

    [self.window makeKeyAndVisible];
}

//账号异地登录
- (void)logitOut{
    User.loginStatus = NO;
    
    NSUserDefaults *localUser = [NSUserDefaults standardUserDefaults];
    [localUser removeObjectForKey:TOKEN];
    [localUser removeObjectForKey:MEMBERLOCATION];
    
    self.window.rootViewController = nil;
    [self customTabBar];
    
    // 如果是微信登录,取消授权
//    [SSEThirdPartyLoginHelper logout:<#(SSEBaseUser *)#>];
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    }
    
//    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在另一台设备上登录,如非本人操作请及时修改账号!" preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alertView dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }];
//    
//    [alertView addAction:alertAction];
//    
//    [self.window.rootViewController presentViewController:alertView animated:YES completion:NULL];
}

-(void)guidePage
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        self.window.rootViewController = [[WKGuideViewController alloc] init];
    }
    else
    {
        [self customTabBar];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"pushType"];
    }
}

-(void)uMeng
{
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = kUmAppKey;
    UMConfigInstance.channelId = kUmChannelId;
    [MobClick startWithConfigure:UMConfigInstance];
}

-(void)shareSdk
{
    //管理定时器
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"playTimerCreate"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"GoodsTimerCreate"];
    
    [ShareSDK registerApp:ShareSDK_KEY
     
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 // @"db3a797f151739d8d5eeef91956ac4e8"
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WXAPPID
                                       appSecret:WXAPP_SECRET];
                 break;
             default:
                 break;
         }
     }];
}

-(void)rongSdk
{
    
    [[RCIM sharedRCIM] initWithAppKey:RAppKey];
    
    //NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:RONGTOKEN];
    
    //如果用户存在融云的TokenID进行连接，不存在获取
    if(User.RongCloudToken.length>0)
    {
        [self connectRong:User.RongCloudToken];
    }
    else
    {
        [self getRongToken];
        
    }
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
    [RCIM sharedRCIM].disableMessageNotificaiton = NO;
    [self xw_addNotificationForName:@"chatNoti" block:^(NSNotification * _Nonnull notification) {
        [self RongData];
    }];
}

-(void)getRongToken
{
    [WKHttpRequest getRongToken:HttpRequestMethodGet url:WKGetRongToken model:nil param:nil success:^(WKBaseResponse *response) {
        self.rongToken = response.Data;
        [self connectRong:self.rongToken];
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)connectRong:(NSString *)token
{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);

        self.userId = userId;
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        User.RongCloudToken = @"";
    }];
}
// 接收消息的回调方法
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    [self RongData];
    //刷新红点
    [self xw_postNotificationWithName:@"redCircle" userInfo:@{@"isRed":@(1)}];
}
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message
{
    return YES;
}
- (NSArray *)getConversationList:(NSArray *)conversationTypeList{
    
    return nil;
}
//融云获取用户信息提供者的信息
//- (void)getUserInfoWithUserId:(NSString *)userId
//                   completion:(void (^)(RCUserInfo *userInfo))completion
//{
//    WKRongBPOIDItem *model = [WKRongBPOIDItem new];
//    for (WKRongBPOIDItem *item in self.RongIMArr) {
//        
//        if ([userId isEqualToString:item.BPOID]) {
//            model = item;
//        }else if ([userId isEqualToString:@"SystemUser"]){
//            model.MemberName = @"订单消息";
//            model.MemberMinPhoto =[NSString stringWithFormat:@"%@images/default/ordermessage.png",WK_URL_Base];
//        }
//    }
//    RCUserInfo *userinfo =[[RCUserInfo alloc] init];
//    userinfo.userId = userId;
//    if (model.MemberName.length<1) {
//        model.MemberName = @" ";
//    }
//    userinfo.name = model.MemberName;
//    userinfo.portraitUri = model.MemberMinPhoto;
//    return completion(userinfo);
//}

-(void)RongData
{
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    NSMutableArray *customArr= [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]].mutableCopy;
    RCConversation *mySelf = [[RCConversation alloc]init];
    mySelf.targetId = User.BPOID;
    [customArr addObject:mySelf];
    
    RCUserInfo *userInfo = [[RCUserInfo alloc]init];
    userInfo.userId = @"SystemUser";
    userInfo.name = @"秀加加官方";
    userInfo.portraitUri = [NSString stringWithFormat:@"%@images/default/systemuser.png",WK_URL_Base];
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:@"SystemUser"];
    
    NSMutableArray *customArrCopy = customArr.copy;
    for (RCConversation *item in customArrCopy) {
        RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:item.targetId];
        if (userInfo) {
            [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:item.targetId];
        }else{
            NSString *url = [NSString configUrl:WKGetMemberByBPOID With:@[@"BPOIDs"] values:@[item.targetId]];
            [WKHttpRequest GetMemberByBPOID:HttpRequestMethodGet url:url model:nil param:nil success:^(WKBaseResponse *response) {
                
                for (NSDictionary *item in response.Data) {
                    WKRongBPOIDItem *itemModel = [WKRongBPOIDItem yy_modelWithJSON:item];
                    [self.RongIMArr addObject:itemModel];
                    RCUserInfo *userInfo = [[RCUserInfo alloc]init];
                    userInfo.userId = itemModel.BPOID;
                    userInfo.name = itemModel.MemberName;
                    userInfo.portraitUri = itemModel.MemberMinPhoto;
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:itemModel.BPOID];
                }
                [self xw_postNotificationWithName:@"RongRefresh" userInfo:nil];//刷新头像昵称
                
            } failure:^(WKBaseResponse *response) {
                
                [WKProgressHUD showTopMessage:response.ResultMessage];
            }];
        }
    }
//    [self.BPOIDArr addObjectsFromArray:customArr];
//    NSMutableString *BPOIDStr = @"".mutableCopy;
//    for (RCConversation *item in customArr) {
//        [BPOIDStr appendString:item.targetId];
//        [BPOIDStr appendString:@","];
//    }
//    
//    
//    NSLog(@"%@",url);
//    
//    ;
}

-(void)jPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:jPushAppKey
                          channel:jPushchannel
                 apsForProduction:jPushisProduction
            advertisingIdentifier:nil];

    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

// MARK: 配置bug检测 和热修复
- (void)setupBugly{
    // bug 监测
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
//    config.blockMonitorEnable = YES;
    config.channel = @"App Store";
    config.delegate = self;
    [Bugly startWithAppId:BuglyAppId developmentDevice:NO config:config];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // 热修复
    //NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    
//    [JSPatch startWithAppKey:JSPatchKey];
//    [JSPatch sync];
//    [JSPatch testScriptInBundle];
}

// 记录登录日志
- (void)uploadLoginLog{
    
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;

    NSString *url = [NSString configUrl:WKLoginLog With:@[@"LoginDevice",@"LoginFrom",@"DeviceID"] values:@[@"2",@"",uuid]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        
        if ( [NSStringFromClass([response.Data class]) isEqualToString:@"__NSCFBoolean"] ) {
            return ;
        }
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        //只有版本不同且强制更新时才会提示更新
        if ([app_Version compare:response.Data[@"Version"] options:NSNumericSearch] == NSOrderedDescending && [response.Data[@"IsUpdate"] boolValue]) {
            
            UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"版本更新" message: nil preferredStyle:UIAlertControllerStyleAlert];
            [alertContro addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id1131977306"]];
                abort();
            }]];
            [self.window.rootViewController presentViewController:alertContro animated:YES completion:nil];
        }
        NSLog(@"记录登录日志成功");
    } failure:^(WKBaseResponse *response) {
        
    }];
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}

#pragma mark - 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

#pragma mark - 注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    _LOGD(@"注册通知失败:%@",error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    _LOGD(@"%@",[NSString stringWithFormat:@"设备:Token:%@",deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo);
    /*前台收到消息*/
//    completionHandler(UIBackgroundFetchResultNewData);
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [userInfo[@"aps"][@"badge"] integerValue];
    
    NSString *pushTitle = userInfo[@"PushTitle"];
    if (!pushTitle) {
        pushTitle = userInfo[@"CK1"];
    }
    if ([pushTitle isEqualToString:@"直播通知"]) {
        // 关注主播上线
        NSString *memberNo = userInfo[@"MemberNo"];
        NSString *name = userInfo[@"MemberName"];
        NSString *loaction = userInfo[@"Location"];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            // 选择观看方式
            NSString *reminderStr = [NSString stringWithFormat:@"%@(门牌号%@)正在%@直播",name,memberNo,loaction];
            
            [WKPromptView showPromptView:userInfo[@"aps"][@"alert"] clickBlock:^{
                [WKSelectIndexView showWithText:reminderStr btnTitles:@[@"取消",@"立即查看"] SelectIndex:^(NSInteger index) {
                    if (index == 1) {
                        [self xw_postNotificationWithName:@"TOFOLLOWVC" userInfo:@{@"MemberNo":memberNo}];
                    }
                }];
            }];
            
        }else{
            NSInteger badge = [userInfo[@"aps"][@"badge"] integerValue] - 1;
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            
            if (User.loginStatus) {
                [self xw_postNotificationWithName:@"TOFOLLOWVC" userInfo:@{@"MemberNo":memberNo}];
                
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                });
            }
        }
    }else if([pushTitle isEqualToString:@"订单通知"]){
        [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isShow":@true,@"type":@(1)}];
    }else if([pushTitle isEqualToString:@"发货通知"]){
        [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isShow":@true,@"type":@(2)}];
    }else{
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [WKPromptView showPromptView:@"您还有未支付的订单,请在订单列表中查看"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"pushTouch"];
            [self customTabBar];
        }
    }
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo);
    /*前台收到消息*/
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSString *pushTitle = userInfo[@"PushTitle"];
    if (!pushTitle) {
        pushTitle = userInfo[@"CK1"];
    }
    if ([pushTitle isEqualToString:@"直播通知"]) {
        // 关注主播上线
        NSString *memberNo = userInfo[@"MemberNo"];
        NSString *name = userInfo[@"MemberName"];
        NSString *loaction = userInfo[@"Location"];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            // 选择观看方式
            NSString *reminderStr = [NSString stringWithFormat:@"%@(门牌号%@)正在%@直播",name,memberNo,loaction];
            
            [WKPromptView showPromptView:userInfo[@"aps"][@"alert"] clickBlock:^{
                [WKSelectIndexView showWithText:reminderStr btnTitles:@[@"取消",@"立即查看"] SelectIndex:^(NSInteger index) {
                    if (index == 1) {
                        [self xw_postNotificationWithName:@"TOFOLLOWVC" userInfo:@{@"MemberNo":memberNo}];
                    }
                }];
            }];
            
        }else{
            
            NSInteger badge = [userInfo[@"aps"][@"badge"] integerValue] - 1;
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;

            if (User.loginStatus) {
                [self xw_postNotificationWithName:@"TOFOLLOWVC" userInfo:@{@"MemberNo":memberNo}];

//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                });
            }
        }
    }else if([pushTitle isEqualToString:@"订单通知"]){
        [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isHidden":@false,@"type":@(1)}];
    }else if([pushTitle isEqualToString:@"发货通知"]){
        [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isHidden":@false,@"type":@(2)}];
    }else{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [WKPromptView showPromptView:@"您还有未支付的订单,请在订单列表中查看"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"pushTouch"];
            [self customTabBar];
        }
    }
}

- (void)handlePushNotification:(NSDictionary *)userInfo{
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if (User.showStatus == WKShowStatusShowing) {
        [WKHttpRequest showPause:HttpRequestMethodPost url:WKShowPause param:nil success:^(WKBaseResponse *response) {
            _LOGD(@"直播暂停");
        } failure:^(WKBaseResponse *response) {
            
        }];
        
    }else{
        _LOGD(@"普通状态不做处理");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    if (User.showStatus == WKShowStatusShowing) {
        [WKHttpRequest showPause:HttpRequestMethodPost url:WKPlayPause param:nil success:^(WKBaseResponse *response) {
            _LOGD(@"直播开始");
        } failure:^(WKBaseResponse *response) {
            
        }];
        
    }else{
        _LOGD(@"普通状态不做处理");
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"应用将被杀死");
    [self xw_postNotificationWithName:APPKILL userInfo:nil];
}

@end
