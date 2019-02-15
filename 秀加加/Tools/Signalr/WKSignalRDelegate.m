//
//  WKSignalRDelegate.m
//  wdbo
//
//  Created by sks on 16/7/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSignalRDelegate.h"
#import "SignalR.h"
#import "WKMessage.h"
#import "NSObject+XWAdd.h"
#import <sys/utsname.h>

@interface WKSignalRDelegate ()<SRConnectionDelegate>{
    NSString *_memberNo;
    NSString *_bpoId;
}

@property (nonatomic,strong) SRHubConnection *hubConnection;
@property (nonatomic,strong) SRHubProxy *chat;

//@property (nonatomic,strong) NSMutableArray *messagesReceived;

@end

@implementation WKSignalRDelegate

- (void)dealloc{
//    NSLog(@"释放SingalR");
//    [self disconnect];
}

- (instancetype)initWithMemberNo:(NSString *)memberNo andBPOId:(NSString *)bpoId{
    if (self = [super init]) {
        _memberNo = memberNo;
        _bpoId = bpoId;
        [self connect];
    }
    return self;
}

-(void)connect{
    // Connect to the service
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    // app名称
    //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    NSString *deviceInfo = [NSString stringWithFormat:@"%@;%@;%@",[self iphoneType],currentDevice.systemVersion,app_Version];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    
    NSDictionary *headers = @{
                   @"rc":_memberNo,
                   @"tid":_bpoId,
                   @"t":@"0",
                   @"v":deviceInfo,
                   @"tk":token
                   };

    SRHubConnection *hubConnection = [[SRHubConnection alloc] initWithURLString:WK_Singlelr queryString:headers useDefault:NO];
    self.hubConnection = hubConnection;
    
    // Create a proxy to the chat service
    SRHubProxy *chat = (SRHubProxy *)[hubConnection createHubProxy:@"WChatServiceHub"];
    self.chat = chat;

    [chat on:@"invoke" perform:self selector:@selector(receiveMsg:data:)];

    [hubConnection stop];
    
    // Register for connection lifecycle events
    [hubConnection setStarted:^{
        
//        NSLog(@"Connection Started");
        
//        [chat invoke:@"getList" withArgs:@[] completionHandler:^(id response, NSError *error) {
//            NSLog(@"chat response is%@",response);
//            if (self.block) {
//                self.block(WKMessageInfoTypeGetList,response);
//            }
//        }];
    }];
    
    [hubConnection setReceived:^(NSString *message) {
//        NSLog(@"Connection Recieved Data: %@",message);
    }];
    [hubConnection setConnectionSlow:^{
        NSLog(@"Connection Slow");
    }];
    [hubConnection setReconnecting:^{
        NSLog(@"Connection Reconnecting");
    }];
    [hubConnection setReconnected:^{
        NSLog(@"Connection Reconnected");
    }];
    [hubConnection setClosed:^{
        NSLog(@"Connection Closed");
        if (User.showStatus != WKShowStatusNormal) {
            [self connect];
        }
    }];
    
    [hubConnection setError:^(NSError *error) {
        NSLog(@"Connection Error %@",error);
    }];
    
    [hubConnection setDelegate:self];
    [hubConnection start];
    
    NSLog(@"connent id %@",hubConnection.connectionToken);

}

- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";

    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

-(void)disconnect{
//    NSLog(@"断开连接");
    [self.hubConnection stop];
    
//    self.block = nil;
    self.chat = nil;
    self.hubConnection.delegate = nil;
    self.hubConnection = nil;
}

- (void)sendMsg:(WKMessage *)msg completionBlock:(void(^)(BOOL isSended))block{
    NSString *method;
    NSArray *arr;
    
    if (msg.isGif) {
        method = @"SendImg";
        arr = @[msg.name,msg.gif,User.MemberPhotoMinUrl,User.MemberLevel];
    }else{
        method = @"SendMsg";
        arr = @[msg.name,msg.content,User.MemberPhotoMinUrl,User.MemberLevel];
    }
    
    [self.chat invoke:method withArgs:arr completionHandler:^(id response, NSError *error) {
//        NSLog(@"send response %@",response);
        if (block) {
            block(YES);
        }
    }];
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark -
#pragma mark SRConnection Delegate
- (void)SRConnectionDidOpen:(SRConnection *)connection
{
//    NSLog(@"SRConnectionDidOpen");
}

- (void)SRConnection:(SRConnection *)connection didReceiveData:(id)data
{
//    NSLog(@"didReceiveData");
}

- (void)SRConnectionDidClose:(SRConnection *)connection
{
//    NSLog(@"SRConnectionDidClose");
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error{
//    NSLog(@"didReceiveError");
}

#pragma mark - 收到消息的回调方法
- (void)receiveMsg:(NSString *)eventName data:(id)result{
    NSLog(@"event name: %@  result: %@",eventName,result);
    WKMessageInfoType messageType;
    
    if ([eventName isEqualToString:@"receiveMsg"]) {

        messageType = WKMessageInfoTypeReceiveMsg;
    }else if ([eventName isEqualToString:@"onlineUser"]){

        messageType = WKMessageInfoTypeOnline;

    }else if ([eventName isEqualToString:@"offlineUser"]){

        messageType = WKMessageInfoTypeOffline;

    }else if ([eventName isEqualToString:@"systemMsg"]){

        messageType = WKMessageInfoTypeSystemMsg;

    }else if ([eventName isEqualToString:@"systemMsgPush"]){
        
        messageType = WKMessageInfoTypeSystemMsgPush;
        
    }
    else if ([eventName isEqualToString:@"receiveImg"]){

        messageType = WKMessageInfoTypeImg;
        
    }else if ([eventName isEqualToString:@"reward2"]){

        messageType = WKMessageInfoTypeReward;
    }else if ([eventName isEqualToString:@"auction"]){

        messageType = WKMessageInfoTypeAuction;
    }else if ([eventName isEqualToString:@"auctionJoin"]){
        messageType = WKMessageInfoTypeJoin;
    }
    else if ([eventName isEqualToString:@"auctionBid"]){

        messageType = WKMessageInfoTypeAuctionBid;
    }else if ([eventName isEqualToString:@"auctionCount"]){

        messageType = WKMessageInfoTypeAuctionCount;
    }
    else if([eventName isEqualToString:@"getList"]){
        messageType = WKMessageInfoTypeGetList;
    }else if ([eventName isEqualToString:@"videoPause"]){
        messageType = WKMessageInfoTypeVideoPause;
    }else if ([eventName isEqualToString:@"videoPlay"]){
        messageType = WKMessageInfoTypeVideoPlay;
    }else if ([eventName isEqualToString:@"videoClose"]){
        messageType = WKMessageInfoTypeVideoClose;
    }else if ([eventName isEqualToString:@"systemLogout"]){
        messageType = WKMessageInfoTypeSystemLoginOut;
    }else if ([eventName isEqualToString:@"roomTalk"]){
        messageType = WKMessageInfoTypeRoomTalk;
    }else if ([eventName isEqualToString:@"auctionDelay"]){
        messageType = WKMessageInfoTypeAuctionDelay;
    }else if ([eventName isEqualToString:@"headerList"]){
        messageType = WKMessageInfoTypeHeadList;
        NSLog(@"head list : %@",result);
    }
    else if ([eventName isEqualToString:@"redGroupPacket"]){
        messageType = WKMessageInfoTypeRedGroupEvenlop;
    }else if ([eventName isEqualToString:@"redSinglePacket"]){
        messageType = WKMessageInfoTypeRedSingleEvenlop;
    }
    else{
        messageType = WKMessageInfoTypeUnknown;
    }
    
//    [UIDevice currentDevice]
    if ([result isKindOfClass:[NSNull class]]) {
        // 返回类型错误,忽略该消息
        messageType = WKMessageInfoTypeUnknown;
    }
//    if (self.block) {
//        self.block(messageType,result);
//    }
    if ([_delegate respondsToSelector:@selector(receiveMsgType:msgBody:)]) {
        [_delegate receiveMsgType:messageType msgBody:result];
    }
    
}


@end
