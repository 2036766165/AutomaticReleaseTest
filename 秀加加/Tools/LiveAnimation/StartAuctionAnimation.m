//
//  StartAuctionAnimation.m
//  Animation
//
//  Created by Chang_Mac on 17/2/21.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import "StartAuctionAnimation.h"

@interface StartAuctionAnimation ()<CAAnimationDelegate>

@end

@implementation StartAuctionAnimation

+(void)startAcutionAnimation:(saleType)saleType andData:(StartAuctionModel *)auctionModel superView:(UIView *)superView{
    
    StartAuctionAnimation *selfView = [StartAuctionAnimation new];
    
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    maskView.tag = 1010110;
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [superView addSubview:maskView];
    UIView *view = [superView viewWithTag:123213];
    [superView insertSubview:maskView aboveSubview:view];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]init];
    [maskView addGestureRecognizer:tapGR];
    
    UIImageView *lightIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, WKScreenW*0.55, WKScreenW, WKScreenW*0.9)];
    lightIM.image = [UIImage imageNamed:@"paimaichoumaiqietu-_18"];
    lightIM.layer.opacity = 0;
    [maskView addSubview:lightIM];
    
    UIImageView *centerIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW *0.125, -WKScreenW*1.1, WKScreenW*0.75, WKScreenW*0.6)];
    centerIM.image = [UIImage imageNamed:@"paimaichoumaiqietu-_17"];
    [maskView addSubview:centerIM];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW/2-1, -WKScreenW*1.1-3, 2, WKScreenW*0.5+3)];
    line.backgroundColor = [UIColor colorWithRed:253/255.0 green:200/255.0 blue:60/255.0 alpha:1];
    [maskView addSubview:line];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake((WKScreenW-WKScreenW*0.23)/2, WKScreenH-WKScreenW*0.23-10, WKScreenW*0.23, WKScreenW*0.23)];
    backView.layer.cornerRadius = WKScreenW*0.115;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:backView];
    
    UIImageView *goodsIM = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WKScreenW*0.23-4, WKScreenW*0.23-4)];
    goodsIM.layer.cornerRadius = WKScreenW*0.115-2;
    goodsIM.layer.masksToBounds = YES;
    goodsIM.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:auctionModel.goodsPic]]];
    if (auctionModel.goodsName.length<1) {
        goodsIM.image = [UIImage imageNamed:@"yuyin"];
    }
    [backView addSubview:goodsIM];
    
//    UIImageView *bottomIconIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.5-10, WKScreenH-30, 20, 20)];
//    bottomIconIM.backgroundColor = [UIColor redColor];
//    [maskView addSubview:bottomIconIM];
    
#pragma mark centerView
    
    UIImageView *headIM = [[UIImageView alloc]initWithFrame:CGRectMake(-WKScreenW*0.01, WKScreenW*0.02, WKScreenW*0.77, WKScreenW*0.1)];
    headIM.image = [UIImage imageNamed:@"paimaichoumaiqietu-_15"];
    [centerIM addSubview:headIM];
    
    UIImage *titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"paimaichoumaiqietu-_%d",saleType==auctionType?14:13]];
    UIImageView *titleIM = [[UIImageView alloc]initWithFrame:CGRectMake((WKScreenW*0.77-titleImage.size.width)/2, (WKScreenW*0.09-titleImage.size.height)/2, titleImage.size.width, titleImage.size.height)];
    titleIM.image = titleImage;
    [headIM addSubview:titleIM];
    
    UIImage *contentImage = [UIImage imageNamed:@"paimaichoumaiqietu-_16"];
    UIImageView *contentIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.075, WKScreenW*0.44, WKScreenW*0.6, WKScreenW*0.13)];
    contentIM.image = contentImage;
    [centerIM addSubview:contentIM];
    
    UILabel *contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,WKScreenW*0.6, WKScreenW*0.13)];
    contentLabel1.text = auctionModel.goodsName.length<1?@"语音商品":auctionModel.goodsName;
    contentLabel1.layer.opacity = 0;
//    contentLabel1.adjustsFontSizeToFitWidth = YES;
    contentLabel1.textAlignment = NSTextAlignmentCenter;
    contentLabel1.textColor = [UIColor whiteColor];
    [contentIM addSubview:contentLabel1];
    
    UILabel *contentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,WKScreenW*0.6, WKScreenW*0.13)];
    NSString *contentStr;
    if (saleType == auctionType) {
        contentStr = [NSString stringWithFormat:@"起拍价: ¥ %@",auctionModel.goodsPrice];
    }else{
        contentStr = [NSString stringWithFormat:@"商品金额: ¥ %@",auctionModel.goodsPrice];
    }
    contentLabel2.text = contentStr;
    contentLabel2.layer.opacity = 0;
    contentLabel2.adjustsFontSizeToFitWidth = YES;
    contentLabel2.textAlignment = NSTextAlignmentCenter;
    contentLabel2.textColor = [UIColor whiteColor];
    [contentIM addSubview:contentLabel2];
    
    UILabel *contentLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,WKScreenW*0.6, WKScreenW*0.13)];
    NSString *contentStr1;
    if (saleType == auctionType) {
        contentStr1 = [NSString stringWithFormat:@"拍卖时间: %@",auctionModel.auctionTime];
    }else{
        contentStr1 = [NSString stringWithFormat:@"幸运购: %@",auctionModel.auctionTime];
    }
    contentLabel3.text = contentStr1;
    contentLabel3.adjustsFontSizeToFitWidth = YES;
    contentLabel3.layer.opacity = 0;
    contentLabel3.textAlignment = NSTextAlignmentCenter;
    contentLabel3.textColor = [UIColor whiteColor];
    [contentIM addSubview:contentLabel3];
    
#pragma mark animation
    
    [centerIM.layer addAnimation:[selfView createCenterViewAnimation:1] forKey:nil] ;
    [line.layer addAnimation:[selfView createCenterViewAnimation:2] forKey:nil];
    
    CAKeyframeAnimation *goodsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    goodsAnimation.duration = 7;
    goodsAnimation.values = @[@(0.1),@(0.1),@(1.2),@(1),@(1),@(1.2),@(0.6),@(0.1)];
    goodsAnimation.keyTimes = @[@(0),@(0.01),@(0.03),@(0.05),@(0.95),@(0.96),@(0.97),@(1)];
    
    CAKeyframeAnimation *goodsFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    goodsFrameAnimation.duration = 7;
    goodsFrameAnimation.values = @[
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenH*0.96)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenH*0.95)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenW*0.43)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenW*0.78)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenW*0.78)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.35, WKScreenW*0.45)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.15, WKScreenW*0.05)],
                                   [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.05, WKScreenW*0.15)]
                                   ];
    goodsFrameAnimation.keyTimes = @[@(0),@(0.01),@(0.03),@(0.05),@(0.95),@(0.96),@(0.97),@(1)];
    CAAnimationGroup *goodsGroup = [CAAnimationGroup animation];
    goodsGroup.duration = 7;
    goodsGroup.removedOnCompletion = NO;
    goodsGroup.fillMode = kCAFillModeForwards;
    goodsGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    goodsGroup.animations = @[goodsAnimation,goodsFrameAnimation];
    [backView.layer addAnimation:goodsGroup forKey:nil];
    
    CAKeyframeAnimation *lightAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    lightAnimation.duration = 6;
    lightAnimation.beginTime = 1.0+CACurrentMediaTime();
    lightAnimation.values = @[@(0.9),@(0.4),@(0.9),@(0.4),@(0.9),@(0.4),@(0)];
    lightAnimation.keyTimes = @[@(0.14),@(0.28),@(0.42),@(0.56),@(0.7),@(0.84),@(1)];
    [lightIM.layer addAnimation:lightAnimation forKey:nil];
    
    
    CAKeyframeAnimation *contentAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    contentAnimation1.duration = 1.7;
    contentAnimation1.beginTime = 1.2+CACurrentMediaTime();
    contentAnimation1.values = @[@(1),@(1),@(1),@(0.1)];
    [contentLabel1.layer addAnimation:contentAnimation1 forKey:nil];
 
    CAKeyframeAnimation *contentAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    contentAnimation2.duration = 1.7;
    contentAnimation2.beginTime = 2.9+CACurrentMediaTime();
    contentAnimation2.values = @[@(1),@(1),@(1),@(0.1)];
    [contentLabel2.layer addAnimation:contentAnimation2 forKey:nil];
    
    CAKeyframeAnimation *contentAnimation3 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    contentAnimation3.duration = 1.7;
    contentAnimation3.beginTime = 4.6+CACurrentMediaTime();
    contentAnimation3.values = @[@(1),@(1),@(1),@(0.1)];
    [contentLabel3.layer addAnimation:contentAnimation3 forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [maskView removeFromSuperview];
    });
}

-(CAAnimationGroup *)createCenterViewAnimation:(NSInteger)type{
    CAKeyframeAnimation *frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    frameAnimation.duration =1;
    
    NSValue *value0 ;
    NSValue *value1 ;
    NSValue *value2 ;
    NSValue *value3 ;
    NSValue *value4 ;
    if (type == 1) {
        value0 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW *0.5,-WKScreenW*0.6)];
        value1 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.9)];
        value2 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.78)];
        value3 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.84)];
        value4 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.8)];
    }else{
        value0 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW *0.5,-WKScreenW*0.6+3)];
        value1 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.35+3)];
        value2 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.23+3)];
        value3 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.29+3)];
        value4 = [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5,WKScreenW*0.25+3)];
    }
    frameAnimation.values = @[value0,value1,value2,value3,value4];
    frameAnimation.repeatCount = 0;
    frameAnimation.removedOnCompletion = NO;
    frameAnimation.fillMode = kCAFillModeForwards;
    frameAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    frameAnimation.keyTimes = @[@(0),@(0.6),@(0.8),@(0.95),@(1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.beginTime = 6;//延时
    alphaAnimation.duration = 1;//不设置默认为 group 中设置的时长
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[frameAnimation,alphaAnimation];
    animationGroup.duration = 7;  //设置为全部动画总时长
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    NSString *animType;
    if (type == 1) {
        animType = @"center";
    }else{
        animType = @"line";
    }
    [animationGroup setValue:animType forKey:@"animType"];
    return animationGroup;
}
#pragma mark animation delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%@",[anim valueForKey:@"animType"]);
}
@end








