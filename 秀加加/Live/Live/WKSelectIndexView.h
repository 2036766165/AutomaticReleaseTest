//
//  WKSelectIndexView.h
//  秀加加
//
//  Created by sks on 2016/11/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKSelectIndexView : UIView

/*
 0 取消
 1 查看
 */
+ (void)showWithText:(NSString *)text btnTitles:(NSArray *)btnTitles SelectIndex:(void (^)(NSInteger index))block;

@end
