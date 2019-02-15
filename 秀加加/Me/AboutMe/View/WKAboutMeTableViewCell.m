//
//  WKAboutMeTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAboutMeTableViewCell.h"

@implementation WKAboutMeTableViewCell

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
    UILabel *name = [[UILabel alloc] init];
    name.text = @"用户服务协议";
    name.textColor = [UIColor colorWithHex:0xADB3C1];
    name.font = [UIFont systemFontOfSize:14];
    _name = name;
    [self addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((50-20)/2);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UIImage *goImage = [UIImage imageNamed:@"go"];
    UIImageView *goImageView = [[UIImageView alloc] init];
    goImageView.image = goImage;
    [self addSubview:goImageView];
    [goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset((50-goImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
    }];
}

@end
