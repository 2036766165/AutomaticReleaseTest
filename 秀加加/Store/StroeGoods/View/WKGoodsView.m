//
//  WKGoodsView.m
//  wdbo
//
//  Created by sks on 16/7/7.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKGoodsView.h"
#import "WKGoodsModel.h"

#import "WKShareItem.h"
#import "WKShareTool.h"

@interface WKGoodsView (){
    WKGoodsListItem *_tempModel;
}

@property (nonatomic,strong) UIButton *bgBtn;

@end

@implementation WKGoodsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arr = @[@[@"微信",@"icon_weixin"],
                         @[@"朋友圈",@"icon_friend"]
                         ];
        for (int i=0; i<arr.count; i++) {
            WKShareItem *item = [[WKShareItem alloc] init];
            item.itemImage = arr[i][1];
            item.itemName = arr[i][0];
            
            item.tag = 10 + i;
            [self addSubview:item];
            
            CGFloat spacing = i==0?-50 * WKScaleW:50 * WKScaleW;

            [item mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerY.mas_offset(0);
                make.centerX.mas_equalTo(self.mas_centerX).offset(spacing);
                make.size.mas_offset(CGSizeMake(WKScaleW * 50, WKScaleW * 80));
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [item addGestureRecognizer:tap];
        }
    }

    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    WKShareItem *item = (WKShareItem *)tap.view;
    if (item.tag - 10 == 0) {
        
        
//        NSString *url;
//        NSString *content;
//        if (self.type == 200) {
////            url = [NSString stringWithFormat:@"%@%@",baseUrl,_tempModel.GoodsCode];
////            content = [NSString stringWithFormat:@"%@邀您一起体验show++,赶紧下载~",User.MemberName];
//        }else{
//            url = [NSString stringWithFormat:@"%@%@#/details?GoodsCode=%@&fromType=list",ShareBaseUrl,User.LiveKey,_tempModel.GoodsCode];
//            content = [NSString stringWithFormat:@"%@向您推荐了一款商品%@,迅速来围观~",User.MemberName,_tempModel.GoodsName];
//        }
        
//        [WKShareTool shareWithWeChat:@[_tempModel.image] andTitle:@"show++ 让直播更有价值!" andContent:content andType:SHARECONTACT :url];
        
        
    }else{
        
//        // 朋友圈
//        
//        NSString *url;
//        NSString *content;
//        if (self.type == 200) {
//            url = [NSString stringWithFormat:@"%@%@",baseUrl,_tempModel.GoodsCode];
//            content = [NSString stringWithFormat:@"%@邀您体验show++,赶紧下载~",User.MemberName];
//        }else{
//            url = [NSString stringWithFormat:@"%@%@#/details?GoodsCode=%@&fromType=list",ShareBaseUrl,User.LiveKey,_tempModel.GoodsCode];
//            content = [NSString stringWithFormat:@"%@向您推荐了一款商品%@,迅速来围观~[Show++]",User.MemberName,_tempModel.GoodsName];
//        }
//        
//        //NSString *url = [NSString stringWithFormat:@"http://www.p.net/?rc=%@/details?GoodCode=%@&fromType=list",User.LiveKey,_tempModel.GoodsCode];
//        
//        [WKShareTool shareWithWeChat:@[_tempModel.image] andTitle:content andContent:content andType:SHAREFRIENDCIRRLE :url];
////        [WKShareTool shareWithWeChat:@[] andTitle:@"标题" andContent:@"内容" andType:SHARECONTACT :@"点击的url"];
    }
}

- (void)showWith:(WKGoodsListItem *)goods{
    
    _tempModel = goods;
    
    UIViewController *rootViewController = [self appRootViewController];
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgBtn.frame  = rootViewController.view.frame;
    [self.bgBtn addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
    [rootViewController.view addSubview:self.bgBtn];
    
    [self.bgBtn addSubview:self];
    
    self.frame = CGRectMake(0, WKScreenH, WKScreenW, 150 * WKScaleW);
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(0);
//        make.right.mas_equalTo(self.bgBtn.mas_right).offset(0);
//        make.top.mas_equalTo(self.bgBtn.mas_top).offset(WKScreenH);
//        make.height.mas_offset(150 * WKScale);
//    }];
    
    sleep(0.3);
    
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.bgBtn.mas_top).offset(WKScreenH-150 * WKScale);
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

        self.frame = CGRectMake(0, WKScreenH-150 * WKScaleW, WKScreenW, 150 * WKScaleW);
    }];
    
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)bgClick{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, WKScreenH, WKScreenW, 150 * WKScaleW);
////        self.hidden = NO;
        self.bgBtn.alpha = 0.1;
        self.bgBtn.backgroundColor = [UIColor whiteColor];
//        self.bgBtn = nil;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
        [self.bgBtn removeFromSuperview];
    }];
    
}

@end
