//
//  WKTagCell.h
//  aa
//
//  Created by Chang_Mac on 16/9/21.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTagModel.h"
typedef void(^tagCellBlock)(BOOL,WkTagTitle*,UIButton *);

@interface WKTagCell : UITableViewCell

@property (copy, nonatomic) tagCellBlock tagBlock;

@property (strong, nonatomic) UIView * lineView;

@property (strong, nonatomic) WKTagModel * model;

@end
