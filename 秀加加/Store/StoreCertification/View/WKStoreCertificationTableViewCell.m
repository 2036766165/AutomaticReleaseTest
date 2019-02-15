//
//  WKStoreCertificationTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreCertificationTableViewCell.h"

@implementation WKStoreCertificationTableViewCell

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
    self.name = [[UILabel alloc] init];
    self.name.font = [UIFont systemFontOfSize:16];
    self.name.tag = 101;
    self.name.textColor = [UIColor colorWithHex:0xBDC1CC];
    self.name.text = @"实体店名";
    [self.contentView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset((50-20)/2);
        make.width.mas_greaterThanOrEqualTo(10);
        make.height.mas_offset(20);
    }];
    
    UIImage *goImage = [UIImage imageNamed:@"go"];
    self.goImageView = [[UIImageView alloc] init];
    self.goImageView.image = goImage;
    [self.contentView addSubview:self.goImageView];
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView).offset((50-goImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
    }];
    
    self.content = [[UITextField alloc] init];
    self.content.font = [UIFont systemFontOfSize:16];
    self.content.textColor = [UIColor colorWithHex:0xBDC1CC];
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset((50-20)/2);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-goImage.size.width-10-10-10-80, 20));
    }];
}

@end
