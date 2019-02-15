//
//  WKStoreTagViewController.m
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreTagViewController.h"
#import "WKTagTableView.h"
#import "WKTagModel.h"
#import "WKTitleChooseView.h"
#import "NSObject+XCTag.h"

@interface WKStoreTagViewController ()

@property (strong, nonatomic) WKTagTableView * tagTableView;

//数据库中获取的标签集合
@property (strong, nonatomic) NSMutableArray * tagModelArr;

//页面选中的标签集合
@property (strong, nonatomic) NSMutableArray * callBackArr;

@property (strong, nonatomic) WKTitleChooseView * titleChoose;

@property (strong, nonatomic) NSMutableArray * titleArr;

@property (strong, nonatomic) NSMutableArray * colorArr;

@property (strong, nonatomic) UIView *promptView;

@property (strong, nonatomic) UILabel * promptLabel;

@end

@implementation WKStoreTagViewController

-(WKTagTableView *)tagTableView{
    if (!_tagTableView) {
        _tagTableView = [[WKTagTableView alloc]initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64)];
        
        WeakSelf(WKStoreTagViewController);
        _tagTableView.tagTableCallBack = ^(NSMutableArray *array){
            weakSelf.callBackArr = array;
        };
    }
    return _tagTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self tagReloadData];
}

-(void)createUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    self.title = @"标签选择";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成 " style:UIBarButtonItemStyleDone target:self action:@selector(rightAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.titleArr = [NSMutableArray new];
    self.colorArr = [NSMutableArray new];
    self.callBackArr = [NSMutableArray new];
    self.tagModelArr = [NSMutableArray new];
    
    [self.view addSubview:self.tagTableView];
//    NSDictionary *tagDic = [NSDictionary dicWithJsonStr:User.ShopTag];
//    NSArray *titleArr = [tagDic objectForKey:@"titleArr"];
//    NSArray *sortArr = [tagDic objectForKey:@"sortArr"];
//    NSArray *colorArr = [tagDic objectForKey:@"colorArr"];
//    for (int i = 0 ; i < titleArr.count ; i ++ ) {
//        NSDictionary *dic = @{@"Sort":sortArr[i],@"TagColor":colorArr[i],@"TagName":titleArr[i]};
//        [self.callBackArr addObject:dic];
//    }
}

-(void)tagReloadData{
    [WKProgressHUD showLoadingText:@""];
    [WKHttpRequest getTagMessage:HttpRequestMethodGet url:WKGetTag model:nil success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data) {
            WKTagModel *tagModel = [WKTagModel yy_modelWithDictionary:item];
            [self.tagModelArr addObject:tagModel];
        }
        self.tagTableView.dataArr = self.tagModelArr;
        
        NSDictionary *tagDic = [NSDictionary dicWithJsonStr:User.ShopTag];
        NSArray *titleArr = [tagDic objectForKey:@"titleArr"];
        NSArray *sortArr = [tagDic objectForKey:@"sortArr"];
        NSArray *colorArr = [tagDic objectForKey:@"colorArr"];
        for (int i = 0 ; i < titleArr.count ; i ++ ) {
            NSDictionary *dic = @{@"Sort":sortArr[i],@"TagColor":colorArr[i],@"TagName":titleArr[i]};
            [self.callBackArr addObject:dic];
        }
        [self.tagTableView reloadData];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)rightAction{
    if(self.callBackArr.count<1){
//         [self.tagTableView promptViewShow:@"个性标签最少选一个,快去选择属于你的个性标签!"];
        [WKPromptView showPromptView:@"个性标签最少选一个,快去选择属于你的个性标签!"];
        return;
    }
    WeakSelf(WKStoreTagViewController);
    [WKProgressHUD showLoadingText:@""];
    NSString *url = [NSString configUrl:WKMemberUpdateInfo With:@[@"Key",@"Value"] values:@[@"5",[self.callBackArr yy_modelToJSONString]]];
    [WKHttpRequest uploadTagMessage:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response){
        //更新用户数据
        User.ShopTag = [self.callBackArr yy_modelToJSONString];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TAG" object:nil];
        
        //延时跳转回页面
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
           [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end
