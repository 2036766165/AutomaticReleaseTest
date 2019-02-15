//
//  WKQuene.h
//  秀加加
//
//  Created by sks on 2017/3/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKQuene : NSObject

- (void)enqueueWith:(id)md;
- (id)dequeue;
- (BOOL)isEmpty;
- (NSInteger)queueCount;

@end
