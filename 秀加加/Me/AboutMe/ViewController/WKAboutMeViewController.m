//
//  WKAboutMeViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAboutMeViewController.h"
#import "WKAboutMeTableView.h"
#import "WKAllWebViewController.h"
#import "WKContactViewController.h"


@interface WKAboutMeViewController()

@property (nonatomic,strong) WKAboutMeTableView *aboutTableView;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSArray *urlString;

@end

@implementation WKAboutMeViewController


- (WKAboutMeTableView *)aboutTableView
{
    if (!_aboutTableView) {
        _aboutTableView = [[WKAboutMeTableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW-40, 150)];
        _aboutTableView.backgroundColor = [UIColor whiteColor];
        _aboutTableView.titles = self.titles;
        
    }
    return _aboutTableView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
    
    [self initData];
    
    [self initUi];
    
    [self event];
}

-(void)initData
{
    self.titles = @[@"用户服务协议",@"直播协议",@"联系我们"];
    self.urlString = @[WK_UserAddress,WK_LiveAddress,@""];
}

-(void)initUi
{
    self.title = @"关于我们";
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *headimageView = [[UIImageView alloc] init];
    headimageView.image = logoImage;
    [self.view addSubview:headimageView];
    [headimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset((WKScreenW-logoImage.size.width)/2);
        make.top.equalTo(self.view).offset(90+64);
        make.size.mas_equalTo(CGSizeMake(logoImage.size.width,logoImage.size.height));
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    // app名称
    //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
//    version.text = [NSString stringWithFormat:@"版本: V%@",app_Version];

    
    UILabel *version = [[UILabel alloc] init];
    version.textAlignment = NSTextAlignmentCenter;
    version.text = [NSString stringWithFormat:@"版本: V%@",app_Version];
    version.font = [UIFont systemFontOfSize:14];
    version.textColor = [UIColor colorWithHex:0x9199AC];
    [self.view addSubview:version];
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(headimageView.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 4.0;
    backgroundView.layer.borderColor = [[UIColor colorWithHex:0x9199AC] CGColor];
    backgroundView.layer.borderWidth = 1.0;
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(version.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-40, 150));
    }];
    
    [backgroundView addSubview:self.aboutTableView];
    [self.aboutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(0);
        make.right.equalTo(backgroundView.mas_right).offset(0);
        make.top.equalTo(backgroundView).offset(0);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(0);
    }];
}

-(void)event
{
    WeakSelf(WKAboutMeViewController);
    self.aboutTableView.selectClickType = ^(NSIndexPath *index){
        if(index.row == 2)
        {
            WKContactViewController *contactVc = [[WKContactViewController alloc] init];
            [weakSelf.navigationController pushViewController:contactVc animated:YES];
        }
        else
        {
            WKAllWebViewController *allWebVc = [[WKAllWebViewController alloc] init];
            allWebVc.titles = weakSelf.titles[index.row];
            allWebVc.urlString = weakSelf.urlString[index.row];
            [weakSelf.navigationController pushViewController:allWebVc animated:YES];
        }
    };
}

@end
