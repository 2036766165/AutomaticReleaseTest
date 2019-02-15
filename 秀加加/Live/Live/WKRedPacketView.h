//
//  WKRedPacketView.h
//  秀加加
//
//  Created by Chang_Mac on 17/3/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    rechargeType,
    sendRedPacketType,
}callBackType;

@interface WKRedPacketView : UIImageView<UITextViewDelegate>

@property (copy, nonatomic) void(^callBack)(callBackType type,NSDictionary *data);
@property (assign, nonatomic) NSInteger userCount;
@property (strong, nonatomic) NSString * maxAmount;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * memberName;

-(void)createControlWithType:(NSInteger)type;//1.个人红包 2.群红包

-(void)setUserBalance:(NSString *)balance;

@end
