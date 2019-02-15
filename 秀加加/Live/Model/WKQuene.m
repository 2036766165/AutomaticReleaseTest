//
//  WKQuene.m
//  秀加加
//
//  Created by sks on 2017/3/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKQuene.h"

@implementation WKQuene{
    NSMutableArray *_queueArr;
}

- (void)enqueueWith:(id)md{
    if (!_queueArr) {
        _queueArr = @[].mutableCopy;
    }
    [_queueArr addObject:md];
}

- (id)dequeue{
    if ([self isEmpty]) {
        return nil;
    }
    id md = _queueArr[0];
    [_queueArr removeObjectAtIndex:0];
    return md;
}

- (BOOL)isEmpty{
    if (!_queueArr || _queueArr.count == 0) {
        return YES;
    }
    return NO;
}

- (NSInteger)queueCount{
    return _queueArr.count;
}

@end
