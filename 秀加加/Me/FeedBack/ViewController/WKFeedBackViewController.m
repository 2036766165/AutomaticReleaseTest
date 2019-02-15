//
//  WKFeedBackViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKFeedBackViewController.h"
#import "UITextView+Placeholder.h"

@implementation WKFeedBackViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",WK_MyAppID ];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}

@end
