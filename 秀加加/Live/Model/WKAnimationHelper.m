//
//  WKAnimationHelper.m
//  秀加加
//
//  Created by sks on 2017/2/8.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKAnimationHelper.h"
#import "WKRaiseItem.h"
#import "WKSelectAuctionView.h"

@interface WKAnimationHelper () <CAAnimationDelegate,WKAuctionSelectDelegate>

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,copy)  void(^selectedIdx)(WKAimation type, NSInteger idx);  // 选中的下标
@property (nonatomic,assign) WKAimation type;
@property (nonatomic,strong) WKSelectAuctionView *auctionBtn; //拍卖的view
@property (nonatomic,strong) WKSelectAuctionView *crowdBtn;   // 筹麦的view

@end

static WKAnimationHelper *animationHelper = nil;

@implementation WKAnimationHelper

+ (void)showAnimation:(WKAimation)animation OnView:(UIView *)view withInfo:(id)info callback:(void (^)(WKAimation animationType,NSInteger idx))callback{
    animationHelper = nil;
    if (!animationHelper) {
        
        @synchronized (self) {
            
            animationHelper = [WKAnimationHelper new];
            
            animationHelper.type = animation;
            animationHelper.selectedIdx = callback;
            
            UIView *superview = view;
            if (!view) {
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                superview = keyWindow;
            }

            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            maskBtn.frame = superview.bounds;
            [maskBtn addTarget:animationHelper action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
            [superview addSubview:maskBtn];
            animationHelper.maskBtn = maskBtn;
            
            switch (animation) {
                case WKAimationBid:
                    [self bidAnimationOn:superview price:info];
                    break;
                case WKAimationAuction:
                    [self chooseAuctionTypeOnView:superview];
                    break;
                default:
                    break;
            }
            
        }
    }
}

//MARK: 选择拍卖或筹卖动画
+ (void)chooseAuctionTypeOnView:(UIView *)superView{
    UIImage *bgImage = [UIImage imageNamed:@"item_back"];

    superView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    
    // 拍卖
    WKSelectAuctionView *auctionView = [[WKSelectAuctionView alloc] initWithFrame:CGRectMake(-bgImage.size.width, WKScreenH * 0.3, bgImage.size.width, bgImage.size.height) type:0];
    auctionView.delegate = animationHelper;
    [superView addSubview:auctionView];
    
    animationHelper.auctionBtn = auctionView;
    
    // 筹卖
    WKSelectAuctionView *crowdView = [[WKSelectAuctionView alloc] initWithFrame:CGRectMake(WKScreenW + bgImage.size.width , WKScreenH * 0.3, bgImage.size.width, bgImage.size.height) type:1];
    crowdView.delegate = animationHelper;
    [superView addSubview:crowdView];
    
    animationHelper.crowdBtn = crowdView;
    
//    [auctionView showDescription:YES];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        auctionView.frame = CGRectMake(WKScreenW/2 - 10 - bgImage.size.width, WKScreenH * 0.3, bgImage.size.width, bgImage.size.height);
        crowdView.frame = CGRectMake(WKScreenW/2 + 10, WKScreenH * 0.3, bgImage.size.width, bgImage.size.height);

    } completion:^(BOOL finished) {
        
    }];

}

- (void)selectedType:(NSUInteger)type{
    if (animationHelper.selectedIdx) {
        [animationHelper dismissView];
        animationHelper.selectedIdx(animationHelper.type,type);
    }
}

- (void)showInfoType:(NSInteger)type{
    if (type == 0) {
        [animationHelper.auctionBtn showDescription:YES];
        [animationHelper.crowdBtn showDescription:NO];
    }else{
        [animationHelper.auctionBtn showDescription:NO];
        [animationHelper.crowdBtn showDescription:YES];
    }
    
}

- (void)dismissView{
    
    if (animationHelper.type == WKAimationAuction) {
        
        [animationHelper.auctionBtn showDescription:NO];
        [animationHelper.crowdBtn showDescription:NO];
        
        UIImage *bgImage = [UIImage imageNamed:@"item_back"];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            animationHelper.auctionBtn.frame = CGRectMake(-bgImage.size.width - 100, animationHelper.auctionBtn.frame.origin.y, animationHelper.auctionBtn.frame.size.width, animationHelper.auctionBtn.frame.size.height);
            animationHelper.crowdBtn.frame = CGRectMake(WKScreenW + bgImage.size.width + 100, animationHelper.crowdBtn.frame.origin.y, animationHelper.crowdBtn.frame.size.width, animationHelper.crowdBtn.frame.size.height);
            animationHelper.maskBtn.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [animationHelper.auctionBtn removeFromSuperview];
            [animationHelper.crowdBtn removeFromSuperview];
            [animationHelper.maskBtn removeFromSuperview];
            
            animationHelper.maskBtn = nil;
            animationHelper.auctionBtn = nil;
            animationHelper.crowdBtn = nil;
        }];
        
    }else{
        
    }
    
}

//MARK: 举牌动画
+ (void)bidAnimationOn:(UIView *)superview price:(NSString *)price{
    
    UIImage *image = [UIImage imageNamed:@"jupai2_03"];
    // 动画背景
    UIImage *imageLight = [UIImage imageNamed:@"guang"];
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,imageLight.size.width, imageLight.size.height)];
    animationView.center = CGPointMake(WKScreenW/2, WKScreenH/2);
    [superview addSubview:animationView];
    
    //翻拍
    UIImageView *switchImage = [[UIImageView alloc] initWithImage:image];
    switchImage.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    switchImage.center = CGPointMake(animationView.frame.size.width/2, animationView.frame.size.height/2);
    
    // 背后的光
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageLight];
    imageView.frame = CGRectMake(0, 0,imageLight.size.width, imageLight.size.height);
    imageView.center = CGPointMake(animationView.frame.size.width/2, animationView.frame.size.height/2);
    imageView.hidden = YES;
    [animationView addSubview:imageView];
    
    // 举牌
    WKRaiseItem *animationItem = [[WKRaiseItem alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height) price:price screenType:WKGoodsLayoutTypeVertical];
    [animationItem setFontWith:18.0f];
    animationItem.selected = YES;
    //    animationItem.center = imageView.center;
    animationItem.center = CGPointMake(animationView.frame.size.width/2 - image.size.width/2, animationView.frame.size.height/2 - image.size.height/2);
    
    CABasicAnimation *rotationA = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationA.toValue= [NSNumber numberWithFloat:M_PI/2];
    rotationA.duration = 0.2;
    [switchImage.layer addAnimation:rotationA forKey:@"rotationA"];
//    rotationA.delegate = animationHelper;

    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    keyAnimation.timeOffset = 0.2;
    keyAnimation.values = @[@(25 * (M_PI / 180.0f)),
                            @(-25 * (M_PI / 180.0f)),
                            @(18 * (M_PI / 180.0f)),
                            @(-18 * (M_PI / 180.0f)),
                            @(10 * (M_PI / 180.0f)),
                            @0];
    keyAnimation.keyTimes = @[@(0.2),@(0.2),@(0.1),@(0.1),@(0.08),@(0.08),@0];
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animationItem.layer addAnimation:keyAnimation forKey:@"raiseAnim"];
    
    keyAnimation.delegate = animationHelper;
    
    /*dispatch_async(dispatch_get_main_queue(), ^{
     
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        //        auctionView.containView.userInteractionEnabled = NO;
        //        keyWindow.userInteractionEnabled = NO;
//        auctionView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        
        CGFloat scale = 1;
        
        UIImage *image = [UIImage imageNamed:@"jupai2_03"];
        // 动画背景
        UIImage *imageLight = [UIImage imageNamed:@"guang"];
        
        UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,imageLight.size.width* auctionView.screenScale * scale, imageLight.size.height * auctionView.screenScale* scale)];
        animationView.center = CGPointMake(WKScreenW/2, WKScreenH/2);
        [keyWindow addSubview:animationView];
        
        //翻拍
        UIImageView *switchImage = [[UIImageView alloc] initWithImage:image];
        switchImage.frame = CGRectMake(0, 0, image.size.width* auctionView.screenScale* scale, image.size.height* auctionView.screenScale* scale);
        switchImage.center = CGPointMake(animationView.frame.size.width/2, animationView.frame.size.height/2);
        
        // 背后的光
        UIImageView *imageView = [[UIImageView alloc] initWithImage:imageLight];
        imageView.frame = CGRectMake(0, 0,imageLight.size.width* auctionView.screenScale * scale, imageLight.size.height* auctionView.screenScale* scale);
        imageView.center = CGPointMake(animationView.frame.size.width/2, animationView.frame.size.height/2);
        imageView.hidden = YES;
        [animationView addSubview:imageView];
        
        // 举牌
        WKRaiseItem *animationItem = [[WKRaiseItem alloc] initWithFrame:CGRectMake(0, 0, image.size.width* auctionView.screenScale * scale, image.size.height* auctionView.screenScale*scale) price:price screenType:auctionView.type];
        [animationItem setFontWith:18.0f];
        animationItem.selected = YES;
        //    animationItem.center = imageView.center;
        animationItem.center = CGPointMake(animationView.frame.size.width/2 - image.size.width/2, animationView.frame.size.height/2 - image.size.height/2);
        
        [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [animationView addSubview:switchImage];
            
            switchImage.layer.transform = CATransform3DMakeRotation(M_PI/2, 1, 0, 0);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                switchImage.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                [switchImage removeFromSuperview];
                
                [animationView addSubview:animationItem];
                
                animationItem.frame = CGRectMake(0, 0, image.size.width* auctionView.screenScale, image.size.height* auctionView.screenScale);
                animationItem.center = CGPointMake(animationView.frame.size.width/2, animationView.frame.size.height/2 + 40 * auctionView.screenScale);
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    animationItem.layer.anchorPoint = CGPointMake(0.5, 1.0);
                    animationItem.transform = CGAffineTransformMakeRotation(25 * (M_PI / 180.0f));
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        animationItem.transform = CGAffineTransformMakeRotation(-25 * (M_PI / 180.0f));
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.15 animations:^{
                            
                            animationItem.transform = CGAffineTransformMakeRotation(18 * (M_PI / 180.0f));
                            
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:0.1 animations:^{
                                animationItem.transform = CGAffineTransformMakeRotation( -10 * (M_PI / 180.0f));
                                
                            } completion:^(BOOL finished) {
                                
                                [UIView animateWithDuration:0.08 animations:^{
                                    
                                    animationItem.transform = CGAffineTransformMakeRotation((M_PI / 180.0f));
                                    
                                } completion:^(BOOL finished) {
                                    imageView.hidden = NO;
                                    animationView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                                    [UIView animateWithDuration:0.9 delay:0.0 options:0 animations:^{
                                        animationView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                    } completion:^(BOOL finished) {
                                        auctionView.backgroundColor = [UIColor clearColor];
                                        [animationView removeFromSuperview];
                                        keyWindow.backgroundColor = [UIColor clearColor];
                                        keyWindow.alpha = 1.0;
                                        
                                        for (int i=0; i<auctionView.btnArr.count; i++) {
                                            UIButton *btn = auctionView.btnArr[i];
                                            btn.userInteractionEnabled = YES;
                                        }
                                        
                                        //                                        auctionView.containView.userInteractionEnabled = YES;
                                        //                                        auctionView.isRewarding = NO;
                                    }];
                                }];
                            }];
                            
                        }];
                        
                    }];
                    
                }];
            }];
        }];
        
    });*/

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    animationHelper = nil;
}

@end
