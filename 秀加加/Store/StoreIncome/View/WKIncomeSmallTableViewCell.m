//
//  WKIncomeSmallTableViewCell.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKIncomeSmallTableViewCell.h"

@implementation WKIncomeSmallTableViewCell

-(instancetype)init{
    if (self = [super init]) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.size.sizeOffset(CGSizeMake(WKScreenW*0.5-15, 20));
        }];
        
        self.valueLabel = [[UILabel alloc]init];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont systemFontOfSize:14];
        self.valueLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        [self.contentView addSubview:self.valueLabel];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.sizeOffset(CGSizeMake(WKScreenW*0.5-15, 20));
        }];
    }
    return self;
}

@end
