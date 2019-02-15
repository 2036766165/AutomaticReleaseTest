//
//  WKGoodsItemProtocol.h
//  秀加加
//
//  Created by sks on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class WKGoodsListItem;

typedef enum : NSUInteger {
    WKOperateTypeUp,
    WKOperateTypeShare,
    WKOperateTypeTop,
    WKOperateTypeDown,
    WKOperateTypeDelete,
    WKOperateTypeDetail,
    WKOperateTypeEdit
} WKOperateType;

@protocol WKGoodsItemProtocol <NSObject>
- (void)operateGoods:(WKOperateType)type obj:(id)model;

@end
