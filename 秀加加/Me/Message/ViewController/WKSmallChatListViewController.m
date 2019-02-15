//
//  WKSmallChatListViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/12/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSmallChatListViewController.h"
#import "WKMessageTableView.h"
#import "WKMessageBookViewController.h"
#import "WKMessageTalkViewController.h"
#import "WKSmallChatViewController.h"
#import "WKNavigationController.h"
#import "NSObject+XWAdd.h"

@interface WKSmallChatListViewController ()
@property (strong, nonatomic) UIButton * maskBtn;
@end

@implementation WKSmallChatListViewController

-(instancetype)init{
    self = [super init];
    if(self)
    {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_SYSTEM)]];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)createView{
    self.view.backgroundColor = [UIColor clearColor];
    [self.emptyConversationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-20);
    }];
    self.maskBtn = [[UIButton alloc]init];
    self.maskBtn.backgroundColor = [UIColor clearColor];
    [self.maskBtn addTarget:self action:@selector(maskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskBtn];
    [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(0);
        make.bottom.equalTo(self.conversationListTableView.mas_top).offset(0);
        make.width.mas_offset(WKScreenW);
    }];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]init];
    [self.maskBtn addGestureRecognizer:panGR];
    [self.view addGestureRecognizer:panGR];
    
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallChat"]];
    headView.userInteractionEnabled = YES;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.height.mas_offset(50);
        make.bottom.equalTo(self.conversationListTableView.mas_top).offset(0);
        make.width.mas_offset(WKScreenW);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_offset(-1);
        make.width.mas_offset(WKScreenW);
        make.height.mas_offset(0.5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"我的消息";
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.width.height.mas_greaterThanOrEqualTo(20);
    }];
    
    UIButton *exitBtn = [[UIButton alloc]init];
    [exitBtn setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(maskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(-10);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    CGFloat height;
    if (WKScreenW>WKScreenH) {
        height = WKScreenH - 60;
    }else{
        height = 280*WKScaleW;
    }
    self.conversationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.conversationListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_offset(WKScreenW);
        make.height.mas_offset(height);
    }];
}

-(void)maskBtnAction{
    [self.navigationController willMoveToParentViewController:nil];
    if (self.isLive) {
        [self.navigationController.view removeFromSuperview];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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
        WKSmallChatListViewController *messageVc = [[WKSmallChatListViewController alloc] init];
        
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationModelType]];
        
        [messageVc setDisplayConversationTypes:array];
        
        [messageVc setCollectionConversationType:nil];
        
        messageVc.isEnteredToCollectionViewController = YES;
        
        [self.navigationController pushViewController:messageVc animated:YES];
    }
    else if(conversationModelType == ConversationType_PRIVATE)
    {
        WKSmallChatViewController *vc = [[WKSmallChatViewController alloc]init];
        vc.targetId = model.targetId;
        vc.title = model.conversationTitle;
        vc.conversationType = model.conversationType;
        vc.exit = ^(){
            [self maskBtnAction];
        };
        vc.refresh = ^(){
            [self refreshConversationTableViewIfNeeded];
        };
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
    }
}

@end
