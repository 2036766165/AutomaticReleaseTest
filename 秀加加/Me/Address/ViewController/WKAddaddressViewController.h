//
//  WKAddaddressViewController.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKAddressViewController.h"

typedef enum : NSUInteger {
    WKAddressEditTypeAdd,          // 新增地址
    WKAddressEditTypeEdit,         // 普通的编辑
    WKAddressEditTypeEditDistrict  // 修改订单编辑地址
} WKAddressEditType;

@class WKAddressModel;

@interface WKAddaddressViewController : ViewController
/*
 *新建ID @"0"
 */
//- (instancetype)initWithID:(NSString *)ID;

- (instancetype)initWithID:(NSString *)ID type:(WKAddressEditType)type from:(WKAddressFrom)from;

//- (instancetype)initWithID:(NSString *)ID from:(WKAddressFrom)from;

@property (nonatomic,copy) void(^AddSuccess)(NSDictionary*);

@property (nonatomic,strong) WKAddressModel *dataModel;

@end
