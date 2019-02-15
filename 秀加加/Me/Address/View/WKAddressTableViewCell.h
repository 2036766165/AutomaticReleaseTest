//
//  WKAddressTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKAddressListItem;

@interface WKAddressTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *number;
@property (nonatomic,strong) UILabel *defaultName;
@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UIButton *editBtn;

- (void)setItem:(WKAddressListItem *)item isEdit:(BOOL)isEdit;

@end
