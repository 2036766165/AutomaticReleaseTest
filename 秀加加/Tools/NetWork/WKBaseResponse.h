//
//  WKBaseResponse.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBaseResponse : NSObject

/**
 *  服务端返回的响应码
 */
@property (nonatomic, assign)   NSInteger       ResultCode;
/**
 *  服务端返回的消息描述
 */
@property (nonatomic, copy)     NSString        *ResultMessage;

/**
 *  服务端返回的数据
 */
@property (nonatomic ,strong)   id    Data;

@property (nonatomic ,strong)   id    json;

+ (instancetype)responseParse:(id)json modelClass:(NSString *)modelClass;

@end
