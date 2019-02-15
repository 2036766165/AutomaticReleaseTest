//
//  WKAuctionPriceView.m
//  秀加加
//
//  Created by sks on 2016/10/21.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionPriceView.h"

@interface WKAuctionPriceView ()
@property (nonatomic,strong) UILabel *priceLabel;
@end

@implementation WKAuctionPriceView

- (instancetype)initWithFrame:(CGRect)frame screenType:(WKGoodsLayoutType)layoutType{
    if (self = [super initWithFrame:frame]) {
        
        NSString *bgImage;
        if (layoutType == WKGoodsLayoutTypeVertical) {
            bgImage = @"pricekuang";
        }else{
            bgImage = @"henghuang";
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgImage]];
        [self addSubview:imageView];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:priceLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.priceLabel = priceLabel;
        
    }
    return self;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
