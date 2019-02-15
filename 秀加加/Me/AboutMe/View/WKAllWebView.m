//
//  WKAllWebView.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAllWebView.h"


@interface WKAllWebView()<UIWebViewDelegate>

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation WKAllWebView

-(instancetype)initWithFrame:(CGRect)frame UrlString:(NSString *)UrlString
{
    if (self =[super initWithFrame:frame])
    {
        [self SubView:UrlString];
    }
    return self;
}

-(void)SubView:(NSString *)UrlString
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64)];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    webView.opaque = NO;
    NSURL* url = [NSURL URLWithString:UrlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self addSubview:webView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.3];
    [self addSubview:view];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:self.activityIndicator];
    [self addSubview:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)web
{
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView *)[self viewWithTag:103];
    [view removeFromSuperview];
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error
{
    [WKProgressHUD showTopMessage:@"网页错误"];
}

@end
