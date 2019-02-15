//
//  WKStoreRechargeView.h
//  秀加加
//
//  Created by Chang_Mac on 16/12/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^rechargeBlock)(NSString *);
@interface WKStoreRechargeView : UIView

-(void)refreshBalanceMoney:(NSString *)balanceMoney;

@property (copy, nonatomic) rechargeBlock block;
@property (strong, nonatomic) UIView *backView;
@end
