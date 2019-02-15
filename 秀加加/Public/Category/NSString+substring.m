//
//  NSString+substring.m
//  IOS_YFramework
//
//  Created by 吴文豪 on 2016/11/11.
//  Copyright © 2016年 Alienwow. All rights reserved.
//

#import "NSString+substring.h"

@implementation NSString (substring)

-(NSString *)subEmojiStringTo:(NSUInteger)index with:(NSString *)material{
    NSUInteger rIndex = 0;
    int i = 0;
    for(;i < index; i++){
        if(self.length < rIndex+1)
            break;
        rIndex = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, rIndex+1)].length;
    }
    return [NSString stringWithFormat:@"%@%@",[self substringToIndex:rIndex],material==nil||(rIndex >= self.length)?@"":material];
}

-(NSString *)subStringTo:(NSUInteger)index with:(NSString *)material{
    NSString *res = self;
    if(res.length > index){
        NSRange rang = NSMakeRange(0, index);
        index = [res rangeOfComposedCharacterSequencesForRange:rang].length;
        NSLog(@"%ld",(unsigned long)index);
        res = [NSString stringWithFormat:@"%@%@",[res substringToIndex:index],material==nil?@"":material];
    }
    return res;
}

+(NSString *)subEmojiStringTo:(NSString *)str To:(NSUInteger)index with:(NSString *)material{
    return [str subEmojiStringTo:index with:material];
}

+(NSString *)subString:(NSString *)str To:(NSUInteger)index with:(NSString *)material{
    return [str subStringTo:index with:material];
}

@end
