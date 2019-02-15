//
//  WKHistoryViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHistoryViewController.h"
#import "WKHistoryTableView.h"
#import "WKLiveViewController.h"
#import "WKUserMessage.h"
#import "WKHistoryModel.h"

@interface WKHistoryViewController()

@property (strong, nonatomic) WKHistoryModel *model;
@property (nonatomic,strong) WKHistoryTableView *historyTableView;
@end

@implementation WKHistoryViewController

- (WKHistoryTableView *)historyTableView
{
    if (!_historyTableView) {
        _historyTableView = [[WKHistoryTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
    }
    return _historyTableView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.historyTableView];
    
    [self initUi];
    
    [self event];
    
    [self loadData];
}

-(void)initUi
{
    self.title = @"我看过的";
}

-(void)event
{
    WeakSelf(WKHistoryViewController);
    self.historyTableView.selectClickType = ^(NSIndexPath *index,NSInteger type){
        if(type == 1)
        {
            WKHistoryItemModel *itemModel = weakSelf.model.InnerList[index.row];
            [weakSelf loadingUserMessage:itemModel.BPOID];
        }
        else if(type == 2)
        {
            NSLog(@"点击分享:%ld",(long)index.row);
        }
        else if(type == 3)
        {
            WKHistoryItemModel *model=weakSelf.model.InnerList[index.row];
            [weakSelf pushToShowWith:model.MemberNo];
        }
    };
}
- (void)pushToShowWith:(NSString *)memberNo{
    
    NSString *url = [NSString configUrl:WKMemberGetShowInfo With:@[@"MemberNo"] values:@[memberNo]];
    
    [WKHttpRequest getShowMemberInfo:HttpRequestMethodGet url:url model:NSStringFromClass([WKHomePlayModel class]) param:nil success:^(WKBaseResponse *response) {
        
        NSLog(@"response data : %@",response.json);
        
        if (response.Data) {
            WKLiveViewController *live = [[WKLiveViewController alloc] initWithHomeList:response.Data from:WKLiveFromHotSaler];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:live];
            
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [WKProgressHUD showTopMessage:@"获取直播信息失败"];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)loadData
{
    [WKHttpRequest searchHistory:HttpRequestMethodGet url:WKSearchHistory model:NSStringFromClass([WKHistoryModel class]) param:nil success:^(WKBaseResponse *response) {
        _LOGD(@"====%@",response.json);
        self.model = response.Data;
        
        if(self.model.InnerList.count <= 0)
        {
            [self.historyTableView setRemindreImageName:@"lishi" text:@"您还没有浏览记录\n快去观看直播吧!" completion:^{
                
            }];
        }
        
        [self.historyTableView reloadDataWithArray:self.model.InnerList];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}
-(void)loadingUserMessage:(NSString *)memberID{
    NSString *urlStr = [NSString configUrl:WKUserMessageDetails With:@[@"BPOID",@"VisitBPOID",@"LiveStatus"] values:@[User.BPOID,memberID,@"2"]];
    [WKHttpRequest UserDetailsMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKUserMessageModel *userMessageModel = [WKUserMessageModel yy_modelWithJSON:response.Data];
        if ([memberID isEqualToString:User.BPOID]) {
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:mySelfMessage chatType:emptyType :^(NSInteger type){
                
            }];
        }else{
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:emptyType :^(NSInteger type){
//            [WKUserMessage showUserMessageWithModel:userMessageModel andType:mySelfMessage chatType:emptyType :^(WKUserParameterModel *md){
//                
//            }];
//        }else{
//            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:emptyType :^(WKUserParameterModel *md){
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}
@end
