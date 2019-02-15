//
//  WKStoreModel.h
//  秀加加
//
//  Created by lin on 2016/9/23.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKStoreModel : NSObject<NSMutableCopying,NSCopying>

@property (nonatomic,assign) NSInteger FollowCount;

@property (nonatomic,assign) NSInteger FunsCount;

@property (nonatomic,assign) NSInteger LiveStatus;

@property (nonatomic,strong) NSString *LastShowTime;

@property (nonatomic,strong) NSString *LastShowTimeStr;

+ (instancetype)sharedInstance;

@end
