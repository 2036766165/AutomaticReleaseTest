//
//  WKPushFlowViewController.m
//  秀加加
//
//  Created by lin on 2016/9/26.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPushFlowViewController.h"
#import "UINavigationController+WKInterfaceOrientation.h"

#import <GPUImage/GPUImage.h>
//#import <libksygpulive/libksygpulive.h>
#import <libksygpulive/libksygpulive.h>

#import "WKShowInputView.h"
#import "NSObject+XWAdd.h"
#import "NSDate+Extension.h"
#import "AppDelegate.h"
#import "WKUserMessage.h"
#import "WKSmallChatListViewController.h"
#import "WKOnLineMd.h"
#import "WKSmallChatViewController.h"
#import "WKLivePreView.h"
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "NSObject+XWAdd.h"
#import "WKBulletView.h"
#import "WKBulletManager.h"
#import "WKBulletBackgroudView.h"
//#import "WKVirtualWorldViewController.h"
#import "WKContributorViewController.h"
#import "WKAllOnlineViewController.h"
#import "WKRedPacketViewController.h"
#import "WKRedPacketDetails.h"
#import "WKAllWebViewController.h"

@interface WKPushFlowViewController ()<WKLivePreDelegate,UIScrollViewDelegate>{
    NSString *_titleStr;
    WKLivePreView *_preView;
    UIImageView *_foucsCursor;
    NSDate *_joinDate;
    WKGoodsLayoutType _type;
    
    NSMutableDictionary *_obsDict;
}

@property KSYGPUStreamerKit * kit;
//@property GPUImageFilter    * filter;
@property (nonatomic,strong) GPUImageFilterGroup *curFilter;

@property (nonatomic,strong) WKKSYConfigModel *configModel;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,copy)    NSString *PushUrl;
@property (nonatomic,assign) BOOL preStateShow;    // YES : 显示图层 NO : 隐藏图层
@property (nonatomic, strong) WKBulletManager *bulletManager;
@property (nonatomic, strong) WKBulletBackgroudView *bulletBgView;


@end


#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

@implementation WKPushFlowViewController

- (instancetype)initStreamCfg:(WKKSYConfigModel *)config{
    if (self = [super init]) {
        [self initObservers];
        _type = config.screenType;
        self.configModel = config;
    }
    return self;
}

-(KSYGPUStreamerKit *)getStreamer {
    return _kit;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Life cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 防止屏幕睡眠
    [UIApplication sharedApplication].idleTimerDisabled=YES;

    // 开始预览
    [self onCapture];
}

//- (WKCurFilter *)curFilter{
//    if (_curFilter == nil) {
//        _curFilter = [[WKCurFilter alloc] init];
//    }
//    return _curFilter;
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self xw_postNotificationWithName:@"LIVEEND" userInfo:nil];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObservers];
    
    // 监测直播状态
    User.showStatus = WKShowStatusShowing;
    _joinDate = [NSDate date];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _kit = [[KSYGPUStreamerKit alloc] initWithDefaultCfg];
    [_kit setupFilter:nil];
    
//    NSLog(@"push url : %@",User.PushUrl);
    
    // 打印版本号信息
    NSLog(@"version: %@", [_kit getKSYVersion]);
    
    // 添加控制图层
    [self addPreView];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKGetPushURL param:nil success:^(WKBaseResponse *response) {
        self.PushUrl = response.Data;
        // 开始推流
//        NSLog(@"push url : %@",response.Data);
        [self onStream];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
    
    [self xw_addNotificationForName:@"startAudio" block:^(NSNotification * _Nonnull notification) {
        [_kit.aCapDev startCapture];
    }];
    
    // 检测是否连上耳机
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:[
                                                                                                                                                                      AVAudioSession sharedInstance]];
    
    // 显示网络状态
    [_preView setSingalStateWithIndex:1];
    
    [self xw_addNotificationForName:@"TOFOLLOWVC" block:^(NSNotification * _Nonnull notification) {
        
        [self closeWithAnimation:NO];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self getShowInfoWith:memberNo];
//        });
    }];
    
    self.preStateShow = YES;
    [self commitView];
    [self addTapGesture];

}

// MARK: 推流
- (void) onStream{
    if (_kit.streamerBase.streamState == KSYStreamStateIdle ||
        _kit.streamerBase.streamState == KSYStreamStateError) {
        // 推流相关初始化
        [self setStreamerCfg];
        [_kit.streamerBase startStream:[NSURL URLWithString:self.PushUrl]];
    }
}

- (void)operateType:(WKLiveOpeartion)type md:(id)md{
    // to foolish activity VC
    if (type == WKLiveOpeartionRedEvenlope) {
        WKRedPacketDetails *packetDetails = [[WKRedPacketDetails alloc]init];
        packetDetails.model = md;
        [self.navigationController pushViewController:packetDetails animated:YES];
    }else{
        NSString *linkUrl = md;
        WKAllWebViewController *allWebVc = [[WKAllWebViewController alloc] init];
        allWebVc.titles = @"愚人节活动";
        allWebVc.urlString = linkUrl;
        [self.navigationController pushViewController:allWebVc animated:YES];

    }
}


// 判断是否有耳机
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            //插入耳机
            _kit.aCapDev.bPlayCapturedAudio = YES;
            _kit.aCapDev.micVolume = 0.9;
//            [_kit.vCapDev stopCameraCapture];
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            //拔出耳机
            _kit.aCapDev.bPlayCapturedAudio = NO;
//            [_kit.vCapDev startCameraCapture];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
//            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

// MARK: 视频采集
- (void) onCapture{
    if (!_kit.vCapDev.isRunning){
        // 采集相关设置初始化
        [self setCaptureCfg];
        
        _kit.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        [_kit startPreview:self.view];
    }
//    else {
//        [_kit stopPreview];
//    }
}

#pragma mark - 配置采集视频和推流的参数
- (void) setCaptureCfg {
    /*
     分辨率
     @"360p",@"540p",@"720p", @"480p"
     */
    _kit.capPreset        = _configModel.capResolution;
    
    /*
     // 分辨率有效范围检查
     */
    _kit.previewDimension = _configModel.streamResolution;
    
    _kit.streamDimension  = _configModel.streamResolution;
    
    /*
     视频帧率
     */
    _kit.videoFPS       = _configModel.videoFPS;
    
    /*摄像头*/
    _kit.cameraPosition = _configModel.capPosition;
    if (_kit.cameraPosition == AVCaptureDevicePositionFront) {
        _kit.streamerMirrored = _configModel.frontMirror;
    }
    /*设置gpu输出的图像像素格式*/
    _kit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    
    /*监测是否插上耳机 耳返*/
    if ([KSYAUAudioCapture isHeadsetPluggedIn]) {
        _kit.aCapDev.bPlayCapturedAudio = YES;
        _kit.aCapDev.micVolume = 0.9;
    }else{
        _kit.aCapDev.bPlayCapturedAudio = NO;
    }
    
//    _kit.videoProcessingCallback = ^(CMSampleBufferRef buf){
//        
//    };
    
    UIInterfaceOrientation oren;
    if (_type == WKGoodsLayoutTypeVertical) {
        oren = UIInterfaceOrientationPortrait;
    }else{
        oren = UIInterfaceOrientationLandscapeRight;
    }
    _kit.videoOrientation = oren;

}

- (void)setStreamerCfg {
    // stream settings  must set after capture (必须在capConfig 后调用)
    if (_kit.streamerBase == nil) {
        return;
    }
    
    if (User.PushUrl == nil){
        [WKProgressHUD showTopMessage:@"获取直播地址失败"];
        return;
    }
    
    _kit.streamerBase.videoCodec       = _configModel.videoCodec;
    _kit.streamerBase.videoInitBitrate = _configModel.videoInitBitrate;
    _kit.streamerBase.videoMaxBitrate  = _configModel.videoMaxBitrate;
    _kit.streamerBase.videoMinBitrate  = _configModel.videoMinBitrate; //
    _kit.streamerBase.audioCodec       = _configModel.audioCodec;
    _kit.streamerBase.audiokBPS        = _configModel.audiokBPS;
    _kit.streamerBase.videoFPS         = _configModel.videoFPS;
    _kit.streamerBase.bwEstimateMode   = _configModel.bwEstMode;
    _kit.streamerBase.shouldEnableKSYStatModule = YES;
    
}

- (void)close{
    [self closeWithAnimation:YES];
}

#pragma mark - 关闭推流和聊天
- (void)closeWithAnimation:(BOOL)animated{
    
    User.showStatus = WKShowStatusNormal;

    [self rmObservers];

    NSString *lastTime = [self getLastTime];
    NSDictionary *dict = @{
                           @"lastTime":lastTime,
                           @"audiences":@(_preView.currentPerson)
                           };
    
    // 发通知关闭singleR 聊天
    [self xw_postNotificationWithName:DISMISSLIVEVIEW userInfo:dict];
    
    /* 关闭推流和录制*/
    [_kit.streamerBase stopStream];
    [_kit stopPreview];

    [self dismissViewControllerAnimated:animated completion:NULL];

    _kit = nil;
    _preView = nil;
}

- (NSString *)getLastTime{
    NSDate *currentDate = [NSDate date];
    NSInteger time = (NSInteger)[currentDate timeIntervalSinceDate:_joinDate];
    NSInteger hour = time/3600;
    NSInteger minute = (time - 3600 * hour)/60;
    NSInteger second = time - hour * 3600 - 60 * minute;
    NSString *lastTime = [NSString stringWithFormat:@" %02d : %02d : %02d",(unsigned int)hour,(unsigned int)minute,(unsigned int)second];
    return lastTime;
}

#define SEL_VALUE(SEL_NAME) [NSValue valueWithPointer:@selector(SEL_NAME)]

- (void) initObservers{

    _obsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                SEL_VALUE(onCaptureStateChange:) ,  KSYCaptureStateDidChangeNotification,
                SEL_VALUE(onStreamStateChange:) ,   KSYStreamStateDidChangeNotification,
                SEL_VALUE(onNetStateEvent:) ,       KSYNetStateEventNotification,
//                SEL_VALUE(onBgmPlayerStateChange:) ,KSYAudioStateDidChangeNotification,
                SEL_VALUE(enterBg:) ,           UIApplicationDidEnterBackgroundNotification,
                SEL_VALUE(becameActive:) ,      UIApplicationDidBecomeActiveNotification,
                SEL_VALUE(close),               Unauthorized,
                SEL_VALUE(close),               APPKILL,
                nil];
}

- (void) addObservers {
    //KSYStreamer state changes
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    for (NSString *key in _obsDict) {
        SEL aSel = [[_obsDict objectForKey:key] pointerValue];
        [dc addObserver:self
               selector:aSel
                   name:key
                 object:nil];
    }
}

- (void) rmObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 添加preView
- (void)addPreView
{
    _preView = [[WKLivePreView alloc] initWithFrame:self.view.bounds type:_type];
    _preView.backgroundColor = [UIColor clearColor];
    _preView.delegate = self;
    [self.view addSubview:_preView];
    
    [_preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [_preView layoutIfNeeded];
    
//    __weak KSYGPUStreamerKit            *weaKit   = _kit;
    
    WeakSelf(WKPushFlowViewController);
//    _preView.beautifulLevel = ^(NSInteger level)
//    {
//            };
    _preView.btnBlock = ^(NSInteger type){//1.聊天 2.红包
        if (type == 1) {
            WKSmallChatListViewController *chatList = [[WKSmallChatListViewController alloc]init];
            chatList.isLive = NO;
            [weakSelf addChildViewController:chatList];
            [weakSelf.view addSubview:chatList.view];
        }else{
            WKRedPacketViewController *redPacketVC = [[WKRedPacketViewController alloc]init];
            redPacketVC.type = 2;
            redPacketVC.memberNo = User.MemberNo;
            [weakSelf.navigationController pushViewController:redPacketVC animated:YES];
//            WKRedPacketDetails *details = [[WKRedPacketDetails alloc]init];
//            
//            [weakSelf.navigationController pushViewController:details animated:YES];
        }
    };
    [self addSwipeGesture];
}

- (void)addSwipeGesture{
    UIPanGestureRecognizer *swiptGestureToRight = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeController:)];
    [self.view addGestureRecognizer:swiptGestureToRight];
    
//    UISwipeGestureRecognizer *swiptGestureToRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeController:)];
//    swiptGestureToRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swiptGestureToRight];
//    
//    UISwipeGestureRecognizer *swiptGestureToLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeController:)];
//    [self.view addGestureRecognizer:swiptGestureToLeft];
//    swiptGestureToLeft.direction = UISwipeGestureRecognizerDirectionLeft;
}

- (void)swipeController:(UIPanGestureRecognizer *)gesture{
//    CGPoint startPoint;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
//            startPoint = [gesture locationInView:self.view];
//            NSLog(@"start point x : %f",startPoint.x);
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            CGPoint translationPoint = [gesture translationInView:self.view];
            
            if (self.preStateShow) {
                if (translationPoint.x > 0) {
                    _preView.frame = CGRectMake(translationPoint.x, 0, WKScreenW, WKScreenH);
                    
                }else{
                    _preView.frame = self.view.bounds;
                }
                
            }else{
                
                if (translationPoint.x < 0) {
                    _preView.frame = CGRectMake(WKScreenW + translationPoint.x, 0, WKScreenW, WKScreenH);
                }else{
                    _preView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
            if (self.preStateShow) {
                if (_preView.frame.origin.x >= WKScreenW/5) {
                    [UIView animateWithDuration:0.3 animations:^{
                        _preView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
                    } completion:^(BOOL finished) {
                        self.preStateShow = NO;
                    }];
                    
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        _preView.frame = self.view.bounds;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }else{
                if (_preView.frame.origin.x <= WKScreenW * 4/5) {
                    [UIView animateWithDuration:0.2 animations:^{
                        _preView.frame = self.view.bounds;
                    } completion:^(BOOL finished) {
                        self.preStateShow = YES;
                    }];
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        _preView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        }
            break;
            
        default:
            break;
    }

    
//    if (state.direction == UISwipeGestureRecognizerDirectionRight) {
//        [self xw_postNotificationWithName:@"StopVoice" userInfo:nil];
//        [UIView animateWithDuration:0.5 animations:^{
//            _preView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }else if (state.direction == UISwipeGestureRecognizerDirectionLeft){
//        [UIView animateWithDuration:0.5 animations:^{
//            _preView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH);
//        }];
//    }
}

#pragma mark -  state change
- (void) onCaptureStateChange:(NSNotification *)notification{
//    NSLog(@"new capStat: %@", _kit.getCurCaptureStateName );
}

- (void) onStreamStateChange :(NSNotification *)notification{
    if (_kit.streamerBase){
//        NSLog(@"stream State %@", [_kit.streamerBase getCurStreamStateName]);
    }

    if(_kit.streamerBase.streamState == KSYStreamStateError || _kit.streamerBase.streamState == KSYStreamStateDisconnecting) {
        [self onStreamError:_kit.streamerBase.streamErrorCode];
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateConnecting) {
        NSLog(@"正在重新连接...");
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateConnected) {
        NSLog(@"连接成功");
    }
}

- (void) onNetStateEvent:(NSNotification *)notification{
    
    NSInteger netState=2;
    if (_kit.streamerBase.encodeVKbps <= 450) {
        netState = 3;
    }else if (_kit.streamerBase.encodeVKbps > 450 && _kit.streamerBase.encodeVKbps < 650){
        netState = 2;
    }else{
        netState = 1;
    }
    
    [_preView setSingalStateWithIndex:netState];
    
//    switch (_kit.streamerBase.netStateCode) {
//        case KSYNetStateCode_SEND_PACKET_SLOW: {
//            //NSLog(@"网络状况不佳\n");
//            //[WKPromptView showPromptView:@"您现在网络不佳！"];
//            
//            break;
//        }
//        case KSYNetStateCode_EST_BW_RAISE: {
//            
//            break;
//        }
//        case KSYNetStateCode_EST_BW_DROP: {
//
//            break;
//        }
//        default:break;
//    }
}

- (void)enterBg:(NSNotification *)not{  //app will resigned
    // 进入后台时, 将预览从图像混合器中脱离, 避免后台OpenGL渲染崩溃
    [_kit.vPreviewMixer removeAllTargets];
    [_kit.vStreamMixer removeAllTargets];
}

- (void) becameActive:(NSNotification *)not{ //app becameAction
    // 回到前台, 重新连接预览
    [_kit setupFilter:self.curFilter];
}

- (void) onStreamError:(KSYStreamErrorCode) errCode{
    if (errCode == KSYStreamErrorCode_CONNECT_BREAK) {
        // Reconnect
        [self tryReconnect];
    }
    else if (errCode == KSYStreamErrorCode_AV_SYNC_ERROR) {
//        NSLog(@"audio video is not synced, please check timestamp");
        [self tryReconnect];
    }
    else if (errCode == KSYStreamErrorCode_CODEC_OPEN_FAILED) {
//        NSLog(@"video codec open failed, try software codec");
        _kit.streamerBase.videoCodec = KSYVideoCodec_X264;
        [self tryReconnect];
    }
}

- (void)tryReconnect {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        NSLog(@"try again");
        _kit.streamerBase.bWithVideo = YES;
        [_kit.streamerBase startStream:[NSURL URLWithString:User.PushUrl]];
    });
}

#pragma mark - WKLivePreView delegate
- (void)livePreOperation:(WKLiveOpeartion)operation{
    switch (operation) {
        case WKLiveOpeartionLeave:
        {
            [WKShowInputView showInputWithPlaceString:@"结束直播?" type:LABELTYPE andBlock:^(NSString *str) {
                [self xw_postNotificationWithName:@"LIVEEND" userInfo:nil];
                [self closeWithAnimation:YES];
            }];
        }
            break;
            
        case WKLiveOpeartionContributor:{
            // 贡献榜
            WKContributorViewController *rankList = [[WKContributorViewController alloc] initWithShopOwnerNo:User.MemberNo];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rankList];
            [self.navigationController pushViewController:rankList animated:YES];
//            [self presentViewController:nav animated:YES completion:NULL];
            
        }
            break;
        case WKLiveOpeartionOnlineList:
        {
//            // 虚拟世界
            WKAllOnlineViewController *virtualWorld = [[WKAllOnlineViewController alloc] initWithMemberNo:User.MemberNo];
            [self.navigationController pushViewController:virtualWorld animated:YES];
            
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:virtualWorld];
//            [self presentViewController:nav animated:YES completion:NULL];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)switchFilterType:(NSInteger)type{
    
    if (type == 0){
        [_kit setupFilter:nil];
    }else
    {
        // 小清新 靓丽 甜美可人 怀旧
        //            [weakSelf.curFilter.specialEffectFilter setSpecialEffectsIdx:level+1];
        // 构造美颜滤镜 和 特效滤镜
        //            KSYBeautifyFaceFilter *bf = [[KSYBeautifyFaceFilter alloc] init];
        //            KSYBuildInSpecialEffects *sf = [[KSYBuildInSpecialEffects alloc] initWithIdx:level];
        
        // use a new filter
        float grindRatio = 0;
        float whitenRatio = 0;
        float ruddyRatio = 0;
        
        switch (type) {
            case 1:
                grindRatio = 0.74;
                whitenRatio = 0.69;
                ruddyRatio = 0.57;
                break;
                
            case 2:
                grindRatio = 0.53;
                whitenRatio = 0.45;
                ruddyRatio = 0.44;
                break;
                
            case 3:
                grindRatio = 0.65;
                whitenRatio = 0.50;
                ruddyRatio = 0.40;
                break;
            case 4:
                grindRatio = 0.70;
                whitenRatio = 0.60;
                ruddyRatio = 0.50;
                break;
                
            case 5:
                grindRatio = 0.60;
                whitenRatio = 0.56;
                ruddyRatio = 0.51;
                break;
                
            case 6:
                grindRatio = 0.61;
                whitenRatio = 0.54;
                ruddyRatio = 0.39;
                break;
                
            default:
                break;
        }
        
        // 构造美颜滤镜 和  特效滤镜
        KSYBeautifyFaceFilter    * bf = [[KSYBeautifyFaceFilter alloc] init];
        KSYBuildInSpecialEffects * sf = [[KSYBuildInSpecialEffects alloc] initWithIdx:type];
//        bf.grindRatio  = 0.7;
//        bf.whitenRatio = 0.5;
//        sf.intensity   = 0.5;
        bf.grindRatio  = grindRatio * 0.8;
        bf.whitenRatio = whitenRatio;
        sf.intensity   = ruddyRatio;

        [bf addTarget:sf];
        
        // 用滤镜组 将 滤镜 串联成整体
        GPUImageFilterGroup * fg = [[GPUImageFilterGroup alloc] init];
        [fg addFilter:bf];
        [fg addFilter:sf];
        
        [fg setInitialFilters:[NSArray arrayWithObject:bf]];
        [fg setTerminalFilter:sf];
        
        
        self.curFilter = fg;
        
        [_kit setupFilter:(GPUImageOutput<GPUImageInput> *)self.curFilter];
        
//        if (self.curFilter == nil){
//            
//
////            [_kit setupFilter:self.curFilter];
//        }else{
//            
//            if ( [_curFilter isMemberOfClass:[GPUImageFilterGroup class]]){
//                GPUImageFilterGroup * fg = (GPUImageFilterGroup *)_curFilter;
//                KSYBuildInSpecialEffects * sf = (KSYBuildInSpecialEffects *)[fg filterAtIndex:1];
//                [sf setSpecialEffectsIdx: type];
//            }
//            
////            [_kit setupFilter:_curFilter];
//        }
    }

}

- (void)controlCamearSingal:(NSInteger)singal{
    if (singal == 1) {
        // 反转摄像头
        [_kit switchCamera];
    }else{
        // 开镜像
        if(_kit.cameraPosition == AVCaptureDevicePositionFront){
            _configModel.frontMirror = !_configModel.frontMirror;
            _kit.streamerMirrored = _configModel.frontMirror;
        }else{
            _configModel.backMirror = !_configModel.backMirror;
            _kit.streamerMirrored = _configModel.backMirror;
        }
        if (_kit.streamerMirrored) {
            [WKPromptView showPromptView:@"观众与您看到的是相反的"];
        }else{
            [WKPromptView showPromptView:@"观众与您看到的是相同的"];
        }
//        _configModel.frontMirror
//        _kit.streamerMirrored = _configModel.frontMirror;

//        _kit.aCapDev.reverbType
    }
    
}

- (void)controlAudioSingal:(NSInteger)singal{
    _kit.aCapDev.reverbType = (int)singal;
}

- (void)selectedIndexPerson:(WKOnLineMd *)md{
    if (md.isAddItem) {
        [self livePreOperation:WKLiveOpeartionOnlineList];
    }else{
        [self loadingUserMessage:md.BPOID];
    }
}

- (void)selectedIndexSelf{
    [self loadingUserMessage:User.BPOID];
}

-(void)loadingUserMessage:(NSString *)memberID
{
    NSString *urlStr = [NSString configUrl:WKUserMessageDetails With:@[@"BPOID",@"VisitBPOID",@"LiveStatus"] values:@[User.BPOID,memberID,@"2"]];
    [WKHttpRequest UserDetailsMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKUserMessageModel *userMessageModel = [WKUserMessageModel yy_modelWithJSON:response.Data];
        if ([memberID isEqualToString:User.BPOID]) {

            [WKUserMessage showUserMessageWithModel:userMessageModel andType:mySelfMessage chatType:emptyType :^(NSInteger type){
                
            }];
            
        }else{
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:rewardMessage chatType:gagType :^(NSInteger type){
                if (type == 2) {
                    WKSmallChatViewController *smallChat = [[WKSmallChatViewController alloc]init];
                    smallChat.isLive = NO;
                    smallChat.targetId = userMessageModel.BPOID;
                    smallChat.conversationType = ConversationType_PRIVATE;
                    smallChat.title = userMessageModel.MemberName;
                    smallChat.backType = hiddenBack;
                    [self addChildViewController:smallChat];
                    [self.view addSubview:smallChat.view];
                }else if (type == 3) {
                    WKRedPacketViewController *redPacketVC = [[WKRedPacketViewController alloc]init];
                    redPacketVC.type = 1;
                    redPacketVC.memberName = userMessageModel.MemberName;
                    redPacketVC.memberNo = User.MemberNo;
                    redPacketVC.receiveBPOID = memberID;
                    [self.navigationController pushViewController:redPacketVC animated:YES];
                }
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_configModel.screenType == WKGoodsLayoutTypeHoriztal) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (_configModel.screenType == WKGoodsLayoutTypeHoriztal) {
        return UIInterfaceOrientationLandscapeRight;
    }else{
        return UIInterfaceOrientationPortrait;
    }
}

//#pragma mark - ui rotate
//- (void)viewWillTransitionToSize:(CGSize)size
//       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) { }
//                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//                                     if(SYSTEM_VERSION_GE_TO(@"8.0")) {
//                                         [self onViewRotate];
//                                     }
//                                 }];
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}
//
//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if(SYSTEM_VERSION_GE_TO(@"8.0")) {
//        return;
//    }
//    [self onViewRotate];
//}
//- (void) onViewRotate {
//    // 子类 重新该方法来响应屏幕旋转
////    UIInterfaceOrientation orie = [[UIApplication sharedApplication] statusBarOrientation];
//    [_kit rotatePreview];
//    [_kit rotateStream];
//    
////    [_kit rotatePreviewTo:orie];
////    if (_ksyFilterView.swStrRotate.on) {
////        [_kit rotateStreamTo:orie];
////    }
//    
//}

- (void)dealloc{
    NSLog(@"释放推流界面");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark 弹幕
-(void)commitView{
    [self xw_addNotificationForName:@"sendComment" block:^(NSNotification * _Nonnull notification) {
        WKBarrageModel *barrageModel = [[WKBarrageModel alloc]init];
        barrageModel.nameStr = notification.userInfo[@"name"];
        barrageModel.content = notification.userInfo[@"message"];;
        barrageModel.headPic = notification.userInfo[@"usericon"];
        barrageModel.level = [notification.userInfo[@"ml"] integerValue];
        barrageModel.BPOID = notification.userInfo[@"bpoid"];
        [self.bulletManager insertBullet: barrageModel];
    }];
    
    self.bulletManager = [[WKBulletManager alloc] init];
    WeakSelf(WKPushFlowViewController);
    self.bulletManager.generateBulletBlock = ^(WKBulletView *bulletView) {
        [weakSelf addBulletView:bulletView];
    };
    [self.bulletManager start];
}
- (void)addBulletView:(WKBulletView *)bulletView {
    bulletView.frame = CGRectMake(CGRectGetWidth(self.view.frame)+50,(WKScreenH> WKScreenW?WKScreenW:WKScreenH)*0.12* bulletView.trajectory, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.bulletBgView addSubview:bulletView];
    [bulletView startAnimation];
}

- (WKBulletBackgroudView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[WKBulletBackgroudView alloc] init];
        _bulletBgView.frame = CGRectMake(0,WKScreenW>WKScreenH?WKScreenH*0.15:WKScreenW*0.7, CGRectGetWidth(self.view.frame), WKScreenW>WKScreenH?WKScreenH*0.35:WKScreenW*0.35);
        [_preView addSubview:_bulletBgView];
        for (UIView *item in _preView.subviews) {
            if ([item isKindOfClass:NSClassFromString(@"WKMessageListView")]) {
                [_preView insertSubview:_bulletBgView belowSubview:item];
            }
        }
    }
    return _bulletBgView;
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [self.bulletBgView dealTapGesture:gesture block:^(WKBulletView *bulletView){
        if (bulletView.BPOID.length>0) {
            [self loadingUserMessage:bulletView.BPOID];
        }
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.cancelsTouchesInView = NO;
    [_preView addGestureRecognizer:tap];
}

@end

@implementation WKKSYConfigModel

- (instancetype)init{
    if (self = [super init]) {
        
        self.capResolution = AVCaptureSessionPresetiFrame960x540;
        self.streamResolution = CGSizeMake(960, 540);
        self.capPosition = AVCaptureDevicePositionFront;
        self.osType = kCVPixelFormatType_32BGRA;
        self.videoFPS = 15.0;
        self.videoCodec = KSYVideoCodec_AUTO;
        self.audioCodec = KSYAudioCodec_AAC_HE;
        self.videoMaxBitrate = 800;// 100 ~ 1500
        self.videoMinBitrate = 400;
        self.videoInitBitrate = 600;
        self.audiokBPS = 32; // @"12",@"24",@"32", @"48", @"64", @"128"
        self.bwEstMode = KSYBWEstMode_Default;
        self.screenType = WKGoodsLayoutTypeVertical;
        self.frontMirror = NO;
        self.backMirror = NO;
    }
    return self;
}

@end

@implementation WKCurFilter

- (instancetype)init{
    if (self = [super init]) {
        
        // 构造美颜滤镜 和  特效滤镜
        KSYBeautifyFaceFilter    * bf = [[KSYBeautifyFaceFilter alloc] init];
        KSYBuildInSpecialEffects * sf = [[KSYBuildInSpecialEffects alloc] initWithIdx:1];
        bf.grindRatio  = 0.8;
        bf.whitenRatio = 0.8;
        sf.intensity   = 0.8;
        [bf addTarget:sf];
        
        // 用滤镜组 将 滤镜 串联成整体
        GPUImageFilterGroup * fg = [[GPUImageFilterGroup alloc] init];
        [fg addFilter:bf];
        [fg addFilter:sf];
        
        [fg setInitialFilters:[NSArray arrayWithObject:bf]];
        [fg setTerminalFilter:sf];
//        _curFilter = fg;
        
        self.beautyFilter = bf;
        self.specialEffectFilter = sf;
        
        self.groupFilter = fg;

    }
    return self;
}


@end
