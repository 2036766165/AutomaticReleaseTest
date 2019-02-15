//
//  WKScrollLabel.m
//  秀加加
//
//  Created by sks on 2017/3/8.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKScrollLabel.h"

@interface WKScrollLabel (){
    CGFloat _superWidth;
}

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,assign) CGFloat textWidth;

@end

@implementation WKScrollLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithSuperViewWidth:(CGFloat)width{
    if (self = [super init]) {
        _superWidth = width;
        [self commonInit];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    UILabel *lab = [UILabel new];
//    lab.backgroundColor = [UIColor redColor];
    lab.font = [UIFont systemFontOfSize:14.0f];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [self addSubview:lab];
    
    self.textLabel = lab;
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_offset(0);
    }];
}

- (void)setText:(NSString *)text{
    self.textLabel.text = text;
    CGFloat width = [NSString sizeWithText:text font:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(10000, 25)].width;
    self.textWidth = width + 10;
    
    if (_superWidth < self.textWidth) {
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(self.textWidth);
        }];
        [self layoutIfNeeded];
        
        [self scrollAnimation];
    }else{
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(_superWidth);
        }];
        [self layoutIfNeeded];
    }
}

- (void)setIsScrollAble:(BOOL)isScrollAble{
//    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(-self.textWidth);
//    }];

    
}

- (void)scrollAnimation{
    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(-self.textWidth);
//        make.left.mas_offset(-self.textWidth);
    }];
    
    [UIView animateWithDuration:3.0 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.textWidth);
        }];
        [self layoutIfNeeded];

        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
        }];
        
        [UIView animateWithDuration:1.5 animations:^{
            [self layoutIfNeeded];

        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollAnimation];

//                if (_isScrollAble) {
//                }
            });
        }];
        
    }];
}

@end
