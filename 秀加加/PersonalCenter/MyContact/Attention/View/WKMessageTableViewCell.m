//
//  WKMessageTableViewCell.m
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMessageTableViewCell.h"

@interface WKMessageTableViewCell()

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *redImageView;
@property (nonatomic,strong) UIButton *levelBtn;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *time;

@end

@implementation WKMessageTableViewCell

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
    UIImage *headImage = [UIImage imageNamed:@"default_08"];
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.image = headImage;
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self).offset((60-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    self.redImageView = [[UIImageView alloc] init];
    self.redImageView.backgroundColor = [UIColor colorWithHex:0xFF6306];
    self.redImageView.layer.masksToBounds = YES;
    self.redImageView.layer.cornerRadius = 4;
    [self.headImageView addSubview:self.redImageView];
    [self.redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImageView.mas_right).offset(4);
        make.top.equalTo(self.headImageView).offset(-2);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"动力三驴子";
    self.name.textColor = [UIColor colorWithHex:0x9C9FA8];
    self.name.font = [UIFont systemFontOfSize:14];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    self.time = [[UILabel alloc] init];
    self.time.text = @"2016-09-12 22:22";
    self.time.textColor = [UIColor colorWithHex:0x9C9FA8];
    self.time.font = [UIFont systemFontOfSize:14];
    self.time.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.top.equalTo(self.name.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UIImage *levelImage = [UIImage imageNamed:@"dengji"];
    self.levelBtn = [[UIButton alloc] init];
    [self.levelBtn setImage:levelImage forState:UIControlStateNormal];
    [self.levelBtn addTarget:self action:@selector(levelEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.levelBtn];
    [self.levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(levelImage.size.width, levelImage.size.height));
    }];
}

-(void)levelEvent:(UIButton *)sender
{
    if(_selectClickTypeCell)
    {
        _selectClickTypeCell();
    }
}

@end
