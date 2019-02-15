//
//  WKCustomDetailsTableViewCell.h
//  秀加加
//
//  Created by 吴文豪 on 2016/10/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCustomerOrderModel.h"

@interface WKCustomDetailsTableViewCell : UITableViewCell

//商品图片
@property (strong ,nonatomic) UIImageView *goodImg ;

//商品名称
@property (strong , nonatomic) UILabel *goodName ;

//商品规格
@property (strong , nonatomic) UILabel *goodtype ;

//商品单价
@property (strong , nonatomic) UILabel *goodPrice ;

//商品个数
@property (strong , nonatomic) UILabel *goodNum ;

//商品信息
@property (strong, nonatomic) WKCustomerListProduct *model;

@end
