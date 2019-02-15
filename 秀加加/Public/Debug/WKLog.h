//
//  WKLog.h
//  秀加加
//
//  Created by lin on 16/8/31.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(unsigned char, WKLogLevel){
    WKLog_None  = 0,
    WKLog_Error = 1 << 0,
    WKLog_Warn  = 1 << 1,
    WKLog_Debug = 1 << 2,
    WKLog_Info  = 1 << 3,
};

#ifdef  DEBUG
#define LOGD(...)  [[WKLog sharedInstance] output:WKLog_Debug fmt:__VA_ARGS__];
#define LOGW(...)  [[WKLog sharedInstance] output:WKLog_Warn  fmt:__VA_ARGS__];
#define LOGE(...)  [[WKLog sharedInstance] output:WKLog_Error fmt:__VA_ARGS__];
#define LOGI(...)  [[WKLog sharedInstance] output:WKLog_Info  fmt:__VA_ARGS__];

//带行号 函数名的实现
#define _LOGD(...)  [[WKLog sharedInstance] output:WKLog_Debug funcName:__func__ line:__LINE__ fmt:__VA_ARGS__];
#define _LOGW(...)  [[WKLog sharedInstance] output:WKLog_Warn  funcName:__func__ line:__LINE__ fmt:__VA_ARGS__];
#define _LOGE(...)  [[WKLog sharedInstance] output:WKLog_Error funcName:__func__ line:__LINE__ fmt:__VA_ARGS__];
#define _LOGI(...)  [[WKLog sharedInstance] output:WKLog_Info  funcName:__func__ line:__LINE__ fmt:__VA_ARGS__];
#else

#define LOGD(...)
#define LOGW(...)
#define LOGE(...)
#define LOGI(...)


#define _LOGD(...)
#define _LOGW(...)
#define _LOGE(...)
#define _LOGI(...)

#endif

@interface WKLog : NSObject

+(instancetype)sharedInstance;

-(void)output:(WKLogLevel)level fmt:(NSString *)fmt, ...;

-(void)output:(WKLogLevel)level funcName:(const char *)funcName line:(int)line fmt:(NSString *)fmt, ...;
/**
 *  默认输出全部log
 */
@property(atomic, assign)WKLogLevel  logLevel;

@end
