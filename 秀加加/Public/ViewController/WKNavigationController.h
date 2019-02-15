//
//  WKNavigationController.h
//  wdbo
//
//  Created by sks on 16/6/15.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKNavigationController : UINavigationController

@property (nonatomic, strong) id popDelegate;

- (void)back;

@end
