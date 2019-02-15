//
//  WKHomePlayCell.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKFlowButton.h"
#import "WKHomePlayModel.h"
#import "WKCircleView.h"
#import "WKTimeCalcute.h"

@interface WKHomePlayCell : UITableViewCell

@property (strong, nonatomic) UIView * backView;

@property (strong, nonatomic) UIButton * iconImageView;

@property (strong, nonatomic) UIImageView * levelImageView;

@property (strong, nonatomic) UILabel * userNameLabel;

@property (strong, nonatomic) UILabel * cityLabel;

@property (strong, nonatomic) UILabel * fansLabel;

@property (strong, nonatomic) UILabel * onlineNumber;

@property (strong, nonatomic) UIImageView * showImageView;

@property (strong, nonatomic) UIButton * certificationButton;

@property (strong, nonatomic) UIView * masksView;

@property (strong, nonatomic) WKFlowButton * flowButton;

@property (strong, nonatomic) UIImageView * goodsImageView;

@property (strong, nonatomic) UILabel * memberMood;

@property (copy, nonatomic) void(^block)(NSString *member);

@property (strong, nonatomic) WKHomePlayModel * model;

@property (strong, nonatomic) WKCircleView * circleView;

@property (assign, nonatomic) BOOL isSearch;

@end
