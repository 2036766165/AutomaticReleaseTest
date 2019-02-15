//
//  WKMeTableViewCell.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKMeTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIImageView *goImageView;
@property (nonatomic,strong) UILabel *content;
@property (strong, nonatomic) UIView *circleView;

@end
