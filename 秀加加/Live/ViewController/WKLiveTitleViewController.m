//
//  WKLiveTitleViewController.m
//  wdbo
//  开始直播准备页面
//  Created by Chang_Mac on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLiveTitleViewController.h"
#import "WKLiveViewController.h"
#import "WKShareTool.h"
#import "WKStoreModel.h"
#import "NSObject+XWAdd.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "WKPushFlowViewController.h"
#import "WKLivePreView.h"
#import "UITextView+Placeholder.h"
#import "NSString+Size.h"


@interface WKLiveTitleViewController ()<UITextViewDelegate>{
    WKGoodsLayoutType _type;
}

@property(nonatomic, strong) UITextView *textField;

@property (strong, nonatomic) WKStoreModel * model;

@property (nonatomic,strong) UILabel *titleName;

@property (nonatomic,strong) UILabel *livetime;

@property (nonatomic,strong) UILabel *livename;

@property (nonatomic,strong) UILabel *liveNum;

@property (nonatomic,strong) UILabel *liveNumName;

@property (nonatomic,strong) UIView *horView;
@property (nonatomic,strong) UIView *verView;

@property (assign, nonatomic) NSInteger shareType;//1.开始直播2.结束直播
@end

@implementation WKLiveTitleViewController

#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"页面被销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        _type = WKGoodsLayoutTypeVertical;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self xw_postNotificationWithName:@"refreshHomeData" userInfo:@{@"type":@(1)}];
    //    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
    //        SEL selector = NSSelectorFromString(@"setOrientation:");
    //        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    //        [invocation setSelector:selector];
    //        [invocation setTarget:[UIDevice currentDevice]];
    //        int val = UIInterfaceOrientationPortrait;//竖屏
    //        [invocation setArgument:&val atIndex:2];
    //        [invocation invoke];
    //    }
    
    IQKeyboardManager *key = [IQKeyboardManager sharedManager];
    key.enableAutoToolbar = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    IQKeyboardManager *key = [IQKeyboardManager sharedManager];
    key.enableAutoToolbar = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initStartLive];

    self.shareType = 1;
    
    [self xw_addNotificationForName:@"TOFOLLOWVC" block:^(NSNotification * _Nonnull notification) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
    
    
}

/**
 清空直播心情
 */
-(void)clearLiveMood{
    self.textField.text = @"";
    [self textViewDidChange:self.textField];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮开始位置
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (offsetRange.location < 30) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 30 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        [WKPromptView showPromptView:@"直播心情只能填写30个字喔！"];
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 30)
    {
        [WKPromptView showPromptView:@"直播心情只能填写30个字喔！"];
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:30];
        [textView setText:s];
    }
}

-(void)initStartLive
{
    UIImageView *im = [[UIImageView alloc]init];
    [im sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoUrl] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    
    //添加背景虚化
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH);
    visualEffectView.alpha = 0.9;
    [im addSubview:visualEffectView];
    
    im.userInteractionEnabled = YES;
    [self.view addSubview:im];
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(25, 150 * WKScaleW, WKScreenW - 50, 0.8)];
    line.backgroundColor = [UIColor orangeColor];
    [im addSubview:line];
    
    self.textField = [[UITextView alloc]init];
    self.textField.delegate = self;
    self.textField.placeholder = @"给直播写个响亮的标题吧";
    self.textField.delegate = self;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textColor =[UIColor whiteColor];
    self.textField.font = [UIFont systemFontOfSize:18];
    self.textField.placeholderColor =[UIColor lightGrayColor];
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [im addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(im.mas_left).offset(40);
        make.right.equalTo(im.mas_right).offset(-40);
        make.size.sizeOffset(CGSizeMake(WKScreenW - 80, 40));
        make.top.equalTo(line.mas_bottom).offset(35);
    }];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(25, 150 * WKScaleW + 110, WKScreenW - 50, 0.8)];
    line2.backgroundColor = [UIColor orangeColor];
    [im addSubview:line2];
    
    UIImage *imgWechat = [UIImage imageNamed:@"live_wx"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW/2*0.7, 150 * WKScaleW + 110 + 40, imgWechat.size.width, imgWechat.size.height)];
    [button setBackgroundImage:imgWechat forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"live_wx_highlight"] forState:UIControlStateHighlighted];
    button.tag = 1;
    [button addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [im addSubview:button];
    
    UIImage *imgMoments = [UIImage imageNamed:@"live_pyq"];
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.58, button.frame.origin.y, imgMoments.size.width, imgMoments.size.height)];
    [button1 setBackgroundImage:imgMoments forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"live_pyq_highlight"] forState:UIControlStateHighlighted];
    button1.tag = 2;
    [button1 addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [im addSubview:button1];
    
    UIButton *startPlay = [[UIButton alloc]initWithFrame:CGRectMake(25, button.frame.size.height + button.frame.origin.y + 20, WKScreenW - 50, 60 * WKScaleW)];
    startPlay.layer.cornerRadius = 60 * WKScaleW * 0.5 ;
    startPlay.layer.masksToBounds = YES;
    startPlay.layer.borderColor = [UIColor orangeColor].CGColor;
    startPlay.layer.borderWidth = 1;
    startPlay.backgroundColor = [UIColor colorWithHexString:@"#745039"];
    [startPlay addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [startPlay setTitle:@"开始直播" forState:UIControlStateNormal];
    [startPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startPlay.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:startPlay];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"live_close_highlight"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-5);
        make.top.mas_offset(10);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    [self xw_addNotificationForName:DISMISSLIVEVIEW block:^(NSNotification * _Nonnull notification) {
        [self initEndLiveWith:notification.userInfo];
    }];
}

- (UIView *)getViewWith:(NSString *)title screenType:(NSInteger)type{
    
    UIView *bgView = [UIView new];
    
    bgView.frame = CGRectMake(80 * type * WKScaleW, 0, 80 * WKScaleW, 100 * WKScaleH);
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 11;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(0, 100 * WKScaleH - 30, WKScaleW * 80, 20);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 10;
    btn.frame = CGRectMake(00, 0, bgView.frame.size.width, bgView.frame.size.height - 30);
    if (type == 0) {
        self.verView = bgView;
        [btn setImage:[UIImage imageNamed:@"baishuping"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"shuping"] forState:UIControlStateSelected];
    }else{
        self.horView = bgView;
        [btn setImage:[UIImage imageNamed:@"baihengping"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"hengping"] forState:UIControlStateSelected];
    }
    btn.userInteractionEnabled = NO;
    titleLabel.userInteractionEnabled = NO;
    [bgView addSubview:titleLabel];
    [bgView addSubview:btn];
    
    //初始化默认为竖屏
    if(type == 0)
    {
        btn.selected = YES;
        titleLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [bgView addGestureRecognizer:tap];
    
    return bgView;
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    UIButton *btn = [self.horView viewWithTag:10];
    UILabel *titleLab = [self.horView viewWithTag:11];
    btn.selected = NO;
    titleLab.textColor = [UIColor whiteColor];
    
    UIButton *btn0 = [self.verView viewWithTag:10];
    UILabel *titleLab0 = [self.verView viewWithTag:11];
    btn0.selected = NO;
    titleLab0.textColor = [UIColor whiteColor];
    
    UIButton *btn1 = [tap.view viewWithTag:10];
    UILabel *lab1 = [tap.view viewWithTag:11];
    
    btn1.selected = YES;
    lab1.textColor = [UIColor colorWithHexString:@"#FC6620"];
    
    if ([tap.view isEqual:self.verView]) {
        _type = WKGoodsLayoutTypeVertical;
    }else{
        _type = WKGoodsLayoutTypeHoriztal;
    }
}

- (void)closeClick{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)btnClick{
    //    POST api/Shop/ShowStart
    //    直播开始时调用
    //    POST api/Shop/ShowEnd
    //    直播结束时调用
    [self.view endEditing:YES];
    
    NSString *liveMood = self.textField.text;
    if(liveMood.length > 30){
        [WKPromptView showPromptView:@"直播心情只能填写30个字喔！"];
        return;
    }
    
    [self startShow];
    
    if (User.PushUrl != nil) {
        //        WKPushFlowViewController *liveView = [[WKPushFlowViewController alloc] initWith:self.textField.text orientation:_type];
        //        liveView.titleContent = self.textField.text;
        WKKSYConfigModel *configTool = [[WKKSYConfigModel alloc] init];
        configTool.screenType = _type;
        
        WKPushFlowViewController *streamVC = [[WKPushFlowViewController alloc] initStreamCfg:configTool];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:streamVC];
        
        [self presentViewController:nav animated:NO completion:NULL];
    }else{
        [self getMemberInfo];
    }
}

- (void)startShow{
    NSString *showType = (_type == WKGoodsLayoutTypeHoriztal) ? @"1" : @"0";
    NSString *liveMood = self.textField.text;
    NSString *url = [NSString configUrl:WKMemberShowStatus With:@[@"PlayMode",@"LiveMood"] values:@[showType,liveMood]];
    
    [WKHttpRequest showStart:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        
    } failure:^(WKBaseResponse *response) {
        
    }];
    
}

-(void)shareButton:(UIButton *)button{
    self.shareType = 1;
    [self shareTheWeChat:button.tag];
}

-(void)getMemberInfo
{
    [WKHttpRequest getPersonMessage:HttpRequestMethodGet url:WKGetPersonMessage model:nil param:nil success:^(WKBaseResponse *response) {
        
        _LOGD(@"Data : %@",response.json);
        
        [User setValuesForKeysWithDictionary:(NSDictionary *)response.Data];
        
        //        WKPushFlowViewController *liveView = [[WKPushFlowViewController alloc] initWith:self.textField.text orientation:_type];
        WKKSYConfigModel *configTool = [[WKKSYConfigModel alloc] init];
        configTool.screenType = _type;
        WKPushFlowViewController *streamVC = [[WKPushFlowViewController alloc] initStreamCfg:configTool];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:streamVC];
        
        [self presentViewController:nav animated:NO completion:NULL];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

-(void)shareTheWeChat:(NSInteger)type{
    WKShareModel *shareModel = [[WKShareModel alloc]init];
    if(User.MemberPhotoMinUrl.length == 0)
    {
        shareModel.shareImageArr = @[@""];
    }
    else
    {
        UIImage *headerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:User.MemberPhotoMinUrl]]];
        if (headerImage) {
            shareModel.shareImageArr = @[headerImage];
        }else{
            shareModel.shareImageArr = @[@""];
        }
    }
    shareModel.shareTitle = @"秀加加,让直播更有价值!";
    if (self.shareType == 1) {
        shareModel.shareContent = [NSString stringWithFormat:@"真人，真货，真感情!%@正在招客，来呀！来呀！",User.MemberName ];
    }else{
        shareModel.shareContent = [NSString stringWithFormat:@"真人，真货，真感情!%@直播已结束，来ta的店铺看看吧！",User.MemberName ];
    }
    
    shareModel.shareUrl = [NSString stringWithFormat:@"%@%@&bpoid=%@",WK_ShareBaseUrl,User.MemberNo,User.BPOID];
    if (type == 1) {
        shareModel.shareType = SHARECONTACT;
    }else{
        shareModel.shareType = SHAREFRIENDCIRRLE;
    }
    [WKShareTool shareShow:shareModel];
}

-(void)initEndLiveWith:(NSDictionary *)dict
{
    [self.view removeAllSubviews];

    NSString *allTime = [dict objectForKey:@"lastTime"];
    NSNumber *allNum = [dict objectForKey:@"audiences"];
    NSString *allNumStr = [NSString stringWithFormat:@"%@",allNum];
    
    CGRect rect;
    
    if (_type == WKGoodsLayoutTypeHoriztal) {
       rect = CGRectMake(0, 0,WKScreenH  ,WKScreenW);
    }else{
       rect = CGRectMake(0, 0,WKScreenW  ,WKScreenH);
    }
    
    // 设置背景图片
    UIView *backGroundView = [[UIView alloc] initWithFrame:rect];
    UIImageView *backgroundImg = [[UIImageView alloc] init];
    //backgroundImg.image = [UIImage imageNamed:@"live_close_bg"];
    [backgroundImg sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoUrl] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    [backGroundView addSubview:backgroundImg];
    [self.view addSubview:backGroundView];
    [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView).offset(0);
        make.right.equalTo(backGroundView.mas_right).offset(0);
        make.top.equalTo(backGroundView).offset(0);
        make.bottom.equalTo(backGroundView.mas_bottom).offset(0);
    }];
    
    //添加背景虚化
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = rect;
    visualEffectView.alpha = 0.9;
    [backGroundView addSubview:visualEffectView];
//    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:rect];
//    toolbar.barStyle = UIBarStyleBlackTranslucent;
//    [backGroundView addSubview:toolbar];
    
    UIImageView *headView = [[UIImageView alloc]init];
    [headView sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoMinUrl] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    headView.layer.cornerRadius = 80 / 2.0f ;
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor whiteColor].CGColor;
    headView.layer.masksToBounds = YES;
    [backGroundView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backGroundView.mas_top).offset(90 * WKScaleH);
        make.centerX.equalTo(backGroundView.mas_centerX);
        make.size.sizeOffset(CGSizeMake(80, 80));
    }];
    
    UILabel *houseMember = [[UILabel alloc]init];
    houseMember.font = [UIFont systemFontOfSize:14];
    houseMember.textColor = [UIColor whiteColor];
    houseMember.textAlignment = NSTextAlignmentCenter;
    houseMember.text = [NSString stringWithFormat:@"门牌号： %@",User.MemberNo];
    [backGroundView addSubview:houseMember];
    [houseMember mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundView.mas_centerX);
        make.top.equalTo(headView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 30));
    }];
    
    UIView *lineTop = [[UIView alloc]init];
    lineTop.backgroundColor = [UIColor whiteColor];
    [backGroundView addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseMember.mas_bottom).offset(10);
        make.centerX.mas_offset(0);
        make.width.mas_offset(WKScreenW>WKScreenH?WKScreenH*0.8:WKScreenW*0.8);
        make.height.mas_offset(1);
    }];
    
    self.titleName = [[UILabel alloc] init];
    self.titleName.text = @"直播已结束";
    self.titleName.font = [UIFont systemFontOfSize:20];
    self.titleName.textColor = [UIColor whiteColor];
    self.titleName.textAlignment = NSTextAlignmentCenter;
    [backGroundView addSubview:self.titleName];
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundView.mas_centerX);
        make.top.equalTo(lineTop.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 30));
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy/MM/dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = [NSString stringWithFormat:@"日期:  %@",currentDate];
    [backGroundView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundView.mas_centerX);
        make.top.equalTo(self.titleName.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 30));
    }];
    
    UIView *lineCenter = [[UIView alloc]init];
    lineCenter.backgroundColor = [UIColor whiteColor];
    [backGroundView addSubview:lineCenter];
    [lineCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(10);
        make.centerX.mas_offset(0);
        make.width.mas_offset(WKScreenW>WKScreenH?WKScreenH*0.8:WKScreenW*0.8);
        make.height.mas_offset(1);
    }];
    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor whiteColor];
    [backGroundView addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundView.mas_centerX).offset(0);
        make.top.equalTo(lineCenter.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(1, 55));
    }];
    
    self.livetime = [[UILabel alloc] init];
    self.livetime.textColor = [UIColor whiteColor];
    self.livetime.font = [UIFont systemFontOfSize:14];
    self.livetime.text = allTime;
    self.livetime.textAlignment = NSTextAlignmentCenter;
    self.livetime.textColor = [UIColor whiteColor];
    [backGroundView addSubview:self.livetime];
    [self.livetime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xianView.mas_left).offset(-20);
        make.top.equalTo(lineCenter.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.livename = [[UILabel alloc] init];
    self.livename.text = @"直播时长";
    self.livename.textAlignment = NSTextAlignmentCenter;
    self.livename.font = [UIFont systemFontOfSize:14];
    self.livename.textColor = [UIColor whiteColor];
    [backGroundView addSubview:self.livename];
    [self.livename mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xianView.mas_left).offset(-20);
        make.top.equalTo(self.livetime.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.liveNum = [[UILabel alloc] init];
    self.liveNum.text = allNumStr;
    self.liveNum.font = [UIFont systemFontOfSize:14];
    self.liveNum.textAlignment = NSTextAlignmentCenter;
    self.liveNum.textColor = [UIColor whiteColor];
    [backGroundView addSubview:self.liveNum];
    [self.liveNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xianView.mas_right).offset(20);
        make.top.equalTo(lineCenter.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    self.liveNumName = [[UILabel alloc] init];
    self.liveNumName.textColor = [UIColor whiteColor];
    self.liveNumName.textAlignment = NSTextAlignmentCenter;
    self.liveNumName.font = [UIFont systemFontOfSize:14];
    self.liveNumName.text = @"总观看人数";
    [backGroundView addSubview:self.liveNumName];
    [self.liveNumName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xianView.mas_right).offset(20);
        make.top.equalTo(self.liveNum.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    UIButton *okBtn = [[UIButton alloc] init];
    okBtn.layer.cornerRadius = 50 * WKScaleW /2.0f;
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.borderColor = [[UIColor colorWithHex:0xB5592E] CGColor];
    okBtn.layer.borderWidth = 1;
    okBtn.backgroundColor = [UIColor colorWithHexString:@"#7A4B31"];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okEvent:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backGroundView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView).offset(25);
        make.right.equalTo(backGroundView.mas_right).offset(-25);
        make.top.equalTo(self.livename.mas_bottom).offset(25);
        make.height.mas_equalTo(50 * WKScaleW);
    }];
    
    UILabel *lblTip = [[UILabel alloc]init];
    lblTip.text = @"将成就分享到";
    lblTip.textColor = [UIColor whiteColor];
    lblTip.textAlignment = NSTextAlignmentCenter;
    lblTip.font = [UIFont systemFontOfSize:14];
    [backGroundView addSubview:lblTip];
    [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(okBtn.mas_bottom).offset(25);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 15));
    }];
    
    UIImage *weixinImg = [UIImage imageNamed:@"live_wx"];
    UIImage *friendImg = [UIImage imageNamed:@"live_pyq"];
    
    UIView *backView1 = [[UIView alloc]init];
    backView1.backgroundColor = [UIColor colorWithHexString:@"#3E3240"];
    backView1.layer.cornerRadius = (friendImg.size.height + 10) /2;
    backView1.layer.masksToBounds = YES;
    [backGroundView addSubview:backView1];
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTip.mas_bottom).offset(10);
        make.right.equalTo(xianView.mas_left).offset(-15);
        make.size.sizeOffset(CGSizeMake(friendImg.size.width + 10, friendImg.size.height + 10)); //设置分享图片两张大小尺寸相同
    }];
    UIButton *weixinBtn = [[UIButton alloc] init];
    [weixinBtn setImage:weixinImg forState:UIControlStateNormal];
    [weixinBtn setImage:[UIImage imageNamed:@"live_wx_highlight"] forState:UIControlStateHighlighted];
    [backView1 addSubview:weixinBtn];
    [weixinBtn addTarget:self action:@selector(weixinEvent:) forControlEvents:UIControlEventTouchUpInside];
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xianView.mas_left).offset(-20);
        make.top.equalTo(lblTip.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(friendImg.size.width, friendImg.size.height));
    }];
    
    UIView *backView2 = [[UIView alloc]init];
    backView2.backgroundColor = [UIColor colorWithHexString:@"#3E3240"];
    backView2.layer.cornerRadius = (friendImg.size.height + 10) /2;
    backView2.layer.masksToBounds = YES;
    [backGroundView addSubview:backView2];
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTip.mas_bottom).offset(10);
        make.left.equalTo(xianView.mas_right).offset(15);
        make.size.sizeOffset(CGSizeMake(friendImg.size.width + 10, friendImg.size.height + 10));
    }];
    UIButton *friendBtn = [[UIButton alloc] init];
    [friendBtn setImage:friendImg forState:UIControlStateNormal];
    [friendBtn setImage:[UIImage imageNamed:@"live_pyq_highlight"] forState:UIControlStateHighlighted];
    [backView2 addSubview:friendBtn];
    [friendBtn addTarget:self action:@selector(friendEvent:) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xianView.mas_right).offset(20);
        make.top.equalTo(lblTip.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(friendImg.size.width, friendImg.size.height));
    }];
    
    
}

-(void)weixinEvent:(UIButton *)sender
{
    self.shareType = 2;
    [self shareTheWeChat:1];
}

-(void)friendEvent:(UIButton *)sender
{
    self.shareType = 2;
    [self shareTheWeChat:2];
}

-(void)okEvent:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 确定横竖屏
- (BOOL)shouldAutorotate {
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self xw_postNotificationWithName:@"refreshHomeData" userInfo:@{@"type":@(2)}];
}
@end
