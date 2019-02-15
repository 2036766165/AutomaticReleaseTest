//
//  倒计时扇形.m
//  测试
//
//  Created by Chang_Mac on 16/9/26.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import "WKCircleView.h"

@implementation WKCircleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createMainUI];
    }
    return self;
}

-(void)createMainUI{
    self.backgroundColor = [UIColor clearColor];
    self.angle = 0.00001;
    self.onAuction = [[WKLabel alloc]initWithFrame:CGRectMake(0, 23, 82, 17)];
    self.onAuction.text = @"拍卖中";
    self.onAuction.font = [UIFont systemFontOfSize:16];
    self.onAuction.textAlignment = NSTextAlignmentCenter;
    self.onAuction.textColor = [UIColor whiteColor];
    [self addSubview:self.onAuction];
    [self.onAuction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.centerY.mas_offset(-17);
        make.height.mas_offset(17);
    }];
    
    self.timeLable = [[WKLabel alloc]init];
//    self.timeLable.text = [NSString stringWithFormat:@"%lumin",(long)0];
    self.timeLable.font = [UIFont systemFontOfSize:16];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    self.timeLable.textColor = [UIColor whiteColor];
    [self addSubview:self.timeLable];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.onAuction.mas_bottom).offset(5);
        make.left.right.mas_offset(0);
        make.height.mas_offset(17);
    }];
}
-(void)timerAction{
    self.angle += M_PI * 2/self.allTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
        if (self.remainingTime <= 60) {
            self.timeLable.text = [NSString stringWithFormat:@"%ldsec",(long)self.remainingTime];
        }else{
            self.timeLable.text = [NSString stringWithFormat:@"%ldmin",self.remainingTime/60+1];
            self.timeLable.text = [NSString stringWithFormat:@"%ldmin",self.remainingTime/60];
        }
        if (![self.recordStr isEqualToString:self.timeLable.text]) {
            [UIView animateWithDuration:0.2 animations:^{
                self.timeLable.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.timeLable.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        }

    });
    
    self.remainingTime = self.remainingTime -1;
    if (self.remainingTime == -1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLable.hidden = YES;
            self.angle = 0.00001;
            self.onAuction.text = @"";
            [self.onAuction mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                make.centerY.mas_offset(0);
                make.height.mas_offset(17);
            }];
            [self.onAuction layoutIfNeeded];
            [self setNeedsDisplay];
        });
    }
    self.recordStr = self.timeLable.text;
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
    CGContextSetLineWidth(context, 0.0);
    CGContextMoveToPoint(context, self.frame.size.width/2, self.frame.size.width/2);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width, -M_PI_2, -M_PI_2+self.angle, 1);
        CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)setAuctionTime:(NSInteger)alltime and:(NSInteger)remainingTime{
    self.remainingTime = remainingTime;
    self.allTime = alltime*60;
    self.angle = M_PI * 2/self.allTime * (self.allTime - self.remainingTime);
    if (self.remainingTime <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLable.hidden = YES;
            self.onAuction.text = @"";
            [self.onAuction mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                make.centerY.mas_offset(0);
                make.height.mas_offset(17);
            }];
            [self.onAuction layoutIfNeeded];
        });
    }else{
        self.timeLable.hidden = NO;
        self.onAuction.text = @"拍卖中";
        [self.onAuction mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.centerY.mas_offset(-17);
            make.height.mas_offset(17);
        }];
        [self.onAuction layoutIfNeeded];
        [self timerAction];
    }
}

-(void)setLucklySaleMoney:(NSInteger)allPrice and:(float)currentPrice{
    self.angle = M_PI * 2/allPrice * (float)(currentPrice == 0?0.001:currentPrice);
    self.angle = self.angle<0.000001?0.0001:self.angle;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
        self.timeLable.text = [NSString stringWithFormat:@"%0.1lf%%",currentPrice/allPrice*100.0];
        self.timeLable.hidden = NO;
        self.onAuction.text = @"幸运购";
    });
    
    
    
}

@end

@implementation WKLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:1];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

@end
