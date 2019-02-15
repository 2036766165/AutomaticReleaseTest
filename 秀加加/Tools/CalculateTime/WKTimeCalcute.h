//
//  XCTimeCalcute.h
//  矿脉
//
//  Created by Chang_Mac on 16/1/13.
//  Copyright © 2016年 徐恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKTimeCalcute : NSObject

+(NSString *) compareCurrentTime:(NSString*) timeStr;
/**
 *  (yyyy-MM-dd HH:mm:ss)
 */
+(NSDate *)stringTransferDate:(NSString *)dateStr;
@end
