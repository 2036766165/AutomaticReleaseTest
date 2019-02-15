//
//  WKUser.m
//  wdbo
//
//  Created by sks on 16/6/19.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKUser.h"

@implementation WKUser

+ (id)allocWithZone:(struct _NSZone *)zone{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


+ (instancetype)sharedInstance{
    return [[self alloc] init];
}

- (instancetype)init{
    if (self = [super init]) {
        self.usericon = [[UIImageView alloc] init];
        self.recordType = WKRecordingTypeNO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

#if __has_feature(objc_arc)

#else

- (NSUInteger)retainCount{
    return -1;
}

- (instancetype)release{
    return self;
}

#endif
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
