//
//  WKPaymentDetailsModel.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/28.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKPaymentDetailsModel : NSObject

/**
 *  账户日志类型
 */
@property (strong, nonatomic) NSString * AccountLogType;
/**
 *  金额
 */
@property (strong, nonatomic) NSString * Amount;
/**
 *  日志参数
 */
@property (strong, nonatomic) NSString * LogParm;
/**
 *  日志内容
 */
@property (strong, nonatomic) NSString * LogDescription;
/**
 *  创建时间
 */
@property (strong, nonatomic) NSString * CreateTime;

@end
