//
//  WKauctionView.m
//  秀加加
//
//  Created by sks on 2016/10/15.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCashView.h"
#import "NSString+Size.h"
#import "WKCornerBtn.h"

@interface WKCashView ()

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *containView;

@property (nonatomic,strong) WKCornerBtn *weixinBtn;
@property (nonatomic,strong) WKCornerBtn *aliPayBtn;
@property (nonatomic,strong) WKCornerBtn *balanceBtn;

@property (nonatomic,assign) WKGoodsLayoutType screenType;

@property (nonatomic,copy) NSNumber *balanceMoney;

@property (nonatomic,copy) void(^PayClick)(WKPayOfType payType,NSNumber *balanceNum);

@end

static WKCashView *auctionView = nil;

@implementation WKCashView

+ (void)showCashViewWith:(WKGoodsLayoutType)screenType titleStr:(NSString *)titleStr reminderStr:(NSString *)reminderStr tipStr:(NSString *)tipStr payBlock:(void(^)(WKPayOfType payType,NSNumber *balanceNum))block{

    if (auctionView == nil) {
        @synchronized (self) {
            
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            
            auctionView = [[self alloc] init];
            auctionView.frame = keyWindow.bounds;
            auctionView.screenType = screenType;
            
            [keyWindow addSubview:auctionView];
            
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = keyWindow.bounds;
            maskBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            [maskBtn addTarget:auctionView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            auctionView.maskBtn = maskBtn;
            [auctionView addSubview:maskBtn];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, WKScreenH, WKScreenW, 0)];
            bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [auctionView addSubview:bgView];
            bgView.layer.cornerRadius = 8.0;
            bgView.clipsToBounds = YES;
            auctionView.containView = bgView;
            
            // 关闭按钮
            UIImage *closeImage = [UIImage imageNamed:@"close"];
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn setImage:closeImage forState:UIControlStateNormal];
            
            [closeBtn addTarget:auctionView action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
            [auctionView.containView addSubview:closeBtn];
            
            // 保证金
            UILabel *titleLab = [UILabel new];
            titleLab.text = titleStr;
            titleLab.font = [UIFont systemFontOfSize:16.0f];
            titleLab.textColor = [UIColor lightGrayColor];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [auctionView.containView addSubview:titleLab];
            
            // 提示
            UILabel *reminder = [UILabel new];
            reminder.text = reminderStr;
//            reminder.text = @"拍卖结束后全额退还保证金";
            reminder.font = [UIFont systemFontOfSize:14.0f];
            reminder.textColor = [UIColor lightGrayColor];
            reminder.textAlignment = NSTextAlignmentCenter;
            [auctionView.containView addSubview:reminder];
            
            // 注意
            UILabel *tip = [UILabel new];
            tip.text = tipStr;
            tip.font = [UIFont systemFontOfSize:12.0f];
            tip.numberOfLines = 0;
            tip.textColor = [UIColor lightGrayColor];
            tip.textAlignment = NSTextAlignmentCenter;
            [auctionView.containView addSubview:tip];
            
            // 底下两个按钮
            NSArray *btnTitles = @[@"weixin_icon",@"alipay",@"remainImg"];
            NSArray *titlesArr = @[@"微信支付",@"支付宝",@"余额"];
            NSArray *colorArr = @[[UIColor colorWithHexString:@"#27C025"],[UIColor colorWithHexString:@"#21A2E4"],[UIColor colorWithHexString:@"#FC6620"]];
            
            NSMutableArray *btnsArr = @[].mutableCopy;
            
            [auctionView getMemberIncome];
            
            for (int i=0; i<btnTitles.count; i++) {
                
                WKCornerBtn *cornerBtn = [[WKCornerBtn alloc] initWithFrame:CGRectZero title:titlesArr[i] imageName:btnTitles[i] borderColor:colorArr[i]];
                cornerBtn.tag = 10 + i;
                [cornerBtn addTarget:auctionView sel:@selector(selectedPayType:)];
                
                [auctionView.containView addSubview:cornerBtn];
                
                if (i==0) {
                    auctionView.weixinBtn = cornerBtn;
                }else if (i == 1){
                    auctionView.aliPayBtn = cornerBtn;
                }else{
                    auctionView.balanceBtn = cornerBtn;
                }
                
                [btnsArr addObject:cornerBtn];
            }
            
            // 布局
            auctionView.containView.frame = CGRectMake(0, 0, 300,190);
            auctionView.containView.center = keyWindow.center;
            
            
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(auctionView.containView);
                make.top.mas_equalTo(@10);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
            
            [reminder mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLab.mas_bottom).offset(10);
                make.centerX.mas_equalTo(auctionView.containView);
                make.width.mas_equalTo(280);
                make.height.mas_equalTo(20);
            }];
            
            [tip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(reminder.mas_bottom).offset(0);
                make.centerX.mas_equalTo(auctionView.containView);
                make.width.mas_equalTo(300);
                make.height.mas_equalTo(40);
            }];
            
            
            if (User.isReviewID) {
                
                [auctionView.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-10);
                    make.right.mas_equalTo(auctionView.containView.mas_centerX).offset(-20);
                }];
                
                [auctionView.weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-10);
                    make.left.mas_equalTo(auctionView.containView.mas_centerX).offset(20);
                }];
                
                [auctionView.balanceBtn removeFromSuperview];
                
            }else{
                
                [auctionView.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-10);
                    make.centerX.mas_equalTo(auctionView.containView);
                }];
                
                [auctionView.weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-10);
                    make.right.mas_equalTo(auctionView.aliPayBtn.mas_left).offset(-20);
                }];
                
                [auctionView.balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-10);
                    make.left.mas_equalTo(auctionView.aliPayBtn.mas_right).offset(20);
                }];
            }
            
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(closeImage.size.width + 20, closeImage.size.height + 20));
                make.top.mas_offset(10);
                make.right.mas_equalTo(auctionView.containView.mas_right).offset(-10);
            }];
            
            auctionView.PayClick = block;
            
            [UIView animateWithDuration:0.3 animations:^{
                auctionView.containView.center = keyWindow.center;
                auctionView.containView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                auctionView.containView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                auctionView.containView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
    }
}

- (void)selectedPayType:(WKCornerBtn *)btn{
    WKPayOfType type;
    if (btn.tag == 10) {
        // 微信
        type = WKPayOfTypeWeixi;
    }else if (btn.tag == 11){
        // 支付宝
        type = WKPayOfTypeAliPay;
    }else{
        type = WKPayOfTypeBalance;
    }
    
    if (auctionView.PayClick) {
        auctionView.PayClick(type,auctionView.balanceMoney);
    }
    
    [auctionView dismissView:nil];
}

- (void)closeClick:(UIButton *)btn{
    [btn removeFromSuperview];
    
    [auctionView dismissView:auctionView.maskBtn];
}
- (void)dismissView:(UIButton *)btn{
    
    [UIView animateWithDuration:0.2 animations:^{
        auctionView.maskBtn.alpha = 0;
        auctionView.containView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [auctionView.maskBtn removeFromSuperview];
        [auctionView.containView removeFromSuperview];
        [auctionView removeFromSuperview];
        auctionView = nil;
    }];
    
}

// 获取用户余额
- (void)getMemberIncome{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response : %@",response);
        
        NSNumber *moneyCanTake = response.Data[@"MoneyCanTake"];
        
        auctionView.balanceMoney = moneyCanTake;
        
        [auctionView.balanceBtn setTitle:[NSString stringWithFormat:@"%.2f",[moneyCanTake floatValue]]];
        
//        NSString *str = [NSString stringWithFormat:@"余额: %.2f",[moneyCanTake floatValue]];
//        CGFloat width = [NSString sizeWithText:str font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(CGFLOAT_MAX, 35)].width;
        
        
    } failure:^(WKBaseResponse *response) {
        
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
