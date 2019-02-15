//
//  BulletManager.h
//  CommentDemo
//
//  Created by feng jia on 16/2/20.
//  Copyright © 2016年 caishi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKBulletView;
@class WKBarrageModel;
@interface WKBulletManager : NSObject
@property (nonatomic, copy) void(^generateBulletBlock)(WKBulletView *view);
- (void)start;
- (void)stop;
- (void)insertBullet:(WKBarrageModel *)model;
@end
