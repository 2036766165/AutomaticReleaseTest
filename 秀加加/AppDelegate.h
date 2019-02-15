//
//  AppDelegate.h
//  秀加加
//
//  Created by lin on 16/8/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy) void(^RunRongCloud)();

-(void)customTabBar;  


@end

