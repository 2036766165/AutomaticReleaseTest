//
//  WKIncomeMoneyView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^incomeMoneyBlock)(NSString *);
@interface WKIncomeMoneyView : UIView

@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UITextField *moneyField;

@property (nonatomic,strong) UITextField *nameTF;

@property (strong, nonatomic) UITextField * IDCard;

@property (strong, nonatomic) NSString * maxMoney;

@property (strong, nonatomic) UILabel * promptLabel;

@property (copy, nonatomic) incomeMoneyBlock block;

-(instancetype)initWithFrame:(CGRect)frame andMaxMoney:(NSString *)money;

@property (strong, nonatomic) WKPromptView* AlertView;

-(void)MessageShow:(NSString *)message;

-(void)refreshPromptMessage:(NSString *)promptStr;

@end
