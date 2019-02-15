//
//  WKLiveViewController.m
//  wdbo
//
//  Created by lin on 16/6/20.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLiveViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "WKShowInputView.h"
#import "WKLiveView.h"
#import "WKAuctionShopModel.h"
#import "NSObject+XWAdd.h"
#import "WKLiveShopTableView.h"
#import "WKLiveShopListModel.h"
#import "WKLiveShopModel.h"
#import "WKLiveShopCommentModel.h"
#import "WKGoodsCollectionView.h"
#import "WKUserMessageModel.h"
#import "WKGoodsDetailViewController.h"
#import "WKUserMessage.h"
#import "WKGoodsHorCollectionViewCell.h"
//#import "WKGoodsDetailHorViewController.h"
#import "WKOnLineMd.h"
#import "WKAuctionStatusModel.h"
#import "WKAddressViewController.h"
#import "WKAddaddressViewController.h"
#import "WKNavigationController.h"
#import "WKPayView.h"
#import "WKAddressModel.h"
#import "WKVideoPauseView.h"
#import "WKLeaveShowView.h"
#import "WKHomeGoodsModel.h"
#import "WKPaySuccessView.h"
#import "WKSmallChatViewController.h"
#import "WKSmallChatListViewController.h"
#import "WKEmptyViewController.h"
#import "WKBulletView.h"
#import "WKBulletManager.h"
#import "WKBulletBackgroudView.h"
#import <AVFoundation/AVFoundation.h>
#import "WKStoreRechargeViewController.h"
#import "WKContributorViewController.h"
#import "WKVirtualWorldViewController.h"
#import "WKAllOnlineViewController.h"
#import "WKRedPacketViewController.h"
#import "WKMessage.h"
#import "WKRedPacketDetails.h"
#import "WKAllWebViewController.h"

@interface WKLiveViewController ()<WKWatchShowDelegate,WKGoodsDetailDelegate,WKSelectAddressDelegate>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) KSYMoviePlayerController *player;
@property (strong, nonatomic) WKLiveView *liveView;
@property (strong, nonatomic) NSString *numberCode;
@property (strong, nonatomic) WKLiveShopTableView *liveShopTableView;
@property (assign, nonatomic) BOOL isPresent;
@property (strong, nonatomic) WKLiveShopModel *shopmodel;
@property (strong, nonatomic) WKLiveShopListModel *liveshopListModel;
@property (strong, nonatomic) WKLiveShopCommentModel *commentModel;
@property (nonatomic,strong) WKNavigationController *addressVC;
@property (nonatomic,strong) WKPayView *payView;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) UIView *preView;
@property (nonatomic,assign) BOOL preStateShow;    // YES : 显示图层 NO : 隐藏图层
@property (nonatomic, strong) WKBulletManager *bulletManager;
@property (nonatomic, strong) WKBulletBackgroudView *bulletBgView;
@property (nonatomic, strong) UIVisualEffectView *VFView; //头像模糊遮罩

@end

@implementation WKLiveViewController{
    WKHomePlayModel *_homeModel;       // 热门的数据
    double lastSize;
    NSTimeInterval lastCheckTime;
    UIView *videoView;
    int rotate_degress;
    int content_mode;
    WKGoodsLayoutType _type;
    WKLiveFrom _from;
    ShowTypeEnum _currentType;
}

- (instancetype)initWithHomeList:(id)homeList from:(WKLiveFrom)from{
    if (self = [super init]) {
        _from = from;
        _homeModel = homeList;
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_homeModel.AppShowUrl]];
        if (_homeModel.PlayMode.integerValue == 1) {
            _type = WKGoodsLayoutTypeHoriztal;
        }else{
            _type = WKGoodsLayoutTypeVertical;
        }
    }
    return self;
}

- (void)dealloc{
    NSLog(@"======销毁播放界面=====");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isPresent = NO;
    if (!videoView) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;

        videoView = [[UIView alloc] initWithFrame:self.view.bounds];
        videoView.tag = 10001;
        videoView.backgroundColor = [UIColor whiteColor];
        
        //设置背景头像虚化
        UIImageView *bgImage = [[UIImageView alloc] init];
        [bgImage sd_setImageWithURL:[NSURL URLWithString:_homeModel.MemberPhoto] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
        self.VFView = [WKPromptView GetImageVisualView:CGRectMake(0, 0, WKScreenW, WKScreenH)];
        [bgImage addSubview:self.VFView];
        
        [videoView addSubview:bgImage];
        [bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.view addSubview:videoView];
        
        [self setupPlayer];
        
        //添加view到播放器界面上
        self.liveView = [[WKLiveView alloc] initWithFrame:self.view.bounds model:_homeModel];
        self.liveView.layer.masksToBounds = YES;
        self.liveView.delegate = self;
        [self.view addSubview:self.liveView];
        
        [self addSwipeGesture];
        
        [self.liveView layoutIfNeeded];
        
        [self commitView];
        [self addTapGesture];
//        [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//        }];
        NSString *memberNo = _homeModel.MemberNo;
        WeakSelf(WKLiveViewController);
        self.liveView.liveCallBack = ^(NSInteger type){
            switch (type) {
                case 1://私信
                {
                    WKSmallChatListViewController *chatList =
                    [[WKSmallChatListViewController alloc]init];
                    chatList.isLive = YES;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatList];
                    nav.navigationBar.hidden = YES;
                    [weakSelf addChildViewController:nav];
                    [weakSelf.view addSubview:nav.view];
                }
                    break;
                case 2://充值
                {
                    [WKShowInputView showInputWithPlaceString:@"当前余额不足,是否去充值" type:LABELTYPE andBlock:^(NSString *str) {
                        WKEmptyViewController *rechargeVC = [[WKEmptyViewController alloc] init];
                        [weakSelf presentViewController:rechargeVC animated:YES completion:NULL];
                    }];
                }
                    break;
                case 3://红包
                {
                    WKRedPacketViewController *redPacketVC = [[WKRedPacketViewController alloc]init];
                    redPacketVC.type = 2;
                    redPacketVC.memberNo = memberNo;
                    [weakSelf.navigationController pushViewController:redPacketVC animated:YES];
                }
                    break;
            }
        };
        // 查看 直播状态  0 : 直播ing  1: pause 2: 未直播
        if (_homeModel.CurrentShowStatus.integerValue == 0) {
            // 正在直播
            [_player play];
        }else if (_homeModel.CurrentShowStatus.integerValue == 1){
            // 暂停直播
            [self videoPauseWithType:WKVideoStatusPause];
        }else{
            // 未直播
            [self videoPauseWithType:WKVideoStatusStop];
        }
        
        if (_from == WKLiveFromHotGoods) {
            WKGoodsListItem *item = [[WKGoodsListItem alloc] init];
            item.GoodsCode = [NSNumber numberWithInteger:_homeModel.GoodsCode.integerValue];
            BOOL showGoods;
            if (_homeModel.SaleType.integerValue != 0) {
                showGoods = NO;
            }else{
                showGoods = YES;
            }
            [self showLiveLayoutWithItem:item showGoods:showGoods];
        }
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WKVideoPauseView *PasueView = [[WKVideoPauseView alloc]initWithFrame:CGRectZero PlayModel:_homeModel];
    self.preView = PasueView;
    [PasueView setLiveType:StartShow rect:self.view.bounds];
    [self.view addSubview:self.preView];
    _currentType = StartShow;
    
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    User.showStatus = WKShowStatusPlaying;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 监测播放状态
    [self setupObservers];
    
    //记录用户观看历史
    [self history];
    
    // 用户听语音是静音
    [self xw_addNotificationForName:@"AUDIOPLAYING" block:^(NSNotification * _Nonnull notification) {
        if (_player.isPlaying) {
            NSNumber *isMute = notification.userInfo[@"isPlaying"];
            _player.shouldMute = isMute.boolValue;
        }
    }];
    
    // 监测用户网络状态
    [self xw_addNotificationForName:@"TOFOLLOWVC" block:^(NSNotification * _Nonnull notification) {
        [self exitLiveShowWithAnimated:NO];
    }];
    
    self.preStateShow = YES;
    [self xw_addNotificationForName:@"BALANCE" block:^(NSNotification * _Nonnull notification) {
        
        [WKShowInputView showInputWithPlaceString:@"当前余额不足,是否去充值" type:LABELTYPE andBlock:^(NSString *str) {
            self.isPresent = YES;
            WKEmptyViewController *rechargeVC = [[WKEmptyViewController alloc] init];
            //        [self. pushViewController:rechargeVC animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:rechargeVC animated:YES completion:NULL];
            });
        }];
    }];

}

//MARK: 监测系统权限
- (void)checkSystemJurisdiction{
    
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied || audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied) {// 未授权
        
        [WKShowInputView showInputWithPlaceString:@"观看直播需要打开相机和麦克风权限,前往设置->秀加加打开" type:LABELTYPE andBlock:^(NSString *text) {
            
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication] openURL:settingUrl];
            }
        }];
    }
}

-(void)setupPlayer{
    lastSize = 0.0;
    
    _player = [[KSYMoviePlayerController alloc] initWithContentURL:self.url];
    [_player.view setFrame:videoView.bounds];  // player's frame must match parent's
    [videoView addSubview:_player.view];
    
    videoView.autoresizesSubviews = TRUE;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _player.scalingMode = MPMovieScalingModeAspectFill;

    _player.shouldAutoplay = TRUE;
    //    _player.bufferTimeMax = 5;
    _player.shouldEnableVideoPostProcessing = TRUE;
    content_mode = _player.scalingMode + 1;
    if(content_mode > MPMovieScalingModeFill)
        content_mode = MPMovieScalingModeNone;
    _player.shouldEnableKSYStatModule = FALSE;
    _player.shouldLoop = NO;
    [_player setTimeout:30 readTimeout:60 * 5];
    
//    NSLog(@"sdk version:%@", [_player getVersion]);
    [_player prepareToPlay];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - 确定横竖屏
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_type == WKGoodsLayoutTypeHoriztal) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (_type == WKGoodsLayoutTypeHoriztal) {
        return UIInterfaceOrientationLandscapeRight;
    }else{
        return UIInterfaceOrientationPortrait;
    }
}

- (NSTimeInterval) getCurrentTime{
    return [[NSDate date] timeIntervalSince1970];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: 监测拉流的状态
-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {

        if (_homeModel.CurrentShowStatus.integerValue == 1) {
            [_player pause];
        }
        
        // using autoPlay to start live stream
//        [_player play];
//        serverIp = [_player serverAddress];
//        NSLog(@"KSYPlayerVC: %@ -- ip:%@", [[_player contentURL] absoluteString], serverIp);
//        prepared_time = (long long int)([self getCurrentTime] * 1000);
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
//        NSLog(@"------------------------");
//        NSLog(@"player playback state: %ld", (long)_player.playbackState);
//        NSLog(@"------------------------");
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        NSLog(@"player load state: %ld", (long)_player.loadState);
        
        if (_player.loadState == MPMovieLoadStatePlayable || _player.loadState == MPMovieLoadStateUnknown) {

            if (self.preView) {
                return;
            }
            WKVideoPauseView *videoPuaseView = [[WKVideoPauseView alloc]initWithFrame:CGRectZero PlayModel:_homeModel];
            [videoPuaseView setLiveType:StartShow rect:videoView.bounds];
            self.preView = videoPuaseView;

            [videoView addSubview:self.preView];

            [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];

        }else{

            if (_homeModel.CurrentShowStatus.integerValue == 0) {
                [self.preView removeFromSuperview];
                self.preView = nil;
            }
        }

    }
    
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
//        NSLog(@"video size %.0f-%.0f", _player.naturalSize.width, _player.naturalSize.height);
    }
    if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
    {
//        fvr_costtime = (int)((long long int)([self getCurrentTime] * 1000) - prepared_time);
//        NSLog(@"first video frame show, cost time : %dms!\n", fvr_costtime);
    }
    
    if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
    {
//        far_costtime = (int)((long long int)([self getCurrentTime] * 1000) - prepared_time);
//        NSLog(@"first audio frame render, cost time : %dms!\n", far_costtime);
    }
    
    if (MPMoviePlayerSuggestReloadNotification == notify.name)
    {
        [_player reload:self.url flush:true mode:MPMovieReloadMode_Accurate];
//        NSLog(@"suggest using reload function!\n");
    }
    
    if(MPMoviePlayerPlaybackStatusNotification == notify.name)
    {
        int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
        if(MPMovieStatusVideoDecodeWrong == status)
        {
//            NSLog(@"Video Decode Wrong!\n");
        }
        else if(MPMovieStatusAudioDecodeWrong == status)
        {
//            NSLog(@"Audio Decode Wrong!\n");
        }
        else if (MPMovieStatusHWCodecUsed == status )
        {
//            NSLog(@"Hardware Codec used\n");
        }
        else if (MPMovieStatusSWCodecUsed == status )
        {
//            NSLog(@"Software Codec used\n");
        }
    }
    
}

- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerSuggestReloadNotification)
                                              object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStatusNotification)
                                              object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLiveShow) name:Unauthorized object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLiveShow) name:APPKILL object:nil];
}

- (void)releaseObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMovieNaturalSizeAvailableNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerFirstVideoFrameRenderedNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerFirstAudioFrameRenderedNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerSuggestReloadNotification
                                                 object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStatusNotification
                                                 object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Unauthorized object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKILL object:nil];
}

#pragma mark - 播放器回调
- (void)operateWith:(ClickLiveType)type{
    if (type == ClickExitType) {
        // 退出当前房间  已确认 观看用户退出不需要弹出提示
        [self exitLiveShowWithAnimated:YES];
        
    }else if (type == ClickShopType){
        
        NSDictionary *param = @{
                                @"ShopOwnerNo":_homeModel.MemberNo,
                                @"IsSelectAll":@"false",
                                @"PageIndex":@(1),
                                @"PageSize":@(15)
                                };
        
        WeakSelf(WKLiveViewController);
        [WKGoodsCollectionView showGoodsListOn:self.view WithScreenType:_type goodsType:WKGoodsTypeSale requestParameters:param clientType:WKClientTypePlay selectedBlock:^(id goodsItem){
            // 查看商品详情
            WKGoodsListItem *item = goodsItem;
            // 点击查看商品详情
            _from = WKLiveFromHotSaler;
            [weakSelf showLiveLayoutWithItem:item showGoods:YES];
        }];
    }
    else if(type == ClickIconType)
    {
        [self loadingUserMessage:_homeModel.BPOID andType:WKLiveHost];
    }else if (type == ClickLiveTypeRank){
        WKContributorViewController *rankList = [[WKContributorViewController alloc] initWithShopOwnerNo:_homeModel.MemberNo];
        [self.navigationController pushViewController:rankList animated:YES];
        
    }else if(type == ClickLiveTypeVirtual){
        // 虚拟世界
        WKVirtualWorldViewController *virtualWorld = [[WKVirtualWorldViewController alloc] init];
        [self.navigationController pushViewController:virtualWorld animated:YES];
    }else if (type == ClickLiveTypeToOnlineList){
        // to online list
        WKAllOnlineViewController *onlineVC = [[WKAllOnlineViewController alloc] initWithMemberNo:_homeModel.MemberNo];
        [self.navigationController pushViewController:onlineVC animated:YES];
    }
    else{
        NSLog(@"ignore this event");
    }
}

//MARK: 退出当前房间  已确认 观看用户退出不需要弹出提示
- (void)exitLiveShowWithAnimated:(BOOL)animated{
    User.showStatus = WKShowStatusNormal;

    [self releaseObservers];
    if (self.playStop) {
        self.playStop();
    }
    [self xw_postNotificationWithName:@"LIVEEND" userInfo:nil];
    
    [self stopPlay];
    [self dismissViewControllerAnimated:animated completion:NULL];
}

- (void)exitLiveShow{
    User.showStatus = WKShowStatusNormal;
    
    [self releaseObservers];
    if (self.playStop) {
        self.playStop();
    }
    
    [self stopPlay];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//MARK: Present to Goods Detail VC
- (void)showLiveLayoutWithItem:(WKGoodsListItem *)item showGoods:(BOOL)showGoods{
    
    WKGoodsDetailViewController *goodsDetailVC = [[WKGoodsDetailViewController alloc] initWithGoodsItem:item playModel:_homeModel from:_from showGoods:showGoods];
    goodsDetailVC.delegate = self;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];

    [videoView removeFromSuperview];
    [self.navigationController.view addSubview:videoView];
    self.VFView.frame = CGRectMake(0, 0, WKScreenW/3, WKScreenH/4);

    [UIView animateWithDuration:0.3 animations:^{
        videoView.frame = CGRectMake(0, 64, WKScreenW/3, WKScreenH/4);
    } completion:^(BOOL finished) {

    }];
    
    if (self.preView) {
        if ([self.preView isKindOfClass:[WKLeaveShowView class]]) {
            WKLeaveShowView *leave = (WKLeaveShowView *)self.preView;
            [leave setShowType:WKLeaveShowTypeGoodsInfo rect:self.VFView.bounds];
        }else{
            WKVideoPauseView *pauseView = (WKVideoPauseView *)self.preView;
            [pauseView setLiveType:LeavingOnGoods rect:self.VFView.bounds];
        }
    }
    
//    [self xw_postNotificationWithName:@"TOGOODSDETAIL" userInfo:nil];
}


- (void)operateWith:(ClickLiveType)type md:(id)md{
    if ([md isKindOfClass:[WKOnLineMd class]]) {
        WKOnLineMd *obj = md;
        if (obj.isAddItem) {
            [self operateWith:ClickLiveTypeToOnlineList];
        }else{
            [self loadingUserMessage:obj.BPOID andType:WKLiveWatch];
        }
        
    }else if ([md isKindOfClass:[WKAuctionStatusModel class]]){
        if (type == ClickLiveTypeToRecharge) {
            WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc] init];
            [self presentViewController:rechargeVC animated:YES completion:NULL];
        }else{
            WKAuctionStatusModel *obj = md;
            
            WKGoodsListItem *item = [[WKGoodsListItem alloc] init];
            item.GoodsCode = [NSNumber numberWithInteger:obj.GoodsCode.integerValue];
            [self showLiveLayoutWithItem:item showGoods:NO];
        }
       
    }else if ([md isKindOfClass:[NSNumber class]]){
        WKEmptyViewController *rechargeVC = [[WKEmptyViewController alloc]init];
        [self presentViewController:rechargeVC animated:NO completion:NULL];
    }else if ([md isKindOfClass:[WKMessage class]]){
        WKRedPacketDetails *packetDetails = [[WKRedPacketDetails alloc]init];
        packetDetails.model = md;
        [self.navigationController pushViewController:packetDetails animated:YES];
    }else if ([md isKindOfClass:[NSString class]]){
        // foolish activity
        NSString *linkUrl = md;
        WKAllWebViewController *allWebVc = [[WKAllWebViewController alloc] init];
        allWebVc.titles = @"愚人节活动";
        allWebVc.urlString = linkUrl;
        [self.navigationController pushViewController:allWebVc animated:YES];
    }
}
// MARK: 推流的状态
- (void)videoStatus:(WKVideoStatus)status{
    if (status == WKVideoStatusPause) {
        _homeModel.CurrentShowStatus = @1;
        [self videoPauseWithType:WKVideoStatusPause];
    }else if (status == WKVideoStatusStop){
        // 停止 拉流
        _homeModel.CurrentShowStatus = @2;
        [self videoPauseWithType:WKVideoStatusStop];
    }else{
        [self videoStart];
    }
}

- (void)videoStart{
    // 开始拉流
//    NSLog(@"_homeModel status %@",_homeModel.CurrentShowStatus);
    
    if (_homeModel.CurrentShowStatus.integerValue == 2) {
//        NSLog(@"_homeModel status %@",_homeModel.CurrentShowStatus);
//        [_player play];
        [_player reload:self.url flush:false mode:MPMovieReloadMode_Accurate];
    }else{
        [_player play];
    }
    
    _homeModel.CurrentShowStatus = @0;

    [UIView animateWithDuration:0.2 animations:^{
        self.preView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.preView removeFromSuperview];
    }];
}

- (void)videoPauseWithType:(WKVideoStatus)type{
    
    if (self.preView) {
        [self.preView removeFromSuperview];
        self.preView = nil;
        // 暂停推流
    }
    
    if (type == WKVideoStatusPause) {
        WKVideoPauseView *videoPuaseView = [[WKVideoPauseView alloc] initWithFrame:CGRectZero PlayModel:_homeModel];
        self.preView = videoPuaseView;
        if (self.navigationController.viewControllers.count != 1) {
            UIViewController *secondVC = self.navigationController.viewControllers[1];
            if ([secondVC isKindOfClass:[WKGoodsDetailViewController class]]) {
                [videoPuaseView setLiveType:LeavingOnGoods rect:videoView.bounds];
            }else{
                [videoPuaseView setLiveType:LeavingOnLive rect:videoView.bounds];
            }
        }else{
            [videoPuaseView setLiveType:LeavingOnLive rect:videoView.bounds];
        }
        
    }else{
        WKLeaveShowView *leaveShow = [[WKLeaveShowView alloc] initWithFrame:CGRectZero playModel:_homeModel];
        self.preView = leaveShow;
        if (self.navigationController.viewControllers.count != 1) {
            UIViewController *secondVC = self.navigationController.viewControllers[1];
            if ([secondVC isKindOfClass:[WKGoodsDetailViewController class]]) {
                [leaveShow setShowType:WKLeaveShowTypeGoodsInfo rect:videoView.bounds];
            }else{
                [leaveShow setShowType:WKLeaveShowTypeLive rect:videoView.bounds];
            }
        }else{
            [leaveShow setShowType:WKLeaveShowTypeLive rect:videoView.bounds];
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player pause];
    });

    [videoView addSubview:self.preView];
    
    self.VFView.frame = videoView.bounds;
//    self.preView.frame = videoView.bounds;
    
    //NSLog(@"video width %f",videoView.bounds.size.width);
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [videoView layoutIfNeeded];
}

- (void)addSwipeGesture{
    UIPanGestureRecognizer *swiptGestureToRight = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeController:)];
    [self.view addGestureRecognizer:swiptGestureToRight];
}

- (void)swipeController:(UIPanGestureRecognizer *)gesture{
    [self.liveView endEditing:YES];
//    CGPoint startPoint;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
//            startPoint = [gesture locationInView:self.view];
//            NSLog(@"start point x : %f",startPoint.x);
//            [self.bulletManager stop];
        }
            break;
        case UIGestureRecognizerStateChanged:{

            CGPoint translationPoint = [gesture translationInView:self.view];
            
            if (self.preStateShow) {
                if (translationPoint.x > 0) {
                    self.liveView.frame = CGRectMake(translationPoint.x, 0, WKScreenW, WKScreenH);

                }else{
                    self.liveView.frame = self.view.bounds;
                }

            }else{
                
                if (translationPoint.x < 0) {
                    self.liveView.frame = CGRectMake(WKScreenW + translationPoint.x, 0, WKScreenW, WKScreenH);
                }else{
                    self.liveView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            if (self.preStateShow) {
                if (self.liveView.frame.origin.x >= WKScreenW/5) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.liveView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
                    } completion:^(BOOL finished) {
                        self.preStateShow = NO;
                    }];
                    
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        self.liveView.frame = self.view.bounds;
                    } completion:^(BOOL finished) {
//                        [self.bulletManager start];
                    }];
                }
            }else{
                if (self.liveView.frame.origin.x <= WKScreenW * 4/5) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.liveView.frame = self.view.bounds;
                    } completion:^(BOOL finished) {
                        self.preStateShow = YES;
//                        [self.bulletManager start];
                    }];
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        self.liveView.frame = CGRectMake( WKScreenW,0, self.view.frame.size.width, self.view.frame.size.height);
                    } completion:^(BOOL finished) {

                    }];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


// MARK: 选择地址
- (void)selectAddress:(WKPayView *)auctionModel{
    UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskBtn.frame = self.view.bounds;
    [maskBtn addTarget:self action:@selector(dismissAddress:) forControlEvents:UIControlEventTouchUpInside];
    maskBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self.view addSubview:maskBtn];
    self.maskBtn = maskBtn;
    
    WKAddressViewController *address = [[WKAddressViewController alloc] initWithFrom:WKAddressFromLive];
    address.delegate = self;
    WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:address];
    nav.view.frame = CGRectMake(0, WKScreenH - (44 * 10), WKScreenW, 44 * 10);

    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    self.addressVC = nav;
    self.payView = auctionModel;
}

- (void)leaveAddressList{
    [self dismissAddress:self.maskBtn];
}

- (void)selectedAddress:(WKAddressListItem *)address{
    self.payView.auctionModel.addressModel = address;
    [self dismissAddress:self.maskBtn];
}

// 退出播放 关闭拉流 和 socket连接
- (void)stopPlay{
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        self.playStop = nil;
        _player = nil;
    }
    
    [self xw_postNotificationWithName:DISMISSLIVEVIEW userInfo:nil];
}

//MARK: Back From Goods Detail VC
- (void)backToShowWith:(WKBackShowType)backType orderInfo:(id)orderInfo{
    [WKGoodsCollectionView dismiss];
    if (backType == WKBackShowTypePay) {
        WKPaySuccessView *paySuccessView = [[WKPaySuccessView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)orderItem:orderInfo];
        [self.view addSubview:paySuccessView];
        [paySuccessView show];
    }
    
    [videoView removeFromSuperview];
    self.VFView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH);

    [UIView animateWithDuration:0.3 animations:^{
        videoView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        [self.view addSubview:videoView];
        [self.view insertSubview:videoView atIndex:0];
    }];
    
    if (self.preView) {
        if ([self.preView isKindOfClass:[WKLeaveShowView class]]) {
            WKLeaveShowView *leave = (WKLeaveShowView *)self.preView;
            [leave setShowType:WKLeaveShowTypeLive rect:videoView.bounds];
        }else{
            WKVideoPauseView *pauseView = (WKVideoPauseView *)self.preView;
            [pauseView setLiveType:LeavingOnLive rect:videoView.bounds];
        }
    }
    
    if (_from == WKLiveFromHotGoods && backType != WKBackShowTypeHotGoods) {
        [self exitLiveShowWithAnimated:YES];
    }
}

-(void)loadingUserMessage:(NSString *)memberID andType:(WKUserType)userType
{
    NSString *urlStr = [NSString configUrl:WKUserMessageDetails With:@[@"BPOID",@"VisitBPOID",@"LiveStatus"] values:@[User.BPOID,memberID,@"2"]];
    [WKHttpRequest UserDetailsMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKUserMessageModel *userMessageModel = [WKUserMessageModel yy_modelWithJSON:response.Data];
        if ([memberID isEqualToString:User.BPOID]) {
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:mySelfMessage chatType:emptyType :^(NSInteger type){
                
            }];
            
        }else{
            styleType type;
            if (userType == WKLiveHost) {
                type = hostType;
            }else{
                type = privateChatType;
            }
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:type :^(NSInteger type){
                if (type == 2) {
                    WKSmallChatViewController *smallChat = [[WKSmallChatViewController alloc]init];
                    smallChat.isLive = YES;
                    smallChat.conversationType = ConversationType_PRIVATE;
                    smallChat.targetId = userMessageModel.BPOID;
                    smallChat.title = userMessageModel.MemberName;
                    smallChat.backType = hiddenBack;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:smallChat];
                    nav.navigationBar.hidden = YES;
                    [self addChildViewController:nav];
                    [self.view addSubview:nav.view];
                }else if (type == 3) {
                    WKRedPacketViewController *redPacketVC = [[WKRedPacketViewController alloc]init];
                    redPacketVC.type = 1;
                    redPacketVC.memberName = userMessageModel.MemberName;
                    redPacketVC.memberNo = _homeModel.MemberNo;
                    redPacketVC.receiveBPOID = memberID;
                    [self.navigationController pushViewController:redPacketVC animated:YES];
                }
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)dismissAddress:(UIButton *)btn{
    
    [self.addressVC willMoveToParentViewController:nil];
    [self.addressVC.view removeFromSuperview];
    
    [self.addressVC removeFromParentViewController];
//
    [btn removeFromSuperview];
    
    //self.currentVC = self;
    self.payView.hidden = NO;
    self.addressVC = nil;
}

//直播历史记录
-(void)history
{
    NSString *urlStr = [NSString configUrl:WKPlayHistory With:@[@"ShowBPOID"] values:@[_homeModel.BPOID]];
    
    [WKHttpRequest PlayHistory:HttpRequestMethodPost url:urlStr model:nil param:nil success:^(WKBaseResponse *response) {
        
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
        
    }];
}
#pragma mark 弹幕
-(void)commitView{
    [self uploadBulletViewFrame];//更新弹幕位置
    [self xw_addNotificationForName:@"sendComment" block:^(NSNotification * _Nonnull notification) {
        WKBarrageModel *barrageModel = [[WKBarrageModel alloc]init];
        barrageModel.nameStr = notification.userInfo[@"name"];
        barrageModel.content = [notification.userInfo[@"message"] isEqual:[NSNull null]]?@" ":notification.userInfo[@"message"];
        barrageModel.headPic = notification.userInfo[@"usericon"];
        barrageModel.level = _homeModel.LoginMemberLevel.integerValue;
        barrageModel.BPOID = notification.userInfo[@"bpoid"];
        [self.bulletManager insertBullet: barrageModel];
    }];
    
    self.bulletManager = [[WKBulletManager alloc] init];
    WeakSelf(WKLiveViewController);
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

-(void)uploadBulletViewFrame{
    [self xw_addNotificationForName:@"SHOWINPUT" block:^(NSNotification * _Nonnull notification) {
        CGFloat y = [notification.userInfo[@"kbheight"] floatValue];
        self.bulletBgView.frame = CGRectMake(0,(WKScreenW>WKScreenH?WKScreenH*0.05:WKScreenW*0.73)-y, CGRectGetWidth(self.view.frame), WKScreenW>WKScreenH?WKScreenH*0.35:WKScreenW*0.35);
    }];
    [self xw_addNotificationForName:@"DISMISSINPUT" block:^(NSNotification * _Nonnull notification) {
        self.bulletBgView.frame = CGRectMake(0,WKScreenW>WKScreenH?WKScreenH*0.05:WKScreenW*0.73, CGRectGetWidth(self.view.frame), WKScreenW>WKScreenH?WKScreenH*0.35:WKScreenW*0.35);
    }];
}

- (WKBulletBackgroudView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[WKBulletBackgroudView alloc] init];
        _bulletBgView.frame = CGRectMake(0,WKScreenW>WKScreenH?WKScreenH*0.05:WKScreenW*0.73, CGRectGetWidth(self.view.frame), WKScreenW>WKScreenH?WKScreenH*0.35:WKScreenW*0.35);
//        _bulletBgView.backgroundColor = [UIColor redColor];
        [self.liveView addSubview:_bulletBgView];
        for (UIView *item in self.liveView.subviews) {
            if ([item isKindOfClass:NSClassFromString(@"WKMessageListView")]) {
                [self.liveView insertSubview:_bulletBgView belowSubview:item];
            }
        }
    }
    return _bulletBgView;
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [self.bulletBgView dealTapGesture:gesture block:^(WKBulletView *bulletView){
        if (bulletView.BPOID.length>0) {
            [self loadingUserMessage:bulletView.BPOID andType:WKLiveWatch];
        }
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.cancelsTouchesInView = NO;
    [self.liveView addGestureRecognizer:tap];
}

@end
