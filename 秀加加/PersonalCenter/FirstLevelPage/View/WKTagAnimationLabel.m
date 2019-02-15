//
//  WKAnimationLabel.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKTagAnimationLabel.h"

@implementation WKTagAnimationLabel

-(instancetype)initWithString:(NSString *)tagString andTextColor:(NSString *)textColor{
    if (self = [super init]) {
        self.frame = CGRectMake(WKScreenW*0.5, WKScreenW*0.3, 0, 0);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = WKScreenW*0.03;
        self.layer.masksToBounds = YES;
        self.alpha = 0.7;
        self.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.03];
        self.backgroundColor = [UIColor whiteColor];
//        self.textAlignment = NSTextAlignmentCenter;
        [self setTitle:tagString forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:textColor] forState:UIControlStateNormal];
    }
    return self;
}
//开始动画
-(void)startAnimation:(CGPoint)startPoint centerPoint:(CGPoint)centerPoint endPoint:(CGPoint)endPoint{
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(startPoint.x, startPoint.y, WKScreenW*0.27, WKScreenW*0.06);
    }completion:^(BOOL finished) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.duration = 2.0f;
        NSValue *value0 = [NSValue valueWithCGPoint:[self formattingPoing: startPoint]];
        NSValue *value1 = [NSValue valueWithCGPoint:[self formattingPoing: centerPoint]];
        NSValue *value2 = [NSValue valueWithCGPoint:[self formattingPoing: endPoint]];
        NSValue *value3 = [NSValue valueWithCGPoint:[self formattingPoing: centerPoint]];
        NSValue *value4 = [NSValue valueWithCGPoint:[self formattingPoing: startPoint]];
        animation.values = @[value0,value1,value2,value3,value4];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = MAXFLOAT;
        [self.layer addAnimation:animation forKey:nil];
    }];
}
//加上控件宽高的一半才是正确位置
-(CGPoint)formattingPoing:(CGPoint)point{
    point.x = point.x + WKScreenW*0.27/2;
    point.y = point.y + WKScreenW*0.06/2;
    return point;
}

@end
