//
//  WKLiveAgreeMent.m
//  wdbo
//
//  Created by lin on 16/7/12.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLiveAgreeMent.h"
#import "WKLiveTitleViewController.h"

@interface WKLiveAgreeMent()<UIWebViewDelegate>

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) UIButton *agreeBtn;

@end

@implementation WKLiveAgreeMent

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUi];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-70 - 64)];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    webView.opaque = NO;
    NSURL* url = [NSURL URLWithString:WK_LiveAddress];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.3];
    [self.view addSubview:view];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:self.activityIndicator];
    [self.view addSubview:webView];
    
    self.agreeBtn = [[UIButton alloc] init];
    [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.agreeBtn setTitle:@"我同意" forState:UIControlStateNormal];
    self.agreeBtn.layer.cornerRadius = 4.0;
    self.agreeBtn.layer.masksToBounds = YES;
    [self.agreeBtn setBackgroundColor:[UIColor colorWithHex:0xFC6620]];
    [self.view addSubview:self.agreeBtn];
    [self.agreeBtn addTarget:self action:@selector(agreeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(50);
    }];

//    [self initWeb];
}

-(void)initUi
{
    self.title = @"直播协议";
}

-(void)initWeb
{
    }

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)web
{
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error
{
    [WKPromptView showPromptView:@"网页错误"];
}

-(void)agreeEvent:(UIButton *)sender
{
    WKLiveTitleViewController *titleVC = [[WKLiveTitleViewController alloc] init];
    [self.navigationController pushViewController:titleVC animated:YES];
}

@end


