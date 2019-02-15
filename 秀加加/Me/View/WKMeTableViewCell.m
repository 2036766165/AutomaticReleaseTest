//
//  WKMeTableViewCell.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMeTableViewCell.h"

@implementation WKMeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubView];
    }
    return self;
}

-(void)addSubView
{
    UIImage *headImage = [UIImage imageNamed:@"my1"];
    self.headImageView = [[UIImageView alloc] init];
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((48-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    self.title = [[UILabel alloc] init];
    [self.title setTextColor:[UIColor colorWithHex:0x8F9198]];
    self.title.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.top.equalTo(self).offset((48-20)/2);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UIImage *goImage = [UIImage imageNamed:@"go"];
    self.goImageView = [[UIImageView alloc] init];
    [self addSubview:self.goImageView];
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(goImage.size.width));
        make.top.equalTo(self).offset((48-goImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
    }];
    
    self.content = [[UILabel alloc] init];
    self.content.text = @"";
    [self.content setTextColor:[UIColor blackColor]];
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goImageView.mas_left).offset(-5);
        make.top.equalTo(self).offset((48-20)/2);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    self.circleView = [[UIView alloc]init];
    self.circleView.hidden = YES;
    self.circleView.layer.cornerRadius = 2.5;
    self.circleView.backgroundColor = [UIColor colorWithRed:238/255.0 green:120/255.0 blue:32/255.0 alpha:1];
    [self addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(-2);
        make.top.equalTo(self.headImageView.mas_top).offset(-2);
        make.width.height.offset(5);
    }];
}

@end
