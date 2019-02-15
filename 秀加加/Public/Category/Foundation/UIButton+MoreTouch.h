//
//  UIButton+MoreTouch.h
//  秀加加
//
//  Created by Chang_Mac on 16/11/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//  暴力点击

#import <UIKit/UIKit.h>

@interface UIButton (MoreTouch)

@property (assign, nonatomic) NSTimeInterval touchInterval;//时间间隔
@property (assign, nonatomic) BOOL isClose;//是否触发间隔 NO不触发

@end
