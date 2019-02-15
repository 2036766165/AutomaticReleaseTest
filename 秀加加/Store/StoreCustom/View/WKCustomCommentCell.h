//
//  WKCustomCommentTableViewCell.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCustomCommentModel.h"
@interface WKCustomCommentCell : UITableViewCell
/**
 *  model
 */
@property (strong, nonatomic) WKCustomCommentModel * model;

@property (strong, nonatomic) UIImageView *playIM;

@property (strong, nonatomic) UILabel *playLabel;

@property (copy, nonatomic) void (^commentBlock) (NSArray *,NSIndexPath *);

@property (copy, nonatomic) void (^block)();
@end
