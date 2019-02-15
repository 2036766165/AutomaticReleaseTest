//
//  WKGoodsDetailViewController.m
//  秀加加
//  标题：直播商品详情 竖屏显示
//  Created by sks on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsDetailViewController.h"
#import "WKLiveShopTableView.h"
#import "WKMapViewController.h"
#import "NSObject+WKImagePicker.h"
#import "PlayerManager.h"
#import "WKLiveSelectShopView.h"
#import "WKPayTool.h"
#import "NSObject+XWAdd.h"
#import "WKAddressViewController.h"
#import "WKNavigationController.h"
#import "WKAddressModel.h"
#import "WKPlayTool.h"
#import "WKGetShopAuthenticationModel.h"
#import "WKPaySuccessView.h"
#import "WKOrderPayStatusModel.h"
#import "WKAuctionStatusModel.h"
#import "WKStoreRechargeViewController.h"
#import "WKShowInputView.h"
#import "WKEmptyViewController.h"

@interface WKGoodsDetailViewController () <PlayingDelegate,WKSelectAddressDelegate,PlayingDelegate>{
//    UIView *_liveView;
    WKBackShowType _backType;
    WKGoodsListItem *_goodsItem;    // 商品
    WKHomePlayModel *_homePlayItem; // 直播
    WKOrederItem *_orderResultItem;
    WKAuctionStatusModel *_auctionStatusModel;
    NSInteger _checkStatusTime;
    WKLiveFrom _from;
    BOOL _showGoods;
}

@property (strong, nonatomic) WKLiveShopTableView *liveShopTableView;
@property (strong, nonatomic) WKLiveShopListModel *liveshopListModel;
@property (strong, nonatomic) WKLiveShopCommentModel *commentModel;
@property (strong, nonatomic) WKLiveSelectShopView *liveShopView;
@property (strong, nonatomic) NSString *number;
@property (assign, nonatomic) NSInteger ModelCode;
@property (strong, nonatomic) NSIndexPath *pindex;
@property (nonatomic,strong) UIViewController *addressVC;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) WKGetShopAuthenticationModel *shopAuthModel;
@property (nonatomic,strong) NSString *orderCode;
@property (nonatomic,strong) NSString *cellHeight;
@property (nonatomic,strong) UITapGestureRecognizer *tap;

@property (nonatomic,assign) CGFloat totalPrice;

@property (nonatomic,assign) CGFloat balancePrice;

@end

@implementation WKGoodsDetailViewController

- (instancetype)initWithGoodsItem:(WKGoodsListItem *)goodsItem playModel:(WKHomePlayModel *)homeModel from:(WKLiveFrom)from showGoods:(BOOL)showGoods{
    if (self = [super init]) {
        _from = from;
        _goodsItem = goodsItem;
        _homePlayItem = homeModel;
        _showGoods = showGoods;
        _checkStatusTime = 2;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _backType = WKBackShowTypeNormal;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //监控修改商品数量的通知
    [self xw_addNotificationForName:@"数量" block:^(NSNotification * _Nonnull notification) {
        self.number = [notification.userInfo objectForKey:@"数量"];
        self.balancePrice = [[notification.userInfo objectForKey:@"余额"] floatValue];
        [self changePrice];
    }];
    
    UIView *videoView = [self.navigationController.view viewWithTag:10001];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tap = tap;
    [videoView addGestureRecognizer:tap];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
////    UIView *videoView = [self.navigationController.view viewWithTag:10001];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick)];
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];

    self.title = @"商品详情";
    [self xw_addNotificationForName:@"BALANCE" block:^(NSNotification * _Nonnull notification) {
        
        [WKShowInputView showInputWithPlaceString:@"当前余额不足,是否去充值" type:LABELTYPE andBlock:^(NSString *str) {
            WKEmptyViewController *rechargeVC = [[WKEmptyViewController alloc] init];
            //        [self. pushViewController:rechargeVC animated:YES];
            [self presentViewController:rechargeVC animated:YES completion:NULL];        }];
    }];
    
    [self xw_addNotificationForName:@"rechargeNumber" block:^(NSNotification * _Nonnull notification) {
        [self getMemberIncome];
    }];
 
    [self xw_addNotificationForName:@"RECHARGESUCCESS" block:^(NSNotification * _Nonnull notification) {
        [self getMemberIncome];
    }];
    
    [self loadGoodsAndAuctionInfo];
}

//MARK: load goods and activity info
- (void)loadGoodsAndAuctionInfo{
    
    dispatch_group_t group = dispatch_group_create();
    [WKProgressHUD showLoadingGifText:@""];
    
    dispatch_group_enter(group);
    
    NSString *url = [NSString configUrl:WKAuctionStatus With:@[@"shopOwnerNo"] values:@[[NSString stringWithFormat:@"%@",_homePlayItem.MemberNo]]];
    [WKHttpRequest AuctionStatus:HttpRequestMethodPost url:url model:NSStringFromClass([WKAuctionStatusModel class]) param:nil success:^(WKBaseResponse *response) {
        WKAuctionStatusModel *md = response.Data;
        _auctionStatusModel = md;
        dispatch_group_leave(group);
        
    } failure:^(WKBaseResponse *response) {
        //        NSLog(@"response json : %@",response.json);
        [WKProgressHUD showTopMessage:response.ResultMessage];
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_enter(group);
    //1.获得商品详情(暂停此接口的调用，稍后处理)
    NSString *shopurl = [NSString configUrl:WKLiveGoodsDetail With:@[@"goodsCode"] values:@[[NSString stringWithFormat:@"%@",_goodsItem.GoodsCode]]];
    
    [WKHttpRequest GoodsGet:HttpRequestMethodGet url:shopurl model:@"WKLiveShopListModel" param:nil success:^(WKBaseResponse *response) {
        NSLog(@"%@",response.json);
        dispatch_group_leave(group);
        
        WKLiveShopListModel *liveModel = response.Data;
        self.liveshopListModel = liveModel;
        
        self.totalPrice = self.liveshopListModel.IsFreeShipping?self.liveshopListModel.Price.floatValue:self.liveshopListModel.Price.floatValue + self.liveshopListModel.TranFee.floatValue;
        
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        for (int i=0; i<self.liveshopListModel.GoodsPicList.count; i++) {
            
            WKLiveShopPicModelItem *item = self.liveshopListModel.GoodsPicList[i];
            
            [item.imageView sd_setImageWithURL:[NSURL URLWithString:item.PicUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                item.cellHeight = image.size.height * WKScreenW/image.size.width;
                item.imageView.image = image;
            }];
        }
        CGRect rect = CGRectZero;
        if (_showGoods) {
            rect = CGRectMake(0, 64, WKScreenW, self.view.bounds.size.height - 45);
        }else{
            rect = CGRectMake(0, 64, WKScreenW, self.view.bounds.size.height);
        }
        
        
        self.liveShopTableView = [[WKLiveShopTableView alloc] initWithFrame:rect withGoodsDetail:self.liveshopListModel playModel:_homePlayItem auctionModel:_auctionStatusModel showGoods:_showGoods];
        [self.view addSubview:self.liveShopTableView];
        
//        [self.view bringSubviewToFront:_liveView];
        
        [self event];
        
        if (_showGoods) {
            [self InitBuyBtn];
        }
        
        
        [self getMemberIncome];
    });
    
}

-(void)payEvent
{
    WKLiveSelectShopView *liveShopView = [[WKLiveSelectShopView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) model:self.liveshopListModel];
    self.liveShopView = liveShopView;
    self.liveShopView.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:liveShopView];
    
    liveShopView.clickPayType = ^(NSInteger type)
    {
        if(type == 1)//1.微信支付(不能跳转)
        {
            [self setAllValue:2];
        }
        else if(type == 2)//2.支付宝支付
        {
            [self setAllValue:4];
        }
        else if(type == 3)//3.跳转地址
        {
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = self.view.bounds;
            [maskBtn addTarget:self action:@selector(dismissAddress:) forControlEvents:UIControlEventTouchUpInside];
            maskBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            
            [self.view addSubview:maskBtn];
            self.maskBtn = maskBtn;
            self.liveShopView.hidden = YES;

            WKAddressViewController *address = [[WKAddressViewController alloc] initWithFrom:WKAddressFromLive];
            address.delegate = self;
            WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:address];
            self.addressVC = nav;
            nav.view.frame = CGRectMake(0, WKScreenH - (44 * 9), WKScreenW, 44 * 9);
            
            [self addChildViewController:nav];
            [self.view addSubview:nav.view];
        }else{
            // 余额支付
            if (self.totalPrice < self.balancePrice) {
                [self setAllValue:6];
            }else{
                [WKPromptView showPromptView:@"余额不足请充值"];
                [self xw_postNotificationWithName:@"BALANCE" userInfo:nil];
            }
        }
    };
    
    //选择不同的商品型号赋值
    liveShopView.cellClick = ^(NSIndexPath *index){
        self.ModelCode = ((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).ModelCode;
        
        CGFloat goodPrice = [((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).Price floatValue];
        CGFloat tranFee = [self.liveshopListModel.TranFee floatValue];
        self.liveShopView.priceName.text = [NSString stringWithFormat:@"￥%.2f  库存%ld件",goodPrice,(long)((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).Stock];
        
        
        if(self.liveshopListModel.IsFreeShipping)
        {
            self.totalPrice = goodPrice;
            self.liveShopView.allMoney.text = [NSString stringWithFormat:@"总计：￥%.2f",goodPrice];
        }
        else
        {
            self.liveShopView.allMoney.text = [NSString stringWithFormat:@"总计：￥%.2f",goodPrice + tranFee];
            self.totalPrice = goodPrice + tranFee;
        }
        
        self.liveShopView.slider.value = 1;
        
//        if(index.row == 0)
//        {
//            self.ModelCode = ((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[0]).ModelCode;
//            self.liveShopView.priceName.text = [NSString stringWithFormat:@"￥%@  库存%ld件",((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[0]).Price,(long)((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[0]).Stock];
//            
//            float money = [((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[0]).Price floatValue] + [self.liveshopListModel.TranFee floatValue];
//            
//            self.liveShopView.allMoney.text = [NSString stringWithFormat:@"总价:￥%.2f",money];
//            self.liveShopView.slider.value = 1;
//        }
//        else
//        {
//            self.ModelCode = ((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).ModelCode;
//            
//            self.liveShopView.priceName.text = [NSString stringWithFormat:@"￥%@  库存%ld件",((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).Price,(long)((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).Stock];
//        
//            float money = [((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[index.row]).Price floatValue] + [self.liveshopListModel.TranFee floatValue];
//            
//            self.liveShopView.allMoney.text = [NSString stringWithFormat:@"总价:￥%.2f",money];
//            self.liveShopView.slider.value = 1;
//        }
        
        self.pindex = index;
    };
    
    [self loadAddress];

    [UIView animateWithDuration:0.3 animations:^{
        self.liveShopView.alpha = 1.0;
    }];
}

- (void)bbiClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([_delegate respondsToSelector:@selector(backToShowWith:orderInfo:)]) {
        [[PlayerManager sharedManager] stopPlaying];
        [_delegate backToShowWith:_backType orderInfo:_orderResultItem];
    }
}

//- (void)setLiveView:(UIView *)liveView{
//    
////    _liveView = liveView;
//    [UIView animateWithDuration:0.2 animations:^{
//        liveView.frame = CGRectMake(0, 64, WKScreenW/3, WKScreenH/4);
//    }];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//    [liveView addGestureRecognizer:tap];
//    
//    self.tap = tap;
//    
//    [self.liveShopTableView removeFromSuperview];
//    self.liveShopTableView = nil;
//}

//MARK: back
- (void)handleTap:(UITapGestureRecognizer *)tap{
    UIView *videoView = [self.navigationController.view viewWithTag:10001];
    [videoView removeGestureRecognizer:tap];
    
    if (_from == WKLiveFromHotGoods) {
        _backType = WKBackShowTypeHotGoods;
    }
    
    [self bbiClick];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)event
{
    WeakSelf(WKGoodsDetailViewController);
    
    self.liveShopTableView.clickAddress = ^(NSInteger type){
        if(type == 1)//地图
        {
            [weakSelf getShopAuthentication];
        }
    };
    
    //浏览图片
    self.liveShopTableView.showPicBlock = ^(LiveShopAudioType type,NSInteger row){
        
        if(type == ClickLiveShopPicType)
        {
            WKLiveShopCommentModelItem *item = weakSelf.liveShopTableView.commentArray[row];
                        
            NSLog(@"%lu",(unsigned long)item.PicUrls.count);
            
            NSMutableArray *arr = @[].mutableCopy;
            
            for (int i=0; i < item.PicUrls.count; i++)
            {
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:item.PicUrls[i]];
                [arr addObject:photo];
            }
            [weakSelf showImageWith:arr index:0];
        }
        else if(type == ClickLiveShopAudioType)
        {
            NSString *content = ((WKLiveShopCommentModelItem*)weakSelf.liveShopTableView.commentArray[row]).Content;
            if(![content isEqualToString:@""])
            {
                [WKPlayTool writeFileWithStr:content :^(NSString *voicePath, NSString *requestMessage) {
                    if ([requestMessage isEqualToString:@"写入成功"]) {
                        [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:weakSelf];
                    }else{
                        NSLog(@"%@",requestMessage);
                    }
                }];
            }

        }
        else if(type == ClickLiveShopReplyAudioType)
        {
            NSString *reply = ((WKLiveShopCommentModelItem*)weakSelf.liveShopTableView.commentArray[row]).Reply;
            if(![reply isEqualToString:@""])
            {
                [WKPlayTool writeFileWithStr:reply :^(NSString *voicePath, NSString *requestMessage) {
                    if ([requestMessage isEqualToString:@"写入成功"])
                    {
                        [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:weakSelf];
                    }else{
                        NSLog(@"%@",requestMessage);
                    }
                }];
            }
        }
    };
}

- (void)playingStoped
{
//    [self.liveShopTableView reloadData];
}

- (void)selectedAddress:(WKAddressListItem *)address
{
    self.liveShopView.addressItem = address;
    self.liveShopView.hidden = NO;
    [self dismissAddress:self.maskBtn];
}

- (void)leaveAddressList{
    [self dismissAddress:self.maskBtn];
    [self payEvent];
}

- (void)dismissAddress:(UIButton *)btn{
    [self.addressVC willMoveToParentViewController:nil];
    [self.addressVC.view removeFromSuperview];
    [self.addressVC removeFromParentViewController];
    [btn removeFromSuperview];
}


// 获取用户余额
- (void)getMemberIncome{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response : %@",response);
        
//        NSString *balanceNum = [NSString stringWithFormat:@"%0.2f",[response.Data[@"MoneyCanTake"] floatValue]];
        
        self.balancePrice = [response.Data[@"MoneyCanTake"] floatValue];
        
        if (self.liveShopView) {
            [self.liveShopView.balanceBtn setTitle:[NSString stringWithFormat:@"%0.2f",self.balancePrice] forState:UIControlStateNormal];
        }
        
//        [self.balanceBtn setTitle:balanceNum forState:UIControlStateNormal];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

//注册购买按钮
-(void)InitBuyBtn
{
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.backgroundColor = [UIColor colorWithHex:0xFC6620];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [payBtn addTarget:self action:@selector(payEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    [self.view bringSubviewToFront:payBtn];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.mas_equalTo(45);
    }];
}

//一键购买的接口
-(void)quickBuy:(NSInteger)type payCount:(NSInteger)payCount
{
    // if not virtual goods, verifiy the address
    if (!_goodsItem.IsVirtual) {
        if(!self.liveShopView.addressItem)
        {
            [WKProgressHUD showTopMessage:@"请填写地址"];
            return;
        }
    }
    //选中的商品型号
    NSString *selectModel = ((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[0]).ModelName;
    //如果商品没有型号，找到默认型号
    if(selectModel.length == 0)
    {
        self.ModelCode = ((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[0]).ModelCode;
    }
    
    //商品编号，商品型号 集合
    NSString *goodsinfo = [NSString stringWithFormat:@"%@,%ld",_goodsItem.GoodsCode,(long)self.ModelCode];
    
    NSMutableDictionary *param = @{@"ShopOwnerBPOID":_homePlayItem.BPOID,
                            @"OrderType":@(1),
                            @"OrderFrom":@(3),
                            @"PayType":@(type),
                            @"GoodsInfo":goodsinfo,
                            @"BuyCount":@(1),
                            @"IsVirtual":_goodsItem.IsVirtual == YES?@"true":@"false"
                            }.mutableCopy;
    
    if (!_goodsItem.IsVirtual) {
        [param addEntriesFromDictionary:@{@"AddressID":self.liveShopView.addressItem.ID}];
        [param addEntriesFromDictionary:@{@"BuyCount":@(payCount)}];
    }else{
        [param addEntriesFromDictionary:@{@"AddressID":@""}];
    }
    
    [WKProgressHUD showLoadingGifText:@""];
    [WKHttpRequest QuickBuy:HttpRequestMethodPost url:WKQuickBuy model:nil param:param success:^(WKBaseResponse *response) {
        [WKProgressHUD dismiss];
        NSString *orderCode = response.Data;
        
        [self payData:orderCode PayType:type orderType:1 addressId:@""]; //调用支付接口
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//支付的接口
-(void)payData:(NSString *)orderCode
       PayType:(NSInteger)PayType
     orderType:(NSInteger)orderType
     addressId:(NSString *)addressId
{
    NSDictionary *param = @{@"OrderCode":orderCode,
                            @"PayType":@(PayType),
                            @"OrderType":@(orderType),
                            @"AddressID":addressId};
    
    
    [[WKPayTool shareInstance] payWith:param type:PayType completionBlock:^(id obj) {
        
        WKPayResult *result = obj;
        if(result.resultType == WKPayResultTypeSuccess)//成功的方法
        {
//            [self.liveShopTableView removeSubviews];
//            [self.liveShopView removeSubviews];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self paySuccess:orderCode];
            });
        }
        else
        {
//            WKPromptView *promptView = [[WKPromptView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, 40)];
//            [promptView promptViewShow:@"支付失败"];
////            [self.view addSubview:promptView];
//            [[UIApplication sharedApplication].keyWindow addSubview:promptView];
        }
    }];
}

-(void)paySuccess:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKOrderPayStatus With:@[@"OrderCode",@"OrderType"] values:@[[NSString stringWithFormat:@"%@",orderCode],[NSString stringWithFormat:@"%@",@"1"]]];
    
    [WKHttpRequest OrderPayStatus:HttpRequestMethodPost url:url model:@"WKOrderPayStatusModel" param:nil success:^(WKBaseResponse *response) {
        
        [self.liveShopView closeEvent];
        
        WKOrderPayStatusModel *payModel = response.Data;
        
        WKOrederItem *item = [[WKOrederItem alloc] init];
        float price= [[NSString stringWithFormat:@"%0.2f",[payModel.PayAmount floatValue]] floatValue];
        
        item.orderAmount = [NSNumber numberWithFloat:price];
        item.orderNo = payModel.OrderCode;
        item.orderTime = payModel.CreateTime;
        item.orderType = WKOrderTypeGoods;
        item.payResult = YES;
        
        _backType = WKBackShowTypePay;
        _orderResultItem = item;
        
        [self handleTap:self.tap];

    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
        _checkStatusTime--;
        if (_checkStatusTime != 0) {
            [self paySuccess:orderCode];
        }
    }];
}

-(void)setAllValue:(NSInteger)type
{
    //一键购买接口
    [self quickBuy:type payCount:[self.liveShopView.sliderNum.text integerValue]];
}

#pragma mark - 滑动改变价格
-(void)changePrice
{
    if(self.liveShopView == nil || self.liveshopListModel == nil)
    {
        return;
    }
    
    CGFloat goodPrice = [((WKLiveShopListModelItem*)self.liveshopListModel.GoodsModelList[self.pindex.row]).Price floatValue];
    CGFloat totalPrice = self.liveShopView.sliderNum.text.integerValue * goodPrice ;
    NSString *Money = @"";
    
    if(self.liveshopListModel.IsFreeShipping == YES)
    {
        Money =  [NSString stringWithFormat:@"总计：￥%.2f",totalPrice];
    }
    else
    {
        Money =  [NSString stringWithFormat:@"总计：￥%.2f",totalPrice + [self.liveshopListModel.TranFee floatValue]];
    }
    
    self.totalPrice = totalPrice + [self.liveshopListModel.TranFee floatValue];
    self.liveShopView.allMoney.text = Money;
}

#pragma mark - 加载地址
- (void)loadAddress{
    [WKHttpRequest  getAddress:HttpRequestMethodGet url:WKAddresssList model:NSStringFromClass([WKAddressListModel class]) param:@{} success:^(WKBaseResponse *response) {
        WKAddressListModel *md = response.Data;
        
        if(md.InnerList.count > 0)
        {
            self.liveShopView.addressItem = (WKAddressListItem*)md.InnerList[0];
        }
        
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
        
    }];
}

#pragma mark - 获取店主认证信息
-(void)getShopAuthentication
{
    NSString *url = [NSString configUrl:WKGetShopAuthentication With:@[@"BPOID"] values:@[[NSString stringWithFormat:@"%@",_homePlayItem.BPOID]]];
    
    [WKHttpRequest GetShopAuthentication:HttpRequestMethodGet url:url model:@"WKGetShopAuthenticationModel" param:nil success:^(WKBaseResponse *response) {
        self.shopAuthModel = response.Data;
        WKMapViewController *mapView = [[WKMapViewController alloc] initWith:1];
        mapView.addressModel = self.shopAuthModel;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mapView];
        
        [self presentViewController:nav animated:YES completion:NULL];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}


- (void)dealloc{
    _goodsItem = nil;
    _homePlayItem = nil;
    _auctionStatusModel = nil;
//    _liveView = nil;
    NSLog(@"释放商品详情页\n");
}

@end
