//
//  WKMessageTalkViewController.m
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMessageTalkViewController.h"
#import "NSObject+XWAdd.h"
@interface WKMessageTalkViewController ()

@property (nonatomic,strong) RCConversationModel *RcModel;

@end

@implementation WKMessageTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self xw_postNotificationWithName:@"chatNoti" userInfo:nil];
}

-(void)initUi
{

}

@end
