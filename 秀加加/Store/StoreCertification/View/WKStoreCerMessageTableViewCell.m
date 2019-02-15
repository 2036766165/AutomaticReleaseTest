//
//  WKStoreCerMessageTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreCerMessageTableViewCell.h"
#import "WKAuthShopModel.h"

@implementation WKStoreCerMessageTableViewCell


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
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.top.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(160);
    }];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"营业执照或资格证书";
    self.name.font = [UIFont systemFontOfSize:18];
    self.name.textColor = [UIColor colorWithHex:0xA0A7B6];
    [backgroundView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(10);
        make.top.equalTo(backgroundView).offset(10);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-20, 20));
    }];
    
    UIImage *addImage = [UIImage imageNamed:@"add"];
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(firstBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:addImage forState:UIControlStateNormal];
    [self.contentView addSubview:addBtn];
    self.frontShenfen = addBtn;
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.name.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(addImage.size.width, addImage.size.height));
    }];
    
    self.shenFen = [[UIButton alloc] init];
    [self.shenFen setImage:addImage forState:UIControlStateNormal];
    [self.shenFen addTarget:self action:@selector(secondBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.shenFen];
    [self.shenFen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn.mas_right).offset(20);
        make.top.equalTo(self.name.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(addImage.size.width, addImage.size.height));
    }];
    
    self.titleUp = [[UILabel alloc] init];
    self.titleUp.font = [UIFont systemFontOfSize:12];
    self.titleUp.textColor = [UIColor colorWithHex:0xA0A7B6];
    [self.contentView addSubview:self.titleUp];
    [self.titleUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn).offset((addImage.size.width-80)/2);
        make.top.equalTo(addBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    self.titleDown = [[UILabel alloc] init];
    self.titleDown.font = [UIFont systemFontOfSize:12];
    self.titleDown.textColor = [UIColor colorWithHex:0xA0A7B6];
    [self.contentView addSubview:self.titleDown];
    [self.titleDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shenFen).offset((addImage.size.width-80)/2);
        make.top.equalTo(addBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
}


-(void)firstBtnEvent:(UIButton *)sender
{
    if(_clickPhoto)
    {
        _clickPhoto(1,sender);
    }
}

-(void)secondBtnEvent:(UIButton *)sender
{
    if(_clickPhoto)
    {
        _clickPhoto(2,sender);
    }
}

@end
