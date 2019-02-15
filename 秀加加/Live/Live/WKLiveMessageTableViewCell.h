//
//  WKLiveMessageTableViewCell.h
//  wdbo
//
//  Created by lin on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKOrderNoticeModel.h"
@interface WKLiveMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameType;

@property (nonatomic,strong) UILabel *time;

@property (nonatomic,strong) UILabel *shopName;

@property (nonatomic,strong) UILabel *shopValue;

@property (nonatomic,strong) UIImageView *headImg;

@property (nonatomic,strong) UILabel *modelType;

@property (nonatomic,strong) UILabel *number;

@property (nonatomic,strong) UILabel *valueName;

//@property (nonatomic, strong) WKListNoticeInfo *model;

- (void)setModel:(WKListNoticeInfo *)md;

@end
