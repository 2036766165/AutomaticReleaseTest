//
//  WKOnlinePersonListView.h
//  秀加加
//
//  Created by sks on 2016/10/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKOnLineMd;

typedef enum : NSUInteger {
    WKOperateTypeGetList,
    WKOperateTypeOnline,
    WKOperateTypeOffline
} WKOperateType;

@protocol WKOnlinePersonDelegate <NSObject>
- (void)selectedPerson:(WKOnLineMd *)md;
@end

@interface WKOnlinePersonListView : UIView

@property (nonatomic,assign) id <WKOnlinePersonDelegate> delegate;

// 操作在线人数列表
- (void)operateAPerson:(id)result operateType:(WKOperateType)type totalCount:(NSUInteger)totalCount completionBlock:(void(^)())block;

- (void)setItemStateWithBPOID:(NSString *)bpoid type:(NSInteger)type;

@end
