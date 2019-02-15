//
//  WKLivePreView.m
//  wdbo
//
//  Created by sks on 16/6/29.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLivePreView.h"
#import "WKItemBtn.h"
#import "WKSignalRDelegate.h"
#import "WKOnlinePerson.h"
#import "WKChatCell.h"
#import "WKMessage.h"
#import "WKLiveMessageTableViewCell.h"
#import "WKLiveTableView.h"
#import "WKOrderNoticeModel.h"
#import "WKNoticeCell.h"
#import "WKGoodsModel.h"
#import "WKOnLineMd.h"
#import "NSObject+XWAdd.h"
#import "NSString+WJ.h"
#import "NSString+substring.h"
#import "PopoverView.h"
#import "WKShareView.h"
#import "WKStoreModel.h"
#import "WKHorizontalList.h"
#import "WKAuctionStatusModel.h"
#import "WKAuctionStatusView.h"
#import "WKGoodsCollectionView.h"
#import "WKUserMessage.h"
#import "WKMessageListView.h"
#import "WKOnlinePersonListView.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
#import "UIImage+Gif.h"
#import "WKVirtualGiftModel.h"
#import "WKAuctionPriceView.h"
#import "WKLiveVirShopView.h"
#import <RongIMKit/RongIMKit.h>
#import "WKLiveConfigView.h"
#import "WKAnimationHelper.h"
#import "WKAuctioningListView.h"
#import "StartAuctionAnimation.h"
#import "StopAuctionAnimation.h"
#import "WKGrabRedView.h"
#import "WKSingleRedEvenlopeView.h"

static NSString *reusableCell = @"cell";

@interface WKLivePreView ()<WKOnlinePersonDelegate,WKMessageDelegate,WKSingalRDelegate>{
    UIImageView *_iconImage;
    UILabel *_titleLabel;
    
    NSMutableArray *_allOnlineUsers; // 所以在线观看客户
    NSInteger _showType;  //1 消息 2 商品
    UILabel *_onLineLabel;
    UIButton *_backViewBtn;
    NSInteger _allAudience;
    WKGoodsLayoutType _type;
    WKGoodsListItem *_auctionGoods;
    NSTimer *_timer;
    BOOL _autoCheckAuctionStatus;
    BOOL _animationBtn;
}

@property (nonatomic,strong) UIView *titleView;        // 店铺名
@property (nonatomic,strong) UIButton *exitBtn;        // 退出按钮
@property (nonatomic,strong) WKMessageListView *messageList;       // 聊天列表
@property (nonatomic,strong) WKOnlinePersonListView *onlinePerson; // 在线人数
@property (nonatomic,strong) UIButton *goodsBtn;        // 商品按钮
@property (nonatomic,strong) UIImageView *auctionBtn;    // 拍卖
@property (nonatomic,strong) UIButton *contributorRank;        // 贡献榜
//@property (nonatomic,strong) UIButton *virtualWorld;        // 虚拟世界
@property (nonatomic,strong) UIButton *chatBtn;      // 切换横竖屏
@property (nonatomic,strong) UIButton *shareBtn;       // 分享
@property (nonatomic,strong) UIButton *beautyBtn;      // 美颜
@property (nonatomic,strong) UIButton *switchBtn;      // 切换摄像头
@property (nonatomic,strong) UIButton *redBagBtn;    // 红包
@property (nonatomic,strong) WKStoreModel *model;
@property (nonatomic,strong) UIButton *backBtn;
@property (strong, nonatomic) UIView *redPointView;//未读消息红点
@property (nonatomic,strong) NSMutableArray *btns;

@property (nonatomic,strong) WKSignalRDelegate *sigDelegate;
@property (nonatomic,assign) NSTimeInterval remainTime;     // 剩余时间
@property (nonatomic,strong) WKAuctionStatusModel *currentAuctionModel;

@property (nonatomic,strong) WKAuctionPriceView *priceLabel;

@property (nonatomic,strong) UIImageView *singalImageView;   // 显示信号

@property (nonatomic,assign) NSInteger currentCameraSetting;          // 0 反转 1 开镜像
@property (nonatomic,assign) NSInteger currentVoiceType;          // 0 录音棚 ...
@property (nonatomic,assign) NSInteger currentFilterType;           // 滤镜效果

@property (nonatomic,strong) WKAuctioningListView *auctionListView;

@property (nonatomic,assign) BOOL isFirstShow;       // is first to show
@property (nonatomic,copy) NSString *fool_linkUrl;

// 保存打赏消息的数组
@property (nonatomic,strong) NSArray *rewardInfo;

@end

@implementation WKLivePreView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    //    NSLog(@"对象被销毁");
}

- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = @[].mutableCopy;
    }
    return _btns;
}

- (WKAuctionPriceView *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[WKAuctionPriceView alloc] initWithFrame:CGRectZero screenType:_type];
        _priceLabel.userInteractionEnabled = NO;
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame type:(WKGoodsLayoutType)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _showType = 1;   // 1:商品  2:消息
        
        _autoCheckAuctionStatus = YES;
        [self checkAuctionStatus];
        
        self.layer.masksToBounds = YES;
        
        self.currentVoiceType = 0;
        self.currentFilterType = 0;
        self.currentCameraSetting = 0;
        
        // 获取打赏消息
        //        self.isFirstShow = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL firstLunch = [userDefaults boolForKey:@"firstLaunch"];
        
        if (!firstLunch) {
            self.isFirstShow = NO;
        }else{
            self.isFirstShow = YES;
        }
        
        [self setupViews];
        
        // show activity icon
        [self showActivity];
        
        // 订阅查看打赏和加价的消息
        [self xw_addNotificationForName:@"TAPICON" block:^(NSNotification * _Nonnull notification) {
            NSString *bpoid = notification.userInfo[@"BPOID"];
            WKOnLineMd *md = [WKOnLineMd new];
            md.BPOID = bpoid;
            [self selectedPerson:md];
        }];
        
        // 聊天的回调
        WKSignalRDelegate *sigDelegate = [[WKSignalRDelegate alloc] initWithMemberNo:User.MemberNo andBPOId:User.BPOID];
        self.sigDelegate = sigDelegate;
        self.sigDelegate.delegate = self;
        [self xw_addNotificationForName:DISMISSLIVEVIEW block:^(NSNotification * _Nonnull notification) {
            [sigDelegate disconnect];
            //            sigDelegate.block = nil;
            //            sigDelegate = nil;
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
        }];
    }
    return self;
}

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
    if ([_delegate respondsToSelector:@selector(operateType:md:)]) {
        [_delegate operateType:WKLiveOpeartionFoolActivity md:self.fool_linkUrl];
    }
}

//MARK: Resolve SingalR Msg
- (void)receiveMsgType:(WKMessageInfoType)type msgBody:(id)obj{
    
    switch (type) {
        case WKMessageInfoTypeReceiveMsg:{
            // 接受消息
            NSMutableDictionary *dict = [(NSDictionary *)obj mutableCopy];
            NSString *str = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dict setObject:str forKey:@"message"];
            [self recmsgWith:dict type:WKMessageTypeUser];
            if ([dict[@"messageType"] integerValue]==1) {
                [self xw_postNotificationWithName:@"sendComment" userInfo:dict];
            }
        }
            break;
            
        case WKMessageInfoTypeOnline:{
            NSArray *arr = @[[WKOnLineMd yy_modelWithJSON:obj]];
            
            if (arr.count > 0) {
                
                NSDictionary *dict = obj;
                
                NSString *usericon = dict[@"MemberPhotoMinUrl"];
                NSString *name = dict[@"MemberName"];
                NSString *bpoid = dict[@"BPOID"];
                //                        NSString *ml = dict[@"ml"];
                
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
        case WKMessageInfoTypeHeadList:{
            
            NSArray *arr = [NSArray yy_modelArrayWithClass:[WKOnLineMd class] json:obj[@"mlist"]];
            BOOL rh = [obj[@"rh"] boolValue];
            NSUInteger currentAudience = [obj[@"mct"] integerValue];
            
            if (rh) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _onLineLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)currentAudience];
                });
                
                [self operateArr:arr Type:WKOperateTypeGetList totalAudience:currentAudience];
            }
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
        case WKMessageInfoTypeAuctionCount:{
            // 查看拍卖状态
            NSString *count = obj;
            self.currentAuctionModel.Count = [NSNumber numberWithInteger:count.integerValue];
        }
            break;
            
        case WKMessageInfoTypeAuctionBid:{
            
            NSDictionary *dict = (NSDictionary *)obj;
            WKAuctionStatusModel *md = [WKAuctionStatusModel yy_modelWithJSON:dict];
            md.Status = @1;
            
            // 显示加价
            [self showAuctionStatusWith:md];
            
            [self.auctionListView bidWith:md];
            
            self.currentAuctionModel.CurrentMemberName = [md.CurrentMemberName subEmojiStringTo:6 with:@"..."];
            self.currentAuctionModel.CurrentPrice = md.CurrentPrice;
            self.currentAuctionModel.AddPrice = md.AddPrice;
            self.currentAuctionModel.Count = md.Count;
            
            WKVirtualGiftModel *virgifModel = [[WKVirtualGiftModel alloc] init];
            virgifModel.virtualPrice = dict[@"AddPrice"];
            virgifModel.virtualType = WKVirtualTypeAuction;
            virgifModel.virtualName = @"加价";
            virgifModel.bpoid = dict[@"CurrentMemberBPOID"];
            virgifModel.memberName = dict[@"CurrentMemberName"];
            virgifModel.memberIcon = dict[@"MemberPhotoUrl"];
            //                    virgifModel.virtualType = WKVirtualTypeAuction;
            
            [self animation:[NSString stringWithFormat:@"%zd",1] virtualModel:virgifModel];
        }
            break;
        case WKMessageInfoTypeAuction:{
            NSDictionary *dict = (NSDictionary *)obj;
            // 查看拍卖状态
            WKAuctionStatusModel *md = [WKAuctionStatusModel yy_modelWithJSON:dict];
            self.remainTime = md.RemainTime.floatValue;
            _currentAuctionModel.CurrentPrice = md.CurrentPrice;
            _currentAuctionModel.Price = md.Price;
            _currentAuctionModel.Count = md.Count;
            _currentAuctionModel.Status = md.Status;
            
            // whether show animation
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
                [StartAuctionAnimation startAcutionAnimation:saleType andData:auctionStartMd superView:self];
            }
            
            // auction_ing
            if (md.Status.integerValue == 1) {
                
                if (!self.auctionListView) {
                    WKAuctioningListView *auctionView = [[WKAuctioningListView alloc] initWithFrame:CGRectMake(0, 80, WKScreenW, 50)];
                    auctionView.block = ^(WKAuctionJoinModel *model){
                        WKOnLineMd *person = [[WKOnLineMd alloc] init];
                        person.BPOID = model.CustomerBPOID;
                        if ([_delegate respondsToSelector:@selector(selectedIndexPerson:)]) {
                            [_delegate selectedIndexPerson:person];
                        }
                    };
                    [self addSubview:auctionView];
                    [auctionView setAuctionerInfo:md];
                    self.auctionListView = auctionView;
                }else{
                    if (md.SaleType.integerValue == 2) {
                        // some luck buy
                        WKAuctionJoinModel *joinMd = [[WKAuctionJoinModel alloc] init];
                        joinMd.CustomerName = md.CurrentMemberName;
                        joinMd.Price = md.Price;
                        joinMd.CustomerPicUrl = md.MemberPhotoUrl;
                        joinMd.Count = md.Count;
                        joinMd.CustomerBPOID = md.CurrentMemberBPOID;
                        joinMd.CurrentPrice = md.CurrentPrice;
                        
                        [self.auctionListView participatePersons:@[joinMd] showAnimation:NO];
                    }
                }
                
            }else if (md.Status.integerValue == 3){   // success
                
                [self.auctionListView crowdEedWith:md superView:self];
                self.auctionListView = nil;
                
            }else{
                [WKAuctionStatusView dismissView];
                
                // fail or no
                [self.auctionListView removeFromSuperview];
                self.auctionListView = nil;
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
            
        case WKMessageInfoTypeSystemLoginOut:{
            // 强制退出
            [[NSNotificationCenter defaultCenter] postNotificationName:Unauthorized object:nil];
        }
            break;
            
        case WKMessageInfoTypeRoomTalk:{
            // 禁言
            NSDictionary *dict = obj;
            [self.onlinePerson setItemStateWithBPOID:dict[@"bpoid"] type:[dict[@"type"] integerValue]];
        }
            break;
            
        case WKMessageInfoTypeAuctionDelay:{
            // 接受多条消息
            //NSLog(@"obj : %@",obj);
            NSDictionary *dict = obj;
            //NSLog(@"dict : %@",dict);
            NSNumber *delaySeconds = dict[@"DelaySeconds"];
            self.currentAuctionModel.RemainTime = delaySeconds;
            
            if (self.auctionListView) {
                [self.auctionListView delayTime:[delaySeconds integerValue]];
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

- (void)toOnlineList{
    if ([_delegate respondsToSelector:@selector(livePreOperation:)]) {
        [_delegate livePreOperation:WKLiveOpeartionOnlineList];
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
        
        [self layoutIfNeeded];
        
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
            [self.auctionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                //                make.right.mas_equalTo(self.chatBtn.mas_left).offset(-20);
                make.centerY.mas_equalTo(self.chatBtn.mas_centerY).offset(0);
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
        [self layoutIfNeeded];
    }
    
    if (User.isReviewID) {
        self.priceLabel.hidden = YES;
    }
}

// MARK: 处理上下线
- (void)operateArr:(id)obj Type:(WKOperateType)type totalAudience:(NSUInteger)audience{
    [self.onlinePerson operateAPerson:obj operateType:type totalCount:audience completionBlock:NULL];
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

#pragma mark - 初始化显示界面
- (void)setupViews{
    
    //标题
    UIView *titleVeiw = [UIView new];
    titleVeiw.backgroundColor = [UIColor colorWithHexString:@"7f353535"];
    
    titleVeiw.layer.cornerRadius = 40/2;
    titleVeiw.clipsToBounds = YES;
    
    [self addSubview:titleVeiw];
    
    self.titleView = titleVeiw;
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _titleLabel.text = [User.MemberName subEmojiStringTo:6 with:@"..."];
    [self.titleView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.layer.cornerRadius = 40/2;
    _iconImage.clipsToBounds = YES;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoUrl] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedSelf)];
    [self.titleView addGestureRecognizer:gesture];
    
    [self.titleView addSubview:_iconImage];
    
    _onLineLabel = [UILabel new];
    _onLineLabel.textAlignment = NSTextAlignmentLeft;
    _onLineLabel.textColor = [UIColor whiteColor];
    _onLineLabel.font = [UIFont systemFontOfSize:11.0f];
    _onLineLabel.text = @"0";
    _onLineLabel.backgroundColor = [UIColor clearColor];
    [self.titleView addSubview:_onLineLabel];
    
    // 显示当前信号强度
    UIImageView *singalImageView = [UIImageView new];
    [self.titleView addSubview:singalImageView];
    
    self.singalImageView = singalImageView;
    
    UIImage *image = [UIImage imageNamed:@"xinhao_1"];
    
    [singalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_onLineLabel);
        make.right.mas_equalTo(self.titleView.mas_right).offset(-10);
        make.size.mas_offset(image.size);
    }];
    
    // 显示在线人数
    self.onlinePerson = [[WKOnlinePersonListView alloc] initWithFrame:CGRectZero];
    self.onlinePerson.delegate = self;
    [self addSubview:self.onlinePerson];
    
    // 贡献榜
    UIButton *contributorRanks = [UIButton buttonWithType:UIButtonTypeCustom];
    [contributorRanks setImage:[UIImage imageNamed:@"contributorRank"] forState:UIControlStateNormal];
    contributorRanks.tag = 1003;
    [contributorRanks addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contributorRanks];
    self.contributorRank = contributorRanks;
    
    // 退出按钮
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"live_exit"] forState:UIControlStateNormal];
    [exitBtn setImage:[UIImage imageNamed:@"live_exit_highlight"] forState:UIControlStateHighlighted];
    [exitBtn addTarget:self action:@selector(exitLive) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitBtn];
    self.exitBtn = exitBtn;
    
    // 弹幕
    WKMessageListView *messageList = [[WKMessageListView alloc] initWithFrame:CGRectZero];
    messageList.delegate = self;
    [self addSubview:messageList];
    self.messageList = messageList;
    
    // 商品
    UIButton *goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsBtn setImage:[UIImage imageNamed:@"goodsList"] forState:UIControlStateNormal];
    goodsBtn.tag = 1001;
    [goodsBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goodsBtn];
    self.goodsBtn = goodsBtn;
    
    //MARK: Auction / Crowd
    UIImage *cashImage;
    if (self.isFirstShow) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"live_first" ofType:@"gif"];
        cashImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:filePath]];
    }else{
        cashImage = [UIImage imageNamed:@"auctionHammer2"];
    }
    
    UIImageView *newsBtn = [[UIImageView alloc] initWithImage:cashImage];
    newsBtn.tag = 1002;
    newsBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hanleTap:)];
    [newsBtn addGestureRecognizer:tap];
    [self addSubview:newsBtn];
    self.auctionBtn = newsBtn;
    
    if (User.isReviewID) {
        self.auctionBtn.hidden = YES;
    }
    
    // 右边的四个按钮
    NSArray *imageNames = @[@"cameraType",@"soundEffect",@"filter",@"show-message",@"redpacket"];
    for (int i=0; i < imageNames.count; i++) {
        
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtn.backgroundColor = [UIColor clearColor];
        switchBtn.tag = 1003 + i;
        
        [switchBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchBtn];
        
        if (i == 1 || i == 2) {
            [self.btns addObject:switchBtn];
            [switchBtn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        }else{
            [switchBtn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        }
        
        if (i == 0) {
            self.switchBtn = switchBtn;
        }else if (i == 1){
            self.beautyBtn = switchBtn;
        }else if (i == 2){
            self.shareBtn = switchBtn;
        }else if (i == 3){
            self.redPointView = [[UIView alloc]init];
            self.redPointView.layer.cornerRadius = 2.5;
            self.redPointView.backgroundColor = [UIColor colorWithRed:238/255.0 green:120/255.0 blue:32/255.0 alpha:1];
            self.redPointView.hidden = YES;
            [switchBtn addSubview:self.redPointView];
            [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(-2.5);
                make.top.mas_offset(2.5);
                make.size.sizeOffset(CGSizeMake(5, 5));
            }];
            [self setRedPointViewHidden];
            self.chatBtn = switchBtn;
        }else{
            self.redBagBtn = switchBtn;
        }
    }
    
    [self xw_addNotificationForName:@"redCircle" block:^(NSNotification * _Nonnull notification) {
        [self setRedPointViewHidden];
    }];
    [self layoutUI];
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

#pragma mark - 横屏竖屏两套布局
- (void)layoutUI{
    CGSize btnSize = CGSizeMake(40, 40);
    CGFloat btnSpacing = 8;
    
    CGFloat titleWidth = [[User.MemberName subEmojiStringTo:6 with:@"..."] boundingRectWithSize:CGSizeMake(10000, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:NULL].size.width;
    
    if (titleWidth < 50) {
        titleWidth = 50;
    }
    
    
    if (_type == WKGoodsLayoutTypeVertical) {
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset([[UIApplication sharedApplication] statusBarFrame].size.height);
            make.left.mas_offset(10);
            make.size.mas_offset(CGSizeMake(titleWidth + 60, 40));
        }];
    }
    else{
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(10);
            make.size.mas_offset(CGSizeMake(titleWidth + 60, 40));
        }];
    }
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleView);
        make.left.mas_equalTo(self.titleView.mas_left).offset(0);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.height.mas_offset(25);
        make.left.mas_equalTo(_iconImage.mas_right).offset(3);
        make.right.mas_equalTo(self.titleView).offset(3);
    }];
    
    [_onLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left).offset(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
        make.centerX.mas_equalTo(_titleLabel.mas_centerX).offset(0);
        //        make.right.mas_offset(-2);
        make.bottom.mas_offset(-5);
    }];
    
    // 弹幕
    [self.messageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-70);
        make.width.mas_offset(WKScreenW * 0.8);
        make.height.mas_offset(WKScreenH * 0.3);
    }];
    
    // contribution rank
    [self.contributorRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(WKScreenH * 0.3);
        make.right.mas_offset(0);
        make.size.mas_offset(CGSizeMake(40, 40));
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
    
    [self.goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(btnSpacing);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.auctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self.goodsBtn.mas_centerY).offset(0);
        make.size.mas_offset(btnSize);
    }];
    
    // 底部四个按钮
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-btnSpacing);
        make.right.mas_equalTo(self).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-btnSpacing);
        make.right.mas_equalTo(self.switchBtn.mas_left).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-btnSpacing);
        make.right.mas_equalTo(self.beautyBtn.mas_left).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-btnSpacing);
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    [self.redBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-btnSpacing);
        make.right.mas_equalTo(self.chatBtn.mas_left).offset(-btnSpacing);
        make.size.mas_offset(btnSize);
    }];
    
    if (User.isReviewID) {
        self.redBagBtn.hidden = YES;
    }
    
}

//MARK: show auction status / select activity type
- (void)hanleTap:(UITapGestureRecognizer *)tap{
    // 显示拍卖
    if (self.isFirstShow) {
        
        self.isFirstShow = NO;
        
    }else{
        if (_currentAuctionModel.Status.integerValue == 0) {
            [self selectActivityType];
        }else{
            // check auction status
            _autoCheckAuctionStatus = NO;
            [self checkAuctionStatus];
        }
    }
}

// select activity type
- (void)selectActivityType{
    [WKAnimationHelper showAnimation:WKAimationAuction OnView:nil withInfo:nil callback:^(WKAimation type,NSInteger idx) {
        NSLog(@"选择了 %lu",(unsigned long)type);
        if (type == WKAimationAuction) {
            WKGoodsType goodsType;
            if (idx == 0) {
                // auction
                goodsType = WKGoodsTypeAuction;
            }else{
                // crowd
                goodsType = WKGoodsTypeCrowd;
            }
            
            NSDictionary *parameters = @{
                                         @"PageIndex":@1,
                                         @"PageSize":@10,
                                         @"IsSelectAll":@"true",
                                         @"IsMarketable":@"true"
                                         };
            
            [WKGoodsCollectionView showGoodsListOn:self WithScreenType:_type goodsType:goodsType requestParameters:parameters clientType:WKClientTypePushFlow selectedBlock:^(id obj){
            }];
        }
    }];
}

- (void)setSingalStateWithIndex:(NSInteger)index{
    // 显示信号状态
    NSString *singalImageName = [NSString stringWithFormat:@"xinhao_%zd",index];
    self.singalImageView.image = [UIImage imageNamed:singalImageName];
    
    if (index == 3) {
        // 信号不好 信号标闪动
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
        
    }else{
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    
    self.singalImageView.hidden = NO;
}

- (void)timeCount{
    self.singalImageView.hidden = !self.singalImageView.hidden;
}

- (void)selectedPerson:(WKOnLineMd *)md{
    if ([_delegate respondsToSelector:@selector(selectedIndexPerson:)]) {
        [_delegate selectedIndexPerson:md];
    }
}

- (void)selectedSelf{
    if ([_delegate respondsToSelector:@selector(selectedIndexSelf)]) {
        [_delegate selectedIndexSelf];
    }
}

//MARK: 主播点击查看消息
- (void)selectedMessage:(id)message type:(WKMessageClickType)type{

    WKMessage *md = message;
    if (type == WKMessageClickTypeRed) {
        // redbag
        [WKGrabRedView grabRedEnvelopeOn:self message:md callBack:^{
            if ([_delegate respondsToSelector:@selector(operateType:md:)]) {
                [_delegate operateType:WKLiveOpeartionRedEvenlope md:message];
            }
        }];
        
    }else{
        // show user information
        WKOnLineMd *person = [[WKOnLineMd alloc] init];
        person.BPOID = md.bpoid;
        
        if ([_delegate respondsToSelector:@selector(selectedIndexPerson:)]) {
            [_delegate selectedIndexPerson:person];
        }
    }
}

#pragma mark - btnAction
- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 1001) {
        
        NSDictionary *parameters = @{
                                     @"PageIndex":@1,
                                     @"PageSize":@10,
                                     @"IsSelectAll":@"false",
                                     @"IsMarketable":@"true"
                                     };
        
        [WKGoodsCollectionView showGoodsListOn:self WithScreenType:_type goodsType:WKGoodsTypeSale requestParameters:parameters clientType:WKClientTypePushFlow selectedBlock:^(id obj){
            
        }];
        
    }else if (btn.tag == 1003){
        // 榜单
        if ([_delegate respondsToSelector:@selector(livePreOperation:)]) {
            [_delegate livePreOperation:WKLiveOpeartionContributor];
        }
        
    }else if (btn.tag == 1004){
        // 虚拟世界
        if ([_delegate respondsToSelector:@selector(livePreOperation:)]) {
            [_delegate livePreOperation:WKLiveOpeartionVirtual];
        }
    }
    else{
        
        // 拍卖品
        _autoCheckAuctionStatus = NO;
        [self checkAuctionStatus];
        // 1 订单 2 物流
    }
    
}

- (void)setMuteWithBOPID:(NSString *)bpoid type:(NSInteger)type{
    [self.onlinePerson setItemStateWithBPOID:bpoid type:type];
}

#pragma mark - 切换摄像头 / 美颜 / 分享
- (void)btnAction:(UIButton *)btn{
    
//    WKShowConfigType configType;
    if (btn.tag == 1003) {
        // 切换摄像头
//        configType = WKShowConfigTypeCamera;
        
        [WKLiveConfigView showViewType:WKShowConfigTypeCamera defaultIndex:self.currentCameraSetting clickBlock:^(NSInteger idx,WKShowConfigType type) {
            self.currentCameraSetting = idx;
            
            if (idx == 3) {
                // 分享
                [self shareTheWeChat];
            }else{
                
                if ([_delegate respondsToSelector:@selector(controlCamearSingal:)]) {
                    [_delegate controlCamearSingal:idx];
                }
            }
        }];
        
    }else if (btn.tag == 1004){
        // Voice
        [WKLiveConfigView showViewType:WKShowConfigTypeVoice defaultIndex:self.currentVoiceType clickBlock:^(NSInteger idx,WKShowConfigType type) {
            self.currentVoiceType = idx;
            if ([_delegate respondsToSelector:@selector(controlAudioSingal:)]) {
                [_delegate controlAudioSingal:idx];
            }
        }];
        
    }else if (btn.tag == 1005){
        // filter
        [WKLiveConfigView showViewType:WKShowConfigTypeFilter defaultIndex:self.currentFilterType clickBlock:^(NSInteger idx,WKShowConfigType type) {
            
            self.currentFilterType = idx;
            if ([_delegate respondsToSelector:@selector(switchFilterType:)]) {
                [_delegate switchFilterType:idx];
            }
            
        }];
        
    }
    else if(btn.tag == 1006){ //聊天
        if (self.btnBlock) {
            self.btnBlock(1);
        }
    }else if (btn.tag == 1007){
        // red bag
        if (self.btnBlock) {
            self.btnBlock(2);
        }
    }
}

-(void)shareTheWeChat{
    
    NSString *urlStr = [NSString configUrl:WKShareBefore With:@[@"ShopOwnerNo"] values:@[User.MemberNo]];
    [WKHttpRequest shareWeChatBefore:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKShareModel *shareModel = [[WKShareModel alloc]init];
        shareModel.shareImageArr = @[response.Data[@"PicUrl"]];
        shareModel.shareTitle = response.Data[@"Title"];
        shareModel.shareContent = response.Data[@"Description"];
        shareModel.shopOwnerNo = User.MemberNo;
        shareModel.shareUrl = response.Data[@"LinkUrl"];
        [WKShareView shareViewWithModel:shareModel];
    } failure:^(WKBaseResponse *response) {
        NSLog(@"%@",response);
    }];
    
}

- (void)exitLive{
    
    if ([_delegate respondsToSelector:@selector(livePreOperation:)]) {
        [_delegate livePreOperation:WKLiveOpeartionLeave];
    }
}

// MARK: 查看拍卖状态
- (void)checkAuctionStatus{
    NSString *url = [NSString configUrl:WKAuctionStatus With:@[@"shopOwnerNo"] values:@[User.MemberNo]];
    
    [WKHttpRequest auctionGoods:HttpRequestMethodPost url:url param:nil model:NSStringFromClass([WKAuctionStatusModel class]) success:^(WKBaseResponse *response) {
        WKAuctionStatusModel *md = response.Data;
        self.currentAuctionModel = md;
        if (md.Status.integerValue == 0) {
            self.isFirstShow = YES;
        }
        [self showAuctionStatusWith:md];
        if (self.auctionListView) {
            [self.auctionListView delayTime:md.RemainTime.integerValue];
            NSLog(@"current Remain time %ld",(long)md.RemainTime.integerValue);
        }
        
        
        // 拍卖中显示拍卖状态
        if (md.Status.integerValue == 1) {
            if (!self.auctionListView) {
                WKAuctioningListView *auctionView = [[WKAuctioningListView alloc] initWithFrame:CGRectMake(0, 80, WKScreenW, 50)];
                [self addSubview:auctionView];
                auctionView.block = ^(WKAuctionJoinModel *model){
                    WKOnLineMd *person = [[WKOnLineMd alloc] init];
                    person.BPOID = model.CustomerBPOID;
                    if ([_delegate respondsToSelector:@selector(selectedIndexPerson:)]) {
                        [_delegate selectedIndexPerson:person];
                    }
                };
                [auctionView setAuctionerInfo:md];
                
                self.auctionListView = auctionView;
                
                [self joinInList];
            }
        }else{
            if (self.auctionListView) {
                [self.auctionListView removeFromSuperview];
                self.auctionListView = nil;
            }
        }
        
        if (_autoCheckAuctionStatus) {
            
            
        }else{
            
            if (md.Status.integerValue == 0) {
                // select activity type
                [self selectActivityType];
            }else{
                
                [WKAuctionStatusView showWithModel:md screenOrientation:_type clientType:WKAuctionTypePushFlow completionBlock:^(WKCallBackType type){
                    
                    [self selectActivityType];
                }];
            }
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

//MARK: Get join list
- (void)joinInList{
    NSString *url = [NSString configUrl:WKJoinList With:@[@"ShopOwnerNo"] values:@[User.MemberNo]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        NSArray *arr = [NSArray yy_modelArrayWithClass:[WKAuctionJoinModel class] json:response.Data];
        [self.auctionListView participatePersons:arr showAnimation:NO];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

@end
