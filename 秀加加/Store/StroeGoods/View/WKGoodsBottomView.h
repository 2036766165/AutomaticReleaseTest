//
//  WKGoodsBottomView.h
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKGoodsTypeSale,        // 商品
    WKGoodsTypeAuction,     // 虚拟商品
    WKGoodsTypeCrowd,       // 筹卖
    WKGoodsTypeNormal
} WKGoodsType;

typedef enum : NSUInteger {
    WKGoodsManageAdd,        // 添加
    WKGoodsManagePatch       // 批量管理
} WKGoodsManage;


@protocol WKGoodsBottomDelegate <NSObject>

- (void)goodsBottomType:(WKGoodsManage)type;

@end

@interface WKGoodsBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles type:(WKGoodsType)type;

@property (nonatomic,weak) id<WKGoodsBottomDelegate> delegate;

@end
