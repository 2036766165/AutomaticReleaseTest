//
//  WKProgressHUD.h
//  秀加加
//
//  Created by sks on 2016/9/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKProgressHUD : NSObject

/*
 * 显示文本提示
 */
//+ (void)showText:(NSString *)text;

/*
 * 网络加载提示,在window上
 */
+ (void)showLoadingText:(NSString *)text;

/*
 * 网络加载提示,在view上
 */
+ (void)showLoadingText:(NSString *)text on:(UIView *)view;

/*
 * 成功的提示
 */
//+ (void)showSuccessWith:(NSString *)text;

/*
 * 失败的提示
 */
//+ (void)showErrorWith:(NSString *)text;

/*
 * 显示GIF图
 */
+ (void)showLoadingGifText:(NSString *)text;


/**
 显示圆圈的GIF图

 @param text 描述信息
 */
+ (void)showWatchShowLoadingGifText:(NSString *)text;

/*
 * 在window上隐藏
 */
+ (void)dismiss;

/*
 * 在UIView上隐藏
 */
+ (void)dismissOn:(UIView *)view;

+ (void)showTopMessage:(NSString *)msg;


@end
