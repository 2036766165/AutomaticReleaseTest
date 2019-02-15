//
//  WKImageItemView.m
//  wdbo
//
//  Created by sks on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKImageItemView.h"

@interface WKImageItemView ()
@property (nonatomic,strong) UIButton *btn;
@end

@implementation WKImageItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"pro_closed"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.btn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.right.mas_offset(0);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
    }
    return self;
}

- (void)setHiddenClose:(BOOL)hiddenClose{
    self.btn.hidden = hiddenClose;
}

- (void)deleteImage:(UIButton *)btn{
    
    if ([_delegate respondsToSelector:@selector(deleteImageWith:)]) {
        [_delegate deleteImageWith:self];
    }
}
@end
