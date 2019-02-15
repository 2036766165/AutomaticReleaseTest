//
//  WKCellOperationProtocol.h
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKOpeartionTypeDel
} WKOpeartionType;

@protocol WKCellOperationProtocol <NSObject>

@optional
- (void)opeartionCell:(id)cell type:(WKOpeartionType)type;
- (void)refreshHeight:(CGFloat)height;

- (void)getImageArr:(NSArray *)imageArr memo:(NSString *)memo;

@end
