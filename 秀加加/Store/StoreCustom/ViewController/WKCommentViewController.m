//
//  WKCommentViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCommentViewController.h"
#import "NSObject+WKImagePicker.h"
#import "UIViewController+WKTrack.h"
#import "WKCustomCommentView.h"
#import "WKCustomCommentModel.h"
#import "WKPlayTool.h"
#import "PlayerManager.h"

@interface WKCommentViewController ()

@property (strong, nonatomic) WKCustomCommentView * commentTableView;

@property (strong, nonatomic) NSMutableArray * buttonArray;

@property (strong, nonatomic) NSMutableArray * dataArray;

@property (assign, nonatomic) NSInteger level;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *label;

@end

@implementation WKCommentViewController

-(WKCustomCommentView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[WKCustomCommentView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-70-60)];
    }
    return _commentTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMain];
    [self loadingCustomCommentData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)createMain{
    self.dataArray = [NSMutableArray new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [self.view addSubview:self.commentTableView];
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.right.mas_offset(0);
        make.height.mas_offset(WKScreenH-70-60);
    }];
    self.view.frame = CGRectMake(0, 0, WKScreenW,  WKScreenH-70-60);
    
    WeakSelf(WKCommentViewController);
    self.commentTableView.requestBlock = ^(){
        [weakSelf loadingCustomCommentData];
    };
    self.commentTableView.clickType = ^(NSString *length,NSString *path,NSString *ID){
        [weakSelf uploadVoice:length andPath:path andID:ID];
    };
    self.commentTableView.promptBlock = ^(NSString *promptStr){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"promptNoti" object:nil userInfo:@{@"promptStr":promptStr}];
    };
}
-(void)uploadVoice:(NSString *)length andPath:(NSString *)path andID:(NSString *)ID{
    NSArray *spxArr = @[[NSData dataWithContentsOfFile:path]];
    [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:spxArr success:^(WKBaseResponse *response) {
        [self uploadComment:length andPath:response.Data[0] andID:ID];
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(void)uploadComment:(NSString *)length andPath:(NSString *)path andID:(NSString *)ID{
    [WKHttpRequest ReplyComment:HttpRequestMethodPost url:WKReplyComment param:@{@"ID":ID,@"Reply":path,@"ReplyDuration":length} success:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
        [self loadingCustomCommentData];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)loadingCustomCommentData{
    [WKHttpRequest CustomComment:HttpRequestMethodPost url:WKCustomComment param:@{@"LevelType":[NSString stringWithFormat:@"%lu",(long)self.commentType],@"PageSize":@(self.commentTableView.pageSize),@"PageIndex":@(self.commentTableView.pageNO)} success:^(WKBaseResponse *response) {
        [self.dataArray removeAllObjects];
        NSArray *arr = response.Data[@"InnerList"];
        if ([arr isEqual:[NSNull null]]) {
            [self.commentTableView reloadDataWithArray:self.dataArray];
            return ;
        }
        for (NSDictionary *item in arr) {
            WKCustomCommentModel *model = [WKCustomCommentModel yy_modelWithDictionary:item];
            [self.dataArray addObject:model];
        }
        [self.commentTableView reloadDataWithArray:self.dataArray];
        if (self.commentTableView.dataArray.count<1) {
            [self.commentTableView setRemindreImageName:@"wupinglun-1" text:@"还没有相关评论" offsetY:-50 completion:^{
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        [self.commentTableView setRemindreImageName:@"wupinglun-1" text:@"还没有相关评论" offsetY:-50 completion:^{
            
        }];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[PlayerManager sharedManager] stopPlaying];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.commentTableView) {
        self.commentTableView.tableView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH-70-60);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
