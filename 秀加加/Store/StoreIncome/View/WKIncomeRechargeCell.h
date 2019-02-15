//
//  WKIncomeRechargeCell.h
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPaymentDetailsModel.h"
@interface WKIncomeRechargeCell : UITableViewCell
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UILabel *money;
@property (strong, nonatomic) UILabel * timeLabel;

@property (strong, nonatomic) WKPaymentDetailsModel * model;
@end
