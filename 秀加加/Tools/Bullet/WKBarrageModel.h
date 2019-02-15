//
//  XCShowBarrageModel.h
//  XCBarrageView
//
//  Created by Chang_Mac on 16/12/26.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBarrageModel : NSObject

@property (strong, nonatomic) NSString * headPic;//图片或链接
@property (strong, nonatomic) NSString * nameStr;
@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * BPOID;//可选

@end
