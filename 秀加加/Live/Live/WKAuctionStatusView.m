//
//  WKAuctionStatusView.m
//  秀加加
//
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionStatusView.h"
#import "WKAuctionStatusModel.h"
#import "NSObject+XWAdd.h"
#import "PlayerManager.h"
#import "WKPlayTool.h"
#import "NSString+substring.h"
#import "WKCrowdProgressView.h"

@interface WKAuctionStatusView () <PlayingDelegate>

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIView *containView;

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *startPrice;
@property (nonatomic,strong) UIButton *duration;
@property (nonatomic,strong) UILabel *joinPeople;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *goodsPrice;
@property (nonatomic,strong) UIButton *nextAuction;
@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) UILabel *reminderLabel; // 提示文字

@property (nonatomic,copy)   ClickBlock block;
@property (nonatomic,strong) WKAuctionStatusModel *dataMd;
@property (nonatomic,assign) WKGoodsLayoutType type;       // 布局类型
@property (nonatomic,assign) WKAuctionType     clientType; // 客户端类型

@property (nonatomic,assign) NSUInteger startCountTime;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL isPlaying;
@property (assign, nonatomic) BOOL isTouch;

@property (nonatomic,strong) WKCrowdProgressView *progressView;

@property (nonatomic,strong) UIButton *auctionBtn;
@property (nonatomic,strong) UIButton *luckbuyBtn;
@property (nonatomic,strong) UILabel *descLabel;

@property (nonatomic,copy) NSString *auctionStr;  // auction desc str
@property (nonatomic,copy) NSString *luckbuyStr;  // luck buy desc str

@end

static WKAuctionStatusView *auctionView = nil;

@implementation WKAuctionStatusView

+ (void)showWithModel:(id)model screenOrientation:(WKGoodsLayoutType)screenType clientType:(WKAuctionType)clientType completionBlock:(ClickBlock)block{

    WKAuctionStatusModel *md = model;
    if (auctionView == nil) {
        @synchronized (self) {

            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            
            auctionView = [[WKAuctionStatusView alloc] init];
            auctionView.frame = keyWindow.bounds;
            auctionView.backgroundColor = [UIColor clearColor];
            [keyWindow addSubview:auctionView];
            
            auctionView.dataMd = model;
            auctionView.type = screenType;
            auctionView.clientType = clientType;
            auctionView.startCountTime = md.RemainTime.integerValue - 1;
//MARK: setup UI
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = keyWindow.bounds;
            maskBtn.backgroundColor = [UIColor clearColor];
            [maskBtn addTarget:auctionView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            auctionView.maskBtn = maskBtn;
            [auctionView addSubview:maskBtn];
            
            // bg imageView
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, WKScreenH, WKScreenW - 20, 0)];
            bgView.backgroundColor = [UIColor clearColor];
            bgView.userInteractionEnabled = YES;
            [auctionView addSubview:bgView];
            auctionView.containView = bgView;
            
            UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auction_bg"]];
            [auctionView.containView addSubview:bgImageV];
            
            CGFloat itemHeight;
            if (WKScreenW == 320) {
                itemHeight = WKScreenH * 0.28;
            }else{
                itemHeight = WKScreenH * 0.25;
            }
            
            // if the model is nil, pop the introduction of activity
            if (!model) {
                // first time to show, reminder user how to start the activity
                itemHeight = 250;

                NSString *auctionStr = @"宝贝身价飙升，物尽其值，直播间即是拍卖场，全民举牌，价高者得！\n1.起拍价即为保证金额度，参与拍卖需要提交保证金;\n2.拍卖出价需从余额扣款做冻结处理，请保证账户余额充足;\n3.拍卖成功，平台收取10%服务费，拍卖失败无任何费用; \n4.拍卖结束时，出价最高者支付尾款后获得宝贝 \n5.拍卖发起后，不可强制结束.";
                auctionView.auctionStr = auctionStr;
                
                NSString *luckBuyStr = @"宝贝虽昂贵，人人有机会，幸运购教你玩儿！通过幸运购，把一件宝贝分成若干份，让小伙伴们一起来购买，再由一位幸运者拔得头筹。\n1.幸运购期间,购买总额未达到设定金额，则失败，退换所有支付金; \n2.幸运购成功,平台收取10%服务费，若失败，无任何费用;\n3.幸运购宝贝随机发放，购买额度越高，获得几率越大;\n4.用户在幸运购期间购满设定金额即结束，超时失败;\n5.幸运购发起后，不可强制结束.";
                auctionView.luckbuyStr = luckBuyStr;
                
                UILabel *titleLabel = [UILabel new];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.font = [UIFont systemFontOfSize:14.0f];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = @"拍卖/幸运购活动";
                [auctionView.containView addSubview:titleLabel];
                
                UILabel *lab = [[UILabel alloc] init];
                lab.text = auctionStr;
                lab.textColor = [UIColor whiteColor];
                lab.numberOfLines = 0;
//                lab.backgroundColor = [UIColor redColor];
                lab.font = [UIFont systemFontOfSize:12.0f];
                lab.textAlignment = NSTextAlignmentLeft;
                [auctionView.containView addSubview:lab];
                auctionView.descLabel = lab;
                
                UIButton *auctionBtn = [UIButton buttonWithType:0];
                [auctionBtn setTitle:@"拍卖介绍" forState:UIControlStateNormal];
                [auctionBtn setTitleColor:[UIColor colorWithHexString:@"#FC6621"] forState:UIControlStateNormal];
                [auctionBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [auctionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [auctionBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#FC6621"]] forState:UIControlStateSelected];
                [auctionBtn setBackgroundColor:[UIColor whiteColor]];
                [auctionBtn addTarget:auctionView action:@selector(selectDescText:) forControlEvents:UIControlEventTouchUpInside];
                [auctionView.containView addSubview:auctionBtn];
                auctionBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                auctionBtn.selected = YES;
                auctionView.auctionBtn = auctionBtn;

                UIButton *luckBuyBtn = [UIButton buttonWithType:0];
                [luckBuyBtn setTitle:@"幸运购介绍" forState:UIControlStateNormal];
                [luckBuyBtn setTitleColor:[UIColor colorWithHexString:@"#FC6621"] forState:UIControlStateNormal];
                [luckBuyBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                luckBuyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [luckBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [luckBuyBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#FC6621"]] forState:UIControlStateSelected];
                [luckBuyBtn setBackgroundColor:[UIColor whiteColor]];
                [luckBuyBtn addTarget:auctionView action:@selector(selectDescText:) forControlEvents:UIControlEventTouchUpInside];
                [auctionView.containView addSubview:luckBuyBtn];
                auctionView.luckbuyBtn = luckBuyBtn;
                
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(auctionView.containView);
                    make.top.mas_offset(0);
                    make.size.mas_offset(CGSizeMake(150, 25));
                }];
                
                [auctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(auctionView.containView.mas_centerX).offset(-20);
                    make.size.mas_offset(CGSizeMake(100, 35));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-15);
                }];
                
                [luckBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(auctionView.containView.mas_centerX).offset(20);
                    make.size.mas_offset(CGSizeMake(100, 35));
                    make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-15);
                }];
                
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
                    make.left.mas_offset(30);
                    make.right.mas_offset(-30);
                    make.bottom.mas_equalTo(luckBuyBtn.mas_top).offset(-10);
                }];
                
                [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                
                [UIView animateWithDuration:0.3 animations:^{
                    auctionView.containView.frame = CGRectMake(10, WKScreenH - itemHeight - 10, WKScreenW - 20, itemHeight);
                }];
                
                return;
            }
            
            if (auctionView.dataMd.Status.integerValue == 0) {
                // 暂无拍卖品
                UILabel *reminderLabel = [UILabel new];
                reminderLabel.text = @"亲主播还没开始拍卖!\n去其他地方看看吧";
                reminderLabel.textColor = [UIColor lightGrayColor];
                reminderLabel.numberOfLines = 0;
                reminderLabel.font = [UIFont systemFontOfSize:14.0f];
                reminderLabel.textAlignment = NSTextAlignmentCenter;
                [auctionView.containView addSubview:reminderLabel];
                
                UIImage *image = [UIImage imageNamed:@"noAuction"];
                UIImageView *reminderImage = [[UIImageView alloc] initWithImage:image];
                [auctionView.containView addSubview:reminderImage];
                
                [reminderImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(auctionView.containView.mas_centerY).offset(-20);
                    make.size.mas_offset(image.size);
                    make.centerX.mas_equalTo(auctionView.containView);
                }];
                
                [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(reminderImage.mas_bottom).offset(0);
                    make.centerX.mas_equalTo(auctionView.containView);
                    make.width.mas_equalTo(auctionView.containView);
                    make.height.mas_equalTo(60);
                }];
                
                itemHeight = 250;
                // 竖屏
                auctionView.containView.frame = CGRectMake(0, WKScreenH, WKScreenW, itemHeight);
                
                [UIView animateWithDuration:0.3 animations:^{
                    auctionView.containView.frame = CGRectMake(10, WKScreenH - itemHeight, WKScreenW - 20, itemHeight);
                }];
                
                return;
            }
            
                // 图片
            UIImageView *iconImage = [UIImageView new];
            iconImage.contentMode = UIViewContentModeScaleAspectFill;
            iconImage.clipsToBounds = YES;
            iconImage.userInteractionEnabled = YES;
            
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
                    make.top.mas_offset(20);
                    make.right.mas_equalTo(iconImage.mas_right).offset(-20);
                    make.size.mas_offset(CGSizeMake(30, 20));
                }];
                
            }else{
                // 普通拍卖
                [iconImage sd_setImageWithURL:[NSURL URLWithString:md.GoodsPic] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            }
            
            auctionView.iconImage = iconImage;
            [auctionView.containView addSubview:iconImage];
            
            // present to goods detail vc
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:auctionView action:@selector(tapAuctionGoods)];
            [iconImage addGestureRecognizer:tap];
            
            // 名字
            UILabel *nameLabel = [UILabel new];
            nameLabel.font = [UIFont systemFontOfSize:14.0f];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [UIColor whiteColor];
            if (auctionView.dataMd.GoodsName.length == 0 || !auctionView.dataMd.GoodsName) {
                nameLabel.text = @"语言商品";
            }else{
                nameLabel.text = md.GoodsName;
            }
            nameLabel.numberOfLines = 0;
            auctionView.nameLabel = nameLabel;
            [auctionView.containView addSubview:nameLabel];
            
            // 起拍价
            UILabel *startPrice = [UILabel new];
            startPrice.font = [UIFont systemFontOfSize:12.0f];
            startPrice.textAlignment = NSTextAlignmentLeft;
            startPrice.textColor = [UIColor lightGrayColor];
            startPrice.adjustsFontSizeToFitWidth = YES;
            startPrice.text = [NSString stringWithFormat:@"起拍价 ￥%0.2f",[md.GoodsStartPrice floatValue]];
            auctionView.startPrice = startPrice;
            [auctionView.containView addSubview:startPrice];
            
            if(md.SaleType.integerValue == 2){
                startPrice.text = [NSString stringWithFormat:@"商品金额 ￥%0.2f",[md.GoodsStartPrice floatValue]];
            }
            // 时间
            UIButton *durationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [durationBtn setTitle:[NSString stringWithFormat:@"  %@s",md.RemainTime] forState:UIControlStateNormal];
            [durationBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
            
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
            durationBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            auctionView.duration = durationBtn;
            [durationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [auctionView.containView addSubview:durationBtn];
            
            // 当前参数人数
            UILabel *joinLabel = [UILabel new];
            
//MARK: KVO
            if(md.SaleType.integerValue == 1){
                
                [md xw_addObserverBlockForKeyPath:@"Count" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                    
                    if (auctionView.clientType == WKAuctionTypePushFlow) {
                        auctionView.joinPeople.text = [NSString stringWithFormat:@"当前参与人数  %@",auctionView.dataMd.Count];
                    }else{
                        auctionView.joinPeople.text = [NSString stringWithFormat:@"总参与人数  %@",auctionView.dataMd.Count];
                    }
                }];
            }
            if(md.SaleType.integerValue == 2){
                
                [md xw_addObserverBlockForKeyPath:@"CurrentPrice" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                    if (md.Status.integerValue == 3) {
                        auctionView.joinPeople.text = [NSString stringWithFormat:@"总参与人数  %@",auctionView.dataMd.Count];
                    }else{
                        auctionView.joinPeople.text = [NSString stringWithFormat:@"已购总额  %@",auctionView.dataMd.CurrentPrice];
                        CGFloat value = auctionView.dataMd.CurrentPrice.floatValue/auctionView.dataMd.GoodsStartPrice.floatValue;
                        [auctionView.progressView setProgressValue:value];
                    }
                }];
                
                [md xw_addObserverBlockForKeyPath:@"Count" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                    
                    if (md.Status.integerValue == 3) {
                        auctionView.joinPeople.text = [NSString stringWithFormat:@"总参与人数  %@",auctionView.dataMd.Count];
                    }else{
                        auctionView.joinPeople.text = [NSString stringWithFormat:@"已购总额  %@",auctionView.dataMd.CurrentPrice];
                        if (md.Status.integerValue == 1) {
                            auctionView.statusLabel.text = [NSString stringWithFormat:@"参与人数 %@",auctionView.dataMd.Count];
                        }
                    }
                }];
            }
            
            joinLabel.textColor = [UIColor lightGrayColor];
            joinLabel.textAlignment = NSTextAlignmentLeft;
            joinLabel.font = [UIFont systemFontOfSize:12.0f];
            auctionView.joinPeople = joinLabel;
            [auctionView.containView addSubview:joinLabel];
            
            // 所有人
            UILabel *ownerLabel = [UILabel new];
            if(md.CurrentMemberName != nil && ![md.CurrentMemberName  isEqual: @""]){
            ownerLabel.text = [NSString stringWithFormat:@"%@  ￥%.2f",[md.CurrentMemberName subEmojiStringTo:6 with:@"..."],md.CurrentPrice.floatValue];
            }
            ownerLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
            ownerLabel.font = [UIFont systemFontOfSize:14.0f];
            ownerLabel.textAlignment = NSTextAlignmentLeft;
            auctionView.statusLabel = ownerLabel;
            [auctionView.containView addSubview:ownerLabel];

            [auctionView.dataMd xw_addObserverBlockForKeyPath:@"CurrentPrice" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                ownerLabel.text = [NSString stringWithFormat:@"%@  ￥%0.2f",[auctionView.dataMd.CurrentMemberName subEmojiStringTo:6 with:@"..."],[newVal floatValue]];
            }];
            
            // 提示label
            UILabel *reminder = [UILabel new];
            reminder.textColor = [UIColor lightGrayColor];
            reminder.font = [UIFont systemFontOfSize:12.0f];
            reminder.textAlignment = NSTextAlignmentLeft;
            reminder.numberOfLines = 0;
//            reminder.text = @"恭喜您成功拍得此商品,请在60分钟内支付,否则系统将抵扣你的保证金";
            auctionView.reminderLabel = reminder;
//            auctionView.reminderLabel.hidden = YES;
            [auctionView.containView addSubview:reminder];
            
            // 下次拍卖按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:auctionView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            btn.layer.borderWidth = 1.0;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
            
            auctionView.nextAuction = btn;
            [auctionView.containView addSubview:btn];
            
            // 拍卖状态图片
            UIImageView *statusImage = [UIImageView new];
            auctionView.statusImage = statusImage;
            [auctionView.containView addSubview:statusImage];
            
            // crowding progress
            WKCrowdProgressView *progressView = [[WKCrowdProgressView alloc] init];
            auctionView.progressView = progressView;
            
//MARK: SET VALUE
            // activity _ing
            if (md.Status.integerValue == 1) {
                btn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
                btn.hidden = YES;
                auctionView.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:auctionView selector:@selector(updateTime:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:auctionView.timer forMode:NSRunLoopCommonModes];

                if(md.SaleType.integerValue == 1){
                    auctionView.joinPeople.text = [NSString stringWithFormat:@"当前参与人数  %@",md.Count];
                }
                else{
                    auctionView.joinPeople.text = [NSString stringWithFormat:@"已购总额  %@",md.CurrentPrice];
                    [auctionView.containView addSubview:auctionView.progressView];
                    
                    CGFloat progress = auctionView.dataMd.CurrentPrice.floatValue/auctionView.dataMd.GoodsStartPrice.floatValue;
                    [auctionView.progressView setProgressValue:progress];
                    
                    auctionView.statusLabel.hidden = NO;
                    auctionView.statusLabel.text = [NSString stringWithFormat:@"参与人数 %@",auctionView.dataMd.Count];
                }
                
                [md xw_addObserverBlockForKeyPath:@"RemainTime" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                    NSNumber *currentCountTime = newVal;
                    auctionView.startCountTime = currentCountTime.integerValue;
                }];
                
            }else if (md.Status.integerValue == 3){
                // SUCCESS
                joinLabel.text = [NSString stringWithFormat:@"总参与人数  %@",md.Count];
                
                btn.hidden = NO;
                if (auctionView.clientType == WKAuctionTypePushFlow) {
                    auctionView.statusImage.image = [UIImage imageNamed:@"chenggong"];
                    [durationBtn setTitle:[NSString stringWithFormat:@"0min"] forState:UIControlStateNormal];
                    [btn setTitle:@"发起活动" forState:UIControlStateNormal];
                    
                }else{
                    auctionView.statusImage.image = [UIImage imageNamed:@"auctionSuccess"];
                    [durationBtn setTitle:[NSString stringWithFormat:@"0min"] forState:UIControlStateNormal];
                    if (auctionView.dataMd.IsConfirm) {
                        
                        auctionView.nextAuction.hidden = YES;
                        auctionView.reminderLabel.hidden = YES;
                        NSString *str = [NSString stringWithFormat:@"恭喜%@获得此商品",auctionView.dataMd.CurrentMemberName];
                        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
                        
                        auctionView.reminderLabel.attributedText = attributeStr;

                    }else{
                        
                        if (auctionView.dataMd.SaleType.integerValue == 1) {
                            // auction success, not confirm
                            if ([User.BPOID isEqualToString:auctionView.dataMd.CurrentMemberBPOID]) {
                                
                                auctionView.nextAuction.hidden = NO;     //
                                auctionView.reminderLabel.hidden = NO;
                                auctionView.statusLabel.hidden = NO;
                                
                                [auctionView.nextAuction setTitle:@"确认地址" forState:UIControlStateNormal];
                                auctionView.reminderLabel.text = @"恭喜您成功拍得此商品,请在60分钟内支付,否则系统将抵扣你的保证金";
                                auctionView.statusLabel.text = [NSString stringWithFormat:@"%@ ￥%@",auctionView.dataMd.CurrentMemberName,auctionView.dataMd.GoodsStartPrice];
                            }else{
                                
                                auctionView.nextAuction.hidden = YES;
                                auctionView.reminderLabel.hidden = NO;
                                
                                auctionView.statusLabel.hidden = NO;
                                auctionView.statusLabel.text = [NSString stringWithFormat:@"%@  ￥%0.2f",[auctionView.dataMd.CurrentMemberName subEmojiStringTo:6 with:@"..."],[auctionView.dataMd.CurrentPrice floatValue]];
                            }
                            
                        }else{
                            
                            // crowd success, not confirm
                            if ([User.BPOID isEqualToString:auctionView.dataMd.CurrentMemberBPOID]) {
                                [btn setTitle:@"确认地址" forState:UIControlStateNormal];
                                auctionView.nextAuction.hidden = NO;
                                auctionView.reminderLabel.hidden = YES;
                                auctionView.statusLabel.hidden = YES;
                                
                            }else{
                                
                                auctionView.nextAuction.hidden = YES;
                                auctionView.reminderLabel.hidden = NO;
                                
                                NSString *str = [NSString stringWithFormat:@"恭喜%@获得此商品",auctionView.dataMd.CurrentMemberName];
                                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
                                
                                [attributeStr setAttributes:@{NSBackgroundColorAttributeName:[UIColor colorWithHexString:@"#FC6621"]} range:NSMakeRange(2, auctionView.dataMd.CurrentMemberName.length)];
                                auctionView.reminderLabel.attributedText = attributeStr;
                                
                            }
                        }
                    }
                }
                
            }else{
                //FAILURE
                joinLabel.text = [NSString stringWithFormat:@"总参与人数  %@",md.Count];
                [durationBtn setTitle:[NSString stringWithFormat:@"0min"] forState:UIControlStateNormal];

                if (auctionView.clientType == WKAuctionTypePushFlow) {
                    btn.hidden = NO;
                    [btn setTitle:@"发起活动" forState:UIControlStateNormal];
                }else{
                    btn.hidden = YES;
                }
                
                if(md.SaleType.integerValue == 1){
                    auctionView.statusLabel.text = @"流拍";
                    auctionView.statusImage.image = [UIImage imageNamed:@"auctionFail"];               }
                else{
                    auctionView.statusLabel.text = @"失败";
                    auctionView.statusImage.image = [UIImage imageNamed:@"shibai"];
                    auctionView.joinPeople.text = [NSString stringWithFormat:@"已购总额 ¥ %@",md.CurrentPrice];
                    
                    UILabel *allPeople = [[UILabel alloc]init];
                    allPeople.text = [NSString stringWithFormat:@"总参与人数: %@",md.Count];
                    allPeople.textColor = [UIColor colorWithHexString:@"#FC6620"];
                    allPeople.font = [UIFont systemFontOfSize:14.0f];
                    allPeople.textAlignment = NSTextAlignmentLeft;
                    [auctionView.containView addSubview:allPeople];
                    [allPeople mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                        make.top.mas_equalTo(auctionView.joinPeople.mas_bottom).offset(5);
                        make.height.mas_offset(15);
                        make.right.mas_equalTo(auctionView.containView.mas_right).offset(10);
                    }];
                }
            }

            if (md.IsVirtual && clientType == WKClientTypePlay) {
                auctionView.nextAuction.hidden = YES;
            }
            
//MARK: Layout
            if (screenType == WKGoodsLayoutTypeVertical) {
                
                if (auctionView.dataMd.SaleType.integerValue == 2) {
                    itemHeight += 15;
                }
                // 竖屏
                auctionView.containView.frame = CGRectMake(10, WKScreenH, WKScreenW - 20, itemHeight);

                // background imageView
                [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                // 图片
                if (auctionView.dataMd.SaleType.integerValue == 2 && auctionView.dataMd.Status.integerValue == 1) {
                    [auctionView.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_offset(10);
                        make.top.mas_offset(20);
                        make.width.and.height.mas_offset(itemHeight - 80);
                    }];
                    
                    [auctionView.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_offset(10);
                        make.right.mas_offset(-10);
                        make.top.mas_equalTo(auctionView.iconImage.mas_bottom).offset(5);
                        make.bottom.mas_equalTo(auctionView.containView.mas_bottom).offset(-10);
                    }];
                    
                }else{
                    [auctionView.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_offset(10);
                        make.centerY.mas_equalTo(auctionView.iconImage.superview.mas_centerY).offset(0);
//                        make.left.and.top.mas_offset(10);
                        make.width.and.height.mas_offset(itemHeight - 40);
                    }];
                }
                
                // 名字
                [auctionView.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(-10);
                    make.top.mas_equalTo(auctionView.iconImage.mas_top).offset(0);
                    make.height.mas_equalTo(@20);
                }];
                
                [auctionView.duration mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(0);
                    make.top.mas_equalTo(auctionView.nameLabel.mas_bottom).offset(3);
                    make.size.mas_equalTo(CGSizeMake(70, 15));
                }];
                
                // 起拍价
                [auctionView.startPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(auctionView.duration.mas_centerY).offset(0);
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.right.mas_equalTo(auctionView.duration.mas_left).offset(-10);
                    make.height.mas_equalTo(@15);
                }];
                
                // 参与人数
                [auctionView.joinPeople mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                    make.top.mas_equalTo(auctionView.duration.mas_bottom).offset(5);
                    make.height.mas_offset(15);
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(10);
                }];
                
                // 拍卖状态
                if (auctionView.dataMd.Status.integerValue == 2) {
                    [auctionView.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                        make.top.mas_equalTo(auctionView.joinPeople.mas_bottom).offset(20);
                        make.height.mas_equalTo(20);
                        make.right.mas_equalTo(auctionView.containView.mas_right).offset(-5);                  }];
                }else{
                    
                    if (auctionView.dataMd.SaleType.integerValue == 2) {
                        
                        [auctionView.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                            make.bottom.mas_equalTo(auctionView.iconImage.mas_bottom).offset(-5);
                            make.height.mas_equalTo(20);
                            make.right.mas_equalTo(auctionView.containView.mas_right).offset(-5);
                        }];
                        
                    }else{
                        [auctionView.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                            make.top.mas_equalTo(auctionView.joinPeople.mas_bottom).offset(0);
                            make.height.mas_equalTo(20);
                            make.right.mas_equalTo(auctionView.containView.mas_right).offset(-5);
                        }];
                    }
                    
                }
                
                // 按钮
                if (auctionView.reminderLabel.hidden == NO) {
                    [auctionView.nextAuction mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.top.mas_equalTo(auctionView.reminderLabel.mas_bottom).offset(5);
                        make.bottom.mas_equalTo(auctionView.iconImage.mas_bottom).offset(0);
                        make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(10);
                        make.right.mas_equalTo(auctionView.containView.mas_right).offset(-10);
                        make.height.mas_equalTo(30);
                    }];
                }else{
                    [auctionView.nextAuction mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(auctionView.iconImage.mas_bottom).offset(0);
                        make.left.mas_equalTo(auctionView.iconImage.mas_right).offset(15);
                        make.right.mas_equalTo(auctionView.containView.mas_right).offset(-20);
                        make.height.mas_equalTo(30);
                    }];
                }
                
                [auctionView.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(auctionView.containView.mas_centerY);
                    make.right.mas_equalTo(auctionView.containView.mas_right).offset(-20);
                    make.size.mas_offset(auctionView.statusImage.image.size);
                }];
                
                [UIView animateWithDuration:0.3 animations:^{
                    auctionView.containView.frame = CGRectMake(10, WKScreenH - itemHeight - 15, WKScreenW - 20, itemHeight);
                }];
                
            }
            
            auctionView.block = block;
            [self xw_addNotificationForName:@"LIVEEND" block:^(NSNotification * _Nonnull notification) {
                [auctionView.timer invalidate];
                auctionView.timer = nil;
            }];
        }
    }
}

- (void)selectDescText:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([btn isEqual:auctionView.luckbuyBtn]) {
        auctionView.auctionBtn.selected = NO;
        auctionView.descLabel.text = auctionView.luckbuyStr;
    }else{
        auctionView.luckbuyBtn.selected = NO;
        auctionView.descLabel.text = auctionView.auctionStr;
    }
}

+ (void)dismissView {
    if (auctionView) {
        [auctionView dismissView:auctionView.maskBtn];
    }
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
                [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:self];
                auctionView.isPlaying = YES;
                
                [self xw_postNotificationWithName:@"AUDIOPLAYING" userInfo:@{@"isPlaying":@1}];

            }else{
                NSLog(@"%@",requestMessage);
            }
        }];
        
    }else{
        
        if (auctionView.clientType == WKClientTypePushFlow) {
            return;
        }
        
        // 普通拍卖
        if (self.block) {
            self.block(WKCallBackTypeAuction);
        }
        
        [auctionView dismissView:auctionView.maskBtn];
    }
}

- (void)playingStoped{
    auctionView.isPlaying = NO;
    [auctionView.iconImage stopAnimating];
    
    auctionView.iconImage.image = [UIImage imageNamed:@"play01"];
    
    UIImageView *imagePlaying = [auctionView.iconImage viewWithTag:100];
    UIImageView *playAnimation = [auctionView.iconImage viewWithTag:101];
    
    [self xw_postNotificationWithName:@"AUDIOPLAYING" userInfo:@{@"isPlaying":@0}];
    [self xw_postNotificationWithName:@"startAudio" userInfo:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (imagePlaying) {
            [imagePlaying removeFromSuperview];
            imagePlaying.hidden = YES;
        }
        
        if (playAnimation) {
            playAnimation.hidden = YES;
            [playAnimation removeFromSuperview];
        }
        
    });
    
}
-(void)changeTouch{
    self.isTouch = NO;
}
// MARK: 更新拍卖时间
- (void)updateTime:(NSTimer *)timer{
    auctionView.startCountTime--;

    NSString *unit;
    NSInteger remainTime;
    
    if (auctionView.startCountTime >= 60)
    {
        remainTime = auctionView.startCountTime/60;
        unit = @"min";
    }
    else
    {
        if(auctionView.startCountTime <= 0)
        {
            remainTime = 0;
            unit = @"min";
        }
        else
        {
            remainTime = auctionView.startCountTime;
            unit = @"s";
        }
    }
    [auctionView.duration setTitle:[NSString stringWithFormat:@"  %0zd%@",remainTime,unit] forState:UIControlStateNormal];
    
    if (auctionView.startCountTime <= 0)
    {
        [auctionView.timer invalidate];
        auctionView.timer = nil;
        
        if (auctionView.dataMd.Status.integerValue == 3 && auctionView.dataMd.PayStatus.integerValue == 0)
        {
            auctionView.nextAuction.userInteractionEnabled = NO;
            [auctionView.nextAuction setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            auctionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            auctionView.layer.borderWidth = 1.5;
            [WKPromptView showPromptView:@"逾期未支付,已抵扣保证金"];
        }
        else
        {
            NSString *reminder = @"拍卖结束";
            if (auctionView.dataMd.SaleType.integerValue == 2) {
                reminder = @"幸运购结束";
            }
            [WKPromptView showPromptView:reminder];
        }
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue() , ^{
            [auctionView dismissView:auctionView.maskBtn];
        });
    }
    
}

- (void)dismissView:(UIButton *)btn{

    
    if (auctionView.type == WKGoodsLayoutTypeHoriztal) {
        
        [UIView animateWithDuration:0.2 animations:^{
            auctionView.maskBtn.alpha = 0;
            auctionView.containView.frame = CGRectMake(WKScreenW, 0, WKScreenW * 0.382, WKScreenH);
        } completion:^(BOOL finished) {
            [auctionView.maskBtn removeFromSuperview];
            auctionView.block = nil;
            [auctionView removeFromSuperview];
            [auctionView.timer invalidate];
            auctionView.timer = nil;
            
            auctionView = nil;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            auctionView.maskBtn.alpha = 0;
            auctionView.containView.frame = CGRectMake(10, WKScreenH, WKScreenW - 20, WKScreenH * 0.3);
            
        } completion:^(BOOL finished) {
            [auctionView.maskBtn removeFromSuperview];
            auctionView.block = nil;
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

- (void)btnClick:(UIButton *)btn{
    if (auctionView.dataMd.Status.integerValue == 3) {
        // start activity
        if (auctionView.clientType == WKAuctionTypePushFlow) {
            if (auctionView.block) {
                auctionView.block(WKCallBackTypeNormal);
            }
        }else{
            // confirm address
            if (auctionView.block) {
                auctionView.block(WKCallBackTypeConfirmAddress);
            }
        }
        
    }else{
        if (auctionView.block) {
            auctionView.block(WKCallBackTypeNormal);
        }
    }
    
    [auctionView dismissView:nil];
}

- (void)dealloc{
    NSLog(@"释放拍卖状态");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
