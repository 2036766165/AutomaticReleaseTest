//
//  WKSendShopDetailViewCell.m
//  wdbo
//
//  Created by lin on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSendShopDetailViewCell.h"

@interface WKSendShopDetailViewCell()


@end

@implementation WKSendShopDetailViewCell

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
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, WKScreenW-45, 20)];
    self.detail.text = @"到北京市【北京金盏转运中心 已发出】";
    self.detail.font = [UIFont systemFontOfSize:16];
    self.detail.textColor = [UIColor colorWithHex:0x9e9e9e];
    self.detail.numberOfLines = 0;
    [self addSubview:self.detail];
    
    
    self.date = [[UILabel alloc] init];
    self.date.text = @"2016-06-08 18:00:09";
    self.date.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(35);
        make.top.equalTo(self.detail.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-45, 20));
    }];
    
    self.view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 13, 13)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.layer.cornerRadius = 6.5;
    [self addSubview:self.view];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(WKScreenW-30, 1));
    }]; 
}
-(void)setModel:(InnerListModel *)model{
    
    CGSize size = [model.context sizeOfStringWithFont:[UIFont systemFontOfSize:16] withMaxSize:CGSizeMake(WKScreenW-45, MAXFLOAT)];
    self.detail.frame = CGRectMake(35, 15, WKScreenW-45, 5+size.height);
    
    self.detail.text = model.context;
    self.date.text = model.ftime;
}
@end
