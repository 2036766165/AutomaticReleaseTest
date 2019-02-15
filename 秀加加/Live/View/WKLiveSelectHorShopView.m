//
//  WKLiveSelectHorShopView.m
//  秀加加
//
//  Created by lin on 2016/10/25.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveSelectHorShopView.h"
#import "NSString+Size.h"
#import "FJTagCollectionLayout.h"
#import "CollectionViewCell.h"
#import "NSObject+XWAdd.h"

@interface WKLiveSelectHorShopView()<FJTagCollectionLayoutDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *fakeDataArray;
@property (nonatomic,strong) UIView *currentView;
@property (nonatomic,strong) WKLiveShopListModel *model;

@end

@implementation WKLiveSelectHorShopView

- (instancetype)initWithFrame:(CGRect)frame
                        model:(WKLiveShopListModel*)model;
{
    _model = model;
    if (self = [super initWithFrame:frame])
    {
        
        NSMutableArray *array = [NSMutableArray array];
        if(model.GoodsModelList.count > 0)
        {
            for(int i = 0; i < model.GoodsModelList.count;i++)
            {
                WKLiveShopListModelItem *item = model.GoodsModelList[i];
                if(item.ModelName != nil)
                {
                    [array addObject:item.ModelName];
                }
            }
            self.fakeDataArray = array;
            
            [self initUi:model];
        }
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

-(void)initUi:(WKLiveShopListModel*)model
{
    FJTagCollectionLayout *tagLayout = [[FJTagCollectionLayout alloc] init];
    tagLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    tagLayout.lineSpacing = 10;
    tagLayout.itemSpacing = 10;
    tagLayout.itemHeigh = 30;
    tagLayout.delegate = self;
    
    
    CGSize contentSize = [model.GoodsName sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(WKScreenW-195*WKScaleW, MAXFLOAT)];
    
    UIView *upView = [[UIView alloc] init];
    UITapGestureRecognizer *closeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeEventGesture)];
    [upView addGestureRecognizer:closeGesture];
    [self addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upView.mas_right).offset(-10);
        make.top.equalTo(upView).offset((50-closeImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(closeImage.size.width, closeImage.size.height));
    }];
    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHex:0xE3E3E7];
    [self addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(upView.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *shopName = [[UILabel alloc] init];
    shopName.numberOfLines = 0;
    shopName.lineBreakMode = NSLineBreakByWordWrapping;
    shopName.text = model.GoodsName;
    shopName.textColor = [UIColor colorWithHex:0x8A8D9D];
    [self addSubview:shopName];
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(xianView.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(contentSize.height);
    }];
    
    
    //商品价钱和库存
    UILabel *priceName = [[UILabel alloc] init];
    priceName.font = [UIFont systemFontOfSize:14];
//    priceName.text = [NSString stringWithFormat:@"￥%.2f  库存%ld件",[model.Price floatValue],(long)model.Stock];
    priceName.text = [NSString stringWithFormat:@"￥%.2f  库存%ld件",[((WKLiveShopListModelItem*)(model.GoodsModelList[0])).Price floatValue],(long)model.Stock];
    priceName.textColor = [UIColor colorWithHex:0x8A8D9D];
    self.priceName = priceName;
    [self addSubview:priceName];
    [priceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(shopName.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(250, 20));
    }];
    
    //总价
    UILabel *allMoney = [[UILabel alloc] init];
    allMoney.font = [UIFont systemFontOfSize:14];
    allMoney.textAlignment = NSTextAlignmentRight;
    allMoney.textColor = [UIColor colorWithHex:0xDF6E1D];
    allMoney.text = [NSString stringWithFormat:@"￥%.2f",[model.Price floatValue]];
    self.allMoney = allMoney;
    [self addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(shopName.mas_bottom).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(100, 20));
    }];
    allMoney.hidden = YES;
    
    //运费
    UILabel *tranFee = [[UILabel alloc] init];
    tranFee.font = [UIFont systemFontOfSize:14];
    
    if([model.TranFee isEqualToString:@""] || model.TranFee.integerValue < 0 || [model.TranFee isEqualToString:@"0"])
    {
        tranFee.text = @"包邮";
    }
    else
    {
        tranFee.text = [NSString stringWithFormat:@"(含运费%.2f元)",[((WKLiveShopListModelItem*)(model.GoodsModelList[0])).Price floatValue]+[model.TranFee floatValue]];
    }
    tranFee.textAlignment = NSTextAlignmentRight;
    tranFee.textColor = [UIColor colorWithHex:0x8A8D9D];
    [self addSubview:tranFee];
    [tranFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(allMoney.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    tranFee.hidden = YES;
    
    //商品型号
    UILabel *shopNumName = [[UILabel alloc] init];
    shopNumName.font = [UIFont systemFontOfSize:14];
    shopNumName.text = @"商品型号";
    shopNumName.textAlignment = NSTextAlignmentLeft;
    shopNumName.textColor = [UIColor colorWithHex:0x8A8D9D];
    [self addSubview:shopNumName];
    [shopNumName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(priceName.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    //横线
    UIView *xianView1 = [[UIView alloc] init];
    xianView1.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [self addSubview:xianView1];
    [xianView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(shopNumName.mas_bottom).offset(5);
        make.height.mas_equalTo(1);
    }];
    
    //绑定商品型号
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW-195*WKScaleW,90) collectionViewLayout:tagLayout];
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self addSubview:self.collectionView];

    //判断是否存在商品型号
    if([((WKLiveShopListModelItem*)_model.GoodsModelList[0]).ModelName isEqualToString:@""])
    {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(xianView1.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        xianView1.hidden = YES;
        shopNumName.hidden = YES;
    }
    else
    {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(xianView1.mas_bottom).offset(0);
            make.height.mas_equalTo(90);

        }];
        xianView1.hidden = NO;
        shopNumName.hidden = NO;
    }
    [self.collectionView reloadData];
    
    UIView *xianView2 = [[UIView alloc] init];
    xianView2.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [self addSubview:xianView2];
    [xianView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.collectionView.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    //数量
    UILabel *number = [[UILabel alloc] init];
    number.font = [UIFont systemFontOfSize:14];
    number.text = @"数量";
    number.textColor = [UIColor colorWithHex:0x8A8D9D];
    [self addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(xianView2.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    //滑动控件
    NumberSlider *slider = [[NumberSlider alloc] init];
    slider.type = 1;
    slider.minimumValue = 1;
    slider.maximumValue = 10;
    slider.minimumTrackTintColor = [UIColor colorWithHex:0xF16617];
    slider.maximumTrackTintColor = [UIColor colorWithHex:0x8086A0];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    [self addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(number.mas_right).offset(10);
        make.top.equalTo(xianView2.mas_bottom).offset(23);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-195*WKScaleW-40-30-40, 20));
    }];
    
    
    //滑动控件旁边的数字
    UILabel *sliderNum = [[UILabel alloc] init];
    sliderNum.font = [UIFont systemFontOfSize:14];
    sliderNum.textColor = [UIColor colorWithHex:0x8A8D9D];
    sliderNum.textAlignment = NSTextAlignmentCenter;
    sliderNum.text = @"1";
    self.sliderNum = sliderNum;
    [self addSubview:sliderNum];
    [sliderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(number.mas_centerY).offset(0);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
    sliderNum.hidden = YES;
    
    UIView *xianView3 = [[UIView alloc] init];
    xianView3.backgroundColor = [UIColor colorWithHex:0xE0DFE3];
    [self addSubview:xianView3];
    [xianView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(sliderNum.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    
    UIView *downCenterView = [[UIView alloc] init];
    downCenterView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *addressgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressEvent)];
    [downCenterView addGestureRecognizer:addressgesture];
    [self addSubview:downCenterView];
    [downCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(xianView3.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    
//    NSString *addressStr = [NSString stringWithFormat:@"%@%@",addressItem.Contact,addressItem.Phone];
//    CGSize addressSize = [addressStr sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *addressName = [[UILabel alloc] init];
    addressName.font = [UIFont systemFontOfSize:14];
    addressName.text = @"请选择联系人";//@"三驴子  13456709888";
    addressName.textAlignment = NSTextAlignmentLeft;
    addressName.textColor = [UIColor colorWithHex:0x8A8D9D];
//    self.addressName = addressName;
    [downCenterView addSubview:addressName];
    [addressName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downCenterView).offset(10);
        make.top.equalTo(downCenterView).offset(5);
        make.right.mas_equalTo(downCenterView.mas_right).offset(-80);
//        make.size.mas_equalTo(CGSizeMake(addressSize.width+10, 20));
    }];
    
    //默认地址文字
    UIButton *defaultBtn = [[UIButton alloc] init];
    [defaultBtn setTitle:@"默认" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    defaultBtn.hidden = YES;
    defaultBtn.backgroundColor = [UIColor colorWithHex:0xFC6621];
//    self.defaultBtn = defaultBtn;
    [downCenterView addSubview:defaultBtn];
    [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressName.mas_right).offset(10);
        make.top.equalTo(downCenterView).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    //详细地址
    UILabel *addressCon = [[UILabel alloc] init];
    addressCon.numberOfLines = 0;
    addressCon.font = [UIFont systemFontOfSize:14];
    addressCon.text = @"请选择详细地址";
//    addressCon.text = [NSString stringWithFormat:@"%@%@%@%@",addressItem.ProvinceName,addressItem.CityName,addressItem.CountyName,addressItem.Address];
    addressCon.textColor = [UIColor colorWithHex:0x8A8D9D];
//    self.addressCon = addressCon;
    [downCenterView addSubview:addressCon];
    [addressCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downCenterView).offset(10);
        make.top.equalTo(addressName.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    
    UIImage *goImage = [UIImage imageNamed:@"go"];
    UIButton *goBtn = [[UIButton alloc] init];
    [goBtn setImage:goImage forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(selectAddressEvent) forControlEvents:UIControlEventTouchUpInside];
    [downCenterView addSubview:goBtn];
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downCenterView.mas_right).offset(-10);
        make.centerY.equalTo(downCenterView);
        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
    }];
    
    [self xw_addObserverBlockForKeyPath:@"addressItem" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        WKAddressListItem *addressItem = newVal;
        addressName.text = [NSString stringWithFormat:@"%@%@",addressItem.Contact,addressItem.Phone];
        addressCon.text = [NSString stringWithFormat:@"%@%@%@%@",addressItem.ProvinceName,addressItem.CityName,addressItem.CountyName,addressItem.Address];
        defaultBtn.hidden = !addressItem.IsDefault;
    }];
    
    UITapGestureRecognizer *handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddressEvent)];
    [downCenterView addGestureRecognizer:handleTap];
    

}

-(void)closeEvent
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(WKScreenW, 0,WKScreenW, WKScreenH);
        _clickPayType(2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)closeEventGesture
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(WKScreenW, 0,WKScreenW, WKScreenH);
        _clickPayType(2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)sliderEvent:(UISlider*)sender
{
    self.sliderNum.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    NSDictionary *userinfo = @{@"数量横屏":self.sliderNum.text};
    [self xw_postNotificationWithName:@"数量横屏" userInfo:userinfo];
}

-(void)addressEvent
{
    _clickPayType(1);
}

-(void)selectAddressEvent
{
    _clickPayType(1);
}

@end
