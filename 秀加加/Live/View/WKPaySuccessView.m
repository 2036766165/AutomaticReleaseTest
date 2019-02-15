//
//  WKPaySuccessView.m
//  秀加加
//
//  Created by lin on 2016/10/31.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPaySuccessView.h"

@interface WKOrederDetail : NSObject
@property (nonatomic,copy) NSString *PayAmount;
@property (nonatomic,assign) BOOL PayStatus;
@property (nonatomic,copy) NSString *OrderCode;
@property (nonatomic,copy) NSString *CreateTime;

@end

@implementation WKOrederDetail


@end

@interface WKPaySuccessView (){
    UIView *_payResultView;
    WKOrederItem *_item;
}
@end

@implementation WKPaySuccessView

- (instancetype)initWithFrame:(CGRect)frame orderItem:(WKOrederItem *)item
{
    if (self = [super initWithFrame:frame])
    {
        _item = item;
        [self checkOrderStatusWithTime:0];
    }
    return self;
}

-(void)addSubViewItem:(WKOrederDetail *)item
{
    UIButton *backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backGroundBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [backGroundBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backGroundBtn];
    
    [backGroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    if(type == 1)//竖屏
//    {
//        [backGroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(0);
//            make.right.equalTo(self.mas_right).offset(0);
//            make.top.equalTo(self).offset(0);
//            make.bottom.equalTo(self.mas_bottom).offset(0);
//        }];
//    }
//    else if(type == 2)//横屏
//    {
//        [backGroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(183);
//            make.right.equalTo(self.mas_right).offset(-183);
//            make.top.equalTo(self).offset(87);
//            make.bottom.equalTo(self.mas_bottom).offset(-87);
//        }];
//    }
    //中间
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 8.0;
    [self addSubview:centerView];
    
    _payResultView = centerView;
    
    //close
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:closeBtn];
    
    
    if (item.PayStatus) {
        
        CGFloat width;
        if (WKScreenH > WKScreenW) {
            width = WKScreenW - 40;
        }else{
            width = WKScreenH - 40;
        }
        
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width * 0.7);
            make.center.mas_equalTo(self);
        }];

        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right).offset(-15);
            make.top.equalTo(centerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(closeImage.size.width + 10, closeImage.size.height+ 10));
        }];
        
        //对勾
        UIImage *okImage = [UIImage imageNamed:@"ok"];
        UIButton *okBtn = [[UIButton alloc] init];
        [okBtn setImage:okImage forState:UIControlStateNormal];
        [centerView addSubview:okBtn];
        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(30);
            make.top.equalTo(centerView).offset(35);
            make.size.mas_equalTo(CGSizeMake(okImage.size.width, okImage.size.height));
        }];
        
        //订单支付成功
        UILabel *title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentLeft;
        title.text = @" 恭喜您,订单支付成功!";
        title.font = [UIFont systemFontOfSize:20];
        title.textColor = [UIColor colorWithHex:0x838DA1];
        [centerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(okBtn.mas_right).offset(10);
            make.top.equalTo(centerView).offset(38);
            make.size.mas_equalTo(CGSizeMake(220, 20));
        }];
        
        //content
        UILabel *content = [[UILabel alloc] init];
        content.textAlignment = NSTextAlignmentCenter;
        //    content.text = @"您可以在【我的订单】中查看详细信息";
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"您可以在【我的订单】中查看详细信息"];
        
        content.font = [UIFont systemFontOfSize:14];
        content.textColor = [UIColor colorWithHex:0x838DA1];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FC6620"] range:NSMakeRange(4, 6)];
        
        content.attributedText = str;
        [centerView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(0);
            make.right.equalTo(centerView.mas_right).offset(0);
            make.top.equalTo(title.mas_bottom).offset(15);
            make.height.mas_equalTo(20);
        }];
        
        //线
        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor lightGrayColor];
        xianView.alpha = 0.5;
        [centerView addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(0);
            make.right.equalTo(centerView.mas_right).offset(0);
            make.top.equalTo(content.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        
        //下单时间
        UILabel *orderTime = [[UILabel alloc] init];
        orderTime.textAlignment = NSTextAlignmentLeft;
        orderTime.text = [NSString stringWithFormat:@"下单时间:%@",item.CreateTime];
        orderTime.font = [UIFont systemFontOfSize:14];
        orderTime.textColor = [UIColor colorWithHex:0x838DA1];
//        self.orderTime = orderTime;
        [centerView addSubview:orderTime];
        [orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(58);
            make.right.equalTo(centerView.mas_right).offset(0);
            make.top.equalTo(xianView.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        //订单号
        UILabel *orderNum = [[UILabel alloc] init];
        orderNum.textAlignment = NSTextAlignmentLeft;
        orderNum.text = [NSString stringWithFormat:@"订单号:%@",item.OrderCode];
        orderNum.font = [UIFont systemFontOfSize:14];
        orderNum.textColor = [UIColor colorWithHex:0x838DA1];
//        self.orderNum = orderNum;
        [centerView addSubview:orderNum];
        [orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(58);
            make.right.equalTo(centerView.mas_right).offset(0);
            make.top.equalTo(orderTime.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        //支付金额
        UILabel *payValue = [[UILabel alloc] init];
        payValue.textAlignment = NSTextAlignmentLeft;
        payValue.text = [NSString stringWithFormat:@"支付金额:￥%0.2f",[item.PayAmount floatValue]];
        payValue.font = [UIFont systemFontOfSize:14];
        payValue.textColor = [UIColor colorWithHex:0x838DA1];
//        self.payValue = payValue;
        [centerView addSubview:payValue];
        [payValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(58);
            make.right.equalTo(centerView.mas_right).offset(0);
            make.top.equalTo(orderNum.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }else{
        // 提示图片
        UIImage *image = [UIImage imageNamed:@"payFail"];
        UIImageView *tipImageView = [[UIImageView alloc] initWithImage:image];
        [centerView addSubview:tipImageView];
        
        // 提示文字
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"抱歉,订单支付失败!";
        [centerView addSubview:titleLabel];
        
        // 提示文字
        NSString *reminderText = @"请返回重新支付您的订单,非常感谢!";
        UILabel *reminderLabel = [UILabel new];
        reminderLabel.font = [UIFont systemFontOfSize:14.0];
        reminderLabel.textColor = [UIColor lightGrayColor];
        reminderLabel.textAlignment = NSTextAlignmentLeft;
        reminderLabel.text = reminderText;
        [centerView addSubview:reminderLabel];
        
        CGFloat width = [reminderText sizeOfStringWithFont:[UIFont systemFontOfSize:13.0] withMaxSize:CGSizeMake(CGFLOAT_MAX, 25)].width + 100;
        
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width * 0.45);
            make.center.mas_equalTo(self);
        }];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView.mas_right).offset(-15);
            make.top.equalTo(centerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(closeImage.size.width + 10, closeImage.size.height+ 10));
        }];
        
        [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width + 5, 30));
            make.left.mas_equalTo(centerView.mas_left).offset(50);
            make.centerY.mas_equalTo(centerView.mas_centerY).offset(20);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(reminderLabel);
            make.bottom.mas_equalTo(reminderLabel.mas_top).offset(0);
            make.size.mas_equalTo(CGSizeMake(width, 25));
        }];
        
        [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
            make.centerY.mas_equalTo(centerView);
            make.right.mas_equalTo(reminderLabel.mas_left).offset(-5);
        }];
    }
    
//    _payResultView.hidden = YES;

}

- (void)checkOrderStatusWithTime:(NSInteger)requestTime{
    
    if (requestTime>=3) {
        // 失败
        WKOrederDetail *orderItem = [[WKOrederDetail alloc] init];
        orderItem.PayStatus = NO;
        [self addSubViewItem:orderItem];
        return;
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [WKProgressHUD showLoadingGifText:@""];

        NSString *url = [NSString configUrl:WKOrderPayStatus With:@[@"OrderCode",@"OrderType"] values:@[_item.orderNo,[NSString stringWithFormat:@"%zd",_item.orderType]]];
        
        __block NSInteger currentTime = requestTime;
        [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
            
            [WKProgressHUD dismiss];
//            NSLog(@"response json:%@",response.json);
            // 成功
            WKOrederDetail *orderDetail = [WKOrederDetail yy_modelWithJSON:response.Data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addSubViewItem:orderDetail];
            });
            
        } failure:^(WKBaseResponse *response) {
            currentTime++;
            [WKProgressHUD dismiss];

            [self checkOrderStatusWithTime:currentTime];
        }];
        
    });
    
}

//添加动画隐藏
-(void)closeEvent
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor blackColor];
        
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        self.transform = CGAffineTransformMakeScale(0, 0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    _payResultView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        _payResultView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _payResultView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        _payResultView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

@end

@implementation WKOrederItem


@end
