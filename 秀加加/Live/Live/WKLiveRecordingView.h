//
//  WKLiveRecordingView.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/26.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WKLiveRecordingView : UIView

@property (strong, nonatomic) UIImageView * backIM;

@property (strong, nonatomic) UIButton * backBtn;

@property (strong, nonatomic) UIImageView * playType;

@property (strong, nonatomic) UILabel * promptLabel;

@property (strong, nonatomic) UILabel * timeLabel;

@property (strong, nonatomic) UIButton * rerecordingBtn;

@property (strong, nonatomic) UIButton * startSale;

@property (strong, nonatomic) UIImageView * lineAnimatIM;

@property (strong, nonatomic) UILabel * countDownLabel;

@property (strong, nonatomic) UIImageView * playingIM;

@property (strong, nonatomic) UIView * timeDownView;

@property (assign, nonatomic) BOOL isTimeLong;//时间过长

@property (assign, nonatomic) NSInteger type;//1.拍卖,2.筹卖

@property (copy, nonatomic) void(^startSaleBlock)(NSString *timeLong,NSString *path);

-(void)refreshLayoutWityHorizontal;

@end
