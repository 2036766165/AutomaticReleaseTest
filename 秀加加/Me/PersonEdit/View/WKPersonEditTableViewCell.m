//
//  WKPersonEditTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPersonEditTableViewCell.h"

@implementation WKPersonEditTableViewCell

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
    self.name.tag = 1001;
    self.name.textColor = [UIColor colorWithHex:0xBBBFCA];
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.text = @"用户昵称";
    [self.contentView addSubview:self.name];
    CGSize nameSize = [self.name.text sizeOfStringWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(MAXFLOAT, 14)];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((50 - nameSize.height) * 0.5);
        make.size.mas_equalTo(CGSizeMake(nameSize.width + 2, 14));
    }];
    
    UIImage *goImage = [UIImage imageNamed:@"go"];
    self.goImageView = [[UIImageView alloc] init];
    self.goImageView.image = goImage;
    [self.contentView addSubview:self.goImageView];
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self).offset((50-goImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
    }];
    
    self.content = [[IQDropDownTextField alloc] init];
    self.content.textAlignment = NSTextAlignmentRight;
    self.content.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.content];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_right).offset(10);
        make.centerY.mas_equalTo(self.name.mas_centerY);
        make.right.mas_equalTo(self.goImageView.mas_left).offset(-10);
    }];
    
}

@end
