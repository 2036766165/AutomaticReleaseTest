//
//  WKPersonalCenterViewController.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKPersonalCenterViewController.h"
#import "WKPersonalCenterView.h"
#import "WKPersonalCenterModel.h"
#import "WKAttentionViewController.h"
#import "WKFansViewController.h"
#import "WKPersonEditViewController.h"
#import "WKCustomTabViewController.h"
#import "WKCustomCommentViewController.h"
#import "WKStoreCustomViewController.h"
#import "WKStoreCertificationViewController.h"
#import "WKHistoryViewController.h"
#import "WKAddressViewController.h"
#import "WKStoreTagViewController.h"
#import "WKStoreIncomeViewController.h"
#import "WKVirtualWorldViewController.h"
#import "WkShopOrderViewController.h"
#import "WkMyOrderShopOrderViewController.h"
#import "WKStoreOrderViewController.h"
#import "WKMyOrderViewController.h"
#import "WKGoodsVC.h"
#import "WKSettingViewController.h"
#import "WKMyIntegralViewController.h"
#import "NSObject+XWAdd.h"
#import "WKPersonalCenterCell.h"

@interface WKPersonalCenterViewController ()
@property (strong, nonatomic) CAShapeLayer * shapeLayer;
@property (strong, nonatomic) WKPersonalCenterView *personalView;
@end

@implementation WKPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainUI];
}

-(void)createMainUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.personalView = [[WKPersonalCenterView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-49) style:UITableViewStyleGrouped];
    WeakSelf(WKPersonalCenterViewController);
    self.personalView.selectBlock = ^(SelectType type){
        UIViewController *VC;
        switch (type) {
            case userMessageType://用户信息
            {
                VC = [[WKPersonEditViewController alloc] init];
                break;
            }
            case tagType://标签
            {
                VC = [[WKStoreTagViewController alloc]init];

                break;
            }
            case attentionType://关注
            {
                VC = [[WKAttentionViewController alloc]init];
                break;
            }
            case fansType://粉丝
            {
                VC = [[WKFansViewController alloc]init];
            }
                break;
            case walletType://钱包
            {
                VC = [[WKStoreIncomeViewController alloc] init];
            }
                break;
            case goodsType:{
                //商品
                WKGoodsVC *goodsVC = [[WKGoodsVC alloc] init];
                [weakSelf.navigationController pushViewController:goodsVC animated:YES];
            }
                break;
            case deliverGoodsType://发货
                {
                    NSArray *titles = @[@"发货管理"];
                    NSArray *viewControllers = @[[WKShopOrderViewController class]];
                    WKStoreOrderViewController *pageController = [[WKStoreOrderViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
                    pageController.menuHeight = 44;
                    pageController.menuItemWidth = 80;
                    pageController.titleSizeSelected = 18;
                    pageController.titleSizeNormal = 18;
                    pageController.itemMargin = 0;
                    pageController.selectIndex = 0;
                    pageController.menuViewStyle = WMMenuViewStyleDefault;
                    pageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
                    pageController.titleColorSelected = [UIColor colorWithHex:0xB1B6C3];
                    pageController.showOnNavigationBar = YES;
                    pageController.menuBGColor = [UIColor clearColor];
                    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
                    VC = pageController;
                }
                break;
            case customType://客户
            {
                NSArray *customArr = @[[WKCustomTabViewController class],[WKCustomCommentViewController class]];
                NSArray *customTitles = @[@"客户列表",@"客户评价"];
                WKStoreCustomViewController *customView = [[WKStoreCustomViewController alloc]initWithViewControllerClasses:customArr andTheirTitles:customTitles];
                customView.menuHeight = 44;
                customView.menuItemWidth = 80;
                customView.menuViewStyle = WMMenuViewStyleTriangle;
                customView.titleSizeSelected = 18;
                customView.titleSizeNormal = 18;
                customView.itemMargin = 20;
                customView.showOnNavigationBar = YES;
                customView.menuBGColor = [UIColor clearColor];
                customView.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
                customView.titleColorSelected = [UIColor colorWithHex:0xFB7934];
                customView.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
                VC = customView;
            }
                break;
            case shopCertificateType://店铺认证
            {
                VC =  [[WKStoreCertificationViewController alloc] init];
            }
                break;
            case levelType://等级
            {
                WKMyIntegralViewController *LevelController = [[WKMyIntegralViewController alloc]init];
                LevelController.PersonModel = weakSelf.personalView.model;
                VC = LevelController;
            }
                break;
            case orderType:{
                NSArray *titles = @[@"我的订单"];
                NSArray *viewControllers = @[[WkMyOrderShopOrderViewController class]];
                WKMyOrderViewController *pageController = [[WKMyOrderViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
                pageController.menuHeight = 44;
                pageController.menuItemWidth = 80;
                pageController.titleSizeSelected = 18;
                pageController.titleSizeNormal = 18;
                pageController.itemMargin = 0;
                pageController.selectIndex = 0;
                pageController.menuViewStyle = WMMenuViewStyleDefault;
                pageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
                pageController.titleColorSelected = [UIColor colorWithHex:0xB1B6C3];
                pageController.showOnNavigationBar = YES;
                pageController.menuBGColor = [UIColor clearColor];
                pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
                VC = pageController;
            }
                break;
            case hadSeenType://我看过的
            {
                VC = [[WKHistoryViewController alloc]init];
            }
                break;
            case addressType://地址
            {
                VC = [[WKAddressViewController alloc] initWithFrom:WKAddressFromCenter];
            }
                break;
            case virtualWordType://虚拟世界
                VC = [[WKVirtualWorldViewController alloc]init];
                break;
            case settingType://设置
                VC = [[WKSettingViewController alloc]init];
                break;
                
            default:
                break;
        }
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };

    [self.view addSubview: self.personalView];
    
}
-(void)reloadData{
    [WKHttpRequest personalCenter:HttpRequestMethodGet url:personalCenterUrl param:nil success:^(WKBaseResponse *response) {
        if ([response.ResultMessage isEqualToString:@"操作成功"]) {
            self.personalView.model = [WKPersonalCenterModel yy_modelWithJSON:response.Data];
            [self.personalView reloadData];
        }else{
            [WKPromptView showPromptView:response.ResultMessage];
        }
        [self addNoti];
    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
    }];
}

//红点通知
-(void)addNoti{
    
    [self xw_addNotificationForName:@"SHOPREDDOT" block:^(NSNotification * _Nonnull notification) {
        NSIndexPath * indexPath;
        if ([notification.userInfo[@"type"] integerValue] == 1 ) {//订单
            indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        }else{//发货
            indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        WKPersonalCenterCell * cell = [self.personalView cellForRowAtIndexPath:indexPath];
        cell.redView.hidden = [notification.userInfo[@"isHidden"] boolValue];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = YES;
    [self reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;
}

@end
