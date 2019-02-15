//
//  WKOrderShopMessageTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKOrderShopMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;

@property (nonatomic,strong) UIButton *statusBtn;

typedef void (^ClickTypeOrderShop) ();

@property (nonatomic,copy) ClickTypeOrderShop clickTypeOrderShop;

@end
