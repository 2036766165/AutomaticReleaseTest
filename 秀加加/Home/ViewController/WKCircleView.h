//
//  倒计时扇形.h
//  测试
//
//  Created by Chang_Mac on 16/9/26.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKLabel;

@interface WKCircleView : UIView

@property (assign, nonatomic) __block double angle;

@property (strong, nonatomic) WKLabel *timeLable;

@property (strong, nonatomic) WKLabel * onAuction;

@property (assign, nonatomic) NSInteger allTime;

@property (assign, nonatomic) NSInteger remainingTime;

@property (strong, nonatomic) NSString * recordStr;

-(void)setAuctionTime:(NSInteger)alltime and:(NSInteger)remainingTime;

-(void)setLucklySaleMoney:(NSInteger)allPrice and:(float)currentPrice;

@end

@interface WKLabel : UILabel

@end
