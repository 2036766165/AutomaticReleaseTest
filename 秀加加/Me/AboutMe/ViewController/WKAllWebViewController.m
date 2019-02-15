//
//  WKAllWebViewController.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAllWebViewController.h"
#import "WKAllWebView.h"

@interface WKAllWebViewController ()

@end

@implementation WKAllWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initUi
{
    self.title = self.titles;
    WKAllWebView *allWebView = [[WKAllWebView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-64) UrlString:self.urlString];
    [self.view addSubview:allWebView];
}

@end
