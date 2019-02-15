//
//  WKCustomCommentViewController.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKCustomCommentViewController.h"
#import "WKCustomCommentModel.h"
#import "NSObject+WKImagePicker.h"
#import "UIViewController+WKTrack.h"
#import "WKCommentViewController.h"
#import "WKPagesView.h"

@interface WKCustomCommentViewController ()
@end

@implementation WKCustomCommentViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [self loadingCommentNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(promptAction:) name:@"promptNoti" object:nil];
}
-(void)promptAction:(NSNotification *)noti{
    [WKPromptView showPromptView:noti.userInfo[@"promptStr"]];
}
-(void)loadingCommentNumber{
    [WKHttpRequest CommentNumber:HttpRequestMethodGet url:WKCommentNumber param:nil success:^(WKBaseResponse *response) {
        NSMutableArray *viewControllsers = [NSMutableArray new];
        for (int i = 0 ; i < 4; i ++) {
            WKCommentViewController *commentVC = [[WKCommentViewController alloc]init];
            commentVC.commentType = 3-i;
            [viewControllsers addObject:commentVC];
        }
        NSDictionary *dic = response.Data;
        WKPagesView *pageView = [[WKPagesView alloc] initWithFrame:CGRectZero toolBarType:WKPageTypeOrder BtnTitles:@[[NSString stringWithFormat:@"全部评价(%@)",dic[@"AllCount"]],[NSString stringWithFormat:@"好评(%@)",dic[@"GoodsCount"]],[NSString stringWithFormat:@"中评(%@)",dic[@"MediumCount"]],[NSString stringWithFormat:@"差评(%@)",dic[@"BadCount"]]] images:@[@"quanping",@"haoping",@"zhongping",@"chaping"] selectedImages:@[@"quanping-1",@"haoping-1",@"zhongping-1",@"chaping-1"] viewController:viewControllsers];
        [self.view addSubview:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(6);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
        }];
        [self.view sendSubviewToBack:pageView];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

@end
