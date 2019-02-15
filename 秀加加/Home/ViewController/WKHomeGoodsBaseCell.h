//
//  WKGoodsBaseCell.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKFlowButton.h"
#import "WKHomeGoodsModel.h"
#import "WKCircleView.h"

@interface WKHomeGoodsBaseCell : UITableViewCell

@property (strong, nonatomic) UIView * backView;

@property (strong, nonatomic) UIImageView * goodsImageView;

@property (strong, nonatomic) UILabel * goodsNameLabel;

@property (strong, nonatomic) UILabel * goodsPriceLabel;

@property (strong, nonatomic) UIButton * auctionButton;

@property (strong, nonatomic) UIButton * iconImageView;

@property (strong, nonatomic) UIImageView * levelImageView;

@property (strong, nonatomic) UILabel * userNameLabel;

@property (strong, nonatomic) UILabel * locationLabel;

//@property (strong, nonatomic) UIButton * certificationButton;

@property (strong, nonatomic) WKFlowButton * flowButton;

@property (strong, nonatomic) WKHomeGoodsModel * model;

@property (strong, nonatomic) UIImageView  * certImageView; //认证图片

@property (strong, nonatomic) UILabel * certLabel; //认证文字

@property (strong, nonatomic) WKCircleView * circleView;

@end
