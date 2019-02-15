//
//  WKShareItem.m
//  wdbo
//
//  Created by sks on 16/7/7.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKShareItem.h"

@interface WKShareItem (){
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end
@implementation WKShareItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 图片
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.mas_offset(0);
            make.top.mas_offset(0);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.height.mas_offset(50 * WKScaleW);
        }];
        
        _imageView = image;
        
        // 文字
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor darkGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(image.mas_bottom).offset(0);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        
        _titleLabel = lab;

    }
    
    return self;
}

- (void)setItemName:(NSString *)itemName{
    if (itemName) {
        _titleLabel.text = itemName;
    }
}

- (void)setItemImage:(NSString *)itemImage{
    if (itemImage) {
        _imageView.image = [UIImage imageNamed:itemImage];
    }
}

@end
