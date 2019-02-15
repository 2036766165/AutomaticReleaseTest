//
//  WKLiveShopView.m
//  秀加加
//
//  Created by lin on 2016/10/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopView.h"
#import "WKLiveShopTableViewCell.h"
#import "WKLiveShopModel.h"
#import "NSObject+XWAdd.h"

@interface WKLiveShopView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *backGroundView;

@property (nonatomic,strong) UIScrollView *shopScrollView;

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) WKLiveShopModel *model;

@end

@implementation WKLiveShopView

- (instancetype)initWithFrame:(CGRect)frame memberNo:(NSString *)memberNo
{
    if (self = [super initWithFrame:frame])
    {
        self.array = [NSArray array];
        [self loadData:memberNo];
    }
    return self;
}

-(void)initUi
{
    self.backGroundView = [[UIView alloc] init];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(270);
    }];
    
//    NSLog(@"%lu",(unsigned long)self.array.count);
    
    self.shopScrollView = [[UIScrollView alloc] init];
    self.shopScrollView.contentSize = CGSizeMake(WKScreenW*ceilf(self.array.count/2), 270);
    self.shopScrollView.showsHorizontalScrollIndicator = false;
    self.shopScrollView.scrollsToTop = false;
    self.shopScrollView.bounces = false;
    self.shopScrollView.contentOffset = CGPointZero;
    self.shopScrollView.delegate = self;
    self.shopScrollView.backgroundColor = [UIColor colorWithHex:0xEAF1F5];
    [self.backGroundView addSubview:self.shopScrollView];
    [self.shopScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    UIImage *contentImage = [UIImage imageNamed:@"shop"];
    for (int i = 0; i < self.array.count; i++) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((10+(WKScreenW-30)/2*i+10*i), 10, (WKScreenW-30)/2, 250)];
        contentView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentEvent)];
        [contentView addGestureRecognizer:gesture];
        
        //添加图片
        UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (WKScreenW-30)/2, (WKScreenW-30)/2)];
        [contentView addSubview:contentImageView];
        WKLiveShopItemModel *item = self.array[i];
        [contentImageView sd_setImageWithURL:[NSURL URLWithString:item.PicUrl] placeholderImage:contentImage];
        
        //内容
        UILabel *contentlabel = [[UILabel alloc] init];
        contentlabel.text = item.GoodsName;
        contentlabel.font = [UIFont systemFontOfSize:14];
        contentlabel.textColor = [UIColor colorWithHex:0x919398];
        contentlabel.numberOfLines = 0;
        contentlabel.lineBreakMode = NSLineBreakByWordWrapping;
        [contentView addSubview:contentlabel];
        [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.top.equalTo(contentImageView.mas_bottom).offset(10);
            make.height.mas_lessThanOrEqualTo(60);
        }];
        
        //价钱
        UILabel *money = [[UILabel alloc] init];
        money.textColor = [UIColor colorWithHex:0xFA6606];
        money.text = [NSString stringWithFormat:@"￥%.2f",[item.Price floatValue]];
        money.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:money];
        [money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.bottom.equalTo(contentView.mas_bottom).offset(-10);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(40, 20));
        }];
        
        //详情
        UIButton *detailBtn = [[UIButton alloc] init];
        detailBtn.backgroundColor = [UIColor colorWithHex:0xFA6606];
        [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.bottom.equalTo(contentView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        [self.shopScrollView addSubview:contentView];
    }
}

-(void)loadData:(NSString *)memberNo
{
    NSDictionary *param = @{@"ShopOwnerNo":memberNo,
                            @"IsAuction":@(false),
                            @"PageIndex":@(1),
                            @"PageSize":@(15)};
    
    [WKHttpRequest getLiveGoodsList:HttpRequestMethodPost url:WKLiveGoodsList model:@"WKLiveShopModel" param:param success:^(WKBaseResponse *response) {
        
        self.model = response.Data;
        
        self.array = self.model.InnerList;
        
        [self initUi];
        
    } failure:^(WKBaseResponse *response) {
        
         [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)contentEvent
{
    NSDictionary *dict = @{@"shopModel":self.model};
    [self xw_postNotificationWithName:@"liveShop" userInfo:dict];
}

@end
