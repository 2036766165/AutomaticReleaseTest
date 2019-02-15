//
//  ShakeLabel.m
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "ShakeLabel.h"

@implementation ShakeLabel

- (void)startAnimWithDuration:(NSTimeInterval)duration totalCount:(NSInteger)totalCount currentCount:(NSInteger)currentCount{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (currentCount > totalCount) {
            return;
        }
        
        __block NSInteger current = currentCount;
        
        [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
                self.transform = CGAffineTransformMakeScale(4, 4);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
                self.transform = CGAffineTransformMakeScale(0.8, 0.8);
            }];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                current++;
                
                [self startAnimWithDuration:duration totalCount:totalCount currentCount:current];
                
                if (current <= totalCount) {
                    
                    self.text = [NSString stringWithFormat:@"X %ld",current];
                    
                }
            }];
        }];
    });
}


//  重写 drawTextInRect 文字描边效果
- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1.5);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = _borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

@end
