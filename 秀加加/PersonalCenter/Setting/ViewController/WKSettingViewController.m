//
//  WKSettingViewController.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKSettingViewController.h"
#import "WKSwitchNotifyViewController.h"
#import "WKAboutMeViewController.h"
#import "WKAppealViewController.h"
#import "WKStoreHelpViewController.h"
#import "WKLoginViewController.h"
#import "WKNavigationController.h"
#import <RongIMLib/RCIMClient.h>
#import <RongIMKit/RongIMKit.h>
#import "WKShowInputView.h"
@interface WKSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Personal_help"] selImage:nil target:self action:@selector(rightItemAction)];
    [self createTableView];
}
-(void)createTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [self.view addSubview:tableView];
}
#pragma mark tableview deletage
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0: case 2: case 6:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        default:
        {
            WKSettingCell *settingCell = [[WKSettingCell alloc]init];
            if (indexPath.row == 7) {
                settingCell.arrowIM.hidden = YES;
                settingCell.titleLabel.frame = CGRectMake(0, 0, WKScreenW, WKScreenW*0.15);
                settingCell.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.045];
                settingCell.titleLabel.textAlignment = NSTextAlignmentCenter;
                settingCell.titleLabel.textColor = [UIColor orangeColor];
            }
            settingCell.headIM.image = [UIImage imageNamed:@[@"",@"Personal_notice",@"",@"Personal_about-us",@"Personal_yjfk",@"Personal_cfsq",@"",@""][indexPath.row]];
            settingCell.titleLabel.text = @[@"",@"开播通知",@"",@"关于我们",@"意见与反馈",@"处罚申诉",@"",@"退出登录"][indexPath.row];
            settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return settingCell;
            break;
        }
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0: case 2: case 6:
        {
            return WKScreenW*0.03;
            break;
        }
        default:
        {
            return WKScreenW*0.15;
            break;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        {
            [self.navigationController pushViewController:[[WKSwitchNotifyViewController alloc]init] animated:YES];
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[[WKAboutMeViewController alloc]init] animated:YES];
        }
            break;
        case 4:
        {
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",WK_MyAppID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 5:
        {
            [self.navigationController pushViewController:[[WKAppealViewController alloc]init] animated:YES];
        }
            break;
        case 7:
        {
            [WKShowInputView showInputWithPlaceString:@"您确定要退出么?" type:LABELTYPE andBlock:^(NSString * Count) {
                [WKHttpRequest loginOutApp:HttpRequestMethodPost url:WKAppLogOut param:nil success:^(WKBaseResponse *response) {
                    [self xw_postNotificationWithName:@"LOGOUT" userInfo:nil];
                    WKLoginViewController *loginVc = [[WKLoginViewController alloc] init];
                    WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:loginVc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    
                    User.loginStatus = NO;
                    //删除本地Token
                    NSUserDefaults *defaultUser  = [NSUserDefaults standardUserDefaults];
                    [defaultUser removeObjectForKey:TOKEN];
                    
                    //删除本地定位城市
                    [defaultUser removeObjectForKey:MEMBERLOCATION];
                    
                    [defaultUser synchronize];
                    
                    [[RCIM sharedRCIM] logout];
                    
                } failure:^(WKBaseResponse *response) {
                    LOGD(@"response : %@",response);
                }];
            }];
        }
            break;
            
    }
}

-(void)rightItemAction{
    WKStoreHelpViewController *storeHelpVc = [[WKStoreHelpViewController alloc] init];
    [self.navigationController pushViewController:storeHelpVc animated:YES];
}

@end


@implementation WKSettingCell

-(instancetype)init{
    if(self = [super init]){
        self.headIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.05, WKScreenW*0.06, WKScreenW*0.05)];
        [self.contentView addSubview:self.headIM];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.12, 0, WKScreenW*0.5, WKScreenW*0.15)];
        self.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        [self.contentView addSubview:self.titleLabel];
        self.arrowIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.95, WKScreenW*0.0505, WKScreenW*0.02, WKScreenW*0.04)];
        self.arrowIM.image = [UIImage imageNamed:@"Personal_right_arrow"];
        [self.contentView addSubview:self.arrowIM];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, WKScreenW*0.15-1, WKScreenW, 1)];
        line.alpha = 0.5;
        line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [self.contentView addSubview:line];
    }
    return self;
}

@end












