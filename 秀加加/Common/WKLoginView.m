//
//  WKLoginView.m
//  秀加加
//
//  Created by sks on 2016/9/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLoginView.h"
#import "WKPhoneLoginViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "WKMainViewController.h"
#import "AppDelegate.h"
#import "UIImage+Gif.h"

@implementation WKLoginView

- (instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"gif"];
    UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
    
    UIImageView *bgImage = [UIImageView new];
    bgImage.image = gifImage;
    [self addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    UIView *phone = [self createItemWith:@"手机登录" image:@"denglu_03" withTag:1001];
//    UIView *wechat = [self createItemWith:@"微信登录" image:@"denglu_05" withTag:1002];
    
//    UIImage *iconImage = [UIImage imageNamed:@"denglu_03"];
//    
//    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_offset(CGSizeMake(iconImage.size.width + 50, 80));
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-100);
//        make.centerX.mas_equalTo(self.mas_centerX).offset(-80);
//    }];
//    
//    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_offset(CGSizeMake(iconImage.size.width + 50, 80));
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-100);
//        make.centerX.mas_equalTo(self.mas_centerX).offset(80);
//    }];
    
    UIImageView *lineImage = [UIImageView new];
    UIImage *image1 = [UIImage imageNamed:@"denglufangshi"];
    lineImage.image = image1;
    [self addSubview:lineImage];
    
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(image1.size);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.bottom.mas_offset(-WKScreenW*0.5);
    }];
    
    for (int i = 0 ; i < 2 ; i ++ ) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor colorWithRed:64/255.0 green:58/255.0 blue:59/255.0 alpha:1];
        [btn setImage:[UIImage imageNamed:@[@"denglu_03-1",@"denglu_06"][i]] forState:UIControlStateNormal];
        [btn setTitle:@[@"   微信登录",@"   手机登录"][i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        btn.layer.cornerRadius = WKScreenW*0.055;
        btn.layer.masksToBounds = YES;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineImage.mas_bottom).offset(WKScreenW*0.07+i*WKScreenW*0.15);
            make.left.mas_offset(WKScreenW*0.15);
            make.right.mas_offset(-WKScreenW*0.15);
            make.height.mas_offset(WKScreenW*0.11);
        }];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

//- (UIView *)createItemWith:(NSString *)title image:(NSString *)imageName withTag:(NSInteger)tag{
//    
//    UIView *bgView = [UIView new];
//    
//    bgView.tag = tag;
//    
//    [self addSubview:bgView];
//    
//    // image
//    UIImage *image = [UIImage imageNamed:imageName];
//    UIImageView *iconImage = [UIImageView new];
//    iconImage.image = image;
//    [bgView addSubview:iconImage];
//    
//    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_offset(0);
//        make.top.mas_offset(0);
//        make.size.mas_offset(image.size);
//    }];
//    
//    // title
//    UILabel *titleLab = [UILabel new];
//    titleLab.font = [UIFont systemFontOfSize:14.0];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.text = title;
//    [bgView addSubview:titleLab];
//    
//    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(bgView.mas_bottom).offset(0);
//        make.right.mas_equalTo(bgView.mas_right).offset(0);
//        make.left.mas_offset(0);
//        make.height.mas_offset(20);
//    }];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [bgView addGestureRecognizer:tap];
//    
//    return bgView;
//}

- (void)handleTap:(UIButton *)tap{
    
    if (tap.tag == 1001) {
        // 手机
        WKPhoneLoginViewController *phoneLogin = [[WKPhoneLoginViewController alloc] init];
        [self.obserview.navigationController pushViewController:phoneLogin animated:YES];
    }else{
        // 微信
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"uid=%@",user.rawData[@"unionid"]);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 
                 NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
                 
                 NSDictionary *dict = @{@"MemberCode":user.rawData[@"unionid"],
                                        @"MemberName":user.nickname,
                                        @"MemberPhoto":user.icon,
                                        @"Gender":@(user.gender),
                                        @"DeviceID":uuid
                                        };
                 [self loginWithWechat:dict];
             }
             else
             {
                 NSLog(@"%@",error);
             }
         }];
    }
}

- (void)loginWithWechat:(NSDictionary *)userInfo{
    
    [WKProgressHUD showLoadingGifText:@""];
    
    [WKHttpRequest loginWithMethod:HttpRequestMethodPost url:WKMember_LoginWX param:userInfo success:^(WKBaseResponse *response) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:response.Data forKey:TOKEN];
        User.loginStatus = YES;
        WKMainViewController *tabBarVC = [[WKMainViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
    } failure:^(WKBaseResponse *response) {
        NSLog(@"response : %@",response);
    }];
}


@end
