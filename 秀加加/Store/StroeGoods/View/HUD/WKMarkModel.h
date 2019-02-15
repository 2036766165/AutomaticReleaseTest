//
//  WKMarkModel.h
//  wdbo
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMarkModel : NSObject

/*
 *价格
 */
@property (nonatomic,copy) NSString *Price;

/*
 * 库存
 */
@property (nonatomic,copy) NSNumber *Stock;

/*
 * 型号
 */
@property (nonatomic,copy) NSNumber *ModelCode;  // 型号

/*
 * 型号名
 */
@property (nonatomic,copy) NSString *ModelName;

/*
 * 创建时间
 */
@property (nonatomic,copy) NSString *CreateTime;

/*
 * 型号ID
 */
@property (nonatomic,copy) NSString *ID;

- (instancetype)init;

@end
