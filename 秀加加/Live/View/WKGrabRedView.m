//
//  WKGrabRedView.m
//  秀加加
//
//  Created by sks on 2017/3/16.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKGrabRedView.h"
#import "WKMessage.h"
//#import "wkp"

@interface WKGrabRedView () <CAAnimationDelegate>

@property (nonatomic,weak) WKMessage *message;
@property (nonatomic,weak) UIView *superView;

@property (nonatomic,strong) UIView *containView;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,strong) UIButton *grabBtn;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UIImageView *grabBgImageV;

@property (nonatomic,strong) UIImageView *animationImageV;

@property (nonatomic,copy) void(^callBack)();

@end

static WKGrabRedView *grabView = nil;

@implementation WKGrabRedView


+ (void)grabRedEnvelopeOn:(UIView *)superView message:(WKMessage *)message callBack:(void (^)())callBack {
    if (grabView != nil) {
        grabView = nil;
    }
    
    grabView = [[WKGrabRedView alloc] init];
    grabView.message = message;
    grabView.superView = [UIApplication sharedApplication].keyWindow;
    grabView.callBack = callBack;
    
    NSString *url = [NSString configUrl:WKCheckRedPacket With:@[@"BagID"] values:@[message.ID]];
    //Code
    /*
     1.抢
     2.抢到红包显示金额（金额在Value中）
     3.已过期
     4.专属红包
     5.直接跳转到红包详细页面
     6.已抢完
     */
    [WKProgressHUD showLoadingGifText:@""];
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:url param:nil success:^(WKBaseResponse *response) {
        [WKProgressHUD dismiss];
        NSDictionary *dict = response.Data;
        NSInteger code = [dict[@"Code"] integerValue];
        NSString *value = dict[@"Value"];
        if (code == 5) {
            if (grabView.callBack) {
                grabView.callBack();
            }
        }else{
            [grabView setupViewsWithState:code money:value];
        }

    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD dismiss];
    }];
}

- (void)setupViewsWithState:(NSInteger)state money:(NSString *)money{
    
    UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskBtn.frame = grabView.superView.bounds;
    maskBtn.backgroundColor = [[UIColor colorWithRed:0.27 green:0.26 blue:0.28 alpha:1.00] colorWithAlphaComponent:0.5];
    [maskBtn addTarget:grabView action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [grabView.superView addSubview:maskBtn];
    grabView.maskBtn = maskBtn;
    
    if (grabView.message.type == WKMessageTypeUserRedBag) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WKScreenW * 0.1, WKScreenH * 0.2, WKScreenW * 0.8, WKScreenH * 0.6)];
        bgView.center = CGPointMake(WKScreenW/2, WKScreenH/2);
        bgView.backgroundColor = [UIColor colorWithRed:0.78 green:0.23 blue:0.14 alpha:1.00];
        bgView.layer.cornerRadius = 5.0;
        bgView.clipsToBounds = YES;
        [grabView.superView addSubview:bgView];
        grabView.containView = bgView;
        
        UIImageView *iconImageV = [UIImageView new];
        iconImageV.layer.cornerRadius = 30;
        iconImageV.clipsToBounds = YES;
        [iconImageV sd_setImageWithURL:[NSURL URLWithString:grabView.message.usericon] placeholderImage:[UIImage imageNamed:@"default_03"]];
        [bgView addSubview:iconImageV];
        
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.size.mas_offset(CGSizeMake(60, 60));
            make.top.mas_equalTo(bgView.mas_top).offset(40);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"individualred"] forState:UIControlStateNormal];
        [closeBtn addTarget:grabView action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.mas_offset(3);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        
        // name
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = grabView.message.name;
        nameLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [bgView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.top.mas_equalTo(iconImageV.mas_bottom).offset(5);
            make.size.mas_offset(CGSizeMake(100, 25));
        }];
        
        // desc
        UILabel *descLabel = [UILabel new];
        if (grabView.message.tp.integerValue == 1) {
            descLabel.text = @"发起一个红包";
        }else{
            descLabel.text = @"发起一个红包,金额随机";
        }
        descLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = [UIFont systemFontOfSize:14.0f];
        [bgView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.size.mas_offset(CGSizeMake(200, 25));
        }];
        
        // bless
        UILabel *blessLab = [UILabel new];
        blessLab.text = grabView.message.desc;
        blessLab.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        blessLab.textAlignment = NSTextAlignmentCenter;
        blessLab.font = [UIFont boldSystemFontOfSize:18.0f];
        [bgView addSubview:blessLab];
        [blessLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.top.mas_equalTo(descLabel.mas_bottom).offset(20);
            make.size.mas_offset(CGSizeMake(200, 30));
        }];
        
        // reminder label
        UIImageView *grabBgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grabBgImage"]];
        [bgView addSubview:grabBgImageV];
        grabView.grabBgImageV = grabBgImageV;
        [grabBgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.mas_equalTo(blessLab.mas_bottom).offset(20);
            make.bottom.mas_offset(-(WKScreenH - 200) * 0.2);
            make.left.and.right.mas_offset(0);
            make.height.mas_offset(grabBgImageV.image.size.height);
        }];
        
        // grab btn
        UIImage *btnImage = [UIImage imageNamed:@"rob_icon"];
        UIButton *grabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [grabBtn setImage:btnImage forState:UIControlStateNormal];
        [grabBtn addTarget:grabView action:@selector(grabRedBag:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:grabBtn];
        
        [grabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.centerY.mas_equalTo(grabBgImageV.mas_centerY);
//            make.size.mas_offset(CGSizeMake(, btnImage.size.height * 0.6));
            make.width.and.height.mas_equalTo(bgView.mas_width).multipliedBy(0.3);
        }];
        grabView.grabBtn = grabBtn;
        
        // money lab
        UILabel *moneyLabel = [UILabel new];
        moneyLabel.font = [UIFont boldSystemFontOfSize:28.0f];
        moneyLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.hidden = YES;
        [bgView addSubview:moneyLabel];
        grabView.moneyLabel = moneyLabel;
        
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            //make.centerY.mas_equalTo(grabBgImageV.mas_centerY).offset(0);
            make.bottom.mas_offset(- (WKScreenH - 200) * 0.2);
            make.width.mas_equalTo(bgView.mas_width);
            make.height.mas_equalTo(90);
        }];
        
        // result btn
        UIView *yellowPoint0 = [UIView new];
        yellowPoint0.backgroundColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        yellowPoint0.layer.cornerRadius = 3;
        yellowPoint0.clipsToBounds = YES;
        [bgView addSubview:yellowPoint0];
        
        [yellowPoint0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(6, 6));
            make.left.mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
        
        UIView *yellowPoint1 = [UIView new];
        yellowPoint1.backgroundColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        yellowPoint1.layer.cornerRadius = 3;
        yellowPoint1.clipsToBounds = YES;
        [bgView addSubview:yellowPoint1];
        
        [yellowPoint1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(6, 6));
            make.right.mas_offset(-10);
            make.bottom.mas_offset(-10);
        }];
        
        UIButton *lastHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lastHistoryBtn setTitle:@"最近一次记录" forState:UIControlStateNormal];
        lastHistoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [lastHistoryBtn setTitleColor:[UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00] forState:UIControlStateNormal];
        [lastHistoryBtn addTarget:grabView action:@selector(lastHistory:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:lastHistoryBtn];
        
        [lastHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-5);
            make.size.mas_offset(CGSizeMake(100, 20));
            make.centerX.mas_equalTo(bgView);
        }];
        
        UIImageView *rightImageV = [UIImageView new];
        rightImageV.image = [UIImage imageNamed:@"individualred_right"];
        [bgView addSubview:rightImageV];
        
        [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(lastHistoryBtn);
            make.size.mas_offset(rightImageV.image.size);
            make.left.mas_equalTo(lastHistoryBtn.mas_right).offset(5);
        }];
        
        UIImageView *leftImageV = [UIImageView new];
        leftImageV.image = [UIImage imageNamed:@"individualred_left"];
        [bgView addSubview:leftImageV];
        
        [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(lastHistoryBtn);
            make.size.mas_offset(leftImageV.image.size);
            make.right.mas_equalTo(lastHistoryBtn.mas_left).offset(-5);
        }];
        
        // icon
        bgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        // animation show
        [UIView animateWithDuration:0.3 animations:^{
            bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            // shake grab btn
            [grabView shakeView:grabBtn];
            
            [UIView animateWithDuration:0.3 animations:^{
                grabView.moneyLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    grabView.moneyLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }];
        }];
        
        if (state == 1) {
            NSArray *aniImages = @[@"ribbon_06",@"ribbon_10",@"ribbon_03"];
            NSMutableArray *arr = @[].mutableCopy;
            for (int i=0; i<aniImages.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:aniImages[i]]];
                [grabView.superView addSubview:imageView];
                [arr addObject:imageView];
                
                imageView.frame = CGRectMake(0, 0, imageView.image.size.width * 2/3, imageView.image.size.height * 2/3);
                imageView.center = CGPointMake(WKScreenW/2, WKScreenH/2);
            }
            grabView.imageArr = arr;

            [grabView animationImageV:arr[0] toPoint:CGPointMake(0, 50)];
            [grabView animationImageV:arr[1] toPoint:CGPointMake(WKScreenW, 50)];
            [grabView animationImageV:arr[2] toPoint:CGPointMake(0, WKScreenH - 100)];
        }else{
            [lastHistoryBtn setTitle:@"查看领取详情" forState:UIControlStateNormal];
        }

    }else{
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guan-red"]];
        bgImageView.frame = CGRectMake(20, -WKScreenH, WKScreenW - 40, (WKScreenW - 40) * bgImageView.image.size.height/bgImageView.image.size.width);
        bgImageView.userInteractionEnabled = YES;
        [grabView.superView addSubview:bgImageView];
        grabView.containView = bgImageView;
        
        // system red evenlope
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.cornerRadius = 5.0;
        bgView.clipsToBounds = YES;
        [bgImageView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(90);
            make.bottom.mas_equalTo(bgImageView.mas_bottom).offset(0);
            make.left.mas_offset(5);
            make.right.mas_offset(-5);
        }];
        
        UIImageView *iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"systemIcon"]];
        iconImageV.layer.cornerRadius = 30;
        iconImageV.clipsToBounds = YES;
        [bgView addSubview:iconImageV];
        
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.size.mas_offset(CGSizeMake(60, 60));
            make.top.mas_equalTo(bgView.mas_top).offset(80);
        }];
        
        // close btn
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"shutdown"] forState:UIControlStateNormal];
        [closeBtn addTarget:grabView action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.top.mas_equalTo(bgImageView.mas_bottom).offset(10);
            make.size.mas_offset(CGSizeMake(35, 35));
        }];
        
        // name
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"秀加加官方";
        nameLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [bgView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.top.mas_equalTo(iconImageV.mas_bottom).offset(5);
            make.size.mas_offset(CGSizeMake(100, 25));
        }];
        
        // desc
        UILabel *descLabel = [UILabel new];
        if (grabView.message.tp.integerValue == 1) {
            descLabel.text = @"发起一个红包";
        }else{
            descLabel.text = @"发起一个红包,金额随机";
        }
        descLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = [UIFont systemFontOfSize:14.0f];
        [bgView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.size.mas_offset(CGSizeMake(200, 40));
        }];
        
        // bless
        UILabel *blessLab = [UILabel new];
        blessLab.text = grabView.message.desc;
        blessLab.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        blessLab.textAlignment = NSTextAlignmentCenter;
        blessLab.font = [UIFont boldSystemFontOfSize:18.0f];
        [bgView addSubview:blessLab];
        [blessLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.top.mas_equalTo(descLabel.mas_bottom).offset(20);
            make.size.mas_offset(CGSizeMake(200, 30));
        }];
        
        // reminder label
        UIImageView *grabBgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"offical_grabbg"]];
        [bgView addSubview:grabBgImageV];
        grabView.grabBgImageV = grabBgImageV;
        [grabBgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-(WKScreenH - 200) * 0.2);
            make.left.and.right.mas_offset(0);
            make.height.mas_offset(grabBgImageV.image.size.height);
        }];
        
        // grab btn
        UIImage *btnImage = [UIImage imageNamed:@"rob_icon"];
        UIButton *grabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [grabBtn setImage:btnImage forState:UIControlStateNormal];
        [grabBtn addTarget:grabView action:@selector(grabRedBag:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:grabBtn];
        
        [grabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconImageV);
            make.centerY.mas_equalTo(grabBgImageV.mas_centerY);
            make.size.mas_offset(CGSizeMake(btnImage.size.width * 0.6, btnImage.size.height * 0.6));
        }];
        grabView.grabBtn = grabBtn;
        
        // money lab
        UILabel *moneyLabel = [UILabel new];
        moneyLabel.font = [UIFont boldSystemFontOfSize:28.0f];
        moneyLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.hidden = YES;
        [bgView addSubview:moneyLabel];
        grabView.moneyLabel = moneyLabel;
        
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.bottom.mas_offset(-(WKScreenH - 200)*0.2);
            make.width.mas_equalTo(bgView.mas_width);
            make.height.mas_equalTo(90);
        }];
        
        // result btn
        UIButton *lastHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lastHistoryBtn setTitle:@"最近一次记录" forState:UIControlStateNormal];
        lastHistoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [lastHistoryBtn setTitleColor:[UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00] forState:UIControlStateNormal];
        [lastHistoryBtn addTarget:grabView action:@selector(lastHistory:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:lastHistoryBtn];
        
        [lastHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-15);
            make.size.mas_offset(CGSizeMake(100, 20));
            make.centerX.mas_equalTo(bgView);
        }];
        
        if (state == 1) {
            
            UIImageView *animImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle1"]];
            [bgView addSubview:animImageV];
            grabView.animationImageV = animImageV;
            
            [animImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(grabBtn);
                make.size.mas_equalTo(grabBtn).multipliedBy(1.2);
            }];
            
            NSMutableArray *images = @[].mutableCopy;
            for (int i=1; i<9; i++) {
                NSString *imageName = [NSString stringWithFormat:@"circle%d",i];
                UIImage *image = [UIImage imageNamed:imageName];
                [images addObject:image];
            }
            
            animImageV.animationImages = images;
            animImageV.animationDuration = 2.0;
            animImageV.animationRepeatCount = 2;
            [animImageV startAnimating];
        }else{
            [lastHistoryBtn setTitle:@"查看领取详情" forState:UIControlStateNormal];
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            bgImageView.frame = CGRectMake(20, 20, WKScreenW - 40, (WKScreenW - 40) * bgImageView.image.size.height/bgImageView.image.size.width);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                bgImageView.frame = CGRectMake(20, 0, WKScreenW - 40, (WKScreenW - 40) * bgImageView.image.size.height/bgImageView.image.size.width);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    grabView.moneyLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        grabView.moneyLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }];
                
                [grabView animation];
                
            }];
        }];
    }
    
    if (state != 1) {
        grabView.grabBtn.hidden = YES;
        grabView.grabBgImageV.hidden = YES;
        grabView.moneyLabel.hidden = NO;
        if (state == 2) {
            grabView.moneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[money floatValue]];
        }else{
            if (state == 3) {
                grabView.moneyLabel.text = @"已过期";
            }else if (state == 4){
                grabView.moneyLabel.text = @"专属红包";
            }else{
                grabView.moneyLabel.text = @"已抢光";
            }
        }
        
        
    }
}

//MARK: lastest history about red evenlope
- (void)lastHistory:(UIButton *)btn{
    if (grabView.callBack) {
        grabView.callBack();
    }
    
    [grabView dismissView];
}

- (void)animation{
    UIImage *btnImage = [UIImage imageNamed:@"rob_icon"];

    UIView *v = [[UIView alloc] initWithFrame:grabView.grabBtn.bounds];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
    v.clipsToBounds = YES;
    [grabView.grabBtn addSubview:v];
    
    UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:grabView.grabBtn.center radius:btnImage.size.width/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //MARK: Circle0
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = bPath.CGPath;
    circle.lineWidth = 2.0;
    circle.strokeColor = [UIColor greenColor].CGColor;
    circle.fillColor = [UIColor clearColor].CGColor;
    [v.layer addSublayer:circle];
    
    [v.layer setMask:circle];
    
    
    [UIView animateWithDuration:2.0 animations:^{
        //        waterView.transform = CGAffineTransformScale(waterView.transform, 2, 2);
        v.transform = CGAffineTransformScale(v.transform,2.0,2.0);
        v.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self animation];
    }];
}

- (void)shakeView:(UIView *)view{
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.fromValue = [NSNumber numberWithFloat:M_PI_2/7];
    anim.toValue = [NSNumber numberWithFloat:-M_PI_2/7];
    NSLog(@"%f",M_PI_2/4);
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [anim setAutoreverses:YES];
    anim.duration = 0.15;
    anim.repeatCount = MAXFLOAT;
    [view.layer addAnimation:anim forKey:@"shake"];
}

- (void)animationImageV:(UIImageView *)imageV toPoint:(CGPoint)point{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:imageV.center];
    [path addLineToPoint:point];
    
    CAKeyframeAnimation *moveAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAni.path = path.CGPath;
    moveAni.duration = 0.3;
    moveAni.fillMode = kCAFillModeForwards;
    moveAni.removedOnCompletion = NO;
    moveAni.delegate = grabView;
    moveAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [imageV.layer addAnimation:moveAni forKey:@"move"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        for (int i=0; i<grabView.imageArr.count; i++) {
            UIImageView *imageV = grabView.imageArr[i];
            [imageV removeFromSuperview];
        }
    }
}

- (void)grabRedBag:(UIButton *)btn{
    
    [grabView.grabBtn.layer removeAnimationForKey:@"shake"];
    
    if (grabView.message.type == WKMessageTypeSystemRedBag) {
        [grabView.animationImageV removeFromSuperview];
    }
    
    [UIView transitionWithView:grabView.grabBtn duration:0.3 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self grabRedPackage];
    
}

- (void)dismissView{
    [UIView animateWithDuration:0.2 animations:^{
        grabView.containView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [grabView.containView removeFromSuperview];
        [grabView.maskBtn removeFromSuperview];
        grabView = nil;
        grabView.callBack = nil;
    }];
}

/*
 Code:
 1.抢到金额，Value中存放 
 2.已抢光
 3.已过期
 */
- (void)grabRedPackage{
    
    NSString *url = [NSString configUrl:WKGrabRedPacket With:@[@"BagID"] values:@[grabView.message.ID]];
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        [grabView.grabBtn removeFromSuperview];
        [grabView.grabBgImageV removeFromSuperview];
        grabView.moneyLabel.hidden = NO;
        NSInteger code = [response.Data[@"Code"] integerValue];
        NSLog(@"reponse %@",response);
        
        switch (code) {
            case 1:
                grabView.moneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[response.Data[@"Value"] floatValue]];
                break;
            case 2:
                grabView.moneyLabel.text = @"已抢光";
                break;
            case 3:
                grabView.moneyLabel.text = @"已过期";
                break;
            default:
                break;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            grabView.moneyLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                grabView.moneyLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}


- (void)dealloc{
    NSLog(@"释放抢红包view");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
