//
//  WKPagesView.h
//  wdbo
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCollectionView;

typedef enum : NSUInteger {
    WKPageTypeNormal,
    WKPageTypeShare,
    WKPageTypeOrder
} WKPageType;

@interface WKPagesView : UIView

- (instancetype)initWithFrame:(CGRect)frame toolBarType:(WKPageType)type BtnTitles:(NSArray *)titles images:(NSArray *)imageNames selectedImages:(NSArray *)selectedImages  viewController:(NSArray <UIViewController *>*)viewControllers;

- (void)setBadges:(NSArray *)array;

- (void)selectedIndex:(NSInteger)index;

@end
