//
//  WKLog.m
//  秀加加
//
//  Created by lin on 16/8/31.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLog.h"

@implementation WKLog

+(instancetype)sharedInstance
{
    static WKLog *obj = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        obj = [[self alloc] init];
        obj.logLevel = 0xFF;
    });
    return obj;
}

-(void)output:(WKLogLevel)level fmt:(NSString *)fmt, ...
{
    if (!fmt || ![fmt isKindOfClass:[NSString class]])
        return;
    else{
        if (!(_logLevel&level))
            return;
        else{
            
            va_list args;
            va_start(args, fmt);
            
            NSString *log = [[NSString alloc] initWithFormat:fmt arguments:args];
            fprintf(stdout, "[%s] %s\n", [[self level2String:level] UTF8String], [log UTF8String]);
            
            va_end(args);
        }
    }
}

-(void)output:(WKLogLevel)level funcName:(const char *)funcName line:(int)line fmt:(NSString *)fmt, ...
{
    if (!fmt || ![fmt isKindOfClass:[NSString class]])
        return;
    else{
        if (!(_logLevel&level))
            return;
        else{
            
            va_list args;
            va_start(args, fmt);
            
            NSString *log = [[NSString alloc] initWithFormat:fmt arguments:args];
            fprintf(stdout, "[%s %s %d] %s\n", [[self level2String:level] UTF8String], funcName, line, [log UTF8String]);
            
            va_end(args);
        }
    }
}

-(NSString *)level2String:(WKLogLevel)level
{
    if (level == WKLog_None)  return @"WKLog_None";
    if (level == WKLog_Error) return @"WKLog_Error";
    if (level == WKLog_Warn)  return @"WKLog_Warn";
    if (level == WKLog_Debug) return @"WKLog_Debug";
    if (level == WKLog_Info)  return @"WKLog_Info";
    return @"Undefined";
}

@end
