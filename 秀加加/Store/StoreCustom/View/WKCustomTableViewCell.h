//
//  WKCustomTableViewCell.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCustomTableModel.h"
@interface WKCustomTableViewCell : UITableViewCell

/**
 *  model
 */
@property (strong, nonatomic) CustomInnerList * model;

@end
