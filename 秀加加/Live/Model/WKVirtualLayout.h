//
//  WKVirtualLayout.h
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKVirtualWorldModel;

@interface WKVirtualLayout : NSObject

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGRect profileRect;
@property (nonatomic,copy) NSArray *imageVRects;
@property (nonatomic,assign) CGRect DescRect;
@property (nonatomic,assign) CGRect memoRect;

@property (nonatomic,strong) WKVirtualWorldModel *dataModel;

//- (void)setDataModel:(WKVirtualWorldModel *)dataModel;

@end
