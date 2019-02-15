//
//  WKRedPacketDetails.m
//  秀加加
//
//  Created by Chang_Mac on 17/3/20.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKRedPacketDetails.h"
#import "WKRedViewDetails.h"
#import "WKRedBagDetailsModel.h"
#import "WKAllWebViewController.h"
@interface WKRedPacketDetails ()

@property (strong, nonatomic) WKRedBagDetailsModel * detailsModel;
@property (strong, nonatomic) WKRedViewDetails * detailsView;

@end

@implementation WKRedPacketDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self reloadData];
}

-(void)createUI{
    self.detailsView = [[WKRedViewDetails alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-64)];
    [self.view addSubview:self.detailsView];
}

-(void)reloadData{
    NSString *urlStr = [NSString configUrl:WKRedPacketDetailsUrl With:@[@"BagID"] values:@[self.model.ID]];
    [WKHttpRequest RedPacketDetails:HttpRequestMethodGet url:urlStr param:nil success:^(WKBaseResponse *response) {
        self.detailsView.model = [WKRedBagDetailsModel yy_modelWithJSON:response.Data];
        [self.detailsView.tablview reloadData];
        [self.detailsView addSubview:[self.detailsView createHeadView]];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    att[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x9CA3B3];
    [self.navigationController.navigationBar setTitleTextAttributes:att];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x9CA3B3]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:(UIBarMetricsDefault)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.view.backgroundColor = [UIColor colorWithHexString:@"#ff6250"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setVCStyle];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#ff6250"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

-(void)setVCStyle{
    UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"baijiantou" highImageName:@"" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = @"show++红包";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#ff6250"]] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"help_white"] selImage:nil target:self action:@selector(help)];
    [self.navigationController setDefinesPresentationContext:YES];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)help{
    WKAllWebViewController *webView = [[WKAllWebViewController alloc]init];
    webView.urlString = @"http://www.silentwind.com.cn/HelpCenter/redpackagehelp.html";
    webView.titles = @"红包帮助";
    [self.navigationController pushViewController:webView animated:YES];
}

@end
