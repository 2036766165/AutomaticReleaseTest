//
//  Common.h
//  wdbo
//
//  Created by lin on 16/6/20.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#ifndef Common_h
#define Common_h

// 手动设置debug模式 上线的时候记得注释
//#define iOS_Debug 1

#define WKScreenH   [UIScreen mainScreen].bounds.size.height
#define WKScreenW   [UIScreen mainScreen].bounds.size.width

//iphone6分辨率
#define WKScaleW    [UIScreen mainScreen].bounds.size.width/375
#define WKScaleH    [UIScreen mainScreen].bounds.size.height/667

#define WeakSelf(VC) __weak VC *weakSelf = self

//  弱引用宏
#define User [WKUser sharedInstance]
#define UserRelation    [WKStoreModel sharedInstance]
#define PlayObject      [WKPlayInstanceObject sharedInstance]

#define WKHttpRequest [WKNetWorkManager shareNetWork]

#define MAIN_COLOR [UIColor colorWithRed:0.98 green:0.50 blue:0.22 alpha:1.00]

#ifdef iOS_Debug

//**************测试地址*********************
#define WK_URL_Base     @"http://www.silentwind.com.cn/"                   // 静态页域名
#define WK_HostName     @"http://srv.silentwind.com.cn/api/"               // 服务器地址
#define WK_Singlelr     @"http://10.99.20.60:9097/signalr"                 // 聊天
#define WK_ShareBaseUrl @"http://www.silentwind.com.cn/Show.html?rc="      // 分享

#define WXAPPID         @"wxf841265451e511e5"                              // 测试环境下 微信登录和分享 APPID
#define WXAPP_SECRET    @"1b033c92359c39dcdc89eb2a1b877dd5"                // APPSECRET
#define RAppKey         @"pvxdm17jxpzfr"                                   //融云sdk
#define ShareSDK_KEY    @"18e06b421ebf8"
//    内购验证
#define ItunesVerify    @"https://sandbox.itunes.apple.com/verifyReceipt"
//
//**************发布地址*********************
#else

#define WK_URL_Base     @"http://www.showjiajia.com/"                       // 静态页域名
#define WK_HostName     @"http://srv.showjiajia.com/api/"                   // 服务器地址
#define WK_Singlelr     @"http://chat.showjiajia.com/signalr"               // 聊天
#define WK_ShareBaseUrl @"http://www.showjiajia.com/Show.html?rc="          // 分享

#define WXAPPID         @"wx08a9c6d6e4b6bd3b"                               // 测试环境下 微信登录和分享 APPID
#define WXAPP_SECRET    @"db3a797f151739d8d5eeef91956ac4e8"                 //融云sdk
#define RAppKey         @"bmdehs6pbgzos"//@"uwd1c0sxduif1"                                    //融云生产appkey
#define ShareSDK_KEY    @"146a2692f88a4"
//    内购验证
#define ItunesVerify    @"https://buy.itunes.apple.com/verifyReceipt"

#endif

#define WK_MyAppID  @"1131977306"
//用户服务地址
#define WK_UserAddress     [NSString stringWithFormat:@"%@%@",WK_URL_Base,@"my/protocol/member.html"]
//直播协议地址
#define WK_LiveAddress     [NSString stringWithFormat:@"%@%@",WK_URL_Base,@"my/protocol/show.html"]
//开店帮助中常见问题
#define WK_OftenQuestion   [NSString stringWithFormat:@"%@%@",WK_URL_Base,@"my/shophelp/question.html"]
//开店帮助中禁售商品
#define WK_LimitShops      [NSString stringWithFormat:@"%@%@",WK_URL_Base,@"my/shophelp/productrule.html"]

#define SYSTEM_VERSION_GE_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//客服邮箱
#define WK_ServiceEmail     @"service@walkingtec.cn"
//商务合作邮箱
#define WK_BusCoopEmail     @"walkingtec@walkingtec.cn"
//极光
#define jPushAppKey           @"994784619852efb61fefbf4f"//@"ea780082c1c9b53ccd4d7389"
#define jPushchannel          @"Publish channel"
#define jPushisProduction     TRUE
//友盟
#define kUmAppKey             @"577a12ae67e58e8b6f0018aa"
#define kUmChannelId          @"App Store"
//bugly
#define BuglyAppId            @"8305294b53"

//用户同意信息
#define Unauthorized          @"UNAUTHORIZED"

// 热修复JSPatchPaltform
#define JSPatchKey            @"9167c0c6acb058a4"
// 应用被杀死
#define APPKILL               @"APPKILL"

//第一次获取
#define EVER_IN               @"everUsed"

#define TOKEN                 @"Token"
#define RONGTOKEN             @"RongCloudToken"

//用户的定位地址
#define MEMBERLOCATION        @"MemberLocation"

#define FROMCLIENT            @3
#define DISMISSLIVEVIEW       @"dismissLive"        // 离开直播页

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCALE  SCREEN_WIDTH/375

#define SELECTROW 0 //个人中心点击下标

#define DEGRESS_TO_RADIANS(x) (M_PI*(x)/180.0)


//分享店铺
#define shareGoodsUrl(memberID,bpoid,goodsCode)  [NSString stringWithFormat:@"%@%@&bpoid=%@#!/GoodsDetails/%@",WK_ShareBaseUrl,memberID,bpoid,goodsCode]

//// release 模式下不打印log __OPTIMIZE__ 是release 默认会加的宏
//#ifndef DEBUG
//
//#define NSLog(...) NSLog(__VA_ARGS__)
//
//#else
//
//#define NSLog(...)
//
//#endif


#endif
