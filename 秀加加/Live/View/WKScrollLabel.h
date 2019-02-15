//
//  WKScrollLabel.h
//  秀加加
//
//  Created by sks on 2017/3/8.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKScrollLabel : UIView

@property (nonatomic,copy) NSString *text;

//@property (nonatomic,assign) BOOL isScrollAble;

- (instancetype)initWithSuperViewWidth:(CGFloat)width;

@end
