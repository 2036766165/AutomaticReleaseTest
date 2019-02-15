//
//  WKPlayTool.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/21.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKPlayTool : NSObject

+(void)writeFileWithStr:(NSString *)voiceStr :(void(^)(NSString *voicePath,NSString * requestMessage))message;

@end
