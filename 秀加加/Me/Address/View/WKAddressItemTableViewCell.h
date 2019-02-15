//
//  WKAddressItemTableViewCell.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKAddressItem;

@interface WKAddressItemTableViewCell : UITableViewCell
@property (nonatomic,strong) WKAddressItem * item;
- (void)setItem:(WKAddressItem *)item;

@end
