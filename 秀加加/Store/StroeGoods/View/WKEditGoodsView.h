//
//  WKEditGoodsView.h
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsBottomView.h"

@class WKGoodsModel;

@interface WKEditGoodsView : UIView


- (instancetype)initWithFrame:(CGRect)frame type:(WKGoodsType)type;

// 获取编辑的信息
- (NSDictionary *)getEditInfo;

- (void)setDataModel:(WKGoodsModel *)dataModel;

@end
