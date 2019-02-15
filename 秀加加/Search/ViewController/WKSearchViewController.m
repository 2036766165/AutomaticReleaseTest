//
//  WKSearchViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSearchViewController.h"
#import "WKHomeGoodsBaseView.h"
#import "WKHomePlayBaseView.h"
#import "WKTitleChooseView.h"
#import "WKTagModel.h"
#import "WKHomePlayModel.h"
#import "WKLiveViewController.h"
#import "WKHomeGoodsModel.h"
#import "WKUserMessage.h"

@interface WKSearchViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) WKHomeGoodsBaseView *homeGoodsView;

@property (strong, nonatomic) WKHomePlayBaseView * homePlayView;

@property (strong, nonatomic) NSMutableArray * dataArr;

@property (strong, nonatomic) UITextField * searchTF;

@property (strong, nonatomic) UILabel * searchLabel;

@property (strong, nonatomic) NSMutableArray *titleArr;

@property (strong, nonatomic) NSMutableArray *colorArr;

@property (strong, nonatomic) WKTitleChooseView *titleChoose;

@property (strong, nonatomic) NSMutableAttributedString * attribute;

@property (strong, nonatomic) UIScrollView *searchScroll;

@property (strong, nonatomic) UIView *showView;

@property (strong, nonatomic) NSTimer * timer;

@property (assign, nonatomic) NSInteger timeCount;

@property (assign, nonatomic) BOOL isTimer;

@property (assign, nonatomic) NSInteger keyBoardHeight;

@end

@implementation WKSearchViewController

-(WKHomeGoodsBaseView *)homeGoodsView{
    if (!_homeGoodsView) {
        _homeGoodsView = [[WKHomeGoodsBaseView alloc]initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64) block:^(NSInteger type, NSString *homeId) {
            WKHomeGoodsModel *model = self.dataArr[type];
            [self getShowInfoWith:model.ShopOwnerNo GoodsCode:model.GoodsCode type:WKLiveFromHotGoods];
        }];
    }
    return _homeGoodsView;
}
- (void)getShowInfoWith:(NSString *)memberNo GoodsCode:(NSString *)goodsCode type:(WKLiveFrom)from{
    if ([memberNo isEqualToString:User.MemberNo]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMessage" object:nil];
        return;
    }
    [WKProgressHUD showLoadingGifText:@""];
    
    NSString *url = [NSString configUrl:WKMemberGetShowInfo With:@[@"MemberNo"] values:@[memberNo]];
    
    [WKHttpRequest getShowMemberInfo:HttpRequestMethodGet url:url model:NSStringFromClass([WKHomePlayModel class]) param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response json : %@",response.json);
        
        [WKProgressHUD dismiss];
        
        if (response.Data) {
            WKLiveViewController *live = [[WKLiveViewController alloc] initWithHomeList:response.Data from:from];
            WKHomePlayModel *md = response.Data;
            if (goodsCode.integerValue != 0) {
                md.GoodsCode = goodsCode;
            }
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:live];
            
            [self presentViewController:nav animated:YES completion:nil];
            live.playStop = ^(){
                NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchType"];
                if (type.integerValue == 1) {
                    [self loadingHotData];
                }else{
                    [self loadingGoodsData];
                }
            };
        }else{
            [WKProgressHUD showTopMessage:@"获取直播信息失败"];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(WKHomePlayBaseView *)homePlayView{
    if (!_homePlayView) {
        _homePlayView = [[WKHomePlayBaseView alloc]initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64) andDataArr:self.dataArr cycle:YES block:^(NSInteger type, NSString *homeId) {
            if (type == -1) {
                [self loadingUserMessage:homeId];
            }else{
                WKHomePlayModel *model = self.dataArr[type];
                if ([model.BPOID isEqualToString:User.BPOID]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMessage" object:nil];
                }else{
                    [self getShowInfoWith:model.MemberNo GoodsCode:model.GoodsCode type:WKLiveFromHotSaler];
                }
            }
        }];
        _homePlayView.isSearch = YES;
    }
    return _homePlayView;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI{
    self.dataArr = [NSMutableArray new];
    self.titleArr = [NSMutableArray new];
    self.attribute = [NSMutableAttributedString new];
    self.colorArr = [NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isTimer = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WKScreenW- 100, 30)];
    self.searchTF.rightViewMode = UITextFieldViewModeAlways;
    self.searchTF.layer.cornerRadius = 15;
    self.searchTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchTF.delegate = self;
    self.searchTF.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.searchTF.layer.borderWidth = 0.5;
    self.searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 1)];
    self.searchTF.clearButtonMode = UITextFieldViewModeAlways;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    NSMutableParagraphStyle *style1 = [self.searchTF.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    //居中
    style1.minimumLineHeight = self.searchTF.font.lineHeight - (self.searchTF.font.lineHeight - [UIFont systemFontOfSize:15].lineHeight) / 2.5;
    self.searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入搜索内容" attributes:@{NSParagraphStyleAttributeName : style1}];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [self.searchTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.navigationItem.titleView = self.searchTF;
    [self.searchTF becomeFirstResponder];
    [self tagReloadData];
    NSString *noDataImage;
    NSString *contentStr;
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchType"];
    if (type.integerValue == 1) {
        [self.view addSubview:self.homePlayView];
        noDataImage =@"sousuoweikong";
        contentStr = @"抱歉 Sorry!~\n没有搜索到相关内容";
    }else{
        [self.view addSubview:self.homeGoodsView];
        noDataImage =@"zanwushangpin";
        contentStr = @"暂无内容\n去其他地方看看吧!";
    }
    self.showView = [WKPromptView createDefaultMessage:contentStr andPic:noDataImage andFrame:CGRectMake(0, 0, 200, 200)];
    self.showView.hidden = YES;
    [self.view addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(200, 200));
    }];
    
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search"] highImage:[UIImage imageNamed:@"search_select"] target:self action:@selector(searchMessage)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)searchMessage{
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchType"];
    if (type.integerValue == 1) {
        [self loadingHotData];
    }else{
        [self loadingGoodsData];
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    textField.textColor = [UIColor colorWithHexString:@"7e879d"];
    [self removeTagArr];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.searchScroll.hidden = NO;
    [self removeTagArr];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.searchScroll.hidden = YES;
    [self removeTagArr];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.attribute.length>0) {
        textField.attributedText = nil;
        [self removeTagArr];
    }
    textField.textColor = [UIColor colorWithHexString:@"7e879d"];
    return YES;
}
-(void)removeTagArr{
    self.attribute = [NSMutableAttributedString new];
    [self.titleChoose circleHidden];
}
-(void)tagReloadData{
    [WKHttpRequest getTagMessage:HttpRequestMethodGet url:WKGetTag model:nil success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data) {
            WKTagModel *model = [WKTagModel yy_modelWithDictionary:item];
            for (WkTagTitle *item in model.TagList) {
                [self.titleArr addObject:item.TagName];
                [self.colorArr addObject:item.TagColor];
            }
        }
        [self createTagView];
        NSLog(@"1111%@",response);
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(void)createTagView{
    self.searchScroll = [[UIScrollView alloc]init];
    self.searchScroll.contentSize = CGSizeMake(WKScreenW, self.titleArr.count/3*55);
    [self.view addSubview:self.searchScroll];
    self.titleChoose = [[WKTitleChooseView alloc]initWithData:self.titleArr andColor:self.colorArr type:buttonCircle block:^(NSString *color, NSString *title) {
         self.attribute = [NSMutableAttributedString new];
        NSString *compleStr = [title stringByReplacingOccurrencesOfString:@"#" withString:@""];
        NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: compleStr];
        [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHexString:color] range: NSMakeRange(0, compleStr.length)];
        [self.attribute appendAttributedString:attributedStr01];
        self.searchTF.attributedText = self.attribute;
        [self searchMessage];
    }];
    self.titleChoose.backgroundColor = [UIColor whiteColor];
    [self.searchScroll addSubview:self.titleChoose];
    [self.titleChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(WKScreenW);
        make.height.mas_equalTo(self.titleArr.count/3*55);
    }];
    [self.searchScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.width.mas_equalTo(WKScreenW);
        make.height.mas_equalTo(WKScreenH - 64 - self.keyBoardHeight-10);
    }];
}

-(void)loadingHotData{
    NSString *url = [NSString configUrl:WKHomeHotMessage With:@[@"SearchCondition"] values:@[self.searchTF.text]];
    [WKHttpRequest loadingHomeHotPlay:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        [self.dataArr removeAllObjects];
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.dataArr addObject:[WKHomePlayModel yy_modelWithDictionary:item]];
        }
        if (self.dataArr.count<1) {
            self.showView.hidden = NO;
        }else{
            self.showView.hidden = YES;
        }
        self.searchScroll.hidden = YES;
        [self.searchTF resignFirstResponder];
        self.homePlayView.dataArray = self.dataArr;
        [self.homePlayView reloadData];
        [self startTimer];
    } failure:^(WKBaseResponse *response) {
        self.showView.hidden = NO;
    }];
}

-(void)loadingGoodsData{
    NSString *urlStr = [NSString configUrl:WKHotSaleMessage With:@[@"KeyWord"] values:@[self.searchTF.text]];
    [WKHttpRequest homeHotSaleMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        [self.dataArr removeAllObjects];
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.dataArr addObject:[WKHomeGoodsModel yy_modelWithDictionary:item]];
        }
        if (self.dataArr.count<1) {
            self.showView.hidden = NO;
        }else{
            self.showView.hidden = YES;
        }
        self.searchScroll.hidden = YES;
        [self.searchTF resignFirstResponder];
        self.homeGoodsView.dataArray = self.dataArr;
        [self.homeGoodsView reloadData];
        [self startTimer];
    } failure:^(WKBaseResponse *response) {
        self.showView.hidden = NO;
    }];
}

-(void)loadingUserMessage:(NSString *)memberID{
    NSString *urlStr = [NSString configUrl:WKUserMessageDetails With:@[@"BPOID",@"VisitBPOID",@"LiveStatus"] values:@[User.BPOID,memberID,@"2"]];
    [WKHttpRequest UserDetailsMessage:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKUserMessageModel *userMessageModel = [WKUserMessageModel yy_modelWithJSON:response.Data];
        if ([memberID isEqualToString:User.BPOID]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMessage" object:nil];
        }else{
            [WKUserMessage showUserMessageWithModel:userMessageModel andType:otherMessage chatType:emptyType :^(NSInteger type){
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyBoardHeight = keyboardRect.size.height;
//    int height = keyboardRect.size.height;
//    [self.searchScroll mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(64);
//        make.width.mas_equalTo(WKScreenW);
//        make.height.mas_equalTo(WKScreenH - 64 - height-10);
//    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchScroll.hidden = YES;
    [self.searchTF resignFirstResponder];
    [self searchMessage];
    return YES;
}
-(void)startTimer{
    self.timeCount = 0;
    if (!self.isTimer) {
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.isTimer = YES;
    }
}
-(void)timerAction{
    self.timeCount ++;
    NSString *keyStr;
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchType"];
    if (type.integerValue == 1) {
        keyStr = @"timeCount";
    }else{
        keyStr = @"goodsCount";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:keyStr object:nil userInfo:@{keyStr:@(self.timeCount)}];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.isTimer = NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, WKScreenW, 44);
    [self.searchTF resignFirstResponder];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)dealloc
{
    [self.timer invalidate];
}
@end








