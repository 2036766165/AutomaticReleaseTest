//
//  WKStoreShareView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKShareView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "WKShareTool.h"
@interface WKShareView ()

@property (strong, nonatomic) UIButton * masksButton;

@property (strong, nonatomic) UIView *shareView;

@end
@implementation WKShareView

+(void)shareViewWithModel:(WKShareModel *)model{
    WKShareView *storeShareView = [[WKShareView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    storeShareView.model = model;
    storeShareView.backgroundColor = [UIColor clearColor];
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:storeShareView];
    
    storeShareView.masksButton = [[UIButton alloc]init];
    storeShareView.masksButton.backgroundColor = [UIColor clearColor];
    [storeShareView.masksButton addTarget:storeShareView action:@selector(masksButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [storeShareView addSubview:storeShareView.masksButton];
    [storeShareView.masksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    
    storeShareView.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, WKScreenH,WKScreenW, 300)];
    storeShareView.shareView.backgroundColor = [UIColor whiteColor];
    [storeShareView addSubview:storeShareView.shareView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"分享到";
    label.textColor = [UIColor colorWithHexString:@"ff6600"];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [storeShareView.shareView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.equalTo(storeShareView.shareView.mas_top).offset(10);
        make.right.mas_offset(0);
        make.height.mas_offset(17);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [storeShareView.shareView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    UIView *backLine = [[UIView alloc]init];
    backLine.backgroundColor = [UIColor colorWithHexString:@"ff6600"];
    [storeShareView.shareView addSubview:backLine];
    [backLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.width.mas_offset(60);
        make.height.mas_offset(1);
    }];
    
    UIButton *friendButton = [[UIButton alloc]init];
    [friendButton setImage:[UIImage imageNamed:@"share_weixin"] forState:UIControlStateNormal];
    [friendButton setTitle:@"微信" forState:UIControlStateNormal];
    [friendButton setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    friendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [friendButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
    friendButton.tag = 1;
    [friendButton addTarget:storeShareView action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    friendButton.titleEdgeInsets = UIEdgeInsetsMake(110, -75, 0, 0);
    [storeShareView.shareView addSubview:friendButton];
    [friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(-70);
        make.top.equalTo(backLine.mas_bottom).offset(60);
        make.width.mas_offset(80);
        make.height.mas_offset(100);
    }];
    
    UIButton *friendCircleButton = [[UIButton alloc]init];
    [friendCircleButton setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
    [friendCircleButton setTitle:@"朋友圈" forState:UIControlStateNormal];
    [friendCircleButton setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    friendCircleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [friendCircleButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
    friendCircleButton.tag = 2;
    [friendCircleButton addTarget:storeShareView action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    friendCircleButton.titleEdgeInsets = UIEdgeInsetsMake(110, -75, 0, 0);
    [storeShareView.shareView addSubview:friendCircleButton];
    [friendCircleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(70);
        make.top.equalTo(backLine.mas_bottom).offset(60);
        make.width.mas_offset(80);
        make.height.mas_offset(100);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        storeShareView.masksButton.backgroundColor = [UIColor blackColor];
        storeShareView.masksButton.alpha = 0.5;
        storeShareView.shareView.frame = CGRectMake(0, WKScreenH-300, WKScreenW, 300);
    }];
}

-(void)masksButtonAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.masksButton.backgroundColor = [UIColor clearColor];
        self.masksButton.alpha = 1;
        self.shareView.frame = CGRectMake(0, WKScreenH, WKScreenW, 300);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)shareButtonAction:(UIButton *)button{
    if(button.tag == 1){
        self.model.shareType = SHARECONTACT;
    }else{
        self.model.shareType = SHAREFRIENDCIRRLE;
    }
    [WKShareTool shareShow:self.model];
}

@end
