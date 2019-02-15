//
//  WKSandbox.h
//  秀加加
//
//  Created by sks on 2016/11/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKSandbox : NSObject

// 获取沙盒目录
+ (NSString *)getHomeDirectory;

/*
 获取temp
 
 */
+ (NSString *)getTemporaryDirectory;

/*
 MyApp.app
 */
+ (NSString *)getBundlePath;

/*documents*/
+ (NSString *)getDocumentDirectory;

+ (NSString *)createDirectoryPathWith:(NSSearchPathDirectory)searPath domainMask:(NSSearchPathDomainMask)domaimMask fileName:(NSString *)fileName;

@end
