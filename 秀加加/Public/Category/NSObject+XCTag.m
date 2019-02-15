//
//  NSObject+XCTag.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "NSObject+XCTag.h"

@implementation NSObject (XCTag)

-(NSDictionary *)dicWithJsonStr:(NSString *)jsonStr{
    if (jsonStr.length>3) {
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSArray *titleArr = [self extractMessageWithArr:jsonArr andField:@"TagName"];
        NSArray *colorArr = [self extractMessageWithArr:jsonArr andField:@"TagColor"];
        NSArray *sortArr = [self extractMessageWithArr:jsonArr andField:@"Sort"];
        return @{@"titleArr":titleArr,@"colorArr":colorArr,@"sortArr":sortArr};
    }
    return @{};
}
-(NSArray *)extractMessageWithArr:(NSArray *)arr andField:(NSString *)fieldStr{
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *item in arr) {
        [array addObject:[item objectForKey:fieldStr]];
    }
    return array;
}
@end
