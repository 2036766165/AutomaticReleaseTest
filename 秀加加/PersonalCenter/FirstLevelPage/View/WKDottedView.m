//
//  WKDottedView.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKDottedView.h"

@interface WKDottedView ()

@property (strong, nonatomic) UILabel *tagLabel;

@end

@implementation WKDottedView

+(UIView *)createDottedViewWithFrame:(CGRect)frame{
    UIView *backView = [[UIView alloc]initWithFrame:frame];
    
    UIBezierPath *leftArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, frame.size.height/2) radius:frame.size.height/2 startAngle:-M_PI_2 endAngle:M_PI clockwise:YES];
    CAShapeLayer *leftArcShapeLayer = [CAShapeLayer layer];
    leftArcShapeLayer.path = leftArc.CGPath;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
    leftView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    leftView.layer.mask = leftArcShapeLayer;
    [backView addSubview:leftView];
    
    UIBezierPath *rightArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.height, frame.size.height/2) radius:frame.size.height/2 startAngle:M_PI_2 endAngle:DEGRESS_TO_RADIANS(270) clockwise:YES];

    CAShapeLayer *rightArcShapeLayer = [CAShapeLayer layer];
    rightArcShapeLayer.path = rightArc.CGPath;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height)];
    rightView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    rightView.layer.mask = rightArcShapeLayer;
    [backView addSubview:rightView];
//    虚线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"dae0ed"] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:7],
      [NSNumber numberWithInt:3],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, frame.size.height, frame.size.height/2);
    CGPathAddLineToPoint(path, NULL, frame.size.width-CGRectGetHeight(frame),frame.size.height/2);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[backView layer] addSublayer:shapeLayer];
    
    return backView;
}


@end
