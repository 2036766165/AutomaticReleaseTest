//
//  NSString+ValiMobile.h
//  SaaSPrj
//
//  Created by freeUser on 16/5/23.
//  Copyright © 2016年 ksyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(ShowMessage)
+ (void)showMessage:(NSString *)message inCurrentView:(UIView *)view;
@end

@interface NSString (ValiMobile)
//验证手机号时候正确
+ (NSString *)valiMobile:(NSString *)mobile;
@end

@interface NSString(ValiIdengifier)
+ (BOOL)isValidNumber:(NSString*)value;
//校验身份证
+ (BOOL)validateIDCardNumber:(NSString *)value;
@end