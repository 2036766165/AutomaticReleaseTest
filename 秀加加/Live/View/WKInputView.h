//
//  WKInputView.h
//  秀加加
//
//  Created by sks on 2016/10/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKInputGifView.h"
#import "WKGoodsHorCollectionViewCell.h"

typedef enum : NSUInteger {
    WKInputTypText,
    WKInputTypeGif,
    WKInputTypeBarrage
} WKInputType;

@class WKMessage;

@interface WKInputView : UIView

+ (void)showTextViewOn:(UIView *)superView screenType:(WKGoodsLayoutType)screenType inputType:(WKInputType)inputType WithInputBlock:(void(^)(WKMessage *message))block;

+ (void)settingPlaceholderContentWithType:(NSInteger)status;//根据状态判断提示内容

@end
