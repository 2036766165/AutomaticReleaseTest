//
//  WKAttentionViewController.m
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAttentionViewController.h"
#import "WKAttentionTableView.h"
#import "WKLiveViewController.h"
#import "WKMessageViewController.h"
#import "WKAttentionModel.h"
#import "WKUserMessage.h"
#import "WKShareView.h"
#import "WKMessageTalkViewController.h"

@interface WKAttentionViewController ()

@property (nonatomic,strong) WKAttentionTableView *attentionTableView;

@property (nonatomic,strong) WKAttentionModel *model;

@property (nonatomic,strong) WKAttentionModel *singalPage;

@end

@implementation WKAttentionViewController

- (WKAttentionTableView *)attentionTableView
{
    if (!_attentionTableView) {
        _attentionTableView = [[WKAttentionTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
        _attentionTableView.type = 1;
    }
    return _attentionTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关注";
     [self.view addSubview:self.attentionTableView];
    
    [self event];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)event
{
    WeakSelf(WKAttentionViewController);
    
    self.attentionTableView.requestBlock = ^(){
        [weakSelf loadData];
    };
    
    self.attentionTableView.selectClickType = ^(NSInteger row,ClickType type){
        WKAttentionItemModel *model = weakSelf.attentionTableView.dataArray[row];
        if(type == ClickHead)
        {
            [weakSelf loadingUserMessage:model.BPOID];
        }
        else if(type == ClickShare)
        {
            //定义分享的类
            WKShareModel *shareModel = [[WKShareModel alloc]init];
            shareModel.shareTitle = @"秀加加,让直播更有价值!";
            if(model.MemberPhoto.length == 0)
            {
                shareModel.shareImageArr = @[@""];
            }
            else
            {
                shareModel.shareImageArr = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.MemberPhoto]]]];
            }
            
            if (model.LiveStatus == 1) {
                shareModel.shareContent = [NSString stringWithFormat:@"人生如戏，全靠演技。我关注的%@正在直播，快点来围观吧！",model.MemberName];
            }else{
                shareModel.shareContent = [NSString stringWithFormat:@"人生如戏，全靠演技。向你推荐%@，快来看看吧！",model.MemberName];
            }
            shareModel.shareUrl = [NSString stringWithFormat:@"%@%@&bpoid=%@",WK_ShareBaseUrl,model.MemberNo,User.BPOID];
            
            [WKShareView shareViewWithModel:shareModel];
        }
        else if(type == ClickMessage)
        {
            WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
            messageTalkVc.conversationType = ConversationType_PRIVATE;
            messageTalkVc.title = ((WKAttentionItemModel*)weakSelf.attentionTableView.dataArray[row]).MemberName;
            messageTalkVc.targetId = ((WKAttentionItemModel*)(weakSelf.attentionTableView.dataArray[row])).BPOID;
            [weakSelf.navigationController pushViewController:messageTalkVc animated:YES];
        }
        else if(type == ClickLive)
        {
            WKAttentionItemModel *model = weakSelf.attentionTableView.dataArray[row];
            [weakSelf pushToShowWith:model.MemberNo];
        }else if (ClickFocusNot){
            NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID"] values:@[@"0",model.BPOID]];
            
            [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
                
            } failure:^(WKBaseResponse *response) {
                
                [WKProgressHUD showTopMessage:response.ResultMessage];
            }];
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
//            [self.navigationController pushViewController:nav animated:YES];
            
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [WKProgressHUD showTopMessage:@"获取直播信息失败"];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)loadData
{
    NSString *url = [NSString configUrl:WKAttention With:@[@"PageIndex",@"PageSize"] values:@[[NSString stringWithFormat:@"%ld",(long)self.attentionTableView.pageNO],[NSString stringWithFormat:@"%ld",(long)self.attentionTableView.pageSize]]];
    
    [WKHttpRequest myAttention:HttpRequestMethodGet url:url model:NSStringFromClass([WKAttentionModel class]) param:@{} success:^(WKBaseResponse *response) {
        
        self.model = response.Data;
        
        if(self.model.InnerList.count <= 0)
        {
            [self.attentionTableView setRemindreImageName:@"guanzhudefault" text:@"您还没有关注的主播" offsetY:-80 completion:^{
                
            }];
        }
        
        [self.attentionTableView reloadDataWithArray:self.model.InnerList];
        
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
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

@end
