//
//  WKLiveConfigView.h
//  秀加加
//
//  Created by sks on 2017/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKShowConfigTypeCamera,
    WKShowConfigTypeVoice,
    WKShowConfigTypeFilter
} WKShowConfigType;

@interface WKLiveConfigView : UIView

+ (void)showViewType:(WKShowConfigType)viewType defaultIndex:(NSInteger)index clickBlock:(void(^)(NSInteger,WKShowConfigType))clickBlock;

@end
