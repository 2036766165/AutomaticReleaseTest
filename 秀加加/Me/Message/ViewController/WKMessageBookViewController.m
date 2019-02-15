//
//  WKMessageBookViewController.m
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMessageBookViewController.h"
#import "WKMessageBookTableView.h"
#import "WKMessageTalkViewController.h"
#import "WKAttentionModel.h"

@interface WKMessageBookViewController ()

@property (nonatomic,strong) WKMessageBookTableView  *messageBookTableView;

@property (nonatomic,strong) WKAttentionModel *model;

@end

@implementation WKMessageBookViewController

- (WKMessageBookTableView *)messageBookTableView
{
    if (!_messageBookTableView) {
        _messageBookTableView = [[WKMessageBookTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
    }
    return _messageBookTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.messageBookTableView];
    
    [self event];
    [self initUi];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)event
{
    WeakSelf(WKMessageBookViewController);
    self.messageBookTableView.selectClickType = ^(NSInteger MessageBookRow){
        WKAttentionItemModel *attModel= weakSelf.model.InnerList[MessageBookRow];
        WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
        messageTalkVc.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        messageTalkVc.targetId = attModel.BPOID;
        //设置聊天会话界面要显示的标题
        messageTalkVc.title = attModel.MemberName;
        [weakSelf.navigationController pushViewController:messageTalkVc animated:YES];
    };
}

-(void)initUi
{
    self.title = @"通讯录";
}

-(void)loadData
{
    NSString *url = [NSString configUrl:WKGetBook With:@[@"PageIndex",@"PageSize"] values:@[[NSString stringWithFormat:@"%ld",(long)self.messageBookTableView.pageNO],[NSString stringWithFormat:@"%ld",(long)self.messageBookTableView.pageSize]]];
    
    [WKHttpRequest getBook:HttpRequestMethodGet url:url model:@"WKAttentionModel" param:nil success:^(WKBaseResponse *response) {
        self.model = response.Data;
        
        if(self.model.InnerList.count == 0)
        {
            [self.messageBookTableView setRemindreImageName:@"none_contact" text:@"您的通讯录空空如也\n快去添加吧" completion:^{
            
            }];
        }
        else
        {
            [self.messageBookTableView reloadDataWithArray:self.model.InnerList];
        }
    } failure:^(WKBaseResponse *response) {
        [self.messageBookTableView setRemindreImageName:@"none_contact" text:@"您的通讯录空空如也\n快去添加吧" completion:^{
            
        }];
    }];
}

@end
