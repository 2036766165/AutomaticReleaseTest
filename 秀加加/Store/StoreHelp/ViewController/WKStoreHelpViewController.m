//
//  WKStoreHelpViewController.m
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreHelpViewController.h"
#import "WKAllWebView.h"
#import "WKStoreHelpTableView.h"
#import "WKAllWebViewController.h"

@interface WKStoreHelpViewController ()

@property (nonatomic,strong) WKStoreHelpTableView *storeHelpTableView;
@property (nonatomic,strong) NSArray *urlString;
@property (nonatomic,strong) NSArray *titles;
@property (strong, nonatomic) UIWebView * webView;

@end

@implementation WKStoreHelpViewController

//- (WKStoreHelpTableView *)storeHelpTableView
//{
//    if (!_storeHelpTableView) {
//        _storeHelpTableView = [[WKStoreHelpTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
//        _storeHelpTableView.backgroundColor = [UIColor whiteColor];
//        _storeHelpTableView.titles = self.titles;
//    }
//    return _storeHelpTableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUi];
    [self event];
    [self back];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //    [self.view addSubview:self.storeHelpTableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)back{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(-20, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
-(void)btnClick{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)initUi
{
    self.title = @"开店帮助";
    self.urlString = @[WK_OftenQuestion,WK_LimitShops];
    self.titles = @[@"常见问题",@"show++禁售商品管理规范>>"];
}

-(void)event
{
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.silentwind.com.cn/HelpCenter/index.html"]]];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    
//    WeakSelf(WKStoreHelpViewController);
//    self.storeHelpTableView.selectClickType = ^(NSIndexPath *index){
//        WKAllWebViewController *allWebVc = [[WKAllWebViewController alloc] init];
//        allWebVc.urlString = weakSelf.urlString[index.row];
//        allWebVc.titles = weakSelf.titles[index.row];
//        [weakSelf.navigationController pushViewController:allWebVc animated:YES];
//    };
}

@end
