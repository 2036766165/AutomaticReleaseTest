//
//  XCTimeCalcute.m
//  矿脉
//
//  Created by Chang_Mac on 16/1/13.
//  Copyright © 2016年 徐恒. All rights reserved.
//

#import "WKTimeCalcute.h"

@implementation WKTimeCalcute
+(NSString *) compareCurrentTime:(NSString*) timeStr

{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* compareDate = [formater dateFromString:timeStr];

    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if(timeInterval == 0){
        result = [NSString stringWithFormat:@"未直播"];
    }
    else if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"1分钟前直播"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前直播",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前直播",temp];
    }
    
    else{
        result = [NSString stringWithFormat:@"%ld天前直播",temp/24];
    }
    
//    else if((temp = temp/24) <30){
//        result = [NSString stringWithFormat:@"%ld天前直播",temp];
//    }
//    
//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前直播",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前直播",temp];
//    }
    
    return  result;
}

+(NSDate *)stringTransferDate:(NSString *)dateStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:dateStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
    return localeDate;
}
@end
