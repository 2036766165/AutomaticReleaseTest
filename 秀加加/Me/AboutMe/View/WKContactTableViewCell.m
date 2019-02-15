//
//  WKContactTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKContactTableViewCell.h"

@implementation WKContactTableViewCell

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
    self.name.text = @"";
    self.name.textColor  = [UIColor colorWithHex:0x717171];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((60-20)/2);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    self.email = [[UILabel alloc] init];
    self.email.font = [UIFont systemFontOfSize:16];
    self.email.text = @"";
    self.email.textColor  = [UIColor colorWithHex:0xFDAF80];
    self.email.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.email];
    [self.email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset((60-20)/2);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

@end
