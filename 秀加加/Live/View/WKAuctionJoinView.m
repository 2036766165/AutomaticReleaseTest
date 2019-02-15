//
//  WKAuctionJoinView.m
//  秀加加
//
//  Created by sks on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionJoinView.h"
#import "WKAuctionStatusModel.h"
#import "WKAuctionStatusView.h"
#import "WKRaiseItem.h"
#import "WKCashView.h"
#import "WKPayTool.h"
#import "NSObject+XWAdd.h"
#import "AppDelegate.h"
#import "WKPlayTool.h"
#import "PlayerManager.h"
#import "NSString+substring.h"
#import "WKAnimationHelper.h"
#import "RHSliderView.h"
//#import "WKCustomAlert.h"
#import "WKSelectIndexView.h"

@interface WKAuctionJoinView () <PlayingDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *containView;

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *startPrice;
@property (nonatomic,strong) UIButton *duration;
@property (nonatomic,strong) UILabel *joinPeople;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *goodsPrice;

@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) WKRaiseItem *selectedItem;

@property (nonatomic,strong) WKAuctionStatusModel *dataMd;
@property (nonatomic,assign) WKGoodsLayoutType type;       // 布局类型
@property (nonatomic,copy)   block completionBlock;

@property (nonatomic,assign) NSUInteger startCountTime;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *btnArr;

@property (nonatomic,assign) CGFloat screenScale;

@property (nonatomic,assign) BOOL isPlaying;   // 是否正在播放音乐
@property (nonatomic,assign) BOOL isRewarding; // 是否正在打赏
@property (assign, nonatomic) BOOL isTouch;    // 是否正在显示

@property (nonatomic,strong) UIView *descView;   // before join,description auction

@property (nonatomic,strong) UILabel *myFeeLabel;       // my price

@property (nonatomic,strong) UILabel *balanceLabel;     // account balance

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) RHSliderView *sliderView;

@property (nonatomic,assign) CGFloat moneyCanTake;


@end

static WKAuctionJoinView *auctionView = nil;

@implementation WKAuctionJoinView

+ (void)auctionJoinWith:(id)md screenType:(WKGoodsLayoutType)screenType On:(UIView *)superView completionBlock:(block)block{
    auctionView = nil;
    
    if (auctionView == nil) {
        
        @synchronized (self) {
            
            auctionView = [[self alloc] init];
            auctionView.frame = superView.bounds;
            auctionView.dataMd = md;
            auctionView.type = screenType;
            auctionView.startCountTime = auctionView.dataMd.RemainTime.integerValue;
            auctionView.completionBlock = block;
            [superView addSubview:auctionView];
            
//            CGFloat scale ;
//            if (WKScreenH > WKScreenW) {
//                // 竖屏
//                scale = ;
//            }
            
            UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]init];
            [auctionView addGestureRecognizer:panGR];
            
            auctionView.screenScale = WKScaleW;
            
            auctionView.isRewarding = NO;
            auctionView.timer = [NSTimer timerWithTimeInterval:1.0 target:auctionView selector:@selector(updateTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:auctionView.timer forMode:NSRunLoopCommonModes];
            
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.backgroundColor = [UIColor clearColor];
            maskBtn.frame = superView.bounds;
            [maskBtn addTarget:auctionView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            [auctionView addSubview:maskBtn];
            auctionView.maskBtn = maskBtn;
            
            CGFloat containHeight;
            if (auctionView.dataMd.SaleType.integerValue == 1) {
                // auction-ing
                if (WKScreenH * 0.35 > 200) {
                    containHeight = 260;
                }else{
                    containHeight = 260;
                }
            }else{
                // crowd
                if (WKScreenH * 0.35 > 200) {
                    containHeight = 300;
                }else{
                    containHeight = 260;
                }
            }
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, WKScreenH, WKScreenW - 20, containHeight)];
            bgView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:1.0];
            [auctionView addSubview:bgView];
            auctionView.containView = bgView;
            
            UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auction_bg"]];
            [auctionView.containView addSubview:bgImageV];
            
            // picture
            UIImageView *iconImage = [UIImageView new];
            iconImage.contentMode = UIViewContentModeScaleAspectFill;
            iconImage.clipsToBounds = YES;
            iconImage.userInteractionEnabled = YES;
            auctionView.iconImage = iconImage;
            [auctionView.containView addSubview:iconImage];
            
            if (auctionView.dataMd.GoodsCode.integerValue == 0) {
                // 快速拍卖
                iconImage.image = [UIImage imageNamed:@"play01"];
                
                UILabel *lab = [UILabel new];
                lab.text = [NSString stringWithFormat:@"%@''",auctionView.dataMd.VoiceDuration];
                lab.textColor = [UIColor colorWithHexString:@"#FC6620"];
                lab.font = [UIFont systemFontOfSize:14.0f];
                lab.textAlignment = NSTextAlignmentCenter;
                [iconImage addSubview:lab];
                iconImage.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
                iconImage.layer.borderWidth = 1.0;
                
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(10);
                    make.right.mas_equalTo(iconImage.mas_right).offset(-10);
                    make.size.mas_offset(CGSizeMake(30, 20));
                }];
                
            }else{
                // 普通拍卖
                [iconImage sd_setImageWithURL:[NSURL URLWithString:auctionView.dataMd.GoodsPic] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:auctionView action:@selector(tapAuctionGoods)];
            [iconImage addGestureRecognizer:tap];
            
            // 名字
            UILabel *nameLabel = [UILabel new];
            nameLabel.font = [UIFont systemFontOfSize:14.0f];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [UIColor whiteColor];
            if (auctionView.dataMd.GoodsName.length == 0 || !auctionView.dataMd.GoodsName) {
                nameLabel.text = @"语音商品";
            }else{
                nameLabel.text = auctionView.dataMd.GoodsName;
            }
            nameLabel.numberOfLines = 0;
            auctionView.nameLabel = nameLabel;
            [auctionView.containView addSubview:nameLabel];
            
            // 起拍价
            UILabel *startPrice = [UILabel new];
            startPrice.font = [UIFont systemFontOfSize:13.0f];
            startPrice.textAlignment = NSTextAlignmentLeft;
            startPrice.textColor = [UIColor lightGrayColor];
            startPrice.adjustsFontSizeToFitWidth = YES;
            startPrice.text = [NSString stringWithFormat:@"起拍价 ￥%0.2f",[auctionView.dataMd.GoodsStartPrice floatValue]];
            auctionView.startPrice = startPrice;
            [auctionView.containView addSubview:startPrice];
            
            // 时间
            UIButton *durationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *unit;
            NSUInteger remainTime;
            if (auctionView.startCountTime >= 60) {
                remainTime = auctionView.startCountTime/60;
                unit = @"min";
            }else{
                remainTime = auctionView.startCountTime;
                unit = @"s";
            }
            
            [durationBtn setTitle:[NSString stringWithFormat:@"  %zd%@",remainTime,unit] forState:UIControlStateNormal];
            [durationBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
            durationBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            auctionView.duration = durationBtn;
            [durationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [auctionView.containView addSubview:durationBtn];
            
            // 当前参数人数
            UILabel *joinLabel = [UILabel new];
            joinLabel.text = [NSString stringWithFormat:@"当前参与人数  %@",auctionView.dataMd.Count];
            joinLabel.textColor = [UIColor lightGrayColor];
            joinLabel.textAlignment = NSTextAlignmentLeft;
            joinLabel.font = [UIFont systemFontOfSize:13.0f];
            auctionView.joinPeople = joinLabel;
            [auctionView.containView addSubview:joinLabel];
            
            // 所有人
            UILabel *ownerLabel = [UILabel new];
            if(auctionView.dataMd.CurrentMemberName.length == 0)
            {
                ownerLabel.text = [NSString stringWithFormat:@"￥%0.2f",[auctionView.dataMd.CurrentPrice floatValue]];
            }
            else
            {
                ownerLabel.text = [NSString stringWithFormat:@"%@  ￥%0.2f",[auctionView.dataMd.CurrentMemberName subEmojiStringTo:6 with:@"..."],[auctionView.dataMd.CurrentPrice floatValue]];
            }
            ownerLabel.textColor = [UIColor lightGrayColor];
            ownerLabel.font = [UIFont systemFontOfSize:14.0f];
            ownerLabel.textAlignment = NSTextAlignmentLeft;
            auctionView.statusLabel = ownerLabel;
            [auctionView.containView addSubview:ownerLabel];
            
            // 监听举牌价格和人数
            [auctionView.dataMd xw_addObserverBlockForKeyPath:@"Count" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                if (auctionView.dataMd.SaleType.integerValue == 1) {
                    NSNumber *count = newVal;
                    joinLabel.text = [NSString stringWithFormat:@"总参与人数  %@",count];
                }
            }];
            
            [auctionView.dataMd xw_addObserverBlockForKeyPath:@"CurrentPrice" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                
                if (auctionView.dataMd.SaleType.integerValue == 1) {
                    NSArray *priceArr = [auctionView getPriceArrWithCurrentPrice:newVal];
                    // 刷新价格
                    for (int i=0; i<priceArr.count; i++) {
                        NSNumber *price = priceArr[i];
                        WKRaiseItem *item = auctionView.btnArr[i];
                        item.price = [NSString stringWithFormat:@"%@",price];
                    }
                    ownerLabel.text = [NSString stringWithFormat:@"%@  ￥%0.2f",[auctionView.dataMd.CurrentMemberName subEmojiStringTo:6 with:@"..."],[newVal floatValue]];
                }else{
                    NSLog(@"max value = %lf",[auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue]);
                    
                    auctionView.sliderView.maxValue = [auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue];
                    auctionView.sliderView.minValue = 1;
                    
                    if (auctionView.textField.text.integerValue > auctionView.sliderView.maxValue) {
                        auctionView.textField.text = [NSString stringWithFormat:@"%ld",auctionView.sliderView.maxValue];
                    }
                    
                    if ([auctionView.dataMd.CurrentMemberBPOID isEqualToString:User.BPOID]) {
                        auctionView.myFeeLabel.text = [NSString stringWithFormat:@"我已出价 ￥%0.2f",[auctionView.dataMd.Price floatValue]];
                    }

                    auctionView.joinPeople.text = [NSString stringWithFormat:@"已购总额 ￥%0.2f",[auctionView.dataMd.CurrentPrice floatValue]];
                    
//                    if ([auctionView.dataMd.CurrentPrice floatValue] > 0) {
//                        auctionView.textField.text = [NSString stringWithFormat:@"%0.0f",[auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue]];
//                    }
                }
                
            }];
            
            // 监听是否是自己是最高价格
            [auctionView.dataMd xw_addObserverBlockForKeyPath:@"isMostHighPrice" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                NSNumber *isHigh = newVal;
                if (isHigh.boolValue) {
                    
                }else{
                    
                }
            }];
            
            // oberve my offer price
//            [auctionView.dataMd xw_addObserverBlockForKeyPath:@"Price" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
//                //                NSNumber *currentCountTime = newVal;
//                auctionView.myFeeLabel.text = [NSString stringWithFormat:@"我的出价 ￥%0.2f",[newVal floatValue]];
//                //                auctionView.startCountTime = currentCountTime.integerValue;
//            }];
            
            // 监听是否是自己是最高价格
            [auctionView.dataMd xw_addObserverBlockForKeyPath:@"RemainTime" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                NSNumber *currentCountTime = newVal;
                auctionView.startCountTime = currentCountTime.integerValue;
            }];
            
            [auctionView getMyMoneyCanTake];
            
            if (screenType == WKGoodsLayoutTypeVertical) {
                // 竖屏
                auctionView.containView.frame = CGRectMake(10, WKScreenH, WKScreenW - 20, containHeight);
                // background imageView
                [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                
                // 图片
                [auctionView.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.top.mas_offset(10);
                    make.width.and.height.mas_offset(100 * WKScaleW);
                }];
                
                // 名字
                [auctionView.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(-10);
                    make.top.mas_equalTo(@10);
                    make.height.mas_equalTo(@30);
                }];
                
                // 起拍价
                [auctionView.startPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(auctionView.nameLabel.mas_bottom).offset(5);
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.right.mas_equalTo(auctionView.duration.mas_left).offset(-5);
                    make.height.mas_equalTo(@20);
                }];
                
                [auctionView.duration mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(-5);
                    make.top.mas_equalTo(auctionView.startPrice.mas_bottom).offset(5);
                    make.size.mas_equalTo(CGSizeMake(65, 20));
                }];
                
                // 参与人数
                [auctionView.joinPeople mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.centerY.mas_equalTo(auctionView.duration.mas_centerY).offset(0);
                    make.height.mas_offset(25);
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(10);
                }];
                
                // 拍卖状态
                [auctionView.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.top.mas_equalTo(auctionView.joinPeople.mas_bottom).offset(0);
                    //                    make.size.mas_equalTo(CGSizeMake(100, 25));
                    make.height.mas_equalTo(@25);
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(-20);
                }];
                
                //[auctionView.dataMd addObserver:auctionView forKeyPath:@"" options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>];
                
                if (auctionView.dataMd.SaleType.integerValue == 1) {
                    // auction
                    if (!auctionView.dataMd.IsJoin) {
                        // confirm join btn
                        auctionView.descView = [auctionView setupDescView];
                        [auctionView.containView addSubview:auctionView.descView];
                        
                        [auctionView.descView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(auctionView.iconImage.mas_bottom).offset(5);
                            make.left.mas_offset(5);
                            make.bottom.and.right.mas_offset(-5);
                        }];
                        
                    }else{
                        [auctionView setupBidBtns];
                    }
                }else{
                    // luck buy
                    [auctionView setupBidBtns];

                    auctionView.statusLabel.hidden = YES;
                    auctionView.startPrice.text = [NSString stringWithFormat:@"商品金额 ￥%0.2f",[auctionView.dataMd.GoodsStartPrice floatValue]];
                    auctionView.joinPeople.text = [NSString stringWithFormat:@"已购总额 ￥%0.2lf",[auctionView.dataMd.CurrentPrice floatValue]];
                    auctionView.sliderView.minValue = 1;
                    auctionView.sliderView.maxValue = [auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue];
                    
//                    auctionView.textField.text = [NSString stringWithFormat:@"%0.0lf",[auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue]];
                    
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    auctionView.containView.frame = CGRectMake(10, WKScreenH - containHeight - 15, WKScreenW - 20, containHeight);
                }];
            }
            [self xw_addNotificationForName:@"LIVEEND" block:^(NSNotification * _Nonnull notification) {
                [auctionView.timer invalidate];
                auctionView.timer = nil;
            }];
        }
    }
}

//
- (void)getMyMoneyCanTake{
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        NSNumber *moneyCanTake = response.Data[@"MoneyCanTake"];
        auctionView.balanceLabel.text = [NSString stringWithFormat:@"余额 %0.2lf",[moneyCanTake floatValue]];
        auctionView.moneyCanTake = moneyCanTake.floatValue;
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

//MARK:Crowd Or Auction offer a price
- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 1009) {
        // confirmed to join crowd
        if ([auctionView.textField.text containsString:@"."]) {
            [WKPromptView showPromptView:@"金额不能是小数"];
            return;
        }
        
        CGFloat price = [auctionView.textField.text floatValue];
        CGFloat lastPrice = auctionView.dataMd.GoodsStartPrice.floatValue - auctionView.dataMd.CurrentPrice.floatValue;
        if (price > lastPrice) {
            [WKPromptView showPromptView:@"出价超出剩余金额"];
            auctionView.textField.text = [NSString stringWithFormat:@"%0.0lf",[auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue]];
            [auctionView.sliderView reloadDataWithCurrentValue: [auctionView.dataMd.GoodsStartPrice floatValue] - [auctionView.dataMd.CurrentPrice floatValue]];
            return;
        }
        
        NSDictionary *param = @{@"SpecialSaleID":auctionView.dataMd.SpecialSaleID,
                                @"SaleType":auctionView.dataMd.SaleType,
                                @"CurrentPrice":auctionView.dataMd.CurrentPrice,
                                @"AddPrice":@(price),
                                @"From":FROMCLIENT      // 从那个客户端 3
                                };
        [WKHttpRequest AuctionJoin:HttpRequestMethodPost url:WKAuctionJoin model:nil param:param success:^(WKBaseResponse *response) {
            NSLog(@"response %@",response);
            
            auctionView.textField.text = @"";
            BOOL rechargeSuccess = [response.Data boolValue];
            if (!rechargeSuccess) {
//                [WKPromptView showPromptView:response.json[@"ResultMessage"]];
//                [WKShowInputView showInputWithPlaceString:response.ResultMessage type:LABELTYPE andBlock:^(NSString *str) {
//                    [auctionView toRechargeView];
//                }];
                [WKSelectIndexView showWithText:response.ResultMessage btnTitles:@[@"取消",@"去充值"] SelectIndex:^(NSInteger index) {
                    if (index == 1) {
                        [auctionView toRechargeView];
                    }
                }];
            }else{
                [auctionView dismissView:auctionView.maskBtn];
                [auctionView.textField resignFirstResponder];
            }
            
            [self getMyMoneyCanTake];
            

        } failure:^(WKBaseResponse *response) {
            auctionView.isRewarding = NO;
            //[WKProgressHUD showTopMessage:response.ResultMessage];
        }];
        
    }else{
        [auctionView joinAuctionWithAddPrice:@"0"];
    }
}

- (UIView *)setupDescView{
    UIView *descView = [UIView new];
    
    UILabel *descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:12.0f];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentLeft;
    [descView addSubview:descLabel];
    
    descLabel.text = @"提示:1.确认参与拍卖后,平台将从你的余额中扣除商品起拍价\n2.每次举牌竞价都会从余额中扣除相应金额\n3.如果没有拍得商品,所扣金额将全部返还到你的账户余额中";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:auctionView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认参与拍卖" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    btn.layer.cornerRadius = 3.0;
    btn.tag = 1001;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [descView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-15);
        make.height.mas_offset(35);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.and.top.and.right.mas_offset(0);
        make.left.top.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-10);
    }];
    
    return descView;
}

- (void)setupBidBtns{
    [auctionView.descView removeFromSuperview];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [auctionView.containView addSubview:lineView];
    
    UILabel *myOfferPrice = [UILabel new];
    myOfferPrice.textColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
    myOfferPrice.textAlignment = NSTextAlignmentLeft;
    myOfferPrice.font = [UIFont systemFontOfSize:14.f];
    myOfferPrice.text = [NSString stringWithFormat:@"我已出价 ￥%0.2f",[auctionView.dataMd.Price floatValue]];
    [auctionView.containView addSubview:myOfferPrice];
    auctionView.myFeeLabel = myOfferPrice;
    
    UIImage *arrow = [UIImage imageNamed:@"arrow_recharge"];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:arrow];
    [auctionView.containView addSubview:arrowImg];
    
    UIImage *recharge = [UIImage imageNamed:@"gold"];
    
    UIImageView *rechargeImg = [[UIImageView alloc] initWithImage:recharge];
    [auctionView.containView addSubview:rechargeImg];
    
    UILabel *myFeeText = [UILabel new];
    myFeeText.font = [UIFont systemFontOfSize:14.0f];
    myFeeText.textAlignment = NSTextAlignmentRight;
    myFeeText.userInteractionEnabled = YES;
    myFeeText.text = [NSString stringWithFormat:@"余额 %0.2lf",auctionView.moneyCanTake];
    myFeeText.textColor = [UIColor colorWithRed:0.91 green:0.77 blue:0.22 alpha:1.00];
    //    myFeeText.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [auctionView.containView addSubview:myFeeText];
    auctionView.balanceLabel = myFeeText;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:auctionView action:@selector(toRechargeView)];
    [myFeeText addGestureRecognizer:tap];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-50);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(1);
    }];
    
    [myOfferPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(5);
        make.size.mas_offset(CGSizeMake(180, 40));
    }];
    
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(arrow.size);
        make.right.mas_offset(-10);
        make.centerY.mas_equalTo(myOfferPrice);
    }];
    
    [rechargeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(arrowImg);
        make.size.mas_offset(recharge.size);
        make.right.mas_equalTo(arrowImg.mas_left).offset(-10);
    }];
    
    [myFeeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rechargeImg.mas_left).offset(-10);
        make.centerY.mas_equalTo(arrowImg).offset(0);
        make.size.mas_offset(CGSizeMake(150, 40));
    }];
    
    if (auctionView.dataMd.SaleType.integerValue == 1) {
        // bottom bid btn
        NSArray *priceArr = [auctionView getPriceArrWithCurrentPrice:auctionView.dataMd.CurrentPrice];
        
        NSMutableArray *arr = @[].mutableCopy;
        
        CGFloat itemScale = 0.76;
        CGFloat itemWidth = 80;
        
        for (int i=0; i<priceArr.count; i++) {
            NSString *price = [NSString stringWithFormat:@"%@",priceArr[i]];
            
            CGRect rect = CGRectMake(auctionView.containView.frame.size.width/8 + i * auctionView.containView.frame.size.width/4, auctionView.containView.frame.size.height - itemWidth, itemWidth * itemScale, itemWidth);
            
            WKRaiseItem *btn = [[WKRaiseItem alloc] initWithFrame:rect price:price screenType:WKGoodsLayoutTypeVertical];
            [btn addTarget:auctionView action:@selector(selectedPrice:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1000 + i;
            [auctionView.containView addSubview:btn];
            [arr addObject:btn];
            
            CGFloat centerX;
            if (i == 0) {
                centerX = -auctionView.containView.frame.size.width * 3/8;
            }else if (i == 1){
                centerX = -auctionView.containView.frame.size.width/8;
            }else if (i == 2){
                centerX = auctionView.containView.frame.size.width/8;
            }else{
                centerX = auctionView.containView.frame.size.width * 3/8;
            }
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(itemWidth * 0.76, itemWidth));
                make.centerX.mas_equalTo(centerX);
                make.top.mas_equalTo(auctionView.statusLabel.mas_bottom).offset(5);
            }];
            
        }
        auctionView.btnArr = arr;
    }else{
        
        // slider
        RHSliderView *slider = [[RHSliderView alloc] initWithFrame:CGRectZero];
        slider.minValue = 1;
        slider.maxValue = auctionView.dataMd.GoodsStartPrice.integerValue - auctionView.dataMd.CurrentPrice.integerValue;
        [slider addTarget:auctionView selector:@selector(sliderChange:)];
        [auctionView.containView addSubview:slider];
        
        auctionView.sliderView = slider;
        
        // input text
        UITextField *textField = [UITextField new];
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.placeholder = @"请输入价格";
        textField.text = @"1";
//        textField.delegate = auctionView;
//        [textField addTarget:auctionView action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.backgroundColor = [UIColor colorWithRed:0.27 green:0.26 blue:0.28 alpha:1.00];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textColor = [UIColor whiteColor];
        textField.leftViewMode = UITextFieldViewModeAlways;
        [auctionView.containView addSubview:textField];

        auctionView.textField = textField;
        
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 35)];
        unitLabel.text = @"￥";
        unitLabel.font = [UIFont systemFontOfSize:14.0f];
        unitLabel.textColor = [UIColor whiteColor];
        unitLabel.textAlignment = NSTextAlignmentRight;
        textField.leftView = unitLabel;
        
        // confirm btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn addTarget:auctionView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
        btn.layer.cornerRadius = 3.0;
        btn.tag = 1009;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [auctionView.containView addSubview:btn];
        
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(auctionView.iconImage.mas_bottom).offset(30);
            make.left.mas_offset(20);
            make.right.mas_offset(-20);
            make.height.mas_offset(30);
        }];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lineView.mas_top).offset(-10);
            make.left.mas_equalTo(lineView.mas_left).offset(0);
            make.size.mas_offset(CGSizeMake(WKScreenW * 0.6, 35));
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(textField);
            make.left.mas_equalTo(textField.mas_right).offset(15);
            make.size.mas_offset(CGSizeMake(WKScreenW * 0.23, 35));
        }];
    }
}

//- (void)textChanged:(UITextField *)textField {
//    textField.text = [NSString stringWithFormat:@"￥%0.2f",[textField.text floatValue]];
//}

- (void)sliderChange:(RHSliderView *)slider{
    auctionView.textField.text = [NSString stringWithFormat:@"%ld",(long)slider.currentValue];
}

//MARK: push to recharge viewcontroller
- (void)toRechargeView{
    if (auctionView.completionBlock) {
        auctionView.completionBlock(WKCallBackTypeToRecharge);
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return auctionView.containView;
//}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    
//}

#pragma mark - 计算举牌价格，向上取整
- (NSArray *)getPriceArrWithCurrentPrice:(NSNumber *)currentPrice
{
    //起拍价格
    double startPrice = auctionView.dataMd.GoodsStartPrice.doubleValue;
    
    //竞拍价格
    double totalPrice  = currentPrice.doubleValue;
    
    //得到商
    double tp =  totalPrice/startPrice;
    
    if(tp > 1)
    {
        NSInteger temp = 2;
        while (1 == 1)
        {
            if(tp == 2)
            {
                break;
            }
            else if(temp > tp)
            {
                temp = temp / 2;
                break;
            }
            else
            {
                temp = temp * 2;
            }
        }
        
        //获得当前的起拍价基数
        startPrice = startPrice * temp ;
    }
    
    //根据起拍价的倍数，算出举牌的值
    NSInteger price0 = ceil(startPrice * 0.05);
    NSInteger price1 = price0 * 2;
    NSInteger price2 = price0 * 4;
    NSInteger price3 = price0 * 10;
    
    //当最后一块牌子金额大于10000时，固定取值
    if (price3 >= 10000)
    {
        price0 = 1000;
        price1 = 2000;
        price2 = 4000;
        price3 = 9999;
    }
    
    return @[@(price0),@(price1),@(price2),@(price3)];
}

- (void)selectedPrice:(WKRaiseItem *)btn{
    
    if (auctionView.dataMd.isMostHighPrice) {
        [WKProgressHUD showTopMessage:@"土豪,等一下你的小伙伴吧!"];
    }else{
        if (auctionView.selectedItem) {
            [auctionView.selectedItem setSelected:NO];
        }
        btn.selected = !btn.selected;
        auctionView.selectedItem = btn;
        [self joinAuctionWithAddPrice:btn.price];

        if (btn.price.floatValue > auctionView.moneyCanTake) {
//            [WKCustomAlert alertMessage:@"余额不足,是否去充值?" WithButtons:@[@"取消",@"确定"] callBack:^(NSUInteger idx) {
//                if (idx == 1) {
//                    [self toRechargeView];
//                }
//            }];
            
        }else{
        }
    }
}

// MARK: 更新拍卖时间
- (void)updateTime:(NSTimer *)timer{
    auctionView.startCountTime--;

    if (auctionView.startCountTime > 0) {
        NSString *unit;
        NSUInteger remainTime;
        
        if (auctionView.startCountTime >= 60) {
            remainTime = auctionView.startCountTime/60;
            unit = @"min";
        }else{
            remainTime = auctionView.startCountTime;
            unit = @"s";
        }
        
        [auctionView.duration setTitle:[NSString stringWithFormat:@"  %zd%@",remainTime,unit] forState:UIControlStateNormal];
    }else{
        [auctionView.timer invalidate];
        auctionView.timer = nil;
//        [WKPromptView showPromptView:@"拍卖结束"];
        auctionView.userInteractionEnabled = NO;
        
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
        
//        dispatch_after(time, dispatch_get_main_queue() , ^{
//            [auctionView dismissView:auctionView.maskBtn];
//        });
        
    }
    
}
-(void)changeTouch{
    self.isTouch = NO;
}

//MARK: 点击查看拍卖品详情
- (void)tapAuctionGoods{
    if (self.isTouch) {
        return;
    }
    self.isTouch = YES;
    [self performSelector:@selector(changeTouch) withObject:nil afterDelay:0.5];
    if (auctionView.dataMd.GoodsCode.integerValue == 0) {
        // 快速商品
        
        if (auctionView.isPlaying) {
            [[PlayerManager sharedManager] stopPlaying];
            return;
        }
        
        [self xw_postNotificationWithName:@"AUDIOPLAYING" userInfo:@{@"isPlaying":@1}];
        
        NSMutableArray *arr = @[].mutableCopy;
        for (int i=1; i<15; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%dluyin",i]];
            [arr addObject:image];
        }
        
        UIImage *playImageCircle = [UIImage imageNamed:@"backYuan"];
        auctionView.iconImage.image = [UIImage imageNamed:@""];
        
        UIImageView *playImageCircleV = [[UIImageView alloc] init];
        playImageCircleV.tag = 100;
        playImageCircleV.animationImages = arr;
        playImageCircleV.animationDuration = 5.0f;
        
        [playImageCircleV startAnimating];
        
        [auctionView.iconImage addSubview:playImageCircleV];
        
        UIImage *playImage = [UIImage imageNamed:@"kuai"];
        UIImageView *playingImageV = [[UIImageView alloc] initWithImage:playImage];
        playingImageV.tag = 101;
        [auctionView.iconImage addSubview:playingImageV];
        
        [playImageCircleV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(auctionView.iconImage);
            make.size.mas_offset(playImageCircle.size);
        }];
        
        [playingImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(playImage.size);
            make.center.mas_equalTo(auctionView.iconImage);
        }];
        
        [WKPlayTool writeFileWithStr:auctionView.dataMd.GoodsPic :^(NSString *voicePath, NSString *requestMessage) {
            if ([requestMessage isEqualToString:@"写入成功"]) {
                [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:auctionView];
                auctionView.isPlaying = YES;
            }else{
                NSLog(@"%@",requestMessage);
            }
        }];
        
    }else{
        
        // 普通拍卖
        if (auctionView.completionBlock) {
            self.completionBlock(WKCallBackTypeAuction);
        }
        
        [auctionView dismissView:auctionView.maskBtn];
    }
}

- (void)playingStoped{
    auctionView.isPlaying = NO;
    
    [self xw_postNotificationWithName:@"AUDIOPLAYING" userInfo:@{@"isPlaying":@0}];
    
    UIImageView *animationImgV = [auctionView.iconImage viewWithTag:100];
    [animationImgV stopAnimating];
    
    UIImageView *blockImgV = [auctionView.iconImage viewWithTag:101];
    [blockImgV removeFromSuperview];
    
    [animationImgV removeFromSuperview];
    auctionView.iconImage.image = [UIImage imageNamed:@"play01"];
}

#pragma mark - 隐藏
- (void)dismissView:(UIButton *)btn{
    //    auctionView.containView.backgroundColor = [UIColor ]
    if (auctionView.type == WKGoodsLayoutTypeHoriztal) {
        
        CGFloat screenScale = 0.4 * auctionView.screenScale;
        
        [UIView animateWithDuration:0.2 animations:^{
            auctionView.maskBtn.alpha = 0;
            auctionView.containView.frame = CGRectMake(WKScreenW, 0, WKScreenW * screenScale, WKScreenH);
        } completion:^(BOOL finished) {
            [auctionView.maskBtn removeFromSuperview];
            [auctionView removeFromSuperview];
            [auctionView.timer invalidate];
            auctionView.timer = nil;
            auctionView = nil;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            auctionView.maskBtn.alpha = 0;
            
            auctionView.containView.frame = CGRectMake(10, WKScreenH, WKScreenW - 20, auctionView.containView.frame.size.height);
            
        } completion:^(BOOL finished) {
            [auctionView.maskBtn removeFromSuperview];
            [auctionView removeFromSuperview];
            [auctionView.timer invalidate];
            auctionView.timer = nil;
            auctionView = nil;
            
        }];
    }
    
    if (auctionView.isPlaying) {
        [[PlayerManager sharedManager] stopPlaying];
        [PlayerManager sharedManager].delegate = nil;
    }
}

// MARK: bid func,if addPrice is zero, it's confirm to join auction
- (void)joinAuctionWithAddPrice:(NSString *)addPrice{
    
    if (addPrice.integerValue != 0) {
        for (int i=0; i<auctionView.btnArr.count; i++) {
            UIButton *btn = auctionView.btnArr[i];
            btn.userInteractionEnabled = NO;
        }
    }
    
    NSDictionary *param = @{@"SpecialSaleID":auctionView.dataMd.SpecialSaleID,
                            @"SaleType":auctionView.dataMd.SaleType,
                            @"CurrentPrice":auctionView.dataMd.CurrentPrice,
                            @"AddPrice":addPrice,
                            @"From":FROMCLIENT      // 从那个客户端 3
                            };
    [WKHttpRequest AuctionJoin:HttpRequestMethodPost url:WKAuctionJoin model:nil param:param success:^(WKBaseResponse *response) {
        
        BOOL result = [response.Data boolValue];
        if (!result) {
//            [WKShowInputView showInputWithPlaceString:response.ResultMessage type:LABELTYPE andBlock:^(NSString *str) {
//                [self toRechargeView];
//
//            }];
            [WKSelectIndexView showWithText:response.ResultMessage btnTitles:@[@"取消",@"去充值"] SelectIndex:^(NSInteger index) {
                if (index == 1) {
                    [auctionView toRechargeView];
                }
            }];
            
        }else{

            if (addPrice.integerValue == 0) {
                auctionView.dataMd.IsJoin = YES;
                [auctionView setupBidBtns];
            }else{
                [self animationAuctionSuccessWithPrice:addPrice];
                [auctionView getMyMoneyCanTake];
            }
        }
        
        NSLog(@"参与拍卖或出价成功");
        
    } failure:^(WKBaseResponse *response) {
        auctionView.isRewarding = NO;
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

- (void)animationAuctionSuccessWithPrice:(NSString *)price{
    
    //[WKAnimationHelper showAnimation:WKAimationBid OnView:nil withInfo:price callback:NULL];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        //        auctionView.containView.userInteractionEnabled = NO;
        //        keyWindow.userInteractionEnabled = NO;
        auctionView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        
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
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [animationView addSubview:switchImage];
            
            switchImage.layer.transform = CATransform3DMakeRotation(M_PI/2, 1, 0, 0);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                switchImage.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                [switchImage removeFromSuperview];
                
                [animationView addSubview:animationItem];
                
                animationItem.frame = CGRectMake(0, 0, image.size.width* auctionView.screenScale, image.size.height* auctionView.screenScale);
                animationItem.center = CGPointMake(animationView.frame.size.width/2, animationView.frame.size.height/2 + 40 * auctionView.screenScale);
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    animationItem.layer.anchorPoint = CGPointMake(0.5, 1.0);
                    animationItem.transform = CGAffineTransformMakeRotation(25 * (M_PI / 180.0f));
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        animationItem.transform = CGAffineTransformMakeRotation(-25 * (M_PI / 180.0f));
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            animationItem.transform = CGAffineTransformMakeRotation(18 * (M_PI / 180.0f));
                            
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                animationItem.transform = CGAffineTransformMakeRotation( -10 * (M_PI / 180.0f));
                                
                            } completion:^(BOOL finished) {
                                
                                [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    
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
                                        
                                        [auctionView dismissView:auctionView.maskBtn];

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
        
    });
}

+ (void)dismissView{
    if (auctionView) {
        [auctionView dismissView:auctionView.maskBtn];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
