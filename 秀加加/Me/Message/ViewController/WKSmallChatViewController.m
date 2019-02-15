//
//  WKSmallChatViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/11/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSmallChatViewController.h"
#import "NSString+substring.h"
#import "NSObject+XWAdd.h"
@interface WKSmallChatViewController ()
@property (strong, nonatomic) UIButton * maskBtn;
@end

@implementation WKSmallChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.maskBtn = [[UIButton alloc]init];
    self.maskBtn.backgroundColor = [UIColor clearColor];
    self.maskBtn.tag = 1000;
    self.chatSessionInputBarControl.emojiBoardView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.maskBtn addTarget:self action:@selector(maskBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskBtn];
    [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(0);
        make.bottom.equalTo(self.conversationMessageCollectionView.mas_top).offset(0);
        make.width.mas_offset(WKScreenW);
    }];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]init];
    [self.maskBtn addGestureRecognizer:panGR];
    [self.view addGestureRecognizer:panGR];
    self.chatSessionInputBarControl.switchButton.hidden = YES;
    
    [self.conversationMessageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.bottom.mas_offset(WKScreenW>WKScreenH?0:-50);
        make.width.mas_offset(WKScreenW);
        make.height.mas_offset(WKScreenW>WKScreenH?WKScreenH-60:280*WKScaleW-50);
    }];
    [self createHeadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillHide:(NSNotification *)notifacation{
    [UIView animateWithDuration:0.2 animations:^{
        [self.conversationMessageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.bottom.mas_offset(WKScreenW>WKScreenH?0:-50);
            make.width.mas_offset(WKScreenW);
            make.height.mas_offset(WKScreenW>WKScreenH?WKScreenH-60:280*WKScaleW-50);
        }];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToBottomAnimated:YES];
        });
    }];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        [self.conversationMessageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.bottom.mas_offset(WKScreenW>WKScreenH?0:-50-height);
            make.width.mas_offset(WKScreenW);
            make.height.mas_offset(WKScreenW>WKScreenH?WKScreenH-60:280*WKScaleW-50);
        }];
    } completion:^(BOOL finished) {
        [self scrollToBottomAnimated:YES];
    }];
}

-(void)createHeadView{
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallChat"]];
    headView.userInteractionEnabled = YES;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.height.mas_offset(50);
        make.bottom.equalTo(self.conversationMessageCollectionView.mas_top).offset(0);
        make.width.mas_offset(WKScreenW);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_offset(0);
        make.width.mas_offset(WKScreenW);
        make.height.mas_offset(0.5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.title;
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.width.height.mas_greaterThanOrEqualTo(20);
        make.width.mas_lessThanOrEqualTo(WKScreenW*0.7);
    }];
    
    UIButton *exitBtn = [[UIButton alloc]init];
    [exitBtn setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    exitBtn.tag = 1;
    [exitBtn addTarget:self action:@selector(maskBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(-10);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.hidden = self.backType==showBack?NO:YES;
    backBtn.tag = 100;
    [backBtn addTarget:self action:@selector(maskBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.left.mas_offset(10);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
}
-(void)maskBtnAction:(UIButton *)button{
    if (button.tag == 1 && self.exit) {
        self.exit();
    }else if(self.refresh){
        self.refresh();
    }
    [self.navigationController willMoveToParentViewController:nil];
    if (self.isLive) {
        [self.navigationController.view removeFromSuperview];
    }    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self xw_postNotificationWithName:@"redCircle" userInfo:@{}];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView
//    clickedItemWithTag:(NSInteger)tag{
//    
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

@end
