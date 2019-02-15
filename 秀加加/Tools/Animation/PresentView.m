//
//  PresentView.m
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "PresentView.h"
#import "WKRaiseItem.h"
#import "NSObject+XWAdd.h"

@interface PresentView ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount);
@end

@implementation PresentView

// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self shakeNumberLabel];

        [UIView animateWithDuration:0.3 animations:^{
            
            if (_model.virtualType == WKVirtualTypeAuction) {
                _giftImageView.frame = CGRectMake(self.frame.size.width-30, -(60 * 1.31 - 40)/2, 55, 55 * 1.31);
            }else{
                _giftImageView.frame = CGRectMake(self.frame.size.width-30, -15, 60, 60);
            }
        }];
    }];
    
    self.completeBlock = completed;
}

- (void)shakeNumberLabel{

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
    
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:(4.7 + self.model.giftCount * 0.3)];
    
    self.skLabel.text = [NSString stringWithFormat:@"X %ld",(long)1];
    [self.skLabel startAnimWithDuration:0.3 totalCount:self.model.giftCount currentCount:1];
}

- (void)hidePresendView
{
    [UIView animateWithDuration:0.30 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,_animCount);
        }
        [self reset];
        _finished = finished;
        [self removeFromSuperview];
    }];
}

// 重置
- (void)reset {
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.skLabel.text = @"";
}

- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [self setUI];
    }
    return self;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
//    _headImageView.layer.borderWidth = 1;
//    _headImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height / 2;
    _headImageView.layer.masksToBounds = YES;
    _nameLabel.frame = CGRectMake(_headImageView.frame.size.width + 5, 5, _headImageView.frame.size.width * 3, 10);
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_headImageView.frame) - 10 - 5, _nameLabel.frame.size.width*2, 10);
    
    _bgImageView.frame = self.bounds;
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    
    _skLabel.frame = CGRectMake(CGRectGetMaxX(self.frame) + 5,-20, 70, 30);
    _clickBtn.frame = self.bounds;
}

#pragma mark 初始化 UI
- (void)setUI {
    
    //背景图
    _bgImageView = [[UIImageView alloc] init];
//    _bgImageView.userInteractionEnabled = YES;
    
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.2;
    _headImageView = [[UIImageView alloc] init];
//    _headImageView.userInteractionEnabled = YES;
    
    _giftImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _giftLabel = [[UILabel alloc] init];
    _nameLabel.textColor  = [UIColor whiteColor];
    _nameLabel.userInteractionEnabled = NO;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _giftLabel.textColor  = [UIColor colorWithHexString:@"#FC6620"];
    _giftLabel.font = [UIFont systemFontOfSize:13];
    _giftLabel.userInteractionEnabled = NO;
    _skLabel =  [[ShakeLabel alloc] init];
    _skLabel.font = [UIFont boldSystemFontOfSize:20];
    _skLabel.borderColor = [UIColor whiteColor];
    _skLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
    _skLabel.textAlignment = NSTextAlignmentCenter;
    _skLabel.userInteractionEnabled = NO;
    _animCount = 0;
    _clickBtn = [[UIButton alloc]init];
    _clickBtn.backgroundColor = [UIColor clearColor];
    [_clickBtn addTarget:self action:@selector(tapImageV:) forControlEvents:UIControlEventTouchUpInside];
    
    // 1.31 为举牌的图片比例
    if (_model.virtualType == WKVirtualTypeAuction) {
        _giftImageView.frame = CGRectMake(-80, -(60 * 1.31 - 40)/2, 55, 55 * 1.31);
    }else{
        _giftImageView.frame = CGRectMake(-80, -15, 60, 60);
    }

    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_skLabel];
    [self addSubview:_clickBtn];
}

- (void)setModel:(GiftModel *)model {
    _model = model;
    _headImageView.image = model.headImage;
    
    if (model.virtualType == WKVirtualTypeAuction) {
        NSArray *msg = [model.giftName componentsSeparatedByString:@" "];
        
        WKRaiseItem *raiseItem = [[WKRaiseItem alloc] initWithFrame:_giftImageView.bounds price:msg[1] screenType:WKGoodsLayoutTypeVertical];
        [_giftImageView addSubview:raiseItem];
        
        [_skLabel removeFromSuperview];
        
        _giftLabel.text = [NSString stringWithFormat:@"    %@    ",msg[0]];
        
    }else{
        
        _giftImageView.image = model.giftImage;
        _giftLabel.text = [NSString stringWithFormat:@"打赏  %@",model.giftName];
    }
    
    _nameLabel.text = model.name;
    _giftCount = model.giftCount;
}

- (void)tapImageV:(UIButton *)tap{
    // 点击头像
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"TAPICON" object:@{@"BPOID":_model.BPOID}];
    NSNumber *type;
    if (User.showStatus == WKShowStatusShowing) {
        type = @1;
    }else{
        type = @0;
    }
    
    [self xw_postNotificationWithName:@"TAPICON" userInfo:@{@"BPOID":_model.BPOID,@"TYPE":type}];
}

@end
