//
//  WKOrderAuctionTableViewCell.m
//  秀加加
//
//  Created by lin on 2016/10/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderAuctionTableViewCell.h"

@implementation WKOrderAuctionTableViewCell

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
    name.font = [UIFont systemFontOfSize:14];
    name.text = @"拍卖服务费";
    name.textColor = [UIColor colorWithHex:0xAAB0BE];
    name.textAlignment = NSTextAlignmentLeft;
    self.name = name;
    [self addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    UILabel *value = [[UILabel alloc] init];
    value.font = [UIFont systemFontOfSize:14];
    value.text = @"￥232.00";
    value.textColor = [UIColor colorWithHex:0xAAB0BE];
    value.textAlignment = NSTextAlignmentRight;
    self.value = value;
    [self addSubview:value];
    [value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(100, 20));
    }];
    
//    UIView *xianView = [[UIView alloc] init];
//    xianView.backgroundColor = [UIColor colorWithHex:0xE6E6E8];
//    [self addSubview:xianView];
//    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.bottom.equalTo(self.mas_bottom).offset(-1);
//        make.height.mas_equalTo(1);
//    }];
}

@end
