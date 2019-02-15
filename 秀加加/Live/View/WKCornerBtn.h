//
//  WKCornerBtn.h
//  秀加加
//
//  Created by sks on 2016/12/16.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCornerBtn : UIView

//+ (UIView *)cornerViewWithTitle:(NSString *)title
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName borderColor:(UIColor *)borderColor;

- (void)setTitle:(NSString *)title;

- (void)addTarget:(id)target sel:(SEL)sel;

@end
