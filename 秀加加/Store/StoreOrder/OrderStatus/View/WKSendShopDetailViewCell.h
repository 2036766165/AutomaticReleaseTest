//
//  WKSendShopDetailViewCell.h
//  wdbo
//
//  Created by lin on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKInnerListModel.h"
@interface WKSendShopDetailViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *view;

@property (nonatomic,strong) UILabel *detail;

@property (nonatomic,strong) UILabel *date;

@property (nonatomic,strong) InnerListModel *model;

@end
