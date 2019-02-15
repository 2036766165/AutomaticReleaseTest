//
//  WKSettingViewController.h
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "ViewController.h"
@class WKSettingCell;
@interface WKSettingViewController : ViewController

@end

@interface WKSettingCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headIM ;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIImageView *arrowIM;

@end
