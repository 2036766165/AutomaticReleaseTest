//
//  UIImage+Gif.h
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gif)

/**
 *  NSString *path = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"gif"];
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
    或者
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfFile:path]];
 *
 */
/** 用一个Gif生成UIImage，传入一个GIFData */
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;

/** 用一个Gif生成UIImage，传入一个GIF路径 */
+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;

@end
