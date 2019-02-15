//
//  WKStoreViewController.m
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreViewController.h"
#import "WKStoreTableView.h"
#import "WKStoreTagViewController.h"
#import "WKStoreCertificationViewController.h"
#import "WKStoreManagerViewController.h"
#import "WKStoreOrderViewController.h"
#import "WKStoreCustomViewController.h"
#import "WKStoreIncomeViewController.h"
#import "WKStoreCarriageViewController.h"
#import "WKStoreHelpViewController.h"
#import "WKShopOrderViewController.h"
#import "WKSellOrderViewController.h"
#import "WMPageController.h"
#import "WKGoodsVC.h"
#import "WKAuctionVC.h"
#import "WKStoreCarriageView.h"
#import "WKCustomTabViewController.h"
#import "WKCustomCommentViewController.h"
#import "WKStoreView.h"
#import "WKShareView.h"
#import "WKShareTool.h"
#import "WKStoreModel.h"
#import "WKStoreCertificationViewController.h"
#import "WKSendShopDetailViewController.h"
#import "WKGoodsInfoModel.h"
#import "WKPersonEditViewController.h"
#import "WKTimeCalcute.h"

//#import "秀加加-Swift.h"

@interface WKStoreViewController ()

@property (nonatomic,strong) WKStoreTableView *storeTableView;

@property (nonatomic,strong) NSArray *viewControllerType;

@property (nonatomic,strong) WKStoreCarriageView *storeCarView;

@property (nonatomic,strong) WKStoreView *storeView;

@property (nonatomic,strong) NSString *tranFee;

@end

@implementation WKStoreViewController

- (WKStoreTableView *)storeTableView
{
    if (!_storeTableView) {
        _storeTableView = [[WKStoreTableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-64-49)];
    }
    return _storeTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _storeView = [[WKStoreView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-49)];
    _storeView.backgroundColor = [UIColor colorWithHex:0xF1F4FE];
    _storeView.userInteractionEnabled = YES;
    [self.view addSubview:_storeView];
    
    [self initData];
    [self event];
}

- (void)back:(UIBarButtonItem *)item{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)initData
{
    self.navigationItem.title = @"店铺";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"help"] highImage:[UIImage imageNamed:@"help_highlight"] target:self action:@selector(helpEvent)];
}

//分享操作
-(void)helpEvent
{
    WKStoreHelpViewController *storeHelpVc = [[WKStoreHelpViewController alloc] init];
    [self.navigationController pushViewController:storeHelpVc animated:YES];
}

-(void)event
{
    WeakSelf(WKStoreViewController);
    self.storeView.selectClickType = ^(ClickType type){
        
        if(type == SelectShop)
        {
            WKGoodsVC *goodsVC = [[WKGoodsVC alloc] init];
            [weakSelf.navigationController pushViewController:goodsVC animated:YES];

//            NSArray *goodsVCs = @[[WKGoodsVC class],
//                                  [WKAuctionVC class]];
//            NSArray *goodsTitles = @[@"商品", @"拍卖品"];
//            
//            WMPageController *goodsManager = [[WMPageController alloc] initWithViewControllerClasses:goodsVCs andTheirTitles:goodsTitles];
//            goodsManager.menuHeight = 44;
//            goodsManager.menuItemWidth = 80;
//            goodsManager.cachePolicy = WMPageControllerCachePolicyLowMemory;
//            goodsManager.preloadPolicy = WMPageControllerPreloadPolicyNever;
//            goodsManager.menuViewStyle = WMMenuViewStyleTriangle;
//            goodsManager.titleSizeSelected = 18;
//            goodsManager.titleSizeNormal = 18;
//            goodsManager.itemMargin = 20;
//            goodsManager.showOnNavigationBar = YES;
//            goodsManager.menuBGColor = [UIColor clearColor];
//            goodsManager.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
//            goodsManager.titleColorSelected = [UIColor colorWithHex:0xFB7934];
//            goodsManager.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
//            [weakSelf.navigationController pushViewController:goodsVC animated:YES];
        }
        else if(type == SelectCustom)
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
            [weakSelf.navigationController pushViewController:customView animated:YES];
        }
        else if(type == SelectOrder)
        {
            NSArray *viewControllers = @[[WKShopOrderViewController class],
                                         [WKSellOrderViewController class]];
            NSArray *titles = @[@"商品订单", @"拍卖订单"];
            WKStoreOrderViewController *pageController = [[WKStoreOrderViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
            pageController.menuHeight = 44;
            pageController.menuItemWidth = 80;
            pageController.menuViewStyle = WMMenuViewStyleTriangle;
            pageController.titleSizeSelected = 18;
            pageController.titleSizeNormal = 18;
            pageController.itemMargin = 20;
            pageController.showOnNavigationBar = YES;
            pageController.menuBGColor = [UIColor clearColor];
            pageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
            pageController.titleColorSelected = [UIColor colorWithHex:0xFB7934];
            pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
            [weakSelf.navigationController pushViewController:pageController animated:YES];
        }
        else if(type == SelectFee)
        {
            weakSelf.storeCarView = [[WKStoreCarriageView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
            
            weakSelf.storeCarView.tranFeeBlock =^(NSString *string){
                
                [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"feeNum"];
            };
            if([weakSelf.storeCarView.money.text isEqualToString:@""])
            {
                weakSelf.storeCarView.money.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"feeNum"];
            }
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.storeCarView];
        }
        else if(type == SelectIncome)
        {
            WKStoreIncomeViewController *incomeVc = [[WKStoreIncomeViewController alloc] init];
            incomeVc.title = @"店铺收入";
            [weakSelf.navigationController pushViewController:incomeVc animated:YES];
        }
        else if(type == SelectShare) //分享单独处理
        {
            WKShareModel *shareModel = [[WKShareModel alloc]init];
            if(User.MemberPhotoUrl.length == 0)
            {
                shareModel.shareImageArr = @[@""];
            }
            else
            {
                shareModel.shareImageArr = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:User.MemberPhotoUrl]]]];
            }
            shareModel.shareTitle = @"秀加加,让直播更有价值!";
            shareModel.shareContent = @"商品玲琅满目，缺啥就来店铺。快来看看吧！";
            NSString *str = [NSString stringWithFormat:@"%@%@&bpoid=%@",WK_ShareBaseUrl,User.MemberNo,User.BPOID];
            shareModel.shareUrl = str;
            [WKShareView shareViewWithModel:shareModel];
        }
        else if(type == SelectShop)
        {
            NSArray *goodsVCs = @[[WKGoodsVC class],
                                  [WKAuctionVC class]];
            NSArray *goodsTitles = @[@"商品", @"拍卖品"];

            WMPageController *goodsManager = [[WMPageController alloc] initWithViewControllerClasses:goodsVCs andTheirTitles:goodsTitles];
            goodsManager.menuHeight = 44;
            goodsManager.preloadPolicy = WMPageControllerPreloadPolicyNever;
            goodsManager.cachePolicy = WMPageControllerCachePolicyLowMemory;

            goodsManager.menuViewStyle = WMMenuViewStyleTriangle;
            goodsManager.titleSizeSelected = 16;
            goodsManager.itemMargin = 20;
            goodsManager.showOnNavigationBar = YES;
            goodsManager.menuBGColor = [UIColor clearColor];
            goodsManager.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
            goodsManager.titleColorSelected = [UIColor colorWithHex:0xFB7934];
            goodsManager.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
            [weakSelf.navigationController pushViewController:goodsManager animated:YES];
        }
        else if (type == SelectTitles){
            WKStoreTagViewController *tagVC = [[WKStoreTagViewController alloc]init];
            [weakSelf.navigationController pushViewController:tagVC animated:YES];
        }else if (type == SelectAuthentiaction){
            WKStoreCertificationViewController *storeAuth = [[WKStoreCertificationViewController alloc] init];
            [weakSelf.navigationController pushViewController:storeAuth animated:YES];
        }
        else if(type == SelectEditPerson)
        {
            WKPersonEditViewController *personEditVC = [[WKPersonEditViewController alloc] init];
            [weakSelf.navigationController pushViewController:personEditVC animated:YES];
        }
    };
}

-(void)loadData
{
    //获取粉丝数量
    [WKHttpRequest getMemberMessageCount:HttpRequestMethodGet url:WKGetMemberMessageCount model:@"WKStoreModel" param:nil success:^(WKBaseResponse *response) {
        WKStoreModel *storeModel = response.Data;
        self.storeView.fan.text = [NSString stringWithFormat:@"粉丝 %ld",(long)storeModel.FunsCount];
        self.storeView.liveNum.text = [WKTimeCalcute compareCurrentTime:storeModel.LastShowTime];
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
    
    //店铺商品信息
    [WKHttpRequest GoodsInfo:HttpRequestMethodGet url:WKGoodsInfo param:nil model:@"WKGoodsInfoModel" success:^(WKBaseResponse *response) {
        WKGoodsInfoModel *goodsModel = response.Data;
        [self.storeView.goodsBtn sd_setImageWithURL:[NSURL URLWithString:goodsModel.PicUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zanwu@2x_03"]];
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"TAG" object:nil];
    
    //加载店铺的信息
    [self.storeView.leftImgView sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoMinUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
    [self.storeView.backGroundView sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoUrl] placeholderImage:[UIImage imageNamed:@"default_07"]];
    
    NSString *userLevel = [NSString stringWithFormat: @"dengji_%@",User.MemberLevel];
    [self.storeView.levelImageView setImage:[UIImage imageNamed:userLevel]];
    
    NSUserDefaults *localUser = [NSUserDefaults standardUserDefaults];
    NSString *localCity = [localUser objectForKey:MEMBERLOCATION];
    localCity = localCity.length == 0 ? @"火星" : localCity;
    self.storeView.userName.text =[NSString stringWithFormat:@"%@  %@",User.MemberName,localCity];
    
    self.storeView.renzhengLab.text = User.ShopAuthenticationStatus == 1 ? @"实体店认证" : @"非实体店";
    NSString *strRenzheng = User.ShopAuthenticationStatus == 1 ? @"renzhengSuccess" : @"renzheng_def";
    [self.storeView.renzhengImgView setImage:[UIImage imageNamed:strRenzheng]];
    
    [self loadData];
}

-(void)refreshView
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.storeView promptViewShow:@"选择标签成功"];
    });
}

@end
