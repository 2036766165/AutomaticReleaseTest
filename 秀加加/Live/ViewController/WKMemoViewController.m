//
//  WKMemoViewController.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/26.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKMemoViewController.h"

@interface WKMemoViewController ()

@end

@implementation WKMemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"描述";
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64)];
    textView.editable = NO;
    textView.textColor = [UIColor colorWithHexString:@"7e879d"];
    textView.text = self.textStr;
    textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
