//
//  NSString+substring.h
//  IOS_YFramework
//
//  Created by 吴文豪 on 2016/11/11.
//  Copyright © 2016年 Alienwow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (substring)

/**
 截取包含emoji表情的字符串

 @param index 截取字符串的长度
 @param material 长度超出限制后要拼接的字符串
 @return 返回处理后的字符串 _Nonnull
 */
-(NSString * _Nonnull) subEmojiStringTo:(NSUInteger)index with:(NSString * _Nullable)material;

/**
 截取字符串

 @param index 截取字符串的长度
 @param material 长度超出限制后要拼接的字符串
 @return 返回处理后的字符串 _Nonnull
 */
-(NSString * _Nonnull) subStringTo:(NSUInteger)index with:(NSString * _Nullable)material;

/**
 截取包含emoji表情的字符串

 @param str 要被截取的字符串
 @param index 截取字符串的长度
 @param material 长度超出限制后要拼接的字符串
 @return 返回处理后的字符串 _Nonnull
 */
+(NSString * _Nonnull) subEmojiStringTo:(NSString *_Nonnull)str To:(NSUInteger)index with:(NSString * _Nullable)material;

/**
 截取字符串

 @param str 要被截取的字符串
 @param index 截取字符串的长度
 @param material 长度超出限制后要拼接的字符串
 @return 返回处理后的字符串 _Nonnull
 */
+(NSString * _Nonnull) subString:(NSString *_Nonnull)str To:(NSUInteger)index with:(NSString * _Nullable)material;

@end
