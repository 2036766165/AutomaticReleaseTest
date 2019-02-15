//
//  OrderTypeCell.m
//  秀加加
//
//  Created by liuliang on 2017/2/18.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "OrderTypeCell.h"

@implementation OrderTypeCell

@synthesize typelabel;
@synthesize typeimg;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initui];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected == true){
        typelabel.textColor = [UIColor colorWithHex:0xFFAE75];
    }
    else{
        typelabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
    // Configure the view for the selected state
}

-(void)setData:(NSString*)txt img:(NSString*)img{
    UIImage *headImage = [UIImage imageNamed:img];
    typeimg.image = headImage;
    typelabel.text = txt;
}

-(void)initui
{
    self.backgroundColor = [UIColor clearColor];
    typeimg = [[UIImageView alloc] init];
    [self addSubview:typeimg];
    [typeimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
    }];
    
    typelabel = [[UILabel alloc] init];
    typelabel.font = [UIFont systemFontOfSize:12];
    typelabel.textAlignment = NSTextAlignmentLeft;
    typelabel.text = @"";
    typelabel.numberOfLines = 0;
    typelabel.lineBreakMode = NSLineBreakByCharWrapping;
    typelabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    [self addSubview:typelabel];
    [typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeimg.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor grayColor];
    [self addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(5);
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
}

@end
