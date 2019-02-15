//
//  BaseListVM.h
//  秀加加
//
//  Created by liuliang on 2016/10/24.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseListVM : NSObject

/**
 *  服务端返回的响应码
 */
@property NSInteger ResultCode;
/**
 *  服务端返回的消息描述
 */
@property NSString*  ResultMessage;

@property NSMutableArray* DataList;

@end
