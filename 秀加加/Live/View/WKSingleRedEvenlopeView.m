//
//  WKSingleRedEvenlopeView.m
//  秀加加
//
//  Created by sks on 2017/3/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKSingleRedEvenlopeView.h"
#import "WKQuene.h"
#import "UIImage+Gif.h"
#import "WKMessage.h"

@interface WKSingleRedEvenlopeView () <CAAnimationDelegate>

@property (nonatomic,strong) WKQuene *queue;
@property (nonatomic,strong) UIView *animationView;
@property (nonatomic,assign) BOOL isAnimating;

@property (nonatomic,strong) UILabel *fromName;
@property (nonatomic,strong) UILabel *toName;
@property (nonatomic,strong) UIImageView *fromIcon;
@property (nonatomic,strong) UIImageView *toIcon;

@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *blessLabel;

@property (nonatomic,strong) UIImageView *shakeImageV;

//@property (nonatomic,weak) UIView *superView;

@end

static WKSingleRedEvenlopeView *animation = nil;

@implementation WKSingleRedEvenlopeView

+ (void)showAnimtaionWith:(id)info superView:(UIView *)superView{
    if (animation == nil) {
        animation = [[WKSingleRedEvenlopeView alloc] initWithFrame:superView.bounds];
//        animation.superView = superView;
        animation.userInteractionEnabled = NO;
        [superView addSubview:animation];
        
        animation.animationView = [animation getAnimationView];
        animation.queue = [[WKQuene alloc] init];
    }
    
    [animation.queue enqueueWith:info];
    // enqueue
    if (!animation.isAnimating) {
        [animation showAnimationView];
    }
}

- (void)showAnimationView{
    animation.isAnimating = YES;
    id md = [animation.queue dequeue];
    [animation setinfo:md];
}

- (UIView *)getAnimationView{
    UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message"]];
    [animation addSubview:bgImageV];
    bgImageV.frame = CGRectMake(-bgImageV.image.size.width, WKScreenH - (WKScreenH * 0.3 + 65 + bgImageV.image.size.height + 10), bgImageV.image.size.width, bgImageV.image.size.height);
    
    UIImageView *shakeImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golden"]];
    [bgImageV addSubview:shakeImageV];
    animation.shakeImageV = shakeImageV;
    
    [shakeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(shakeImageV.image.size);
        make.top.mas_offset(20);
        make.left.mas_offset(10);
    }];
    
    // the red bag from ...
    UIImageView *fromIcon = [[UIImageView alloc] init];
    fromIcon.layer.cornerRadius = 15.0f;
    fromIcon.clipsToBounds = YES;
    fromIcon.layer.borderWidth = 1.0;
    fromIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [bgImageV addSubview:fromIcon];
    animation.fromIcon = fromIcon;
    [fromIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30, 30));
        make.top.mas_offset(17);
        make.left.mas_equalTo(shakeImageV.mas_right).offset(20);
    }];
    
    UILabel *fromName = [UILabel new];
    fromName.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
    fromName.font = [UIFont systemFontOfSize:12.0f];
//    fromName.text = @"我";
    fromName.textAlignment = NSTextAlignmentCenter;
    [bgImageV addSubview:fromName];
    animation.fromName = fromName;
    
    [fromName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fromIcon.mas_bottom).offset(5);
        make.size.mas_offset(CGSizeMake(60, 20));
        make.centerX.mas_equalTo(fromIcon);
    }];
    
    // the line to show animation
    NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
    UIImage *gifImg = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
    UIImageView *gifImgV = [[UIImageView alloc] initWithImage:gifImg];
    [bgImageV addSubview:gifImgV];
    
    [gifImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(shakeImageV);
        make.left.mas_equalTo(fromIcon.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(gifImg.size.width * 0.4, gifImg.size.height * 0.4));
    }];
    
    // the red bag to ...
    UIImageView *toIcon = [[UIImageView alloc] init];
    toIcon.layer.cornerRadius = 15.0f;
    toIcon.clipsToBounds = YES;
    toIcon.layer.borderWidth = 1.0;
    toIcon.layer.borderColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00].CGColor;
    [bgImageV addSubview:toIcon];
    animation.toIcon = toIcon;
    
    [toIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30, 30));
        make.top.mas_offset(17);
        make.left.mas_equalTo(gifImgV.mas_right).offset(10);
    }];

    UILabel *toName = [UILabel new];
    toName.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
    toName.font = [UIFont systemFontOfSize:12.0f];
    toName.text = @"我";
    toName.textAlignment = NSTextAlignmentCenter;
    [bgImageV addSubview:toName];
    animation.toName = toName;
    
    [toName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(toIcon.mas_bottom).offset(5);
        make.size.mas_offset(CGSizeMake(60, 20));
        make.centerX.mas_equalTo(toIcon);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
    
    [bgImageV addSubview:moneyLabel];
    
    animation.moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fromIcon.mas_right).offset(2);
        make.right.mas_equalTo(toIcon.mas_left).offset(-2);
        make.height.mas_offset(25);
        make.bottom.mas_equalTo(gifImgV.mas_top).offset(5);
    }];
    
    UILabel *blessLabel = [[UILabel alloc] init];
    blessLabel.textColor = [UIColor lightGrayColor];
//    blessLabel.text = @"恭喜发财,红包拿来";
    blessLabel.font = [UIFont systemFontOfSize:12.0f];
    blessLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:blessLabel];
    animation.blessLabel = blessLabel;
    
    [blessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.bottom.mas_offset(-5);
        make.size.mas_offset(CGSizeMake(150, 18));
    }];
    
    return bgImageV;
}

- (void)setinfo:(WKMessage *)info{
    animation.animationView.alpha = 1.0;
    if (info.type == WKMessageTypeSystemRedBag) {
        animation.fromIcon.image = [UIImage imageNamed:@"systemIcon"];
        animation.fromName.text = @"秀加加...";
    }else{
        [animation.fromIcon sd_setImageWithURL:[NSURL URLWithString:info.fromphoto] placeholderImage:[UIImage imageNamed:@"default_03"]];
        animation.fromName.text = info.fromname;
    }
    
    [animation.toIcon sd_setImageWithURL:[NSURL URLWithString:info.tophoto] placeholderImage:[UIImage imageNamed:@"default_03"]];
    animation.toName.text = info.toname;
    animation.blessLabel.text = info.desc;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",info.money]];
    [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} range:NSMakeRange(0, attri.length-1)];
    [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} range:NSMakeRange(attri.length-1, 1)];
    animation.moneyLabel.attributedText = attri;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        animation.animationView.frame = CGRectMake(30, WKScreenH - (WKScreenH * 0.3 + 65 + animation.animationView.frame.size.height + 10), animation.animationView.frame.size.width, animation.animationView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            animation.animationView.frame = CGRectMake(10, WKScreenH - (WKScreenH * 0.3 + 65 + animation.animationView.frame.size.height + 10), animation.animationView.frame.size.width, animation.animationView.frame.size.height);
        } completion:^(BOOL finished) {
            [animation shakeView];
        }];
    }];
}

- (void)shakeView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anim.fromValue = [NSNumber numberWithFloat:M_PI_2/5];
        anim.toValue = [NSNumber numberWithFloat:-M_PI_2/5];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [anim setAutoreverses:YES];
        anim.duration = 0.2;
        anim.repeatCount = 4;
        
        CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anim1.fromValue = [NSNumber numberWithFloat:M_PI_2/5];
        anim1.toValue = [NSNumber numberWithFloat:-M_PI_2/5];
        anim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [anim1 setAutoreverses:YES];
        anim1.beginTime = 1.5;
        anim1.duration = 0.2;
        anim1.repeatCount = 4;
        
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[anim,anim1];
        groupAnima.duration = 3.0;
        groupAnima.removedOnCompletion = NO;
        groupAnima.fillMode = kCAFillModeForwards;
        groupAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        groupAnima.delegate = animation;
        [animation.shakeImageV.layer addAnimation:groupAnima forKey:@"radar"];
        
    
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            animation.animationView.alpha = 0.0;
        } completion:^(BOOL finished) {
            animation.animationView.frame = CGRectMake(-animation.animationView.frame.size.width, WKScreenH - (WKScreenH * 0.3 + 65 + animation.animationView.frame.size.height + 10), animation.animationView.frame.size.width, animation.animationView.frame.size.height);
            
            if (![animation.queue isEmpty]) {
                [animation showAnimationView];
            }else{
                [animation.shakeImageV.layer removeAllAnimations];
                [animation.animationView removeFromSuperview];
                [animation removeFromSuperview];
                animation.queue = nil;
                animation = nil;
            }
        }];
    });
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    if (flag) {
//        [UIView animateWithDuration:0.3 animations:^{
//            animation.animationView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            animation.animationView.frame = CGRectMake(-animation.animationView.frame.size.width, WKScreenH - (WKScreenH * 0.3 + 65 + animation.animationView.frame.size.height + 10), animation.animationView.frame.size.width, animation.animationView.frame.size.height);
//
//            if (![animation.queue isEmpty]) {
//                [animation showAnimationView];
//            }else{
//                [animation.shakeImageV.layer removeAllAnimations];
//                [animation.animationView removeFromSuperview];
//                [animation removeFromSuperview];
//                animation.queue = nil;
//                animation = nil;
//            }
//        }];
//    }
//}


- (void)dealloc{
    NSLog(@"释放动画弹窗");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
