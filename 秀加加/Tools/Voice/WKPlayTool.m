//
//  WKPlayTool.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/21.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPlayTool.h"
static NSString *lastStr;
@implementation WKPlayTool
+(void)writeFileWithStr:(NSString *)voiceStr :(void(^)(NSString *voicePath,NSString * requestMessage))message{
    NSString * url = NSTemporaryDirectory();
    url = [url stringByAppendingString:[NSString stringWithFormat:@"dsgxc.spx"]];
    if ([voiceStr isEqualToString:lastStr] && url.length>0) {
        message(url,@"写入成功");
        return;
    }
    dispatch_queue_t queue = dispatch_queue_create("voiceLoadQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:voiceStr]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager createFileAtPath:url contents:data attributes:nil];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                message(url,@"写入成功");
            });
            lastStr = voiceStr;
        }else{
            message(url,@"写入失败");
        }
    });
}


@end
