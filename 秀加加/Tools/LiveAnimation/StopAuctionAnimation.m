//
//  StopAuctionAnimation.m
//  Animation
//
//  Created by Chang_Mac on 17/2/23.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import "StopAuctionAnimation.h"
@implementation StopAuctionAnimation

+(void)stopAcutionAnimation:(StartAuctionModel *)auctionModel superView:(UIView *)superView{
    
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [superView addSubview:maskView];
    
    UIView *view = [superView viewWithTag:123213];
    [superView insertSubview:maskView aboveSubview:view];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]init];
    [maskView addGestureRecognizer:tapGR];
    
    UIView *memberBackView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.2, WKScreenW*0.2, WKScreenW*0.2, WKScreenW*0.2)];
    memberBackView.backgroundColor = [[UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1] colorWithAlphaComponent:0.5];
    memberBackView.layer.cornerRadius = WKScreenW*0.1;
    memberBackView.layer.masksToBounds = YES;
    [maskView addSubview:memberBackView];
    
    UIImageView *memberIM = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WKScreenW*0.2-4, WKScreenW*0.2-4)];
    memberIM.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:auctionModel.memberPic]]];
    memberIM.image = memberIM.image == nil ?[UIImage imageNamed:@"default_03"]:memberIM.image;
    memberIM.layer.cornerRadius = WKScreenW*0.1-2;
    memberIM.layer.masksToBounds = YES;
    [memberBackView addSubview:memberIM];
    
    CAKeyframeAnimation *memberIMAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    memberIMAnim1.duration = 0.2;
    memberIMAnim1.values = @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.3, WKScreenW*0.3)],[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.49, WKScreenW*0.72)]];
    memberIMAnim1.keyTimes = @[@(0),@(1)];
    memberIMAnim1.removedOnCompletion = NO;
    memberIMAnim1.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *memberIMAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    memberIMAnim.duration = 6;
    memberIMAnim.values = @[@(0.1),@(1),@(1),@(2)];
    memberIMAnim.keyTimes = @[@(0),@(0.03),@(0.85),@(1)];
    memberIMAnim.removedOnCompletion = NO;
    memberIMAnim.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *memberIMAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    memberIMAnim2.duration = 5;
    memberIMAnim2.values = @[@(1),@(1),@(0.3),@(1)];
    memberIMAnim2.keyTimes = @[@(0.1),@(0.3),@(0.35),@(0.4)];
    memberIMAnim2.removedOnCompletion = NO;
    memberIMAnim2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 6;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.animations = @[memberIMAnim2,memberIMAnim1,memberIMAnim];
    [memberBackView.layer addAnimation:animGroup forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageView *animationIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, WKScreenW*0.1, WKScreenW, WKScreenW*1.3)];
        animationIM.image = [UIImage imageNamed:@"auction5"];
        animationIM.animationRepeatCount = 1;
        animationIM.animationDuration = 1;
        animationIM.alpha = 0;
        [animationIM startAnimating];
        [maskView addSubview:animationIM];
        [maskView sendSubviewToBack:animationIM];
        animationIM.alpha = 1;
        animationIM.animationImages = @[[UIImage imageNamed:@"auction1"],
                                        [UIImage imageNamed:@"auction2"],
                                        [UIImage imageNamed:@"auction3"],
                                        [UIImage imageNamed:@"auction4"],
                                        [UIImage imageNamed:@"auction5"]];
        [animationIM startAnimating];
    
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        animationIM.alpha = 0.3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            animationIM.image = [UIImage imageNamed:@""];
            animationIM.alpha = 1;
            animationIM.animationRepeatCount = 10;
            animationIM.animationImages = @[[UIImage imageNamed:@"star1"],
                                            [UIImage imageNamed:@"star2"],
                                            [UIImage imageNamed:@"star3"],
                                            [UIImage imageNamed:@"star4"],
                                            [UIImage imageNamed:@"star5"]];
            [animationIM startAnimating];
        }];
    }];
    [UIView animateWithDuration:0.3 delay:4.7 options:UIViewAnimationOptionCurveLinear animations:^{
        animationIM.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
        });
    
    CGSize textSize = [auctionModel.memberName sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW*0.035] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW*0.04)];
    UIImageView *memberNameIM = [[UIImageView alloc]initWithFrame:CGRectMake((WKScreenW - textSize.width-WKScreenW*0.1)/2, WKScreenW*0.85, textSize.width+WKScreenW*0.1, WKScreenW*0.04)];
    memberNameIM.layer.opacity = 0;
    memberNameIM.image = [UIImage imageNamed:@"name1"];
    [maskView addSubview:memberNameIM];
    
    UILabel *memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width+WKScreenW*0.1, WKScreenW*0.04)];
    memberLabel.text = auctionModel.memberName;
    memberLabel.font = [UIFont systemFontOfSize:WKScreenW*0.035];
    memberLabel.textAlignment = NSTextAlignmentCenter;
    memberLabel.textColor = [UIColor whiteColor];
    [memberNameIM addSubview:memberLabel];

    CAKeyframeAnimation *memberLabelAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    memberLabelAnim.duration = 3.5;
    memberLabelAnim.beginTime = CACurrentMediaTime()+2.0;
    memberLabelAnim.values = @[@(1),@(1),@(0)];
    memberLabelAnim.keyTimes = @[@(0.01),@(0.7),@(0.8)];
    memberLabelAnim.removedOnCompletion = NO;
    memberLabelAnim.fillMode = kCAFillModeForwards;
    [memberNameIM.layer addAnimation:memberLabelAnim forKey:nil];
    
    UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.2, WKScreenW*1.05, WKScreenW*0.6, WKScreenW*0.13)];
    goodsView.layer.cornerRadius = 8;
    goodsView.layer.borderColor = [UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1].CGColor;
    goodsView.backgroundColor = [[UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1] colorWithAlphaComponent:0.1];
    goodsView.layer.borderWidth = 1;
    goodsView.layer.masksToBounds = YES;
    goodsView.layer.opacity = 0;
    [maskView addSubview:goodsView];
    
    UIImageView *goodsIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.02, WKScreenW*0.09, WKScreenW*0.09)];
    goodsIM.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:auctionModel.goodsPic]]];
    goodsIM.layer.cornerRadius = WKScreenW*0.045;
    goodsIM.layer.masksToBounds = YES;
    [goodsView addSubview:goodsIM];
    
    UILabel *goodsName = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.18, WKScreenW*0.02, WKScreenW*0.7, WKScreenW*0.09)];
    goodsName.textColor = [UIColor whiteColor];
    goodsName.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    goodsName.text = auctionModel.goodsName.length<1?@"语音商品":auctionModel.goodsName;
//    goodsName.adjustsFontSizeToFitWidth = YES;
    [goodsView addSubview:goodsName];
    if ([goodsName.text isEqualToString:@"语音商品"]) {
        goodsIM.image = [UIImage imageNamed:@"yuyin"];
    }
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.2, WKScreenW*1.2, WKScreenW*0.6, WKScreenW*0.13)];
    priceView.layer.cornerRadius = 8;
    priceView.layer.borderColor = [UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1].CGColor;
    priceView.layer.borderWidth = 1;
    priceView.layer.masksToBounds = YES;
    priceView.backgroundColor = [[UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1] colorWithAlphaComponent:0.1];
    priceView.layer.opacity = 0;
    [maskView addSubview:priceView];
    
    UIImageView *priceIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.02, WKScreenW*0.09, WKScreenW*0.09)];
    priceIM.image = [UIImage imageNamed:@"auctionHammer3"];
    priceIM.layer.cornerRadius = WKScreenW*0.045;
    priceIM.layer.masksToBounds = YES;
    [priceView addSubview:priceIM];
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.18, WKScreenW*0.02, WKScreenW*0.7, WKScreenW*0.09)];
    price.textColor = [UIColor whiteColor];
    price.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    price.text = [NSString stringWithFormat:@"成交价: ¥%@",auctionModel.goodsPrice];
    price.adjustsFontSizeToFitWidth = YES;
    [priceView addSubview:price];
    
    CAKeyframeAnimation *priceAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    priceAnim.duration = 3.5;
    priceAnim.beginTime = CACurrentMediaTime()+2;
    priceAnim.values = @[@(0.5),@(1),@(1),@(0)];
    priceAnim.keyTimes = @[@(0.03),@(0.06),@(0.7),@(0.9)];
    priceAnim.removedOnCompletion = NO;
    priceAnim.fillMode = kCAFillModeForwards;
    [priceView.layer addAnimation:priceAnim forKey:nil];
    [goodsView.layer addAnimation:priceAnim forKey:nil];
}


@end






