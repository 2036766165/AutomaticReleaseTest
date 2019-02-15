//
//  WKAddressTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddressTableViewCell.h"
#import "WKAddressModel.h"

@implementation WKAddressTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubView];
    }
    return self;
}

-(void)addSubView{
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
    [self.editBtn setImage:[UIImage imageNamed:@"xuanxze"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.editBtn];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.name = [[UILabel alloc] init];
    self.name.font = [UIFont systemFontOfSize:14];
    self.name.textColor = [UIColor colorWithHex:0xAAB0C1];
    [self.contentView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editBtn.mas_right).offset(20);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    self.number = [[UILabel alloc] init];
    self.number.font = [UIFont systemFontOfSize:14];
    self.number.textColor = [UIColor colorWithHex:0xAAB0C1];
    self.number.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.number];
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.defaultName = [[UILabel alloc] init];
    self.defaultName.textColor = [UIColor whiteColor];
    self.defaultName.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
    self.defaultName.font = [UIFont systemFontOfSize:14];
    self.defaultName.text = @"默认";
    self.defaultName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.defaultName];
    [self.defaultName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    self.title = [[UILabel alloc] init];
    self.title.textColor = [UIColor colorWithHex:0xAAB0C1];
    self.title.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.defaultName.mas_right).offset(5);
        make.top.equalTo(self.defaultName.mas_top).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        make.height.mas_greaterThanOrEqualTo(25);
    }];
}

- (void)setItem:(WKAddressListItem *)item isEdit:(BOOL)isEdit{
    self.name.text = item.Contact;
    self.number.text = item.Phone;
//    self.defaultName.hidden = !item.IsDefault;
    if (item.IsDefault) {
        [self.defaultName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 20));
        }];
    }else{
        [self.defaultName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 20));
        }];
    }
    
    [self layoutIfNeeded];
    
    self.title.text = [NSString stringWithFormat:@"%@%@%@ %@",item.ProvinceName,item.CityName,item.CountyName,item.Address];
    self.editBtn.hidden = !isEdit;
    
    CGFloat padding = 0;
    if (isEdit) {
        padding = 20;
    }else{
        padding = -20;
    }
    
    if (item.IsDefault) {
        self.number.textColor = [UIColor colorWithHexString:@"#FC6620"];
        self.name.textColor = [UIColor colorWithHexString:@"#FC6620"];
    }else{
        self.number.textColor = [UIColor lightGrayColor];
        self.name.textColor = [UIColor lightGrayColor];
    }
    
    [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding);
    }];
    
    NSString *status = item.isSelected?@"xuanxze":@"weixuanze";
    [self.editBtn setImage:[UIImage imageNamed:status] forState:UIControlStateNormal];
}


@end
