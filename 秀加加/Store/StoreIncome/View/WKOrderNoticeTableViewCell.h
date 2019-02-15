//
//  WKOrderNoticeTableViewCell.h
//  wdbo
//
//  Created by lin on 16/6/21.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKOrderNoticeModel.h"
#import "WKPaymentDetailsModel.h"
@interface WKOrderNoticeTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UILabel *detail;

@property (nonatomic,strong) UILabel *money;

@property (strong, nonatomic) UIImageView * arrowIM;

@property (nonatomic,strong) WKListNoticeInfo *model;

@property (nonatomic,strong) WKPaymentDetailsModel *model1;

@end
