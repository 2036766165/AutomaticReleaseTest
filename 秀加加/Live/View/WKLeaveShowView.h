//
//  WKLeaveShowView.h
//  秀加加
//
//  Created by sks on 2016/10/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"
#import "WKHomePlayModel.h"

typedef enum : NSUInteger {
    WKLeaveShowTypeLive,
    WKLeaveShowTypeGoodsInfo
} WKLeaveShowType;

@interface WKLeaveShowView : UIView

- (instancetype)initWithFrame:(CGRect)frame playModel:(WKHomePlayModel *)model;

- (void)setShowType:(WKLeaveShowType)type rect:(CGRect)rect;

@end
