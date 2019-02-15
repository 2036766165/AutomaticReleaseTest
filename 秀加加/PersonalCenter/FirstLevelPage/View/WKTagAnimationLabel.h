//
//  WKAnimationLabel.h
//  秀加加
//
//  Created by Chang_Mac on 17/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTagAnimationLabel : UIButton

-(instancetype)initWithString:(NSString *)tagString andTextColor:(NSString *)textColor;

-(void)startAnimation:(CGPoint)startPoint centerPoint:(CGPoint)centerPoint endPoint:(CGPoint)endPoint;

@end
