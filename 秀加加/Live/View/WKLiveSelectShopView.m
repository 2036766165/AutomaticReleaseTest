//
//  WKLiveSelectShopView.m
//  秀加加
//
//  Created by lin on 2016/10/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveSelectShopView.h"
#import "NSString+Size.h"
#import "FJTagCollectionLayout.h"
#import "CollectionViewCell.h"
#import "NSObject+XWAdd.h"

@interface WKLiveSelectShopView()<FJTagCollectionLayoutDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *fakeDataArray;
@property (nonatomic,strong) UIView *currentView;

@property (nonatomic,strong) WKLiveShopListModel *model;

@property (nonatomic,strong) UILabel *addressName;

@property (nonatomic,strong) UILabel *addressCon;

@property (nonatomic,strong) UIButton *defaultBtn;

@end

@implementation WKLiveSelectShopView

- (instancetype)initWithFrame:(CGRect)frame
                        model:(WKLiveShopListModel*)model
{
    _model = model;
    if (self = [super initWithFrame:frame])
    {
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0; i < model.GoodsModelList.count;i++)
        {
            WKLiveShopListModelItem *item = model.GoodsModelList[i];
            if(item.ModelName != nil)
            {
                [array addObject:item.ModelName];
            }
        }
        self.fakeDataArray = array;
        
        [self xw_addObserverBlockForKeyPath:@"addressItem" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            WKAddressListItem *address = newVal;
            self.addressName.text = [NSString stringWithFormat:@"%@ %@",address.Contact,address.Phone];
            self.addressCon.text = [NSString stringWithFormat:@"%@%@%@%@",address.ProvinceName,address.CityName,address.CountyName,address.Address];
            self.defaultBtn.hidden = !address.IsDefault;
        }];
        
        //刷新充值金额
        [self xw_addNotificationForName:@"rechargeNumber" block:^(NSNotification * _Nonnull notification) {
            [self getMemberIncome];
        }];
        
        if (!model.IsVirtual) {
            [self initUi:model];
        }else{
            [self initVirtualUI:model];
        }
        
        [self getMemberIncome];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fakeDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.fakeDataArray.count) {
        __weak CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
        cell.contentLabel.text = self.fakeDataArray[indexPath.item];
        cell.indexPath = indexPath;
        if(indexPath.row == 0)
        {
            cell.backGroupView.layer.borderColor = [[UIColor colorWithHex:0xEC6419] CGColor];
            self.currentView = cell.backGroupView;
            self.cellClick(0);
        }
        
        cell.clickTypeCell = ^(){
            
            if(self.currentView == nil)//选中状态
            {
                cell.backGroupView.layer.borderColor = [[UIColor colorWithHex:0xEC6419] CGColor];
                self.currentView = cell.backGroupView;
            }
            else
            {
                self.currentView.layer.borderColor = [[UIColor colorWithHex:0xE0DFE3] CGColor];
                self.currentView = cell.backGroupView;
                self.currentView.layer.borderColor = [[UIColor colorWithHex:0xEC6419] CGColor];
                
            }
            
            self.cellClick(indexPath);
        };
        return cell;
    }
    return nil;
}

#pragma mark  ------- FJTagCollectionLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJTagCollectionLayout*)collectionViewLayout widthAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item < self.fakeDataArray.count) {
        CGSize size = CGSizeZero;
        size.height = 30;
        //计算字的width 这里主要font 是字体的大小
        CGSize temSize = [self sizeWithString:self.fakeDataArray[indexPath.item] fontSize:14];
        size.width = temSize.width + 20 + 1; //20为左右空10
        return size.width;
    }else{
        return 90.0f;
    }
}

- (CGSize)sizeWithString:(NSString *)str fontSize:(float)fontSize
{
    CGSize constraint = CGSizeMake(WKScreenW - 40, fontSize + 1);
    
    CGSize tempSize;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize retSize = [str boundingRectWithSize:constraint
                                       options:
                      NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attribute
                                       context:nil].size;
    tempSize = retSize;
    
    return tempSize ;
}

- (void)initVirtualUI:(WKLiveShopListModel *)model{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [backBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, WKScreenH-370*WKScaleW, WKScreenW, 370*WKScaleW)];
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, WKScreenH * 0.6, WKScreenW, WKScreenH * 0.4);
    backView.backgroundColor = [UIColor whiteColor];
    [backBtn addSubview:backView];
    
    CGSize contentSize = [model.GoodsName sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(WKScreenW-100, MAXFLOAT)];
    UIView *contentView = [[UIView alloc] init];
    [backView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.top.equalTo(backView).offset(0);
        make.height.mas_offset(contentSize.height+10+10+10);//20是文字的高度
    }];
    
    //关闭按钮
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.top.equalTo(contentView).offset(10);
        make.size.mas_offset(CGSizeMake(closeImage.size.width, closeImage.size.height));
    }];
    
    //商品名
    UILabel *shopName = [[UILabel alloc] init];
    shopName.numberOfLines = 0;
    shopName.lineBreakMode = NSLineBreakByWordWrapping;
    shopName.text = model.GoodsName;
    shopName.font = [UIFont systemFontOfSize:14.0f];
    shopName.textColor = [UIColor colorWithHex:0x8A8D9D];
    [contentView addSubview:shopName];
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(contentView).offset(10);
        make.right.equalTo(closeBtn.mas_left).offset(10);
        make.height.mas_offset(contentSize.height);
    }];
    
    //商品价钱
    UILabel *priceName = [[UILabel alloc] init];
    priceName.font = [UIFont systemFontOfSize:14];
    priceName.text = [NSString stringWithFormat:@"￥%.2f",[((WKLiveShopListModelItem*)(model.GoodsModelList[0])).Price floatValue]];//model.Price;
    priceName.textColor = [UIColor colorWithHex:0x8A8D9D];
    self.priceName = priceName;
    [contentView addSubview:priceName];
    [priceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(shopName.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(250, 20));
    }];

    //总价
    UILabel *allMoney = [[UILabel alloc] init];
    allMoney.font = [UIFont systemFontOfSize:14];
    allMoney.textAlignment = NSTextAlignmentRight;
    allMoney.textColor = [UIColor colorWithHex:0xDF6E1D];
    CGFloat totalPrice = totalPrice = model.IsFreeShipping ? model.Price.floatValue : model.Price.floatValue + model.TranFee.floatValue;
    allMoney.text = [NSString stringWithFormat:@"总计：￥%.2f",totalPrice];
    self.allMoney = allMoney;
    [contentView addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.top.equalTo(shopName.mas_bottom).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(100, 20));
    }];
    
    //横线
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [contentView addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(0);
        make.right.equalTo(contentView.mas_right).offset(0);
        make.top.equalTo(allMoney.mas_bottom).offset(15);
        make.height.mas_offset(1);
    }];
    
//    UIView *reminderView = [];
    UIImageView *reminderImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reminder_img"]];
    [backView addSubview:reminderImageV];
    
    [reminderImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(xianView.mas_bottom).offset(15);
        make.size.mas_offset(reminderImageV.image.size);
    }];
    
    UILabel *reminderLabel = [UILabel new];
    reminderLabel.text = @"注:虚拟商品购买后自动发货,\n请在\"虚拟世界\"中查看";
    reminderLabel.font = [UIFont systemFontOfSize:12.0f];
    reminderLabel.textColor = [UIColor darkGrayColor];
    reminderLabel.numberOfLines = 0;
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:reminderLabel];
    
    [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reminderImageV.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(200, 60));
        make.centerX.mas_equalTo(backView.mas_centerX).offset(0);
    }];
    
    UIImage *weinxinImage = [UIImage imageNamed:@"weixin"];
    UIView *downView = [[UIView alloc] init];
    downView.layer.borderWidth = 1;
    downView.layer.borderColor = [[UIColor colorWithHex:0xDEDFE1] CGColor];
    downView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
    [backView addSubview:downView];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
        make.height.mas_offset(weinxinImage.size.height+20);
    }];
    
    //支付宝
    UIImage *zhifuImage = [UIImage imageNamed:@"zhifu"];
    UIButton *zhifuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifuBtn.tag = 2;
    [zhifuBtn setImage:zhifuImage forState:UIControlStateNormal];
    [zhifuBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:zhifuBtn];
    
    //微信支付
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.tag = 1;
    [weixinBtn setImage:weinxinImage forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:weixinBtn];
    
    // 余额
    UIImage *balanceImage = [UIImage imageNamed:@"remainImg"];
    UIButton *balanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [balanceBtn setImage:balanceImage forState:UIControlStateNormal];
    [balanceBtn setTitle:@"" forState:UIControlStateNormal];
    [balanceBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    balanceBtn.tag = 3;
    balanceBtn.layer.borderWidth = 1.0;
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    balanceBtn.layer.cornerRadius = 2.0;
    balanceBtn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
    [balanceBtn setImage:balanceImage forState:UIControlStateNormal];
    [balanceBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:balanceBtn];

    self.balanceBtn = balanceBtn;

    [zhifuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(downView);
        make.bottom.equalTo(downView.mas_bottom).offset(-10);
        make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
    }];
    
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhifuBtn.mas_left).offset(-10);
        make.bottom.equalTo(downView.mas_bottom).offset(-10);
        make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
    }];
    
    [balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhifuBtn.mas_right).offset(10);
        make.bottom.equalTo(downView.mas_bottom).offset(-10);
        make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
    }];

}

-(void)initUi:(WKLiveShopListModel*)model
{
    
    FJTagCollectionLayout *tagLayout = [[FJTagCollectionLayout alloc] init];
    tagLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    tagLayout.lineSpacing = 10;
    tagLayout.itemSpacing = 10;
    tagLayout.itemHeigh = 30;
    tagLayout.delegate = self;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [backBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, WKScreenH-370*WKScaleW, WKScreenW, 370*WKScaleW)];
    UIView *backView = [[UIView alloc] init];
    if([((WKLiveShopListModelItem*)_model.GoodsModelList[0]).ModelName isEqualToString:@""])
    {
        backView.frame = CGRectMake(0, WKScreenH-280, WKScreenW, 280);
    }
    else
    {
        backView.frame = CGRectMake(0, WKScreenH-370, WKScreenW, 370);
    }
    backView.backgroundColor = [UIColor whiteColor];
    [backBtn addSubview:backView];
    
//    CGSize contentSize = [model.GoodsName sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(WKScreenW-100, MAXFLOAT)];
    UIView *contentView = [[UIView alloc] init];
    [backView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.top.equalTo(backView).offset(0);
        make.height.mas_offset(20+10+10+10+10+20+20);//20是文字的高度
    }];
    
    //关闭按钮
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.top.equalTo(contentView).offset(10);
        make.size.mas_offset(CGSizeMake(closeImage.size.width, closeImage.size.height));
    }];
    
    //商品名
    UILabel *shopName = [[UILabel alloc] init];
    shopName.numberOfLines = 0;
    shopName.lineBreakMode = NSLineBreakByTruncatingTail;
    shopName.text = model.GoodsName;
    shopName.textColor = [UIColor colorWithHex:0x8A8D9D];
    [contentView addSubview:shopName];
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(contentView).offset(10);
        make.right.equalTo(closeBtn.mas_left).offset(10);
        make.height.mas_offset(25);
    }];
    
    //商品价钱和库存
    UILabel *priceName = [[UILabel alloc] init];
    priceName.font = [UIFont systemFontOfSize:14];
    priceName.text = [NSString stringWithFormat:@"￥%.2f  库存%ld件",[((WKLiveShopListModelItem*)(model.GoodsModelList[0])).Price floatValue],(long)model.Stock];//model.Price;
    priceName.textColor = [UIColor colorWithHex:0x8A8D9D];
    self.priceName = priceName;
    [contentView addSubview:priceName];
    [priceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(shopName.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(250, 20));
    }];
    
    //总价
    UILabel *allMoney = [[UILabel alloc] init];
    allMoney.font = [UIFont systemFontOfSize:14];
    allMoney.textAlignment = NSTextAlignmentRight;
    allMoney.textColor = [UIColor colorWithHex:0xDF6E1D];
    CGFloat totalPrice = totalPrice = model.IsFreeShipping ? model.Price.floatValue : model.Price.floatValue + model.TranFee.floatValue;
    allMoney.text = [NSString stringWithFormat:@"总计：￥%.2f",totalPrice];
    self.allMoney = allMoney;
    [contentView addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.top.equalTo(shopName.mas_bottom).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(100, 20));
    }];
    
    //运费
    UILabel *tranFee = [[UILabel alloc] init];
    tranFee.textColor = [UIColor colorWithHex:0x8A8D9D];
    tranFee.textAlignment = NSTextAlignmentRight;
    tranFee.font = [UIFont systemFontOfSize:14];
//    if([model.Price isEqualToString:@""] || model.Price.integerValue < 0)
//    if([model.TranFee isEqualToString:@""] || model.TranFee.integerValue < 0 || [model.TranFee isEqualToString:@"0"])
    if(model.IsFreeShipping == YES)
    {
        tranFee.text = @"包邮";
    }
    else
    {
        tranFee.text = [NSString stringWithFormat:@"(含运费%.2f元)",[model.TranFee floatValue]];
    }
    self.tranFee = tranFee;
    [contentView addSubview:tranFee];
    [tranFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.top.equalTo(allMoney.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(150, 20));
    }];
    
    //商品型号
    UILabel *shopNumName = [[UILabel alloc] init];
    shopNumName.font = [UIFont systemFontOfSize:14];
    shopNumName.text = @"商品型号";
    shopNumName.textAlignment = NSTextAlignmentLeft;
    shopNumName.textColor = [UIColor colorWithHex:0x8A8D9D];
    shopNumName.hidden = NO;
    [contentView addSubview:shopNumName];
    [shopNumName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(priceName.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(100, 20));
    }];
    
    //判断如果没有型号，不显示商品型号
    if(model.GoodsModelList.count == 1)
    {
        WKLiveShopListModelItem *SM = model.GoodsModelList[0];
        if(SM.ModelName.length == 0)
        {
            shopNumName.hidden = YES;
        }
    }
    
    //横线
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [contentView addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(0);
        make.right.equalTo(contentView.mas_right).offset(0);
        make.top.equalTo(shopNumName.mas_bottom).offset(9);
        make.height.mas_offset(1);
    }];
    
    UIImage *weinxinImage = [UIImage imageNamed:@"weixin"];
    UIView *downView = [[UIView alloc] init];
    downView.layer.borderWidth = 1;
    downView.layer.borderColor = [[UIColor colorWithHex:0xDEDFE1] CGColor];
    downView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
        make.height.mas_offset(weinxinImage.size.height+20);
    }];
    
    //支付宝
    UIImage *zhifuImage = [UIImage imageNamed:@"zhifu"];
    UIButton *zhifuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifuBtn.tag = 2;
    [zhifuBtn setImage:zhifuImage forState:UIControlStateNormal];
    [zhifuBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:zhifuBtn];
    
    
    //微信支付
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.tag = 1;
    [weixinBtn setImage:weinxinImage forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:weixinBtn];
    
    
    // 余额
    UIImage *balanceImage = [UIImage imageNamed:@"remainImg"];
    UIButton *balanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [balanceBtn setImage:balanceImage forState:UIControlStateNormal];
    [balanceBtn setTitle:@"" forState:UIControlStateNormal];
    [balanceBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    balanceBtn.tag = 3;
    balanceBtn.layer.borderWidth = 1.0;
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    balanceBtn.layer.cornerRadius = 2.0;
    balanceBtn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
    [balanceBtn setImage:balanceImage forState:UIControlStateNormal];
    [balanceBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:balanceBtn];
    
    if (User.isReviewID) {
        
        [zhifuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(downView.mas_centerX).offset(-WKScreenW/4);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
        }];
        
        [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(downView.mas_centerX).offset(WKScreenW/4);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
        }];
        
    }else{
        
        [zhifuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(downView);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
        }];
        
        [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(zhifuBtn.mas_left).offset(-10);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
        }];
        
        [balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(zhifuBtn.mas_right).offset(10);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_offset(CGSizeMake(weinxinImage.size.width * 0.85, weinxinImage.size.height));
        }];
    }
    
    
    self.balanceBtn = balanceBtn;
    
    //中间部分
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.top.equalTo(contentView.mas_bottom).offset(0);
        make.bottom.equalTo(downView.mas_top).offset(0);
    }];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW,90) collectionViewLayout:tagLayout];
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [centerView addSubview:self.collectionView];
    
    if([((WKLiveShopListModelItem*)_model.GoodsModelList[0]).ModelName isEqualToString:@""])
    {
        self.collectionView.frame = CGRectMake(0, 0, WKScreenW, 0);
        xianView.hidden = YES;
    }
    else
    {
        self.collectionView.frame = CGRectMake(0, 0, WKScreenW, 90);
        xianView.hidden = NO;
    }
    
    [self.collectionView reloadData];

    UIView *centerXian = [[UIView alloc] init];
    centerXian.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [centerView addSubview:centerXian];
    [centerXian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(0);
        make.right.equalTo(centerView.mas_right).offset(0);
        make.top.equalTo(self.collectionView.mas_bottom).offset(0);
        make.height.mas_offset(1);
    }];
    
    
    //数量
    UILabel *number = [[UILabel alloc] init];
    number.font = [UIFont systemFontOfSize:14];
    number.text = @"数量";
    number.textColor = [UIColor colorWithHex:0x8A8D9D];
    [centerView addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(10);
        make.top.equalTo(centerXian.mas_bottom).offset(25);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];

    //滑动控件
    NumberSlider *slider = [[NumberSlider alloc] init];
    slider.minimumValue = 1;
    slider.maximumValue = 10;
    slider.minimumTrackTintColor = [UIColor colorWithHex:0xF16617];
    slider.maximumTrackTintColor = [UIColor colorWithHex:0x8086A0];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    [centerView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(number.mas_right).offset(20);
        make.centerY.equalTo(number.mas_centerY).offset(0);
        make.size.mas_offset(CGSizeMake(WKScreenW-40-30-40, 15));
    }];
    
    //滑动控件旁边的数字
    UILabel *sliderNum = [[UILabel alloc] init];
    sliderNum.font = [UIFont systemFontOfSize:14];
    sliderNum.textColor = [UIColor colorWithHex:0x8A8D9D];
    sliderNum.textAlignment = NSTextAlignmentCenter;
    sliderNum.text = @"1";
    self.sliderNum = sliderNum;
    [centerView addSubview:sliderNum];
    [sliderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider.mas_right).offset(10);
        make.right.equalTo(centerView.mas_right).offset(-10);
        make.centerY.equalTo(number.mas_centerY).offset(0);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
    sliderNum.hidden = YES;
    
    //线
    UIView *xianView1 = [[UIView alloc] init];
    xianView1.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [centerView addSubview:xianView1];
    [xianView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(0);
        make.right.equalTo(centerView.mas_right).offset(0);
        make.top.equalTo(slider.mas_bottom).offset(20);
        make.height.mas_offset(1);
    }];
    
    UIView *downCenterView = [[UIView alloc] init];
    downCenterView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *addressgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressEvent)];
    [downCenterView addGestureRecognizer:addressgesture];
    [centerView addSubview:downCenterView];
    [downCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(0);
        make.right.equalTo(centerView.mas_right).offset(0);
        make.top.equalTo(xianView1.mas_bottom).offset(0);
        make.bottom.equalTo(downView.mas_top).offset(0);
    }];
    
//    UILabel *messageCon = [[UILabel alloc] init];
//    messageCon.font = [UIFont systemFontOfSize:14];
//    messageCon.text = @"  您还没有添加地址,请添加地址";
//    messageCon.textAlignment = NSTextAlignmentLeft;
//    messageCon.textColor = [UIColor colorWithHex:0x8A8D9D];
//    self.messageCon = messageCon;
//    [downCenterView addSubview:messageCon];
//    [messageCon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(downCenterView).offset(0);
//        make.right.equalTo(downCenterView.mas_right).offset(0);
//        make.top.equalTo(downCenterView).offset(0);
//        make.bottom.equalTo(downCenterView.mas_bottom).offset(0);
//    }];
    
//    UIImage *goImage = [UIImage imageNamed:@"go"];
//    UIButton *goBtn = [[UIButton alloc] init];
//    [goBtn setImage:goImage forState:UIControlStateNormal];
//    [goBtn addTarget:self action:@selector(selectAddressEvent) forControlEvents:UIControlEventTouchUpInside];
//    [downCenterView addSubview:goBtn];
//    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(downCenterView.mas_right).offset(-10);
//        make.centerY.equalTo(downCenterView);
//        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
//    }];
//    goBtn.hidden = YES;
    
    //下面的是地址信息
//    NSString *addressStr = [NSString stringWithFormat:@"%@%@",addressItem.Contact,addressItem.Phone];
//    CGSize addressSize = [addressStr sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *addressName = [[UILabel alloc] init];
    addressName.font = [UIFont systemFontOfSize:14];
    addressName.text = @"请选择联系人";
    addressName.textAlignment = NSTextAlignmentLeft;
    
    addressName.textColor = [UIColor colorWithHex:0x8A8D9D];
    self.addressName = addressName;
    [downCenterView addSubview:addressName];
    [addressName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downCenterView).offset(10);
        make.top.equalTo(downCenterView).offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW - 100, 20));
    }];
        
    //默认地址文字
    UIButton *defaultBtn = [[UIButton alloc] init];
    [defaultBtn setTitle:@"默认" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    defaultBtn.backgroundColor = [UIColor colorWithHex:0xE9681D];
    self.defaultBtn = defaultBtn;
    [downCenterView addSubview:defaultBtn];
    [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressName.mas_right).offset(5);
        make.top.equalTo(downCenterView).offset(10);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
    
    self.defaultBtn.hidden = YES;
        
    //跳转地址
//    UIImage *goImage = [UIImage imageNamed:@"go"];
//    UIButton *goBtn = [[UIButton alloc] init];
//    [goBtn setImage:goImage forState:UIControlStateNormal];
//    [goBtn addTarget:self action:@selector(selectAddressEvent) forControlEvents:UIControlEventTouchUpInside];
//    [downCenterView addSubview:goBtn];
//    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(downCenterView.mas_right).offset(-10);
//        make.top.equalTo(addressName.mas_bottom).offset(0);
//        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
//    }];
    
    //详细地址
    UILabel *addressCon = [[UILabel alloc] init];
    addressCon.numberOfLines = 0;
    addressCon.font = [UIFont systemFontOfSize:14];
    addressCon.text = @"请选择地址详情";
//    addressCon.text = [NSString stringWithFormat:@"%@%@%@%@",addressItem.ProvinceName,addressItem.CityName,addressItem.CountyName,addressItem.Address];
    addressCon.textColor = [UIColor colorWithHex:0x8A8D9D];
    self.addressCon = addressCon;
    [downCenterView addSubview:addressCon];
    [addressCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downCenterView).offset(10);
        make.top.equalTo(addressName.mas_bottom).offset(5);
        make.size.mas_offset(CGSizeMake(300, 20));
    }];
    
//    if(!addressItem)
//    {
//        addressName.hidden = YES;
//        defaultBtn.hidden = YES;
//        addressCon.hidden = YES;
//    }
//    else
//    {
//        messageCon.hidden = YES;
//    }
//    
//    if(addressItem.IsDefault)
//    {
////        defaultBtn.hidden = YES;
//    }
//    else
//    {
//        defaultBtn.hidden = YES;
//    }
}

// 获取用户余额
- (void)getMemberIncome{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
//        NSLog(@"response : %@",response);
        
        NSString *balanceNum = [NSString stringWithFormat:@"%0.2f",[response.Data[@"MoneyCanTake"] floatValue]];
        
        [self.balanceBtn setTitle:balanceNum forState:UIControlStateNormal];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}


-(void)closeEvent
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

-(void)payEvent:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        _clickPayType(1);
    }
    else if(sender.tag == 2){
        
        _clickPayType(2);
        
    }else{
        _clickPayType(6);
    }
}

-(void)sliderEvent:(UISlider*)sender
{
    self.sliderNum.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    NSDictionary *userinfo = @{@"数量":self.sliderNum.text,@"余额":self.balanceBtn.titleLabel.text};
    
    [self xw_postNotificationWithName:@"数量" userInfo:userinfo];
}

//跳转地址
-(void)selectAddressEvent
{
    _clickPayType(3);
}

//点击后面的整个背景进行跳转
-(void)addressEvent
{
    _clickPayType(3);
}

@end
