//
//  WKHistoryTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHistoryModel.h"

@interface WKHistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *share;
@property (nonatomic,strong) UILabel *address;
@property (nonatomic,strong) UILabel *liveCon;

//1.点击头像    2.点击分享  
typedef void (^ClickHistoryType) (int type);

@property (nonatomic,copy) ClickHistoryType clickHistoryType;

@property (nonatomic,strong) WKHistoryItemModel *item;
@end
