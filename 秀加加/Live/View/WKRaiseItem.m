//
//  WKRaiseItem.m
//  秀加加
//
//  Created by sks on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKRaiseItem.h"

@interface WKRaiseItem ()

@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIImageView *bottomImageView;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,assign) WKGoodsLayoutType screenType;

@end

@implementation WKRaiseItem

- (instancetype)initWithFrame:(CGRect)frame price:(NSString *)price screenType:(WKGoodsLayoutType)screenType{
    if (self = [super init]) {
        
        UIImageView *topView = [[UIImageView alloc] init];
        topView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height * 2/3);
        
        NSString *imageName;
        if (screenType == WKGoodsLayoutTypeVertical) {
            imageName = @"verAuction_normal_top";
        }else{
            imageName = @"verAuction_normal_top";
        }
        topView.image = [UIImage imageNamed:imageName];
        [self addSubview:topView];
        
        UIImageView *bottomView = [[UIImageView alloc] init];
        bottomView.frame = CGRectMake(0, frame.size.height * 2/3, frame.size.width, frame.size.height /3);
        NSString *imageNameBottom;
        if (screenType == WKGoodsLayoutTypeVertical) {
            imageNameBottom = @"verAuction_normal_bottom";
        }else{
            imageNameBottom = @"horAuction_normal_bottom";
        }
        bottomView.image = [UIImage imageNamed:imageNameBottom];
        [self addSubview:bottomView];
        
        
        self.topImageView = topView;
        self.bottomImageView = bottomView;
        
        UILabel *lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [NSString stringWithFormat:@"+￥%@",price];
        lab.font = [UIFont systemFontOfSize:13.0f];
        lab.textColor = [UIColor colorWithHexString:@"#FC6620"];
        [topView addSubview:lab];
        
        lab.frame = topView.bounds;
        
        self.price = price;
        self.priceLabel = lab;

        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
        
        self.screenType = screenType;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selected"]) {
        NSNumber *boolKey = change[NSKeyValueChangeNewKey];
        if (boolKey.integerValue == 1) {
            NSString *imageName;
            if (self.screenType == WKGoodsLayoutTypeVertical) {
                imageName = @"verAuction_bid_top";
            }else{
                imageName = @"horAuction_bid_top";
            }
            
            self.topImageView.image = [UIImage imageNamed:imageName];
            
            NSString *imageNameBottom;
            if (self.screenType == WKGoodsLayoutTypeVertical) {
                imageNameBottom = @"verAuction_bid_bottom";
            }else{
                imageNameBottom = @"horAuction_bid_bottom";
            }
            self.bottomImageView.image = [UIImage imageNamed:imageNameBottom];
            
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);

        }else{
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            
            NSString *imageName;
            if (self.screenType == WKGoodsLayoutTypeVertical) {
                imageName = @"verAuction_normal_top";
            }else{
                imageName = @"verAuction_normal_top";
            }
            
            NSString *imageNameBottom;
            if (self.screenType == WKGoodsLayoutTypeVertical) {
                imageNameBottom = @"verAuction_normal_bottom";
            }else{
                imageNameBottom = @"horAuction_normal_bottom";
            }
            
            self.topImageView.image = [UIImage imageNamed:imageName];
            self.bottomImageView.image = [UIImage imageNamed:imageNameBottom];
        }
    }
}

- (void)setFontWith:(CGFloat)font{
    self.priceLabel.font = [UIFont systemFontOfSize:font];
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text = [NSString stringWithFormat:@"+￥%@",price];
}
//
//- (void)layoutSubviews{
//    
//    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.right.mas_offset(0);
////                    make.height.mas_equalTo(60*2/3);
//        make.height.mas_equalTo(self.mas_height).multipliedBy(2/3);
//        
//    }];
//    
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    
//    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_offset(0);
//        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(0);
////                    make.height.mas_equalTo(60*1/3);
//        make.height.mas_equalTo(self.mas_height).multipliedBy(1/3);
//        
//    }];
//    
//}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"selected"];
}

@end
