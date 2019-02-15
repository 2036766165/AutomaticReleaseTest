//
//  WKFansViewController.m
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKFansViewController.h"
#import "WKFansTableView.h"
#import "WKLiveViewController.h"
#import "WKMessageViewController.h"
#import "WKUserMessage.h"
#import "WKMessageTalkViewController.h"

@interface WKFansViewController ()

@property (nonatomic,strong) WKFansTableView *fanTableView;

@property (nonatomic,strong) WKAttentionModel *model;
@end

@implementation WKFansViewController

- (WKFansTableView *)fanTableView
{
    if (!_fanTableView) {
        _fanTableView = [[WKFansTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
        _fanTableView.type = 2;
    }
    return _fanTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.fanTableView];
    
    [self event];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)event
{
    WeakSelf(WKFansViewController);
    
    self.fanTableView.requestBlock = ^(){
        [weakSelf loadData];
    };
    
    self.fanTableView.selectClickType = ^(NSInteger row,ClickType type){
        WKAttentionItemModel *model = weakSelf.fanTableView.dataArray[row];
        NSString *name = model.BPOID;
        
        if(type == ClickHead)
        {
            [weakSelf loadingUserMessage:name];
        }
        else if(type == ClickFocus)//关注
        {
            [weakSelf getFollow:name];
        }
        else if(type == ClickFocusNot)//取消关注
        {
            [weakSelf getFollewNot:name];
        }
        else if(type == ClickMessage)
        {
            WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
            messageTalkVc.title = model.MemberName;
            messageTalkVc.targetId = model.BPOID;
            messageTalkVc.conversationType = ConversationType_PRIVATE;
            [weakSelf.navigationController pushViewController:messageTalkVc animated:YES];
        }
        else if(type == ClickLive)
        {
            WKAttentionItemModel *model = weakSelf.fanTableView.dataArray[row];
            [weakSelf pushToShowWith:model.MemberNo];
        }
        
    };
}

- (void)pushToShowWith:(NSString *)memberNo{
    
    NSString *url = [NSString configUrl:WKMemberGetShowInfo With:@[@"MemberNo"] values:@[memberNo]];
    
    [WKHttpRequest getShowMemberInfo:HttpRequestMethodGet url:url model:NSStringFromClass([WKHomePlayModel class]) param:nil success:^(WKBaseResponse *response) {
        WKLiveViewController *live = [[WKLiveViewController alloc] initWithHomeList:response.Data from:WKLiveFromHotSaler];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:live];
        
        [self presentViewController:nav animated:YES completion:nil];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)loadData
{
    NSString *url = [NSString configUrl:WKFans With:@[@"PageIndex",@"PageSize"] values:@[[NSString stringWithFormat:@"%ld",(long)self.fanTableView.pageNO],[NSString stringWithFormat:@"%ld",(long)self.fanTableView.pageSize]]];

    [WKHttpRequest myAttention:HttpRequestMethodGet url:url model:NSStringFromClass([WKAttentionModel class]) param:@{} success:^(WKBaseResponse *response) {
        
        self.model = response.Data;

        if(self.model.InnerList.count <= 0)
        {
            [self.fanTableView setRemindreImageName:@"guanzhufensizanwu" text:@"您还没有粉丝关注呦！" offsetY:-80 completion:^{
                
            }];
        }

         self.fanTableView.model = self.model;
        
        [self.fanTableView reloadDataWithArray:self.model.InnerList];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//关注
-(void)getFollow:(NSString *)name
{
    NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID"] values:@[@"1",name]];
    
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        [self loadData];
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//取消关注
-(void)getFollewNot:(NSString *)name
{
    NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID"] values:@[@"0",name]];
    
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        
        [self loadData];
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)loadingUserMessage:(NSString *)memberID{
    NSString *urlStr = [NSString configUrl:WKUserMessageDetails With:@[@"BPOID",@"VisitBPOID",@"LiveStatus"] values:@[User.BPOID,memberID,@"2"]];
    [WKHttpRequest UserDetailsMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKUserMessageModel *userMessageModel = [WKUserMessageModel yy_modelWithJSON:response.Data];
        if ([memberID isEqualToString:User.BPOID]) {
//<<<<<<< HEAD
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:mySelfMessage chatType:emptyType :^(NSInteger type){
                
            }];
        }else{
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:emptyType :^(NSInteger type){
//=======
//            [WKUserMessage showUserMessageWithModel:userMessageModel andType:mySelfMessage chatType:emptyType :^(WKUserParameterModel *md){
//                
//            }];
//        }else{
//            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:emptyType :^(WKUserParameterModel *md){
//>>>>>>> 8ed03c233226543017f69cbe5d615e6a84a875a0
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

@end
