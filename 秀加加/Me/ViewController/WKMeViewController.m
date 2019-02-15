//
//  WKMeViewController.m
//  秀加加
//
//  Created by lin on 16/8/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMeViewController.h"
#import "WKMeTableView.h"
#import "WKMyOrderViewController.h"
#import "WKMessageViewController.h"
#import "WKMyAttentionViewController.h"
#import "WKAddressViewController.h"
#import "WKMyIntegralViewController.h"
#import "WKHistoryViewController.h"
#import "WKEvaluateViewController.h"
#import "WKAboutMeViewController.h"
#import "WKFeedBackViewController.h"
#import "WKAppealViewController.h"
#import "WKPersonEditViewController.h"
#import "WKShopOrderViewController.h"
#import "WKSellOrderViewController.h"
#import "WKAttentionViewController.h"
#import "WKFansViewController.h"
#import "WKLoginViewController.h"
#import "WKNavigationController.h"
#import "WKProgressHUD.h"
#import "WKMeModel.h"
#import "WkMyOrderShopOrderViewController.h"
#import "WkMyOrderSellOrderViewController.h"
#import "WKStoreTagViewController.h"
#import "NSObject+XWAdd.h"
#import "WKStoreModel.h"
#import <RongIMLib/RCIMClient.h>
#import "WKStoreIncomeViewController.h"
#import "WKSwitchNotifyViewController.h"


@interface WKMeViewController ()

@property (nonatomic,strong) WKMeTableView *meTableView;
@property (assign, nonatomic) BOOL isRed;

@end

@implementation WKMeViewController

- (WKMeTableView *)meTableView
{
    if (!_meTableView) {
        _meTableView = [[WKMeTableView alloc] initWithFrame:CGRectMake(0, 69, WKScreenW, WKScreenH-69)];
    }
    return _meTableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self xw_addNotificationForName:@"person" block:^(NSNotification * _Nonnull notification) {
        
        [self loadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"TAG" object:nil];
    self.navigationController.navigationBar.hidden = NO;
    [self unreadMessage];
}

-(void)refreshView
{
    [self.meTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TAG" object:nil];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.meTableView promptViewShow:@"选择标签成功"];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.meTableView];
    [self.meTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(69);
        make.height.mas_offset(WKScreenH - 69);
    }];
    [self initData];
    [self event];
    [self loadRelationData];
    [self unreadMessage];
    [self unreadNumber];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
}

-(void)unreadMessage{
    int number = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (number>0) {
        self.meTableView.isRed = YES;
    }else{
        self.meTableView.isRed = NO;
    }
    if (self.meTableView) {
        [self.meTableView.tableView reloadData];
    }
}

-(void)unreadNumber{
    [self xw_addNotificationForName:@"redCircle" block:^(NSNotification * _Nonnull notification) {
        [self unreadMessage];
    }];
    [self xw_addNotificationForName:@"RongRefresh" block:^(NSNotification * _Nonnull notification) {
        [self.meTableView.tableView reloadData];
    }];
}

-(void)pushOrderView{
    NSArray *titles = @[@"商品订单", @"拍卖订单"];
    NSArray *viewControllers = @[[WkMyOrderShopOrderViewController class],
                                 [WkMyOrderSellOrderViewController class]];
    WKMyOrderViewController *pageController = [[WKMyOrderViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageController.menuHeight = 44;
    pageController.menuItemWidth = 80;
    pageController.titleSizeSelected = 18;
    pageController.titleSizeNormal = 18;
    pageController.itemMargin = 20;
    pageController.selectIndex = 1;
    pageController.menuViewStyle = WMMenuViewStyleTriangle;
    pageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
    pageController.titleColorSelected = [UIColor colorWithHex:0xFB7934];
    pageController.showOnNavigationBar = YES;
    pageController.menuBGColor = [UIColor clearColor];
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    [self.navigationController pushViewController:pageController animated:YES];
}

-(void)loadData
{
    [WKHttpRequest getPersonMessage:HttpRequestMethodGet url:WKGetPersonMessage model:NSStringFromClass([WKMeModel class]) param:nil success:^(WKBaseResponse *response) {
        
        NSLog(@"%@",response.json);
        
        WKMeModel *model = response.Data;

        self.meTableView.model = model;
        
        [self.meTableView reloadData];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//查询统计粉丝数量
-(void)loadRelationData
{
    [WKHttpRequest getMemberMessageCount:HttpRequestMethodGet url:WKGetMemberMessageCount model:@"WKStoreModel" param:nil success:^(WKBaseResponse *response) {
        WKStoreModel *model = response.Data;
        self.meTableView.funsCount = model.FunsCount;
        [self.meTableView reloadData];
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)initData
{
    self.title = @"个人中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
}

-(void)event
{
    WeakSelf(WKMeViewController);
    //退出登录账号
    self.meTableView.quitCallBack = ^(NSInteger type){
        if(type == 1)
        {
            [WKHttpRequest loginOutApp:HttpRequestMethodPost url:WKAppLogOut param:nil success:^(WKBaseResponse *response) {
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
        }
        else if(type == 2)
        {
            [weakSelf editEvent];
        }
    };
    
    self.meTableView.selectViewConotroller = ^(NSIndexPath *indexPath){
        if(indexPath.row == SELECTROW+1)
        {
            NSArray *titles = @[@"商品订单", @"拍卖订单"];
            NSArray *viewControllers = @[[WkMyOrderShopOrderViewController class],
                                         [WkMyOrderSellOrderViewController class]];
            WKMyOrderViewController *pageController = [[WKMyOrderViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
            pageController.menuHeight = 44;
            pageController.menuItemWidth = 80;
            pageController.titleSizeSelected = 18;
            pageController.titleSizeNormal = 18;
            pageController.itemMargin = 20;
            pageController.menuViewStyle = WMMenuViewStyleTriangle;
            pageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
            pageController.titleColorSelected = [UIColor colorWithHex:0xFB7934];
            pageController.showOnNavigationBar = YES;
            pageController.menuBGColor = [UIColor clearColor];
            pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
            [weakSelf.navigationController pushViewController:pageController animated:YES];
        }
        else if (indexPath.row == SELECTROW+3)
        {
            NSArray *focusTitles = @[@"关注", @"粉丝"];
            NSArray *focusViewController = @[[WKAttentionViewController class],
                                             [WKFansViewController class]];
            WKMyAttentionViewController *focusPageController = [[WKMyAttentionViewController alloc] initWithViewControllerClasses:focusViewController andTheirTitles:focusTitles];
            focusPageController.menuHeight = 44;
            focusPageController.menuViewStyle = WMMenuViewStyleTriangle;
            focusPageController.titleSizeSelected = 18;
            focusPageController.titleSizeNormal = 18;
            focusPageController.itemMargin = 20;
            focusPageController.showOnNavigationBar = YES;
            focusPageController.menuBGColor = [UIColor clearColor];
            focusPageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
            focusPageController.titleColorSelected = [UIColor colorWithHex:0xFB7934];
            focusPageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
            [weakSelf.navigationController pushViewController:focusPageController animated:YES];
        }
        else if(indexPath.row == SELECTROW+11)
        {
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",WK_MyAppID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else
        {
            UIViewController *jumpController = [[UIViewController alloc]init];
            switch (indexPath.row) {
                case SELECTROW:
                    jumpController = [[WKStoreIncomeViewController alloc]init];
                    jumpController.title = @"我的账户";
                    break;
                case SELECTROW+2:
                    jumpController = [[WKMessageViewController alloc]init];
                    break;
                case SELECTROW+4:
                    jumpController = [[WKAddressViewController alloc] initWithFrom:WKAddressFromCenter];
                    break;
                case SELECTROW+5:
                    jumpController = [[WKMyIntegralViewController alloc]init];
                    break;
                case SELECTROW+6:
                    jumpController = [[WKHistoryViewController alloc]init];
                    break;
                case SELECTROW+7:
                    jumpController = [[WKSwitchNotifyViewController alloc]init];
                    break;
                case SELECTROW+8:
                    jumpController = [[WKStoreTagViewController alloc]init];
                    break;
                case SELECTROW+9:
                    jumpController = [[WKEvaluateViewController alloc]init];
                    break;
                case SELECTROW+10:
                    jumpController = [[WKAboutMeViewController alloc]init];
                    break;
                case SELECTROW+12:
                    jumpController = [[WKAppealViewController alloc]init];
                    break;
                default:
                    break;
            }
            
            [weakSelf.navigationController pushViewController:jumpController animated:YES];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)editEvent
{
    WKPersonEditViewController *personEditVC = [[WKPersonEditViewController alloc] init];
    [self.navigationController pushViewController:personEditVC animated:YES];
}
@end
