//
//  NSString+WJ.h
//  PXMall
//
//  Created by WangJian on 16/1/20.
//  Copyright © 2016年 lchbl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WJ)

+ (NSString *)configUrl:(NSString *)url With:(NSArray *)keys values:(NSArray *)values;
+ (BOOL) isBlankString:(NSString *)string;
//+ (BOOL) isMobileNumber:(NSString *)mobileNum;
+ (BOOL) isZipCode:(NSString *)codenum;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (BOOL) isVaildPhoneNumber:(NSString *)phoneNum;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
