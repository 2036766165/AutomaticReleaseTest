//
//  WKStoreModel.m
//  秀加加
//
//  Created by lin on 2016/9/23.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreModel.h"

@implementation WKStoreModel

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
