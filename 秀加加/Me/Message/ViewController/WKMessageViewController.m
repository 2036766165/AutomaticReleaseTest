//
//  WKMessageViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMessageViewController.h"
#import "WKMessageTableView.h"
#import "WKMessageBookViewController.h"
#import "WKMessageTalkViewController.h"
#import "WKNavigationController.h"
#import "NSObject+XWAdd.h"

@interface WKMessageViewController()

@end

@implementation WKMessageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self initUi];
}

-(void)initUi
{
    self.title = @"消息中心";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"book"] highImage:[UIImage imageNamed:@"book"] target:self action:@selector(personEvent:)];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_SYSTEM)]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self xw_postNotificationWithName:@"redCircle" userInfo:@{@"isRed":@(0)}];
}

-(void)personEvent:(UIButton *)sender
{
    WKMessageBookViewController *messageBookVc = [[WKMessageBookViewController alloc] init];
    
    [self.navigationController pushViewController:messageBookVc animated:YES];
}

//设置昵称的颜色
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    if(model.conversationModelType == ConversationType_PRIVATE)
    {
        RCConversationCell *conversationCell = (RCConversationCell*)cell;
        conversationCell.conversationTitle.textColor = [UIColor colorWithHex:0x979AA4];
    }
}

//点击的回调
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath
{
    //聚合形式列表的显示
    if(conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION)
    {
        WKMessageViewController *messageVc = [[WKMessageViewController alloc] init];
        
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationModelType]];
        
        [messageVc setDisplayConversationTypes:array];
        
        [messageVc setCollectionConversationType:nil];
        
        messageVc.isEnteredToCollectionViewController = YES;
        
        [self.navigationController pushViewController:messageVc animated:YES];
    }
    else if(conversationModelType == ConversationType_PRIVATE)
    {
        WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
        messageTalkVc.conversationType = model.conversationType;
        //对方的bpoid
        messageTalkVc.targetId = model.targetId;
        messageTalkVc.title = model.conversationTitle;//@"测试";
        [self.navigationController pushViewController:messageTalkVc animated:YES];
    }
}

@end
