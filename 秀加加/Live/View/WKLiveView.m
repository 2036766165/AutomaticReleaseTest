//
//  WKLiveView.m
//  秀加加
//
//  Created by lin on 2016/10/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveView.h"
#import "WKOnlinePerson.h"
#import "WKSignalRDelegate.h"
#import "WKLiveShopView.h"
#import "WKLiveVirShopView.h"
#import "WKHorizontalList.h"
#import "WKGoodsCollectionView.h"

#import "WKAuctionStatusModel.h"
#import "WKAuctionStatusView.h"

#import "WKAuctionJoinView.h"
#import "WKGoodsHorCollectionViewCell.h"
#import "WKPayView.h"
#import "WKMessage.h"
#import "WKMessageListView.h"
#import "WKOnLineMd.h"
#import "NSObject+XWAdd.h"
#import "NSString+substring.h"
#import "WKOnlinePersonListView.h"
#import "WKPayTool.h"

#import "WKCashView.h"
#import "WKVirtualGiftModel.h"

#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
#import "UIImage+Gif.h"
#import "WKAuctionPriceView.h"

#import "WKAddressModel.h"
#import "WKAddressViewController.h"
#import "WKPayView.h"
#import "WKVideoPauseView.h"
#import "PopoverView.h"
#import "WKShareTool.h"
#import "WKAuctionPriceView.h"
#import "WKPaySuccessView.h"
#import <RongIMKit/RongIMKit.h>
#import "WKStoreRechargeViewController.h"

#import "WKShowInputView.h"
#import "WKAuctioningListView.h"

#import "StartAuctionAnimation.h"
#import "WKButton.h"
#import "WKGrabRedView.h"
#import "WKSingleRedEvenlopeView.h"

static NSString *reusableCell = @"cell";

@interface WKLiveView() <WKOnlinePersonDelegate,WKMessageDelegate,WKSingalRDelegate>{
    WKHomePlayModel *_tempModel;
    WKGoodsLayoutType _type;
    BOOL _autoCheckAuctionStatus;
    BOOL _animationBtn;
}

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIButton *focusBtn;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *onLineLabel;
@property (nonatomic,strong) UIView *redPointView;
@property (assign, nonatomic) BOOL isShow;
@property (nonatomic,strong) NSMutableArray *allOnlineUsers;
@property (nonatomic,strong) WKSignalRDelegate *sigDelegate;     // 聊天
@property (nonatomic,strong) WKMessageListView *messageList;       // 聊天列表
@property (nonatomic,strong) WKOnlinePersonListView *onlinePerson; // 在线人数
@property (nonatomic,strong) UIButton *exitBtn;      // 退出按钮
@property (nonatomic,strong) UIButton *chatBtn;      // 聊天
@property (nonatomic,strong) UIButton *redBagBtn;    // 红包
@property (nonatomic,strong) UIButton *goodsBtn;      // 商品
@property (nonatomic,strong) UIImageView *auctionBtn;    // 拍卖
@property (strong, nonatomic) UIButton * chatListBtn; // 私聊
@property (nonatomic,strong) UIButton *shareBtn;      // 分享
@property (nonatomic,strong) WKAuctionStatusModel *currentAuctionModel;
@property (nonatomic,strong) NSString *playMpdel;
@property (nonatomic,strong) WKAuctionPriceView *priceLabel;
@property (nonatomic,strong) WKPayView *payView;
@property (assign, nonatomic) NSInteger saleStatus;//拍卖弹幕状态
@property (nonatomic,copy) NSString *sendMsg;      // 要发送的消息
@property (assign, nonatomic) NSInteger count;//判断是不是第一次参与拍卖,调整弹幕状态
@property (nonatomic,strong) WKAuctioningListView *auctionListView;

@property (nonatomic,copy) NSString *fool_linkUrl;
/*
 0 正常未禁言
 1 主播禁言
 2 系统禁言
 */
@property (assign,nonatomic)  NSInteger talkStatus;
@property (nonatomic,strong) UIButton *contributorRank;        // 贡献榜
@property (nonatomic,strong) UIButton *virtualWorld;        // 虚拟世界
@property (nonatomic,assign) BOOL isFirstShow;       // is first to show

@property (nonatomic,strong) WKSingleRedEvenlopeView *singleRed;

@end

@implementation WKLiveView

- (WKSingleRedEvenlopeView *)singleRed{
    if (!_singleRed) {
        _singleRed = [[WKSingleRedEvenlopeView alloc] init];
    }
    return _singleRed;
}

- (instancetype)initWithFrame:(CGRect)frame model:(WKHomePlayModel*) model
{
    if (self = [super initWithFrame:frame])
    {
        // 聊天
        WKSignalRDelegate *sigDelegate = [[WKSignalRDelegate alloc] initWithMemberNo:model.MemberNo andBPOId:User.BPOID];
        self.sigDelegate = sigDelegate;
        self.sigDelegate.delegate = self;
        
        [self xw_addNotificationForName:DISMISSLIVEVIEW block:^(NSNotification * _Nonnull notification) {
            [sigDelegate disconnect];
            //            sigDelegate = nil;
        }];
        
        self.inputType = WKInputTypText;
        self.talkStatus = 0;
        
        //传入mdoel
        _tempModel = model;
        _playMpdel = model.PlayMode;
        self.count = 0;
        self.backgroundColor = [UIColor clearColor];
        
        if (_playMpdel.integerValue == 1) {
            _type = WKGoodsLayoutTypeHoriztal;
        }else{
            _type = WKGoodsLayoutTypeVertical;
        }
        //用来判断动画是否播放
        self.isShow = NO;
        
        // 查看是否当前主播 ###############################
        [self checkStarStatus];
        
        // 实例化界面
        [self initUi];
        
        // 进入界面主动查看拍卖状态
        _autoCheckAuctionStatus = YES;
        [self checkAuctionStatus];
        
        // show activity icon
        [self showActivity];
        
        // 订阅查看打赏和加价的消息
        [self xw_addNotificationForName:@"TAPICON" block:^(NSNotification * _Nonnull notification) {
            
            NSString *bpoid = notification.userInfo[@"BPOID"];
            WKOnLineMd *md = [WKOnLineMd new];
            md.BPOID = bpoid;
            
            [self selectedPerson:md];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"SHOWINPUT" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"DISMISSINPUT" object:nil];
        
        [self xw_addNotificationForName:@"redCircle" block:^(NSNotification * _Nonnull notification) {
            [self setRedPointViewHidden];
        }];
    }
    return self;
}

// resolve singalR msg
- (void)receiveMsgType:(WKMessageInfoType)type msgBody:(id)obj{
    
    switch (type) {
        case WKMessageInfoTypeReceiveMsg:{
            // 接受消息
            NSMutableDictionary *dict = [(NSDictionary *)obj mutableCopy];
            NSString *str = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dict setObject:str forKey:@"message"];
            if ([dict[@"messageType"] integerValue]==1) {
                [self xw_postNotificationWithName:@"sendComment" userInfo:dict];
            }
            [self recmsgWith:dict type:WKMessageTypeUser];
            
        }
            break;
            
        case WKMessageInfoTypeSystemMsg:{
            // 接受消息
            NSDictionary *dict = obj;
            [self recmsgWith:dict type:WKMessageTypeSystem];
            if ([dict[@"messageType"] integerValue]==1) {
                [self xw_postNotificationWithName:@"sendComment" userInfo:dict];
            }
        }
            break;
        case WKMessageInfoTypeSystemMsgPush:{
            // 接受多条消息
            NSArray *messages = (NSArray *)obj;
            
            for (int i=0; i<messages.count; i++) {
                NSDictionary *dict = messages[i];
                [self recmsgWith:dict type:WKMessageTypeSystem];
            }
        }
            break;
            
        case WKMessageInfoTypeImg:{
            NSDictionary *dict = (NSDictionary *)obj;
            [self recmsgWith:dict type:WKMessageTypeUser];
        }
            break;
            
        case WKMessageInfoTypeAuction:{
            // 拍卖状态 (开始/结束)
            NSDictionary *dict = (NSDictionary *)obj;
            WKAuctionStatusModel *md = [WKAuctionStatusModel yy_modelWithJSON:dict];
            _currentAuctionModel.Status = md.Status;
            _currentAuctionModel.Price = md.Price;
            _currentAuctionModel.CurrentPrice = md.CurrentPrice;
            _currentAuctionModel.Count = md.Count;
            
            if (md.Status.integerValue == 1) {
                [WKAuctionStatusView dismissView];
                
                if (!self.auctionListView) {
                    WKAuctioningListView *auctionView = [[WKAuctioningListView alloc] initWithFrame:CGRectMake(0, 80, WKScreenW, 50)];
                    [self addSubview:auctionView];
                    auctionView.block = ^(WKAuctionJoinModel *model){
                        WKOnLineMd *person = [[WKOnLineMd alloc] init];
                        person.BPOID = model.CustomerBPOID;
                        WKOnLineMd *md = [WKOnLineMd new];
                        md.BPOID = model.CustomerBPOID;
                        [self selectedPerson:md];
                    };
                    [auctionView setAuctionerInfo:md];
                    self.auctionListView = auctionView;
                }else{
                    
                    if (md.SaleType.integerValue == 2) {
                        WKAuctionJoinModel *joinMd = [[WKAuctionJoinModel alloc] init];
                        //                            joinMd.CustomerNo = md.CurrentMemberBPOID;
                        joinMd.CustomerName = md.CurrentMemberName;
                        joinMd.Price = md.Price;
                        joinMd.CurrentPrice = md.CurrentPrice;
                        joinMd.CustomerPicUrl = md.MemberPhotoUrl;
                        joinMd.Count = md.Count;
                        joinMd.CustomerBPOID = md.CurrentMemberBPOID;
                        
                        [self.auctionListView participatePersons:@[joinMd] showAnimation:NO];
                    }
                }
                
            }else if (md.Status.integerValue == 3){
                [WKAuctionStatusView dismissView];
                
                // luck buy end
                [self.auctionListView crowdEedWith:md superView:self];
                self.auctionListView = nil;
                
            }else{
                [self.auctionListView removeFromSuperview];
                self.auctionListView = nil;
            }
            
            if (md.Status.integerValue != 1) {
                [WKAuctionJoinView dismissView];
            }
            
            if (md.IsStart) {
                saleType saleType;
                if (md.SaleType.integerValue == 1) {
                    saleType = auctionType;
                }else{
                    saleType = luckBuyType;
                }
                
                StartAuctionModel *auctionStartMd = [[StartAuctionModel alloc] init];
                auctionStartMd.goodsPic = md.GoodsPic;
                auctionStartMd.goodsName = md.GoodsName;
                auctionStartMd.goodsPrice = [NSString stringWithFormat:@"%@",md.GoodsStartPrice];
                auctionStartMd.auctionTime = [NSString stringWithFormat:@"%0.0fmin",ceil(md.RemainTime.integerValue/60.0)];
                if (self.isShow) {
                    [StartAuctionAnimation startAcutionAnimation:saleType andData:auctionStartMd superView:self];
                }
            }
            
            [self showAuctionStatusWith:md];
        }
            
            break;
            
        case WKMessageInfoTypeJoin:{
            // join auction
            WKAuctionJoinModel *md = [WKAuctionJoinModel yy_modelWithJSON:(NSDictionary *)obj];
            _currentAuctionModel.Count = md.Count;
            
            if (self.auctionListView) {
                [self.auctionListView participatePersons:@[md] showAnimation:YES];
            }
        }
            break;
        case WKMessageInfoTypeAuctionBid:{
            // 拍卖(加价)
            NSDictionary *dict = (NSDictionary *)obj;
            WKAuctionStatusModel *md = [WKAuctionStatusModel yy_modelWithJSON:dict];
            md.Status = @1;
            
            // show the bid
            [self showAuctionStatusWith:md];
            
            self.currentAuctionModel.CurrentMemberName = [md.CurrentMemberName subEmojiStringTo:6 with:@"..."];
            self.currentAuctionModel.CurrentPrice = md.CurrentPrice;
            self.currentAuctionModel.AddPrice = md.AddPrice;
            self.currentAuctionModel.Price = md.Price;
            self.currentAuctionModel.Count = md.Count;
            
            //                    NSLog(@"user bop : %@ curren : %@",User.BPOID,md.CurrentMemberBPOID);
            [self.auctionListView bidWith:md];
            
            if ([User.BPOID isEqualToString:md.CurrentMemberBPOID]) {
                // higest bid
                self.currentAuctionModel.isMostHighPrice = YES;
            }else{
                //not higest bid
                self.currentAuctionModel.isMostHighPrice = NO;
            }
            
            WKVirtualGiftModel *virgifModel = [[WKVirtualGiftModel alloc] init];
            virgifModel.virtualPrice = dict[@"AddPrice"];
            virgifModel.virtualType = WKVirtualTypeAuction;
            virgifModel.virtualName = @"加价";
            virgifModel.bpoid = dict[@"CurrentMemberBPOID"];
            virgifModel.memberName = dict[@"CurrentMemberName"];
            virgifModel.memberIcon = dict[@"MemberPhotoUrl"];
            // the animation of bid
            [self animation:[NSString stringWithFormat:@"%zd",1] virtualModel:virgifModel];
            //                    [self reloadUserIsSale:model.MemberNo];
        }
            break;
            
        case WKMessageInfoTypeAuctionCount:{
            // 拍卖(新人加入拍卖)
            NSString *count = obj;
            self.currentAuctionModel.Count = [NSNumber numberWithInteger:count.integerValue];
        }
            break;
            
        case WKMessageInfoTypeVideoPause:{
            // 暂时离开
            if ([_delegate respondsToSelector:@selector(videoStatus:)]) {
                [_delegate videoStatus:WKVideoStatusPause];
            }
        }
            break;
            
        case WKMessageInfoTypeVideoPlay:{
            // 主播回来
            if ([_delegate respondsToSelector:@selector(videoStatus:)]) {
                [_delegate videoStatus:WKVideoStatusPlay];
            }
        }
            break;
            
        case WKMessageInfoTypeVideoClose:{
            // 主播回来
            if ([_delegate respondsToSelector:@selector(videoStatus:)]) {
                [_delegate videoStatus:WKVideoStatusStop];
            }
        }
            break;
            
        case WKMessageInfoTypeRoomTalk:{
            // 禁言
            NSDictionary *dict = obj;
            NSString *bpoid = dict[@"bpoid"];
            NSInteger type = [dict[@"type"] integerValue];
            [self.onlinePerson setItemStateWithBPOID:bpoid type:type];
        }
            break;
            
        case WKMessageInfoTypeAuctionDelay:{
            // 主播回来
            NSDictionary *dict = obj;
            //                    NSLog(@"dict : %@",dict);
            NSNumber *delaySeconds = dict[@"DelaySeconds"];
            self.currentAuctionModel.RemainTime = delaySeconds;
            if (self.auctionListView) {
                [self.auctionListView delayTime:[delaySeconds integerValue]];
            }
        }
            break;
            
        case WKMessageInfoTypeHeadList:{
            
            NSArray *arr = [NSArray yy_modelArrayWithClass:[WKOnLineMd class] json:obj[@"mlist"]];
            BOOL rh = [obj[@"rh"] boolValue];
            
            NSInteger totalNumber = [obj[@"mct"] integerValue];
            
            if (arr.count > 0 && rh) {
                [self operateArr:arr Type:WKOperateTypeGetList totalAudience:totalNumber];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _onLineLabel.text = [NSString stringWithFormat:@"%ld",(long)totalNumber];
                });
            }
        }
            break;
            //MARK: Online
        case WKMessageInfoTypeOnline:{
            
            NSArray *arr = @[[WKOnLineMd yy_modelWithJSON:obj]];
            
            if (arr.count > 0) {
                NSDictionary *dict = obj;
                NSString *usericon = dict[@"MemberPhotoMinUrl"];
                NSString *name = dict[@"MemberName"];
                NSString *bpoid = dict[@"BPOID"];
                
                if (usericon && name && bpoid) {
                    NSDictionary *msgDict = @{
                                              @"usericon":dict[@"MemberPhotoMinUrl"],
                                              @"message":@"进入直播间",
                                              @"name":dict[@"MemberName"],
                                              @"bpoid":dict[@"BPOID"],
                                              @"ml":dict[@"ml"]
                                              };
                    [self recmsgWith:msgDict type:WKMessageTypeUser];
                }
            }
        }
            break;
            
        case WKMessageInfoTypeRedGroupEvenlop:{
            NSDictionary *msgDict = obj;
            BOOL isOffical = [msgDict[@"official"] boolValue];
            WKMessageType type;
            if (isOffical) {
                type = WKMessageTypeSystemRedBag;
            }else{
                type = WKMessageTypeUserRedBag;
            }
            
            [self recmsgWith:msgDict type:type];
        }
            break;
            
        case WKMessageInfoTypeRedSingleEvenlop:{
            NSDictionary *msgDict = obj;
            NSLog(@"msg %@",msgDict);
//            BOOL isOffical = [msgDict[@"official"] boolValue];
            WKMessage *msg = [[WKMessage alloc] init];
            msg.desc = msgDict[@"desc"];
            msg.fromname = msgDict[@"fromname"];
            msg.toname = msgDict[@"toname"];
            msg.fromphoto = msgDict[@"fromphoto"];
            msg.tophoto = msgDict[@"tophoto"];
            msg.money = msgDict[@"money"];
            
            WKMessageType type;
            if (msg.fromname.length == 0 || msg.fromname == nil) {
                type = WKMessageTypeSystemRedBag;
            }else{
                type = WKMessageTypeUserRedBag;
            }
            msg.type = type;
            [WKSingleRedEvenlopeView showAnimtaionWith:msg superView:self];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 收到消息的方法
- (void)recmsgWith:(NSDictionary *)dict type:(WKMessageType)type{
    //NSLog(@"dict is %@",dict);
    if ([dict isKindOfClass:[NSNull class]] || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    WKMessage *message = [WKMessage new];
    message.name = dict[@"name"];
    message.content = dict[@"message"] ;
    message.gif = dict[@"imgcode"];
    message.usericon = dict[@"usericon"];
    message.bpoid = dict[@"bpoid"];
    message.ml = dict[@"ml"];
    message.type = type;
    message.tp = dict[@"tp"];
    message.desc = dict[@"desc"];
    message.ID = dict[@"id"];
    message.official = [dict[@"offical"] boolValue];
    if (message.content) {
        message.isGif = NO;
    }else if(message.gif){
        message.isGif = YES;
    }else{
        _LOGD(@"未知类型的消息");
    }
    
    CGFloat cellWidth = 0.0;
    if (_type == WKGoodsLayoutTypeVertical) {
        // 竖屏 黄金比例
        cellWidth = WKScreenW * 0.8;
    }
    CGFloat labelHeight = 28; // 内容高度
    CGFloat labelWidth  = 0; // 内容宽度
    
    if (type == WKMessageTypeUser) {
        NSString *singleMsg = [NSString stringWithFormat:@"%@ %@",message.name,message.content];
        message.content = singleMsg;
        // 前留40 显示头像 后留 5 空白
        if (message.isGif) {
            CGFloat width = [message.name sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(CGFLOAT_MAX, 30)].width;
            labelWidth = 45 + width;
        }else{
            CGFloat width = [message.content sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(CGFLOAT_MAX, 30)].width;
            labelWidth = cellWidth - 70;
            if (width < labelWidth) {
                labelWidth = width;
            }else{
                labelWidth = cellWidth - 70;
                labelHeight = [message.content sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
            }
        }
        CGFloat cellHeight = labelHeight;
        if (message.isGif) {
            cellHeight = 85;
        }
        message.labelHeight = labelHeight;
        message.labelWidth = labelWidth;
        message.cellHeight = cellHeight + 2;
    }else if (type == WKMessageTypeSystem){
        // 前后留 5 个空白
        message.name = @"[直播消息]";
        NSString *singleMsg = [NSString stringWithFormat:@"%@ %@",message.name,message.content];
        message.content = singleMsg;
        CGFloat width = [message.content sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(CGFLOAT_MAX, 30)].width;
        labelWidth = cellWidth - 30;
        if (width < labelWidth) {
            labelWidth = width;
        }else{
            labelHeight = [message.content sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
        }
        
        CGFloat cellHeight = labelHeight;
        message.labelHeight = labelHeight;
        message.labelWidth = labelWidth;
        message.cellHeight = cellHeight + 2;
        
    }else if (type == WKMessageTypeUserRedBag || type == WKMessageTypeSystemRedBag){
        UIImage *redBagImage = [UIImage imageNamed:@"redtopush_user"];
        NSString *singleMsg = [NSString stringWithFormat:@"%@ %@",message.name,message.content];
        message.content = singleMsg;
        CGFloat width = [message.name sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(CGFLOAT_MAX, 30)].width;
        labelWidth = 45 + width;
        CGFloat cellHeight = 0;
        if (type == WKMessageTypeUserRedBag) {
            if ((labelWidth + redBagImage.size.width + 70) > WKScreenW * 0.8) {
                cellHeight = redBagImage.size.height + 35;
            }else{
                cellHeight = redBagImage.size.height;
            }
        }else{
            cellHeight = redBagImage.size.height + 5;
        }
        
        message.labelHeight = labelHeight;
        message.labelWidth = labelWidth;
        message.cellHeight = cellHeight + 2;
    }
    
    // 插入消息
    [self.messageList insertMessageWith:message];
}


//更新红点
-(void)setRedPointViewHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount]>0) {
            self.redPointView.hidden = NO;
        }else{
            self.redPointView.hidden = YES;
            self.redPointView = nil;
        }
    });
}

- (void)toOnlineList{
    // to online list vc
    if ([_delegate respondsToSelector:@selector(operateWith:)]) {
        [_delegate operateWith:ClickLiveTypeToOnlineList];
    }
}

//MARK:显示活动
- (void)showActivity{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKRoomActivity param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        if (response) {
            BOOL isShow = [response.Data[@"IsShow"] boolValue];
            if (isShow) {
                // show activity icon
                UIImageView *activityImageV = [UIImageView new];
                activityImageV.userInteractionEnabled = YES;
                [self addSubview:activityImageV];
                
                UITapGestureRecognizer *activityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityTap)];
                [activityImageV addGestureRecognizer:activityTap];
                
                self.fool_linkUrl = response.Data[@"LinkUrl"];
                
                [activityImageV sd_setImageWithURL:[NSURL URLWithString:response.Data[@"PicUrl"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [activityImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.titleView.mas_bottom).offset(50);
                        make.left.mas_equalTo(self.titleView);
                        make.size.mas_offset(CGSizeMake(image.size.width * 0.5, image.size.height * 0.5));
                    }];
                }];
            }
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)activityTap{
    // foolish activity
    if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
        [_delegate operateWith:ClickLiveTypeFoolishActivity md:self.fool_linkUrl];
    }
}

// SingalR  监测拍卖状态
- (void)showAuctionStatusWith:(WKAuctionStatusModel *)md{
    
    if (md.Status.integerValue == 1) {
        // 显示拍卖动画
        if (!self.auctionBtn.isAnimating) {
            NSArray *arr;
            if (md.SaleType.integerValue == 1) {
                arr = @[@"auctionHammer1",@"auctionHammer2",@"auctionHammer3"];
            }else{
                arr = @[@"lucky1",@"lucky2",@"lucky3",@"lucky4",@"lucky5",@"lucky6",@"lucky7"];
            }
            
            NSMutableArray *tempArr = @[].mutableCopy;
            for (int i=0; i<arr.count; i++) {
                [tempArr addObject:[UIImage imageNamed:arr[i]]];
            }
            self.auctionBtn.animationImages = tempArr;
            self.auctionBtn.animationDuration = 1.0;
            [self.auctionBtn startAnimating];
        }
        
        [self.auctionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        
        [self layoutIfNeeded];
        
        if (md.SaleType.integerValue == 1) {
            self.priceLabel.hidden = NO;
        }else{
            self.priceLabel.hidden = YES;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.priceLabel.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
        }];
        if (md.CurrentPrice.integerValue >= 10000) {
            self.priceLabel.price = [NSString stringWithFormat:@"%0.2f万",md.CurrentPrice.floatValue/10000];
        }else{
            self.priceLabel.price = [NSString stringWithFormat:@"%0.2f",[md.CurrentPrice floatValue]];
        }
        CGFloat width = [NSString sizeWithText:self.priceLabel.price font:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(CGFLOAT_MAX, 30)].width + 20;
        if (width < 65) {
            width = 65;
        }
        if (_type == WKGoodsLayoutTypeHoriztal) {
            [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-5);
                make.top.mas_equalTo(self.auctionBtn.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(width, 30));
            }];
        }else{
            [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, 30));
                make.left.mas_equalTo(self.auctionBtn.mas_right).offset(-20);
                make.bottom.mas_equalTo(self.auctionBtn.mas_top).offset(10);
            }];
        }
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            self.priceLabel.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            self.priceLabel.hidden = YES;
        }];
        
        [self.auctionBtn stopAnimating];
        
        UIImage *auctionImg;
        if (self.isFirstShow) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"live_first" ofType:@"gif"];
            auctionImg = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:filePath]];
            [self.auctionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX).offset(0);
                make.centerY.mas_equalTo(self.goodsBtn.mas_centerY).offset(0);
                make.size.mas_offset(CGSizeMake(40 * auctionImg.size.width/auctionImg.size.height, 40));
            }];
            
        }else{
            
            if (md.SaleType.integerValue == 1) {
                auctionImg = [UIImage imageNamed:@"auctionHammer3"];
            }else{
                auctionImg = [UIImage imageNamed:@"lucky2"];
            }
            [self.auctionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(40, 40));
            }];
        }
        
        self.auctionBtn.image = auctionImg;
    }
    [self layoutIfNeeded];
    
    if (User.isReviewID) {
        self.priceLabel.hidden = YES;
    }
}

- (void)selectedIcon:(NSNotification *)notify{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notify.name object:nil];
}

- (WKAuctionPriceView *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[WKAuctionPriceView alloc] initWithFrame:CGRectZero screenType:_type];
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

// 操作打赏
-(void)animation:(NSString *)count virtualModel:(WKVirtualGiftModel *)virtualModel
{
    GSPChatMessage *msg = [[GSPChatMessage alloc] init];
    msg.text = [NSString stringWithFormat:@"%@ %@",virtualModel.virtualName,virtualModel.virtualPrice];
    
    GiftModel *giftModel = [[GiftModel alloc] init];
    msg.senderChatID = [NSString stringWithFormat:@"%@%@",virtualModel.memberName,virtualModel.virtualName];
    
    giftModel.name = virtualModel.memberName;
    giftModel.virtualType = virtualModel.virtualType;
    NSString *gifStr = [[NSBundle mainBundle] pathForResource:virtualModel.virtualImage ofType:@"gif"];
    
    giftModel.giftImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gifStr]];
    giftModel.giftName = msg.text;
    giftModel.giftCount = count.integerValue;
    giftModel.BPOID = virtualModel.bpoid;
    
    NSString *timestr = [NSString stringWithFormat:@"%ld",time(NULL)];
    
    UIImageView *imageView = [UIImageView new];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    
    UIImage *image = [cache imageFromDiskCacheForKey:virtualModel.memberIcon];
    
    if (image) {
        giftModel.headImage = image;
        
        AnimOperationManager *manager = [AnimOperationManager sharedManager];
        manager.parentView = self;
        
        // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
        [manager animWithUserID:timestr model:giftModel finishedBlock:^(BOOL result) {
            
        }];
        
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:virtualModel.memberIcon] placeholderImage:[UIImage imageNamed:@"zanwutouxiang"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                giftModel.headImage = [UIImage imageNamed:@"zanwutouxiang"];
            }else{
                giftModel.headImage = image;
            }
            
            AnimOperationManager *manager = [AnimOperationManager sharedManager];
            manager.parentView = self;
            
            // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
            [manager animWithUserID:timestr model:giftModel finishedBlock:^(BOOL result) {
                
            }];
        }];
    }
}

// MARK: 处理上下线
- (void)operateArr:(id)obj Type:(WKOperateType)type totalAudience:(NSUInteger)audience{
    self.onLineCount = audience;
    [self.onlinePerson operateAPerson:obj operateType:type totalCount:audience completionBlock:^{
        // show online list
        
    }];
}

//MARK: init ui
-(void)initUi
{
    //标题
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor colorWithHexString:@"7f353535"];
    titleView.layer.cornerRadius = 40 /2;
    titleView.clipsToBounds = YES;
    //    titleView.layer.borderColor = [UIColor colorWithHexString:@"7fffffff"].CGColor;
    //    titleView.layer.borderWidth = 2.0f;
    self.titleView = titleView;
    [self addSubview:titleView];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.cornerRadius = 40/2;
    self.iconImageView.backgroundColor = [UIColor redColor];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.tag = ClickIconType;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_tempModel.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconEvent:)];
    [titleView addGestureRecognizer:gesture];
    [titleView addSubview:self.iconImageView];
    
    //用户名
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = [_tempModel.MemberName subEmojiStringTo:6 with:@"..."];
    [titleView addSubview:self.titleLabel];
    
    // 小计在线人数
    self.onLineLabel = [UILabel new];
    self.onLineLabel.textAlignment = NSTextAlignmentLeft;
    self.onLineLabel.textColor = [UIColor whiteColor];
    self.onLineLabel.font = [UIFont systemFontOfSize:11.0f];
    self.onLineLabel.text = @"0";
    self.onLineLabel.backgroundColor = [UIColor clearColor];
    [titleView addSubview:_onLineLabel];
    
    // 退出按钮
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"live_exit"] forState:UIControlStateNormal];
    [exitBtn setImage:[UIImage imageNamed:@"live_exit_highlight"] forState:UIControlStateHighlighted];
    [exitBtn addTarget:self action:@selector(ClickType:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitBtn];
    exitBtn.tag = ClickExitType;
    self.exitBtn = exitBtn;
    
    // 贡献榜
    UIButton *contributorRanks = [UIButton buttonWithType:UIButtonTypeCustom];
    [contributorRanks setImage:[UIImage imageNamed:@"contributorRank"] forState:UIControlStateNormal];
    contributorRanks.tag = 1003;
    [contributorRanks addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contributorRanks];
    self.contributorRank = contributorRanks;
    
    UIButton *virtualWorld = [UIButton buttonWithType:UIButtonTypeCustom];
    [virtualWorld setImage:[UIImage imageNamed:@"virtualWorld"] forState:UIControlStateNormal];
    virtualWorld.tag = 1004;
    [virtualWorld addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:virtualWorld];
    self.virtualWorld = virtualWorld;
    
    if (User.isReviewID) {
        virtualWorld.hidden = YES;
    }
    //
    //
    NSArray *imageNames = @[@"chat_watch",@"goodsList",@"share_icon",@"show-message",@"redpacket"];
    
    //    NSArray *imageNames = @[@"chat_watch",@"red_bag",@"goodsList",@"share_icon",@"chat"];
    for (int i=0; i < imageNames.count; i++) {
        
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtn.backgroundColor = [UIColor clearColor];
        switchBtn.tag = 1003 + i;
        
        [switchBtn addTarget:self action:@selector(ClickType:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchBtn];
        
        if (i == 1 || i == 2) {
            //            [self.btns addObject:switchBtn];
            [switchBtn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        }else{
            [switchBtn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        }
        
        if (i == 0) {
            self.chatBtn = switchBtn;
            switchBtn.tag = ClickChatType;
        }
        else if (i == 1){
            self.goodsBtn = switchBtn;
            self.goodsBtn.tag = ClickShopType;
        }else if (i == 2)
        {
            self.shareBtn = switchBtn;
            self.shareBtn.tag = ClickShareType;
        }else if (i == 3){
            self.chatListBtn = switchBtn;
            self.chatListBtn.tag = ClickChatListType;
        }else{
            self.redBagBtn = switchBtn;
            self.redBagBtn.tag = ClickLiveTypeRedBag;
        }
    }
    
    //保证金
    UIImage *cashImage = [UIImage imageNamed:@"auctionHammer1"];
    UIImageView *cashBtn = [[UIImageView alloc] initWithImage:cashImage];
    cashBtn.tag = ClickCashType;
    cashBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hanleTap:)];
    [cashBtn addGestureRecognizer:tap];
    
    [self addSubview:cashBtn];
    self.auctionBtn = cashBtn;
    
    if (User.isReviewID) {
        self.auctionBtn.hidden = YES;
    }
    
    self.redPointView = [[UIView alloc]init];
    self.redPointView.layer.cornerRadius = 2.5;
    self.redPointView.backgroundColor = [UIColor colorWithRed:238/255.0 green:120/255.0 blue:32/255.0 alpha:1];
    self.redPointView.hidden = YES;
    [self.chatListBtn addSubview:self.redPointView];
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-2.5);
        make.top.mas_offset(2.5);
        make.size.sizeOffset(CGSizeMake(5, 5));
    }];
    [self setRedPointViewHidden];
    
    // 聊天列表
    WKMessageListView *messageList = [[WKMessageListView alloc] initWithFrame:CGRectZero];
    messageList.tag = 123213;
    [self addSubview:messageList];
    messageList.delegate = self;
    self.messageList = messageList;
    
    // 显示在线人数
    self.onlinePerson = [[WKOnlinePersonListView alloc] initWithFrame:CGRectZero];
    self.onlinePerson.delegate = self;
    [self addSubview:self.onlinePerson];
    [self sendSubviewToBack:self.onlinePerson];
    // 公用布局
    [self layoutUI];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 1003){
        // 榜单
        if ([_delegate respondsToSelector:@selector(operateWith:)]) {
            [_delegate operateWith:ClickLiveTypeRank];
        }
    }else if (btn.tag == 1004){
        // 虚拟世界
        if ([_delegate respondsToSelector:@selector(operateWith:)]) {
            [_delegate operateWith:ClickLiveTypeVirtual];
        }
    }
}

//MARK: 主播点击查看消息
- (void)selectedMessage:(id)message type:(WKMessageClickType)type{
    WKMessage *md = message;
    if (type == WKMessageClickTypeRed) {
        // redbag
        [WKGrabRedView grabRedEnvelopeOn:self message:md callBack:^{
            // to red evenlope detail
            if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
                [_delegate operateWith:ClickLiveTypeRedPacketDetail md:md];
            }
        }];
        
    }else{
        // show user information
        WKOnLineMd *person = [[WKOnLineMd alloc] init];
        person.BPOID = md.bpoid;
        [self selectedPerson:person];
    }
}

- (void)selectedPerson:(WKOnLineMd *)md{
    if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
        [_delegate operateWith:ClickIconType md:md];
    }
}

// MARK: 公用布局
- (void)layoutUI{
    CGSize btnSize = CGSizeMake(40, 40);
    CGFloat btnSpacing = 8;
    
    CGFloat titleWidth = [[_tempModel.MemberName subEmojiStringTo:6 with:@"..."] boundingRectWithSize:CGSizeMake(10000, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:NULL].size.width;
    
    if (titleWidth < 50) {
        titleWidth = 50;
    }
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset([[UIApplication sharedApplication] statusBarFrame].size.height+5);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(titleWidth + 60, 40));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleView);
        make.left.mas_equalTo(self.titleView.mas_left).offset(0);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.height.mas_offset(25);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(4);
        make.right.mas_equalTo(self.titleView).offset(3);
    }];
    
    [_onLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left).offset(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_titleLabel.mas_centerX).offset(0);
        //        make.right.mas_offset(-2);
        make.bottom.mas_offset(-5);
    }];
    
    // contribution rank
    [self.contributorRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(WKScreenH * 0.3);
        make.right.mas_offset(0);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    [self.virtualWorld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contributorRank.mas_bottom).offset(8);
        make.size.mas_offset(CGSizeMake(40, 40));
        make.right.mas_offset(0);
    }];
    
    // 退出按钮
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleView.mas_centerY).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.size.mas_offset(CGSizeMake(40 , 40));
    }];
    
    // 在线人数
    [self.onlinePerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleView.mas_right).offset(10);
        make.height.mas_offset(40);
        make.right.mas_equalTo(self.exitBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.titleView);
    }];
    
    // 聊天
    [self.messageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-65);
        make.width.mas_offset(WKScreenW * 0.8);
        make.height.mas_offset(WKScreenH * 0.3);
    }];
    
    // bottom btns
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-btnSpacing);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.size.mas_offset(btnSize);
    }];
    
    [self.chatListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-btnSpacing);
        make.centerY.mas_equalTo(self.shareBtn.mas_centerY).offset(0);
        make.size.mas_offset(btnSize);
    }];
    
    // bottom four btns
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-5);
        make.left.mas_equalTo(self).offset(btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.redBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-5);
        make.right.mas_equalTo(self.chatListBtn.mas_left).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    if (User.isReviewID) {
        self.redBagBtn.hidden = YES;
    }
    
    [self.goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-5);
        make.left.mas_equalTo(self.chatBtn.mas_right).offset(btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.auctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-5);
        make.left.mas_equalTo(self.goodsBtn.mas_right).offset(btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
}

// MARK: 点击事件
-(void)ClickType:(UIButton *)sender
{
    if(sender.tag == ClickChatType) //聊天
    {
        IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
        keyBoard.enable = NO;
        keyBoard.enableAutoToolbar = NO;
        
        [WKInputView showTextViewOn:self screenType:_type inputType:self.inputType WithInputBlock:^(WKMessage *msg) {
            if (self.talkStatus == 0) {
                // 是否参与拍卖
                if (self.talkStatus == 0) {
                    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
                    keyBoard.enable = NO;
                    keyBoard.enableAutoToolbar = NO;
                    
                    self.inputType = msg.sendType;
                    
                    if (msg.sendType == WKInputTypeBarrage) {// 弹幕
                        if (msg.content.length>20) {
                            [WKPromptView showPromptView:@"输入字数过长，请输入小于20个字"];
                            return;
                        }
                        NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)msg.content, NULL, (__bridge CFStringRef)@"&+", kCFStringEncodingUTF8 );
                        NSString *urlStr = [NSString configUrl:sendBarrage With:@[@"ShopOwnerNo",@"Message"] values:@[_tempModel.MemberNo,encodedString]];
                        [WKHttpRequest sendBarrageMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
                            if ([response.Data integerValue] == 2) {//余额不足
                                if (self.liveCallBack) {
                                    self.liveCallBack(2);
                                }
                            }
                            
                            UITextField *textField = objc_getAssociatedObject(NSClassFromString(@"WKInputView"), "textField");
                            textField.text = @"";
                            objc_removeAssociatedObjects([WKInputView class]);
                            
                        } failure:^(WKBaseResponse *response) {
                            
                        }];
                        
                    }else{
                        
                        [self.sigDelegate sendMsg:msg completionBlock:^(BOOL isSended) {
                            if (isSended) {
                                UITextField *textField = objc_getAssociatedObject(NSClassFromString(@"WKInputView"), "textField");
                                textField.text = @"";
                                objc_removeAssociatedObjects([WKInputView class]);
                            }
                        }];
                    }
                    
                    //                }];
                    
                }
                //                else{
                //
                //                    NSString *reminderStr;
                //                    if (self.talkStatus == 1) {
                //                        reminderStr = @"你已经被主播禁言";
                //                    }else{
                //                        reminderStr = @"你已经被系统禁言";
                //                    }
                //                };
            }
        }];
    }
    else if(sender.tag == ClickShopType)   //商品
    {
        if ([_delegate respondsToSelector:@selector(operateWith:)]) {
            [_delegate operateWith:ClickShopType];
        }
    }
    else if (sender.tag == ClickLiveTypeRedBag && self.liveCallBack){
        // red bag
        self.liveCallBack(3);
    }
    else if(sender.tag == ClickCashType) // 显示拍卖
    {
        _autoCheckAuctionStatus = NO;
        // 查看拍卖状态
        [self checkAuctionStatus];
    }
    else if(sender.tag == ClickShareType)   //分享
    {
        if (!sender.selected) {
            sender.selected = YES;
        }        // 分享
        PopoverView *popView = [[PopoverView alloc] initFrom:sender On:self titles:@[@"分享到微信",@"分享到朋友圈"] images:@[@"live_wxshare",@"live_pyqshare"] selectedImages:@[@"live_wxshare_select",@"live_pyqshare_select"] type:WKPopverTypeShare];
        popView.selectRowAtIndex = ^(NSInteger index){
            if (index == 0) {
                // 分享到微信
                [self shareTheWeChat:1];
            }else if (index == 1){
                // 分享到朋友圈
                [self shareTheWeChat:2];
            }
        };
        popView.dismissCompletion = ^(){
            sender.selected = NO;
        };
        [popView show];
    }else if (sender.tag == ClickExitType){
        // 退出
        if ([_delegate respondsToSelector:@selector(operateWith:)]) {
            [_delegate operateWith:ClickExitType];
        }
    }else if (sender.tag == ClickChatListType && self.liveCallBack){
        self.liveCallBack(1);
        //        [self testAnimation];
    }
}

- (void)hanleTap:(UITapGestureRecognizer *)tap{
    //    // 显示拍卖
    _autoCheckAuctionStatus = NO;
    // 查看拍卖状态
    [self checkAuctionStatus];
}

-(void)iconEvent:(UITapGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(operateWith:)]) {
        [_delegate operateWith:ClickIconType];
    }
}
//
- (void)selectedWithBOPID:(WKOnLineMd *)md{
    //    WKOnLineMd *md = message;
    if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
        [_delegate operateWith:ClickIconType md:md];
    }
}

#pragma mark - 监测拍卖状态
-(void)checkAuctionStatus{
    //
    [WKProgressHUD showLoadingGifText:@""];
    
    NSString *url = [NSString configUrl:WKAuctionStatus With:@[@"shopOwnerNo"] values:@[[NSString stringWithFormat:@"%@",_tempModel.MemberNo]]];
    [WKHttpRequest AuctionStatus:HttpRequestMethodPost url:url model:NSStringFromClass([WKAuctionStatusModel class]) param:nil success:^(WKBaseResponse *response) {
        WKAuctionStatusModel *md = response.Data;
        NSLog(@"auction response : %@",response.json);
        self.currentAuctionModel = md;
        [WKProgressHUD dismiss];
        
        if (self.auctionListView) {
            [self.auctionListView delayTime:self.currentAuctionModel.RemainTime.integerValue];
        }
        
        if (self.currentAuctionModel.Status.integerValue == 1) {
            if (!self.auctionListView) {
                WKAuctioningListView *auctionView = [[WKAuctioningListView alloc] initWithFrame:CGRectMake(0, 80, WKScreenW, 50)];
                [self addSubview:auctionView];
                [auctionView setAuctionerInfo:md];
                auctionView.block = ^(WKAuctionJoinModel *model){
                    WKOnLineMd *person = [[WKOnLineMd alloc] init];
                    person.BPOID = model.CustomerBPOID;
                    WKOnLineMd *md = [WKOnLineMd new];
                    md.BPOID = model.CustomerBPOID;
                    [self selectedPerson:md];
                };
                self.auctionListView = auctionView;
                [self joinInList];
            }
        }else{
            if (self.auctionListView) {
                [self.auctionListView removeFromSuperview];
                self.auctionListView = nil;
            }
        }
        
        // 当前出价最高者
        if ([self.currentAuctionModel.CurrentMemberBPOID isEqualToString:User.BPOID]) {
            self.currentAuctionModel.isMostHighPrice = YES;
        }
        
        // 查看拍卖状态 拍卖中则可以出价 其他状态就给一个提示
        switch (md.Status.integerValue) {
            case 0:    // 无拍卖
                if (!_autoCheckAuctionStatus) {
                    [WKAuctionStatusView showWithModel:nil screenOrientation:WKGoodsLayoutTypeVertical clientType:WKAuctionTypeLive completionBlock:NULL];
                }else{
                    self.isFirstShow = YES;
                    [self showAuctionStatusWith:self.currentAuctionModel];
                }
                break;
                
            case 2:   // 流拍
            case 3:
            {// 成功
                [self showAuctionStatusWith:self.currentAuctionModel];
                
                if (!_autoCheckAuctionStatus) {
                    
                    [WKAuctionStatusView showWithModel:md screenOrientation:_type clientType:WKAuctionTypeLive  completionBlock:^(WKCallBackType type){
                        
                        if (type == WKCallBackTypeAuction)
                        {
                            if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
                                [_delegate operateWith:ClickAuctionType md:self.currentAuctionModel];
                            }
                            
                        }
                        else
                        {
                            if(md.Status.integerValue == 3)
                            {
                                [self loadAddress];
                                
                                WKPayView *payView = nil;
                                if(self.playMpdel.integerValue == 0)
                                {
                                    payView = [[WKPayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) type:2 direction:1];
                                }
                                else if(self.playMpdel.integerValue == 1)
                                {
                                    payView = [[WKPayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) type:2 direction:0];
                                }
                                
                                payView.auctionModel = self.currentAuctionModel;
                                
                                WeakSelf(WKLiveView);
                                __weak typeof(payView) weakPayView = payView;
                                
                                payView.payTypeCallBlock = ^(NSInteger type){
                                    
                                    if (type == 4) {
                                        // 选择地址
                                        if ([_delegate respondsToSelector:@selector(selectAddress:)]) {
                                            self.payView.hidden = YES;
                                            [_delegate selectAddress:weakSelf.payView];
                                        }
                                    }else if (type == 5){ // 余额支付
                                        // confirm
                                        if (weakSelf.payView.auctionModel.addressModel == nil) {
                                            [WKPromptView showPromptView:@"请选择收货地址"];
                                        }else{
                                            //                                            WKOrderType orderType;
                                            //                                            if (md.SaleType.integerValue == 1) {
                                            //                                                orderType = WKOrderTypeAuction;
                                            //                                            }else{
                                            //                                                orderType = WKOrderTypeCrowd;
                                            //                                            }
                                            
                                            // confirm address
                                            NSString *url = [NSString configUrl:WKConfirmAddress With:@[@"orderCode",@"addressID"] values:@[md.OrderCode,md.addressModel.ID]];
                                            [self payForAuctionWith:url];
                                            [weakPayView removeFromSuperview];
                                        }
                                    }
                                };
                                
                                self.payView = payView;
                                [[UIApplication sharedApplication].keyWindow addSubview:payView];
                            }
                        }
                    }];
                }
            }
                
                break;
            case 1:{
                
                // auctioning
                if (_autoCheckAuctionStatus) {
                    // 主动调取拍卖状态显示
                    [self showAuctionStatusWith:md];
                    //[self reloadUserIsSale:_tempModel.MemberNo];
                }else{
                    
                    [WKAuctionJoinView auctionJoinWith:md screenType:_type On:self completionBlock:^(NSInteger type){
                        
                        if (type == WKCallBackTypeToRecharge) {
                            if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
                                [_delegate operateWith:ClickLiveTypeToRecharge md:self.currentAuctionModel];
                            }
                        }else{
                            if ([_delegate respondsToSelector:@selector(operateWith:md:)]) {
                                [_delegate operateWith:ClickAuctionType md:self.currentAuctionModel];
                            }
                        }
                    }];
                }
            }
                break;
                
            default:
                break;
        }
        
    } failure:^(WKBaseResponse *response) {
        //        NSLog(@"response json : %@",response.json);
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//MARK: Get join list
- (void)joinInList{
    NSString *url = [NSString configUrl:WKJoinList With:@[@"ShopOwnerNo"] values:@[_tempModel.MemberNo]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        NSArray *arr = [NSArray yy_modelArrayWithClass:[WKAuctionJoinModel class] json:response.Data];
        [self.auctionListView participatePersons:arr showAnimation:NO];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)payForAuctionWith:(NSString *)url{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        BOOL result = [response.Data boolValue];
        
        if (result) {
            [WKPromptView showPromptView:@"地址确认成功"];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

// MARK: 加载地址列表
- (void)loadAddress{
    
    [WKHttpRequest  getAddress:HttpRequestMethodGet url:WKAddresssList model:NSStringFromClass([WKAddressListModel class]) param:@{} success:^(WKBaseResponse *response) {
        _LOGD(@"response : %@",response);
        WKAddressListModel *md = response.Data;
        
        [md.InnerList enumerateObjectsUsingBlock:^(WKAddressListItem *addressItem, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (addressItem.IsDefault) {
                self.currentAuctionModel.addressModel = addressItem;
            }
        }];
    } failure:^(WKBaseResponse *response) {
        
    }];
}


// 查看关注状态
- (void)checkStarStatus{
    CGFloat titleWidth = [[_tempModel.MemberName subEmojiStringTo:6 with:@"..."] boundingRectWithSize:CGSizeMake(10000, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:NULL].size.width;
    
    [self xw_addNotificationForName:@"FocusAnchor" block:^(NSNotification * _Nonnull notification) {
        if([_tempModel.MemberNo isEqualToString: notification.userInfo[@"memberNo"]]){
            if(((NSNumber*)notification.userInfo[@"type"]).integerValue){
                //已关注 移除图标
                [self.focusBtn removeFromSuperview];
                [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(titleWidth + 65, 40));
                }];
                [UIView animateWithDuration:0.2 animations:^{
                    [self.titleView layoutIfNeeded];
                }];
            }else{
                //未关注 添加图标
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.focusBtn = btn;
                [btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAttention:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.titleView addSubview:btn];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(_iconImageView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(30, 30));
                    make.right.mas_equalTo(self.titleView.mas_right).offset(-10);
                }];
                
                [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(titleWidth + 60 + 50, 40));
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self.titleView layoutIfNeeded];
                }];
            }
        }
    }];
    
    NSString *url = [NSString configUrl:WKMemberCheckStar With:@[@"BPOID"] values:@[_tempModel.BPOID]];
    [WKHttpRequest checkStarStatus:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        [self xw_postNotificationWithName:@"FocusAnchor" userInfo:@{@"type":(NSNumber *)response.Data,@"memberNo":_tempModel.MemberNo}];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)btnAttention:(UIButton *)btn{
    
    NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID",@"NeedSend"] values:@[@"1",_tempModel.BPOID,@"true"]];
    
    btn.userInteractionEnabled = NO;
    
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        
        [btn removeFromSuperview];
        [WKPromptView showPromptView:@"已关注"];
        btn.userInteractionEnabled = YES;
        
        CGFloat titleWidth = [[_tempModel.MemberName subEmojiStringTo:6 with:@"..."] boundingRectWithSize:CGSizeMake(10000, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:NULL].size.width;
        
        [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(titleWidth + 60, 40));
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.titleView layoutIfNeeded];
        }];
        
    } failure:^(WKBaseResponse *response) {
        
        btn.userInteractionEnabled = YES;
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

#pragma mark - 显示和影藏键盘
- (void)keyboardWillHide:(NSNotification *)notify{
    [self.messageList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-63);
    }];
    
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset([[UIApplication sharedApplication] statusBarFrame].size.height+5);
    }];
    
    self.auctionListView.frame = CGRectMake(0, 80, WKScreenW, 50);
    
    [self layoutIfNeeded];
    
}

- (void)keyboardWillShow:(NSNotification *)notify{
    CGFloat kbHeight = ((NSNumber *)[notify.userInfo objectForKey:@"kbheight"]).floatValue;
    
    // 聊天列表
    [self.messageList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(65 + kbHeight));
    }];
    
    // 主播头像
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset([[UIApplication sharedApplication] statusBarFrame].size.height+5 - kbHeight);
    }];
    
    self.auctionListView.frame = CGRectMake(0, 80 - kbHeight, WKScreenW, 50);
    
    [self layoutIfNeeded];
    
}

-(void)shareTheWeChat:(NSInteger)type{
    
    NSString *urlStr = [NSString configUrl:WKShareBefore With:@[@"ShopOwnerNo"] values:@[_tempModel.MemberNo]];
    [WKHttpRequest shareWeChatBefore:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKShareModel *shareModel = [[WKShareModel alloc]init];
        shareModel.shareImageArr = @[response.Data[@"PicUrl"]];
        shareModel.shareTitle = response.Data[@"Title"];
        shareModel.shareContent = response.Data[@"Description"];
        shareModel.shopOwnerNo = _tempModel.MemberNo;
        shareModel.shareUrl = response.Data[@"LinkUrl"];
        shareModel.shareType = type == 1?SHARECONTACT:SHAREFRIENDCIRRLE;
        [WKShareTool shareShow:shareModel];;
    } failure:^(WKBaseResponse *response) {
        NSLog(@"%@",response);
    }];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow) {
        self.isShow = YES;
    }else{
        self.isShow = NO;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHOWINPUT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DISMISSINPUT" object:nil];
    NSLog(@"DISMISS WKLiveView");
}

@end
