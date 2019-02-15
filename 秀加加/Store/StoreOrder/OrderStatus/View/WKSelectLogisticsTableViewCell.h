//
//  WKBackTableViewCell.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backBlock)(NSString *,NSInteger);

@interface WKSelectLogisticsTableViewCell : UITableViewCell

-(instancetype)initWithNumber:(NSInteger)index and:(backBlock)block;
/**
 *  block
 */
@property (copy, nonatomic) backBlock block;

/**
 *  label
 */
@property (strong, nonatomic) UILabel *label;

/**
 *  button
 */
@property (strong, nonatomic) UIButton * button;
@end
