//
//  WKCrowdProgressView.m
//  秀加加
//
//  Created by sks on 2017/2/23.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKCrowdProgressView.h"

@interface WKCrowdProgressView ()

@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *progressView;

@end

@implementation WKCrowdProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        UILabel *lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"进度0%";
        lab.font = [UIFont systemFontOfSize:13.0f];
        lab.textColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
        [self addSubview:lab];
        self.progressLabel = lab;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.layer.cornerRadius = 4;
        lineView.clipsToBounds = YES;
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        self.lineView = lineView;
        
        UIView *progressView = [UIView new];
        progressView.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
        progressView.layer.cornerRadius = 4.0;
        progressView.clipsToBounds = YES;
        
        [lineView addSubview:progressView];
        self.progressView = progressView;
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.right.mas_offset(-20);
            make.size.mas_offset(CGSizeMake(100, 20));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lab.mas_bottom).offset(10);
            make.left.and.right.mas_offset(0);
            make.height.mas_offset(8);
        }];
        
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.and.left.mas_offset(0);
            make.width.mas_equalTo(lineView.mas_width).multipliedBy(0);
//            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (void)setProgressValue:(CGFloat)value {
    self.progressLabel.text = [NSString stringWithFormat:@"进度%0.2f%@",value * 100,@"%"];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.lineView.mas_width).multipliedBy(value);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.lineView layoutIfNeeded];
    }];
}

@end
