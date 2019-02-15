//
//  WKOrderShopMessageTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderShopMessageTableViewCell.h"

@implementation WKOrderShopMessageTableViewCell

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
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.text = @"选择快递公司";
    self.name.textColor = [UIColor colorWithHex:0xAAB0BE];
    [self addSubview:self.name];
    
    UIImage *editImgae = [UIImage imageNamed:@"edit"];
    self.statusBtn = [[UIButton alloc] init];
    [self.statusBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:[UIColor colorWithHex:0xAAAEBC] forState:UIControlStateNormal];
    self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.statusBtn setImage:editImgae forState:UIControlStateNormal];
    [self.statusBtn addTarget:self action:@selector(editEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.statusBtn];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(editImgae.size.width+45, editImgae.size.height));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.statusBtn.mas_left).offset(-10);
    }];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editEvent)];
    // 2. 将点击事件添加到label上
    [self.name addGestureRecognizer:labelTapGestureRecognizer];
    self.name.userInteractionEnabled = YES; // 可以理解为设置label可被点击

    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHex:0xF7F8FA];
    [self addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.name.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 1));
    }];
}

-(void)editEvent
{
    if(_clickTypeOrderShop)
    {
        _clickTypeOrderShop();
    }
}

@end
