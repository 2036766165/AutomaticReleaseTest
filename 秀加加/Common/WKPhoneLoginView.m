//
//  WKPhoneLoginView.m
//  秀加加
//
//  Created by sks on 2016/9/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPhoneLoginView.h"
#import "WKMainViewController.h"
#import "AppDelegate.h"
#import "UIButton+MoreTouch.h"

@interface WKPhoneLoginView (){
    NSTimer *_timer;
    NSInteger _timeCount;
}

@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *timeBtn;
@end

@implementation WKPhoneLoginView

- (instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    _timeCount = 60;
    
    UIImageView *bgImage = [UIImageView new];
    bgImage.userInteractionEnabled = YES;
    bgImage.image = [UIImage imageNamed:@"beijingtu"];
    [self addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIImageView *logoImage = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"denglu_18"];
//    logoImage.image = image;
    [self addSubview:logoImage];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(image.size);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.top.mas_offset(150 * WKScaleH);
    }];
    
    // 电话
    UIView *phone = [self createItemWithTag:1001];
    
    // 验证码
    UIView *authCode = [self createItemWithTag:1002];
    
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(WKScreenW - 60 * WKScaleW, 60));
        make.top.mas_equalTo(logoImage.mas_bottom).offset(50);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
    }];
    
    [authCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(WKScreenW - 60, 60));
        make.top.mas_equalTo(phone.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登        录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor colorWithRed:64/255.0 green:58/255.0 blue:59/255.0 alpha:1];
    loginBtn.layer.cornerRadius = WKScreenW*0.055;
    loginBtn.layer.masksToBounds = YES;
    [self addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authCode.mas_bottom).offset(40*WKScaleH);
        make.left.mas_offset(WKScreenW*0.15);
        make.right.mas_offset(-WKScreenW*0.15);
        make.height.mas_offset(WKScreenW*0.11);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"fanhuanniu"] forState:UIControlStateNormal];
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgImage addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(60, 40));
    }];
}

- (void)backClick{
    [self.obserview.navigationController popViewControllerAnimated:YES];
}

- (UIView *)createItemWithTag:(NSInteger)tag{
    UIView *bgView = [UIView new];
    bgView.tag = tag;
    [self addSubview:bgView];
    
    UITextField *textFiled = [UITextField new];
    textFiled.font = [UIFont systemFontOfSize:16.0f];
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.textAlignment = NSTextAlignmentLeft;
    textFiled.textColor = [UIColor whiteColor];
    [bgView addSubview:textFiled];
    
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50 * WKScaleW);
        make.right.mas_equalTo(bgView.mas_right).offset(-80);
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
        make.height.mas_offset(40);
    }];
    
    // 手机号
    if (tag == 1001) {
        self.phoneText = textFiled;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: @"请输入手机号"];
        //颜色
        [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, 6)];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 6)];
        self.phoneText.attributedPlaceholder = attributedStr;
        
        UIImageView *iconImage = [UIImageView new];
        UIImage *image0 = [UIImage imageNamed:@"denglu_08"];
        iconImage.image = image0;
        [bgView addSubview:iconImage];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.centerY.mas_equalTo(bgView.mas_centerY).offset(0);
            make.size.mas_offset(image0.size);
        }];


        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"denglu_11"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearInputNum) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(textFiled.mas_centerY).offset(0);
            make.size.mas_offset(image.size);
        }];
        
    }else{
        // 验证码
        self.password = textFiled;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
        btn.touchInterval = 2;
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(textFiled.mas_centerY).offset(0);
            make.size.mas_offset(CGSizeMake(80, 20));
        }];
        self.timeBtn = btn;
    }
    
    UIView *bottomeLine = [UIView new];
    bottomeLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [bgView addSubview:bottomeLine];
    
    [bottomeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(bgView);
        make.height.mas_offset(0.8);
    }];
    
    return bgView;
}

// MARK: 点击事件
// 清空电话号码
- (void)clearInputNum{
    self.phoneText.text = @"";
}

- (void)getAuthCode{
    
    if (_timer == nil) {
        if(self.phoneText.text.length == 0)
        {
            [WKProgressHUD showTopMessage:@"请输入手机号码！"];
            return;
        }
        
        if (![NSString isVaildPhoneNumber:self.phoneText.text]) {
            [WKProgressHUD showTopMessage:@"请输入正确的手机号码！"];
            return;
        }
        
        NSString *url = [NSString configUrl:WKGetAuthCode With:@[@"PhoneNumber",@"SendType"] values:@[self.phoneText.text,@"1"]];
        
        [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
            [WKProgressHUD showTopMessage:@"验证码已发送！"];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        } failure:^(WKBaseResponse *response) {
            
        }];
    }
}

- (void)login{
    // 登录
    if (self.phoneText.text.length == 0) {
        
        UIView *phoneView = [self viewWithTag:1001];
        
        [phoneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-10);
        }];
        
        [phoneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(10);
        }];
        
        [phoneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if(self.phoneText.text.length == 0){
        [WKProgressHUD showTopMessage:@"请输入手机号码！"];
        return;
    }

    if (![NSString isVaildPhoneNumber:self.phoneText.text]) {
        [WKProgressHUD showTopMessage:@"请输入正确的手机号码！"];
        return;
    }
    
    if (self.password.text.length == 0) {
        [WKProgressHUD showTopMessage:@"请输入验证码！"];
        return;
    }
    
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;

    
    NSString *loginUrl = [NSString configUrl:WKLoginByTel With:@[@"MemberCode",@"CheckCode",@"DeviceID"] values:@[self.phoneText.text,self.password.text,uuid]];
    
    [WKProgressHUD showLoadingGifText:@""];
    [WKHttpRequest loginWithMethod:HttpRequestMethodPost url:loginUrl param:@{} success:^(WKBaseResponse *response)
    {
        [_timer invalidate];
        _timer = nil;
        //保存Token到本地
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:response.Data forKey:TOKEN];
        
        User.loginStatus = YES;
        WKMainViewController *tabBarVC = [[WKMainViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
        
    } failure:^(WKBaseResponse *response) {
        ;
        
    }];
}

- (void)countTime{
    NSLog(@"timer:::+++++++++++++:::1");
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)_timeCount] forState:UIControlStateNormal];
    _timeCount--;
    self.timeBtn.userInteractionEnabled = NO;
    if (_timeCount <= 0) {
        [self.timeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
        _timeCount = 60;
        self.timeBtn.userInteractionEnabled = YES;
    }
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}



@end
