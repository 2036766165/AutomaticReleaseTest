//
//  WKEvaluateDetailViewController.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKEvaluateDetailViewController.h"
#import "WKEvaluateView.h"
#import "WKPlayTool.h"
#import "NSObject+XWAdd.h"
@interface WKEvaluateDetailViewController ()

@property (strong, nonatomic) NSMutableArray * picArr;

@property (strong, nonatomic) NSString * voicePath;

@property (strong, nonatomic) NSString * anonymous;

@property (strong, nonatomic) NSString* score;

@property (strong, nonatomic) NSString * timeLong;

@property (strong, nonatomic) NSString * path;

@property (strong, nonatomic) NSArray * picUrlArr;

@property (strong ,nonatomic) WKEvaluateView *evaluateView;

@property (assign, nonatomic) BOOL isCommit;

@end

@implementation WKEvaluateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUi];
}
-(void)initUi
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"评价晒单";
    self.score = @"5";
    self.isCommit = NO;
    self.view.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
    self.evaluateView = [[WKEvaluateView alloc] initWithFrame:CGRectMake(0, 5, WKScreenW, WKScreenH-5)andModel:self.model];
    [self.view addSubview: self.evaluateView];
    WeakSelf(WKEvaluateDetailViewController);
    weakSelf.evaluateView.clickType = ^(ContentType type,id data){
        switch (type) {
            case 1:
                self.picArr = (NSMutableArray *)data;
                break;
            case 2:
                self.voicePath = (NSString *)data;
                break;
            case 3:
                self.score = (NSString *)data;
                break;
            case 4:
                self.anonymous = (NSString *)data;
                break;
            case 5:
                self.timeLong = (NSString *)data;
                break;
        }
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
}
-(void)rightItemAction{
    if (self.isCommit) {
        return;
    }
    self.isCommit = YES;
    if (self.picArr.count>0) {
        [self uploadImage];
    }else{
        [self uploadSpx];
    }
}
-(void)uploadImage{
    [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:self.picArr success:^(WKBaseResponse *response) {
        self.picUrlArr = response.Data;
        [self uploadSpx];
    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
        self.isCommit = NO;
    }];
}
-(void)uploadSpx{
    if(self.voicePath.length == 0 || self.timeLong.integerValue < 3)
    {
        self.isCommit = NO;
        [WKPromptView showPromptView:@"请录制评论!"];
        return;
    }
    NSArray *spxArr = @[[NSData dataWithContentsOfFile:self.voicePath]];
    [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:spxArr success:^(WKBaseResponse *response) {
        self.path = response.Data[0];
        [self addComment];
    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
        self.isCommit = NO;
    }];
}

-(void)addComment{
    if (self.picUrlArr.count<1) {
        self.picUrlArr = [NSMutableArray new];
    }
    if (self.anonymous.integerValue != 1) {
        self.anonymous = @"0";
    }
    NSData *data=[NSJSONSerialization dataWithJSONObject:self.picUrlArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsonStrOne = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSDictionary *dic = @{
                          @"OrderCode":self.model.OrderCode,
                          @"GoodsCode":self.model.GoodsCode,
                          @"ModelCode":@(self.model.GoodsModelCode),
                          @"IsAnoymous":self.anonymous,
                          @"ContentDuration":self.timeLong,
                          @"Content":self.path,
                          @"PicUrls":jsonStrOne,
                          @"Score":self.score
                          };
    [WKHttpRequest addComment:HttpRequestMethodPost url:WKAddComment param:dic success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"评价成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        [self xw_postNotificationWithName:@"commitSuccess" userInfo:nil];
        self.isCommit = NO;
    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
        self.isCommit = NO;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=YES;
}
@end
