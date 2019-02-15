//
//  WKStoreCertificationViewController.m
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreCertificationViewController.h"
#import "WKStoreCertificationTableView.h"
#import "WKMapViewController.h"
#import "WKGetLocation.h"
#import "WKAuthShopModel.h"

@interface WKStoreCertificationViewController ()

@property (nonatomic,strong) WKAuthShopModel *dataModel;
@property (nonatomic,strong) WKStoreCertificationTableView  *storeCertificationTableView;
@end

@implementation WKStoreCertificationViewController

- (WKStoreCertificationTableView *)storeCertificationTableView
{
    if (!_storeCertificationTableView) {
        _storeCertificationTableView = [[WKStoreCertificationTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
        _storeCertificationTableView.obserview = self;
    }
    return _storeCertificationTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实体店认证";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.storeCertificationTableView];
    [self loadStoreInfo];

}

- (void)loadStoreInfo{
    
    [WKHttpRequest uploadStoreInfo:HttpRequestMethodGet url:WKMemberAuthInfo param:@{} success:^(WKBaseResponse *response) {
        _LOGD(@"response : %@",response);
        
        WKAuthShopModel *md = [WKAuthShopModel yy_modelWithJSON:response.Data];
        if(md!=nil){
            
            self.dataModel = md;
            self.storeCertificationTableView.dataModel = md;
          //  NSLog(@"店铺状态是：%d",(int)md.ApproveStatus.integerValue);
            // 0 认证中 1 成功 2 失败
            if (self.dataModel.ApproveStatus.integerValue != 2) {
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendEvent)];

            }
        }else{
             self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendEvent)];
        }
        
    } failure:^(WKBaseResponse *response) {
      //  [WKProgressHUD showText:response.ResultMessage];
        [WKPromptView showPromptView:response.ResultMessage];
    }];
}

-(void)sendEvent
{
    NSDictionary *parameters = [self.storeCertificationTableView getUploadInfo];
    
    if (parameters != nil) {
        [WKHttpRequest uploadStoreInfo:HttpRequestMethodPost url:WKMemberAuth param:parameters success:^(WKBaseResponse *response) {
            _LOGD(@"response : %@",response);
            [self loadStoreInfo];
            
        } failure:^(WKBaseResponse *response) {
            [WKPromptView showPromptView:response.ResultMessage];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
