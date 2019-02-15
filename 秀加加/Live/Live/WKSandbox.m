//
//  WKSandbox.m
//  秀加加
//
//  Created by sks on 2016/11/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSandbox.h"

@implementation WKSandbox

+ (NSString *)getHomeDirectory{
    // eg: /var/mobile/Applications/326640A7-6E27-4C63-BA5E-7391F203659A
    return NSHomeDirectory();
}

+ (NSString *)getTemporaryDirectory{
    //eg: /private/var/mobile/Applications/326640A7-6E27-4C63-BA5E-7391F203659A/tmp/
    return NSTemporaryDirectory();
}

+ (NSString *)getBundlePath{
    // eg: /var/mobile/Applications/326640A7-6E27-4C63-BA5E-7391F203659A/PhoneCall.app
    return [[NSBundle mainBundle] bundlePath];
}


+ (NSString *)getDocumentDirectory{
    // NSDocumentDirectory 是指程序中对应的Documents路径，而NSDocumentionDirectory对应于程序中的Library/Documentation路径，这个路径是没有读写权限的，所以看不到文件生成。
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)createDirectoryPathWith:(NSSearchPathDirectory)directory domainMask:(NSSearchPathDomainMask)domaimMask fileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, domaimMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = paths[0];
    path = [path stringByAppendingPathComponent:fileName];
    
    [fileManager createFileAtPath:path contents:nil attributes:nil];
    
    return path;
}
@end
