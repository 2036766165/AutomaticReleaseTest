//
//  XCUserMessage.m
//  XCUserMessage
//
//  Created by Chang_Mac on 16/9/7.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import "WKUserMessage.h"
#import <Masonry/Masonry.h>
#import "UIButton+ImageTitleSpacing.h"
#import "WKFlowButton.h"
#import "NSObject+XCTag.h"
#import "NSObject+XWAdd.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WKUserMessage () <UIActionSheetDelegate>

@property (strong, nonatomic) UIButton * maskView;

@property (strong, nonatomic) UIView * showView;

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat scale;

@property (strong, nonatomic) WKUserMessageModel * model;

@property (copy, nonatomic) chatBlock block;

@property (assign, nonatomic) styleType chatType;

//@property (strong, nonatomic) UIButton * redPacket;

@end

@implementation WKUserMessage

static WKUserMessage *userMessage=nil;

+(void)showUserMessageWithModel:(WKUserMessageModel *)model andType:(userMessageType)type chatType:(styleType)chatType :(chatBlock)block{
    
    if (userMessage == nil) {
        
        @synchronized (self) {
            
            userMessage = [[WKUserMessage alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            userMessage.block = block;
            userMessage.model = model;
            userMessage.chatType = chatType;
            if (ScreenHeight>ScreenWidth) {
                userMessage.width = ScreenWidth*0.8;
                userMessage.scale = ScreenWidth/375;
            }else{
                userMessage.width = ScreenHeight*0.8;
                userMessage.scale = ScreenHeight/375;
            }
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:userMessage];
            userMessage.maskView = [[UIButton alloc]init];
            userMessage.maskView.backgroundColor = [UIColor clearColor];
            userMessage.maskView.alpha = 0.5;
            [userMessage.maskView addTarget:userMessage action:@selector(exitButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [userMessage addSubview:userMessage.maskView];
            [userMessage.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            userMessage.showView = [[UIView alloc]init];
            userMessage.showView.backgroundColor = [UIColor whiteColor];
            userMessage.showView.layer.cornerRadius = 5;
            [userMessage addSubview:userMessage.showView];
            [userMessage.showView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(userMessage.mas_centerX).offset(0);
                make.top.mas_equalTo((ScreenHeight-userMessage.width*1.1)/2);
                make.width.mas_equalTo(userMessage.width);
                make.height.mas_equalTo(userMessage.width*1.1);
            }];
            UILabel *cityLabel = [[UILabel alloc]init];
            cityLabel.font = [UIFont systemFontOfSize:14];
            if (model.Location.length>0) {
                cityLabel.text = model.Location;
            }else{
                cityLabel.text = @"火星";
            }
            cityLabel.textColor = [UIColor lightGrayColor];
            [userMessage.showView addSubview:cityLabel];
            [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(userMessage.showView.mas_left).offset(15);
                make.top.equalTo(userMessage.showView.mas_top).offset(15);
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(15);
            }];
            
            UIButton *exitButton = [[UIButton alloc]init];
            [exitButton addTarget:userMessage action:@selector(exitButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [exitButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
            [userMessage.showView addSubview:exitButton];
            [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(userMessage.showView.mas_right).offset(-15);
                make.top.equalTo(userMessage.showView.mas_top).offset(10);
                make.width.mas_equalTo(30);
                make.height.mas_equalTo(30);
            }];
            
            UIImageView *iconIM = [[UIImageView alloc]init];
            iconIM.layer.cornerRadius = 80*userMessage.scale/2;
            iconIM.layer.masksToBounds = YES;
            [iconIM sd_setImageWithURL:[NSURL URLWithString:model.MemberPhoto] placeholderImage:[UIImage imageNamed:@"default_03"]];
            iconIM.layer.cornerRadius = 40*userMessage.scale;
            [userMessage.showView addSubview:iconIM];
            [iconIM mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(userMessage.showView.mas_right).offset(-(userMessage.width-80*userMessage.scale)/2);
                make.top.equalTo(userMessage.showView.mas_top).offset(30*userMessage.scale);
                make.width.mas_equalTo(80*userMessage.scale);
                make.height.mas_equalTo(80*userMessage.scale);
            }];
            
            UIButton *redPacketBtn = [[UIButton alloc]init];//红包
            [redPacketBtn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
            redPacketBtn.hidden = YES;
            redPacketBtn.tag = 1004;
            [redPacketBtn addTarget:userMessage action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (!User.isReviewID) {
                [userMessage.showView addSubview:redPacketBtn];
                [redPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(iconIM.mas_right).offset(10);
                    make.centerY.equalTo(iconIM.mas_centerY).offset(-10);
                    make.size.sizeOffset(CGSizeMake(30*userMessage.scale, 30*userMessage.scale));
                }];
            }
            
            UIView *levelView = [userMessage createLevelViewWithLevel:model.MemberLevel];
            [userMessage.showView addSubview:levelView];
            [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(iconIM.mas_right).offset(-3*userMessage.scale);
                make.bottom.equalTo(iconIM.mas_bottom).offset(-3*userMessage.scale);
                make.width.mas_equalTo(20*userMessage.scale);
                make.height.mas_equalTo(10*userMessage.scale);
            }];
            
            UIButton *userNameButton = [[UIButton alloc]init];
            if (model.MemberName.length>15) {
                model.MemberName = [model.MemberName substringToIndex:15];
                model.MemberName = [NSString stringWithFormat:@"%@...",model.MemberName];
            }
            [userNameButton setTitle:model.MemberName forState:UIControlStateNormal];
            [userNameButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            userNameButton.userInteractionEnabled = NO;
            UIImage *sexImage;
            if (model.Sex.integerValue == 1) {
                sexImage = [UIImage imageNamed:@"sex_male"];
                [userNameButton setImage:sexImage forState:UIControlStateNormal];
            }else if(model.Sex.integerValue == 2){
                sexImage = [UIImage imageNamed:@"sex_female"];
                [userNameButton setImage:sexImage forState:UIControlStateNormal];
            }
            // [userNameButton setImage:sexImage forState:UIControlStateNormal];
            userNameButton.titleLabel.font = [UIFont systemFontOfSize:16*userMessage.scale];
            [userNameButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:20];
            [userMessage.showView addSubview:userNameButton];
            [userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(userMessage.showView.mas_left).offset(0);
                make.top.equalTo(iconIM.mas_bottom).offset(10*userMessage.scale);
                make.right.mas_offset(0);
                make.height.mas_equalTo(17*userMessage.scale);
            }];
            
            UIButton *homeId = [[UIButton alloc]init];
            [homeId setTitle:[NSString stringWithFormat:@"  门牌号  %@",model.MemberNo] forState:UIControlStateNormal];
            [homeId setImage:[UIImage imageNamed:@"men"] forState:UIControlStateNormal];
            homeId.userInteractionEnabled = NO;
            [homeId setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            homeId.titleLabel.font = [UIFont systemFontOfSize:14*userMessage.scale];
            [userMessage.showView addSubview:homeId];
            [homeId mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(userMessage.showView.mas_centerX).offset(0);
                make.top.equalTo(userNameButton.mas_bottom).offset(10*userMessage.scale);
                make.width.mas_equalTo(userMessage.width);
                make.height.mas_equalTo(15*userMessage.scale);
            }];
            
            UIButton *certificationButton = [[UIButton alloc]init];
            
            if(model.ShopAuthenticationStatus.integerValue == 1){
                [certificationButton setTitle:@"  实体店认证" forState:UIControlStateNormal];
                [certificationButton setImage:[UIImage imageNamed:@"renzheng"] forState:UIControlStateNormal];
            }else{
                [certificationButton setTitle:@"  非实体店" forState:UIControlStateNormal];
                [certificationButton setImage:[UIImage imageNamed:@"renzheng_def"] forState:UIControlStateNormal];
            }
            
            [certificationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            certificationButton.userInteractionEnabled = NO;
            certificationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 2, 10);
            certificationButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [userMessage.showView addSubview:certificationButton];
            [certificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(userMessage.showView.mas_centerX).offset(0);
                make.top.equalTo(homeId.mas_bottom).offset(10*userMessage.scale);
                make.width.mas_equalTo(userMessage.width);
                make.height.mas_equalTo(17*userMessage.scale);
            }];
            
            if (type == mySelfMessage) {//自己看自己
                [userMessage.showView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(userMessage.mas_centerX).offset(0);
                    make.top.mas_equalTo((ScreenHeight-userMessage.width*0.9)/2);
                    make.width.mas_equalTo(userMessage.width);
                    make.height.mas_equalTo(userMessage.width*0.9);
                }];
                
                UILabel *numberLabel = [[UILabel alloc]init];
                numberLabel.font = [UIFont systemFontOfSize:14];
                numberLabel.text = [NSString stringWithFormat:@"关注:%@      粉丝:%@",model.FollowCount,model.FunsCount];
                numberLabel.textColor = [UIColor lightGrayColor];
                numberLabel.textAlignment = NSTextAlignmentCenter;
                [userMessage.showView addSubview:numberLabel];
                [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(userMessage.showView.mas_centerX).offset(0);
                    make.top.equalTo(certificationButton.mas_bottom).offset(10*userMessage.scale);
                    make.width.mas_equalTo(userMessage.width);
                    make.height.mas_equalTo(15*userMessage.scale);
                }];
                
                UILabel *incomeLabel = [[UILabel alloc]init];
                incomeLabel.font = [UIFont systemFontOfSize:14];
                incomeLabel.adjustsFontSizeToFitWidth = YES;
                incomeLabel.text = [NSString stringWithFormat:@"今日红包¥%0.2f   今日订单¥%0.2f",[model.TodayReward floatValue],[model.TodayOrderReward floatValue]];
                incomeLabel.textColor = [UIColor lightGrayColor];
                incomeLabel.textAlignment = NSTextAlignmentCenter;
                [userMessage.showView addSubview:incomeLabel];
                [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(userMessage.showView.mas_centerX).offset(0);
                    make.top.equalTo(numberLabel.mas_bottom).offset(12*userMessage.scale);
                    make.width.mas_equalTo(userMessage.width-5);
                    make.height.mas_equalTo(15*userMessage.scale);
                }];
            }else{//看别人
                UILabel *numberLabel = [[UILabel alloc]init];
                numberLabel.font = [UIFont systemFontOfSize:14];
                if (type == rewardMessage) {
                    numberLabel.text = [NSString stringWithFormat:@"关注:%@  粉丝:%@  打赏:¥%@",model.FollowCount,model.FunsCount,model.TotalReward];
                }else{
                    numberLabel.text = [NSString stringWithFormat:@"关注:%@            粉丝:%@",model.FollowCount,model.FunsCount];
                }
                
                numberLabel.textColor = [UIColor lightGrayColor];
                numberLabel.textAlignment = NSTextAlignmentCenter;
                [userMessage.showView addSubview:numberLabel];
                [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(userMessage.showView.mas_centerX).offset(0);
                    make.top.equalTo(certificationButton.mas_bottom).offset(10*userMessage.scale);
                    make.width.mas_equalTo(userMessage.width);
                    make.height.mas_equalTo(15*userMessage.scale);
                }];
                
                NSDictionary *dic = [NSDictionary dicWithJsonStr:model.ShopTag];
                NSArray *titleArr = dic[@"titleArr"];
                NSArray *colorArr = dic[@"colorArr"];
                WKFlowButton *flowButton = [[WKFlowButton alloc]initWithFrame:CGRectMake(0, 0, userMessage.width, 68) andTitleArr:titleArr andColorArr:colorArr andFont:12 andType:flowButtonCenter :^(NSInteger index, NSString *title) {
                    
                }];
                [userMessage.showView addSubview:flowButton];
                [flowButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(userMessage.showView.mas_centerX).offset(0);
                    make.top.equalTo(numberLabel.mas_bottom).offset(3*userMessage.scale);
                    make.width.mas_equalTo(userMessage.width);
                    make.height.mas_equalTo(68*userMessage.scale);
                }];
                
                UIView *lineView = [[UIView alloc]init];
                lineView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
                [userMessage.showView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(userMessage.showView.mas_left).offset(0);
                    make.top.equalTo(flowButton.mas_bottom).offset(3);
                    make.width.mas_equalTo(userMessage.width);
                    make.height.mas_equalTo(0.5);
                }];
                
                UIButton *focusButton = [[UIButton alloc]init];
                focusButton.tag = 1001;
                NSString *str ;
                UIImage *image;
                if (model.IsFollow.integerValue == 1) {
                    str = @"  已关注";
                    if (chatType == hostType) {
                        image = [UIImage imageNamed:@""];
                        focusButton.userInteractionEnabled = NO;
                    }else{
                        image = [UIImage imageNamed:@"xin"];
                    }
                    focusButton.selected = YES;
                }else{
                    str = @"  关注";
                    image = [UIImage imageNamed:@"fensiweiguan"];
                    focusButton.selected = NO;
                }
                [focusButton setTitle:str forState:UIControlStateNormal];
                [focusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [focusButton addTarget:userMessage action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [focusButton setImage:image forState:UIControlStateNormal];
                focusButton.titleLabel.font = [UIFont systemFontOfSize:14*userMessage.scale];
                [userMessage.showView addSubview:focusButton];
                [focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(userMessage.width/3*2);
                    make.top.equalTo(lineView.mas_bottom).offset(5);
                    make.width.mas_equalTo(userMessage.width/3);
                    make.bottom.equalTo(userMessage.showView.mas_bottom).offset(-5);
                }];
                    
                if (chatType == privateChatType || chatType == hostType || (chatType == gagType && userMessage.model.DisableStatus.integerValue == 2)) {//私信
                    if (chatType == hostType ) {
                        redPacketBtn.hidden = NO;
                    }
                    UIButton *privateBtn = [[UIButton alloc]init];
                    privateBtn.selected = NO;
                    [privateBtn setTitle:@"  私信" forState:UIControlStateNormal];
                    privateBtn.tag = 1002;
                    [privateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [privateBtn addTarget:userMessage action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//                    privateBtn.backgroundColor = [UIColor redColor];
                    [privateBtn setImage:[UIImage imageNamed:@"private"] forState:UIControlStateNormal];
                    privateBtn.titleLabel.font = [UIFont systemFontOfSize:14*userMessage.scale];
                    [userMessage.showView addSubview:privateBtn];
                    [privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_offset(0);
                        make.top.equalTo(lineView.mas_bottom).offset(5);
                        make.width.mas_equalTo(userMessage.width/3);
                        make.bottom.equalTo(userMessage.showView.mas_bottom).offset(-5);
                    }];
                    
                    [focusButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(privateBtn.mas_right).offset(0);
                        make.top.equalTo(lineView.mas_bottom).offset(5);
                        make.width.mas_equalTo(userMessage.width/3);
                        make.bottom.equalTo(userMessage.showView.mas_bottom).offset(-5);
                    }];
                    
                    UIView *lineView = [[UIView alloc]init];
//                    lineView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
                    lineView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];

                    [privateBtn addSubview:lineView];
                    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_offset(0);
                        make.width.mas_offset(1);
                        make.top.mas_offset(5);
                        make.bottom.mas_offset(-5);
                    }];
                    
                    // report complaints
                    UIButton *reportBtn = [[UIButton alloc] init];
                    reportBtn.selected = NO;
                    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
                    reportBtn.tag = 1009;
                    [reportBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [reportBtn addTarget:userMessage action:@selector(reportComplaint) forControlEvents:UIControlEventTouchUpInside];
//                    reportBtn.backgroundColor = [UIColor redColor];
//                    [reportBtn setImage:[UIImage imageNamed:@"private"] forState:UIControlStateNormal];
                    reportBtn.titleLabel.font = [UIFont systemFontOfSize:14*userMessage.scale];
                    [userMessage.showView addSubview:reportBtn];
                    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(userMessage.showView.mas_right).offset(0);
//                        make.top.mas_equalTo(lineView.mas_bottom).offset(5);
                        make.centerY.mas_equalTo(privateBtn.mas_centerY);
                        make.width.mas_equalTo(userMessage.width/3);
                        make.bottom.equalTo(userMessage.showView.mas_bottom).offset(-5);
//                        make.bottom.mas_offset(-5);
                    }];
                    
                    UIView *lineView1 = [[UIView alloc]init];
                    lineView1.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
                    [reportBtn addSubview:lineView1];
                    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(0);
                        make.width.mas_offset(1);
//                        make.top.mas_offset(5);
                        make.height.mas_equalTo(lineView.mas_height);
                        make.centerY.mas_equalTo(reportBtn.mas_centerY);
                    }];
                    
                }else if (chatType == gagType){//禁言
                    redPacketBtn.hidden = NO;
                    [focusButton mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(userMessage.width/3*2);
                        make.top.equalTo(lineView.mas_bottom).offset(5);
                        make.width.mas_equalTo(userMessage.width/3);
                        make.bottom.equalTo(userMessage.showView.mas_bottom).offset(-5);
                    }];
                    for (int i = 0 ; i < 2 ; i ++ ) {
                        UIButton *privateBtn = [[UIButton alloc]init];
                        privateBtn.selected = NO;
                        if (i == 0) {
                            [privateBtn setTitle:@"  私信" forState:UIControlStateNormal];
                            [privateBtn setImage:[UIImage imageNamed:@"private"] forState:UIControlStateNormal];
                            privateBtn.tag = 1002;
                        }else{
                            
                            NSString *btnName;
                            NSString *btnImage;
                            if (userMessage.model.DisableStatus.integerValue == 0) {
                                // 未禁言
                                btnName = @"  禁言";
                                btnImage = @"mute_Off";
                                
                            }else if(userMessage.model.DisableStatus.integerValue == 1){
                                // 主播禁言
                                btnName = @"  解禁";
                                btnImage = @"mute_On";
                            }else{
                                // 系统禁言
                                btnName = @"系统禁言";
                                btnImage = @"";
                            }
                            
                            [privateBtn setTitle:btnName forState:UIControlStateNormal];
                            [privateBtn setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
                            privateBtn.tag = 1003;
                        }
                        
                        [privateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        [privateBtn addTarget:userMessage action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                        privateBtn.titleLabel.font = [UIFont systemFontOfSize:14*userMessage.scale];
                        [userMessage.showView addSubview:privateBtn];
                        [privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(userMessage.width/3*i);
                            make.top.equalTo(lineView.mas_bottom).offset(5);
                            make.width.mas_equalTo(userMessage.width/3);
                            make.bottom.equalTo(userMessage.showView.mas_bottom).offset(-5);
                        }];
                        
                        UIView *lineView = [[UIView alloc]init];
                        lineView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
                        [privateBtn addSubview:lineView];
                        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_offset(0);
                            make.width.mas_offset(1);
                            make.top.mas_offset(5);
                            make.bottom.mas_offset(-5);
                        }];
                    }
                }
            }
            userMessage.showView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            [UIView animateWithDuration:0.2 animations:^{
                userMessage.maskView.backgroundColor = [UIColor blackColor];
                
                userMessage.showView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
                userMessage.showView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            }];
        }
    }
}

-(void)focusButtonAction:(UIButton *)focusButton{
    // TODO
    if (focusButton.tag == 1001) {
        focusButton.selected = !focusButton.selected;

        if (userMessage.model.IsFollow.integerValue == 0 || focusButton.selected) {
            
            [self xw_postNotificationWithName:@"FocusAnchor" userInfo:@{@"type":@1,@"memberNo":self.model.MemberNo}];
            [focusButton setTitle:@"  已关注" forState:UIControlStateNormal];
            if (self.chatType == hostType) {
                [focusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                focusButton.userInteractionEnabled = NO;
            }else{
              [focusButton setImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
            }
            [self focusNOFocus:@"1"];
        }
        if (!focusButton.selected && self.chatType != hostType) {
            [self xw_postNotificationWithName:@"FocusAnchor" userInfo:@{@"type":@0,@"memberNo":self.model.MemberNo}];
            [focusButton setTitle:@"  关注" forState:UIControlStateNormal];
            [focusButton setImage:[UIImage imageNamed:@"fensiweiguan"] forState:UIControlStateNormal];
            [self focusNOFocus:@"0"];
        }
    }else if (focusButton.tag == 1002){
        // 私信
        [self exitButtonAction];
        self.block(2);
    }else if (focusButton.tag == 1003){
        // 禁言
        NSString *postUrl;
        
        NSString *btnName;
        NSString *btnImage;
        NSNumber *currentMuteStatus;
        
        if (userMessage.model.DisableStatus.integerValue == 0) {
            postUrl = WKRoomStopTalk;
            btnName = @"  解禁";
            btnImage = @"mute_Off";
            currentMuteStatus = @1;
        }else if (userMessage.model.DisableStatus.integerValue == 1){
            postUrl = WKRoomStartTalk;
            btnName = @"  禁言";
            btnImage = @"mute_On";
            currentMuteStatus = @0;
            
        }else{
            return;
        }
        NSString *url = [NSString configUrl:postUrl With:@[@"BPOID"] values:@[userMessage.model.BPOID]];
        
        [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
            [focusButton setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
            [focusButton setTitle:btnName forState:UIControlStateNormal];
            
            userMessage.model.DisableStatus = currentMuteStatus;
            
        } failure:^(WKBaseResponse *response) {
            
        }];
        
    }
    else if (focusButton.tag == 1004 && self.block) {//红包
        [self exitButtonAction];
        self.block(3);
    }
}

//MARK: Report
- (void)reportComplaint{
    // 举报
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"广告欺骗",@"淫秽色情",@"骚扰谩骂",@"反动政治",@"其他内容", nil];
    //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [actionSheet showInView:userMessage];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSArray *arr = @[@"广告欺骗",
                     @"淫秽色情",
                     @"骚扰谩骂",
                     @"反动政治",
                     @"其他内容"];
    
    if (buttonIndex <= arr.count-1) {
        NSLog(@"%ld",(long)buttonIndex);
        
        NSString *url = [NSString configUrl:WKAddAdvice With:@[@"content"] values:@[arr[buttonIndex]]];
        
        [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
            NSLog(@"response %@",response);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [WKPromptView showPromptView:@"举报成功"];
            });
        } failure:^(WKBaseResponse *response) {
            
        }];
    }
}

-(void)focusNOFocus:(NSString *)type{
    NSString *sendBool;
    if (self.chatType == hostType) {
        sendBool = @"true";
    }else{
        sendBool = @"false";
    }
    NSString *urlStr = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID",@"NeedSend"] values:@[type,self.model.BPOID,sendBool]];
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:urlStr model:nil param:nil success:^(WKBaseResponse *response) {
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(UIView *)createLevelViewWithLevel:(NSString *)levelStr{
    NSInteger level = levelStr.integerValue;
    NSString *imageName = @"";
    if (level>9) {
        imageName = @"level10";
    }else{
        imageName = [NSString stringWithFormat:@"level%ld",(long)level];
    }
    NSArray *colorArr = @[@"d9790b",@"e2e2e0",@"eecb00",@"a200d0"];
    NSArray *edgeColorArr = @[@"ff9c20",@"bbbbb9",@"ffe80e",@"8b02b4"];
    UIView *levelView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.2, 0.0075*WKScreenW, WKScreenW*0.1, WKScreenW*0.035)];
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WKScreenW*0.1, WKScreenW*0.035)];
    switch (level) {
        case 1:case 4:case 7:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[0]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[0]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"f6ebab"];
            break;
        case 2:case 5:case 8:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[1]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[1]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
            break;
        case 3:case 6:case 9:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[2]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[2]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"ffeeb3"];
            break;
        default:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[3]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[3]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"f1cb66"];
            break;
    }
    
    levelLabel.layer.borderWidth = 1;
    levelLabel.layer.masksToBounds = YES;
    levelLabel.font = [UIFont systemFontOfSize:WKScreenW*0.025];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.text = [NSString stringWithFormat:@"    V%lu",(long)level];
    levelLabel.layer.cornerRadius = WKScreenW*0.035/2;
    levelLabel.adjustsFontSizeToFitWidth = YES;
    [levelView addSubview:levelLabel];
    
    UIImageView *levelIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, -WKScreenW*0.005, WKScreenW*0.043, WKScreenW*0.043)];
    levelIM.image = [UIImage imageNamed:imageName];
    [levelView addSubview:levelIM];
    
    return levelView;
}

-(void)exitButtonAction{
    [UIView animateWithDuration:0.1 animations:^{
        userMessage.maskView.backgroundColor = [UIColor clearColor];
        userMessage.showView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [userMessage removeFromSuperview];
        userMessage.maskView = nil;
        userMessage.showView = nil;
        userMessage = nil;
    }];
}

@end

//@implementation WKUserParameterModel
//
//
//@end

