//
//  UIViewController+WKTrack.h
//  wdbo
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WKItemBtn;


@interface UIViewController (WKTrack) 

@property (nonatomic,strong) WKItemBtn *itemBtn;

- (UIViewController*)viewControllerWith:(UIView *)view;



//@property (strong, nonatomic) UIView * promptView;

@end
