//
//  WKCashView.h
//  秀加加
//
//  Created by sks on 2016/10/15.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

#import "WKPayTool.h"

typedef void(^PayBlock)(WKPayOfType);

@interface WKCashView : UIView

// 支付保证金
+ (void)showCashViewWith:(WKGoodsLayoutType)screenType titleStr:(NSString *)titleStr reminderStr:(NSString *)reminderStr tipStr:(NSString *)tipStr payBlock:(void(^)(WKPayOfType payType,NSNumber *balanceNum))block;

@end
