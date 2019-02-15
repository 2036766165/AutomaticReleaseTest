//
//  NSString+WJ.m
//  PXMall
//
//  Created by WangJian on 16/1/20.
//  Copyright © 2016年 lchbl. All rights reserved.
//

#import "NSString+WJ.h"


@implementation NSString (WJ)

+ (NSString *)configUrl:(NSString *)url With:(NSArray <NSString *>*)keys values:(NSArray <NSString *>*)values{
    
    NSAssert(keys.count == values.count, @"键值的个数必须相等");
    
    NSString *str = @"";
    
    for (int i=0; i<keys.count; i++) {
        id valueStr = values[i];
        
        if (![valueStr isKindOfClass:[NSString class]]) {
            valueStr = [NSString stringWithFormat:@"%@",valueStr];
        }
        
        NSAssert([valueStr isKindOfClass:[NSString class]], @"必须是NSString类型的值");
        
        valueStr = [valueStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *item = [NSString stringWithFormat:@"%@=%@",keys[i],valueStr];
        if (str.length != 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"&%@",item]];
        }else{
            str = item;
        }
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",str]];
    return url;
    
}

+ (BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

// 手机号码的有效性判断
// 检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isVaildPhoneNumber:(NSString *)phoneNum{
    
    NSString *Mobile = @"^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9])|(14[5,7]))\\d{8}$";
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Mobile];
    return [regextestMobile evaluateWithObject:phoneNum];
}

// 邮政编码的有效性判断
+ (BOOL) isZipCode:(NSString *)codenum
{
    const char *cvalue = [codenum UTF8String];
    int len = (int)strlen(cvalue);
    if (len != 6)
    {
        return NO;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return NO;
        }
    }
    return YES;
}
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
