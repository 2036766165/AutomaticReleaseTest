//
//  BulletView.m
//  CommentDemo
//
//  Created by feng jia on 16/2/20.
//  Copyright © 2016年 caishi. All rights reserved.
//

#import "WKBulletView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define mDuration  15

@interface WKBulletView ()

@property (strong, nonatomic) UIImageView * headIM;
@property (strong, nonatomic) UIImageView * levelIM;
@property (strong, nonatomic) UILabel * contentLabel;
@property BOOL bDealloc;
@property (assign, nonatomic) CGFloat width;

@end

@implementation WKBulletView

- (void)dealloc {
    [self stopAnimation];
    self.moveBlock = nil;
}

- (instancetype)initWithContent:(WKBarrageModel *)model {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        if (SCREENWIDTH>SCREENHEIGHT) {
            self.width = SCREENHEIGHT;
        }else{
            self.width = SCREENWIDTH;
        }
        self.backgroundColor = [UIColor clearColor];
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:self.width*0.04]
                                     };
        float nameWidth = [model.nameStr sizeWithAttributes:attributes].width;
        float width = [model.content sizeWithAttributes:attributes].width;
        self.bounds = CGRectMake(0, 0, (width>nameWidth?width:nameWidth) + self.width*0.1+self.width*0.043 , self.width*0.1);
        [self createUIWithModel:model];

    }
    return self;
}

-(void)createUIWithModel:(WKBarrageModel*)model{
    
    self.BPOID = model.BPOID;
    
    self.headIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
    self.headIM.backgroundColor = [UIColor whiteColor];
    self.headIM.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.headIM.layer.masksToBounds = YES;
    [self.headIM sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:[UIImage imageNamed:@"default_03"]];
    [self addSubview:self.headIM];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:self.width*0.04]
                                 };
    float nameWidth = [model.nameStr sizeWithAttributes:attributes].width;
    float width = [model.content sizeWithAttributes:attributes].width;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetHeight(self.frame)+self.width*0.01, CGRectGetHeight(self.frame)*0.05, nameWidth,  CGRectGetHeight(self.frame)*0.43)];
    self.nameLabel.font = [UIFont systemFontOfSize:self.width*0.04];
    self.nameLabel.text = model.nameStr;
    self.nameLabel.textColor = [UIColor orangeColor];
    [self addSubview:self.nameLabel];
    
    self.levelIM = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.nameLabel.frame)+self.nameLabel.frame.origin.x+self.width*0.01, CGRectGetHeight(self.frame)*0.05, CGRectGetHeight(self.frame)*0.43, CGRectGetHeight(self.frame)*0.43)];
    self.levelIM.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%ld",(long)model.level>10?10:model.level]];
    [self addSubview:self.levelIM];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetHeight(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5,self.width*0.01+CGRectGetHeight(self.frame)*0.5, CGRectGetHeight(self.frame)*0.45)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
    [self sendSubviewToBack:view];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetHeight(self.frame)+self.width*0.01, CGRectGetHeight(self.frame)*0.5, width+self.width*0.02, CGRectGetHeight(self.frame)*0.45)];
    self.contentLabel.font = [UIFont systemFontOfSize:self.width*0.04];
    self.contentLabel.text = model.content;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(CGRectGetHeight(self.frame)*0.45*0.5,CGRectGetHeight(self.frame)*0.45*0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.layer.mask = maskLayer;
    [self addSubview:self.contentLabel];
    if ([model.nameStr isEqualToString:@"系统消息"] && !model.BPOID) {
        self.contentLabel.textColor = [UIColor orangeColor];
        self.headIM.image = [UIImage imageNamed:@"systemIcon"];
        self.levelIM.hidden = YES;
    }
}

- (void)startAnimation {
    
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat wholeWidth = CGRectGetWidth(self.frame) + SCREENWIDTH + 50;
    CGFloat speed = wholeWidth/mDuration;
    CGFloat dur = (CGRectGetWidth(self.frame) + 50)/speed;
    
    __block CGRect frame = self.frame;
    if (self.moveBlock) {
        //弹幕开始进入屏幕
        self.moveBlock(Start);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dur * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //避免重复，通过变量判断是否已经释放了资源，释放后，不在进行操作
        if (self.bDealloc) {
            return;
        }
        //dur时间后弹幕完全进入屏幕
        if (self.moveBlock) {
            self.moveBlock(Enter);
        }
    });
    
    CGFloat animationTime;
    if ([self.contentLabel.textColor isEqual:[UIColor orangeColor]]) {
        animationTime = (CGRectGetWidth(self.frame)+self.width)/50;
    }else{
        animationTime = mDuration;
    }
    
    //弹幕完全离开屏幕
    [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveBlock) {
            self.moveBlock(End);
        }
        [self removeFromSuperview];
    }];
}


- (void)stopAnimation {
    self.bDealloc = YES;
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
