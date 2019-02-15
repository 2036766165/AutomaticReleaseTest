//
//  WKBackTableViewCell.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSelectLogisticsTableViewCell.h"

@implementation WKSelectLogisticsTableViewCell

-(instancetype)initWithNumber:(NSInteger)index and:(backBlock)block{
    if (self = [super init]) {
        self.block = block;
        self.label = [[UILabel alloc]init];
        self.label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.sizeOffset(CGSizeMake(WKScreenW*0.5, 40));
        }];
        
        self.button = [[UIButton alloc]init];
        self.button.tag = index+1;
        [self.contentView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)buttonClick:(UIButton *)button{
    self.block(self.label.text,button.tag);
}
@end
