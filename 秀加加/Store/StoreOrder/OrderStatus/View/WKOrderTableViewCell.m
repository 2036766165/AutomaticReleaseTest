//
//  WKOrderTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderTableViewCell.h"


@interface WKOrderTableViewCell()

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UILabel *number;

@end

@implementation WKOrderTableViewCell

-(void)productItem:(WKOrderProduct*)item type:(NSInteger)type
{
    [self.headImgaeView sd_setImageWithURL:[NSURL URLWithString:item.GoodsPicUrl] placeholderImage:[UIImage imageNamed:@"default_05"]];
    self.title.text = item.GoodsName;
    if(type == 1)
    {
        if([item.GoodsModelName isEqualToString:@""])
        {
            self.content.text = @"";
        }
        else
        {
            self.content.text = [NSString stringWithFormat:@"型号:%@",item.GoodsModelName];
        }
        self.money.text = [NSString stringWithFormat:@"￥%.2f",[item.GoodsPrice floatValue]];
        self.number.text = [NSString stringWithFormat:@"X%ld",(long)item.GoodsNumber];
    }
    else if(type == 2)
    {
        self.content.text = [NSString stringWithFormat:@"起拍价￥%.2f  %@",[item.GoodsStartPrice floatValue],@"竞拍成功"];
        self.money.text = [NSString stringWithFormat:@"成交价￥%.2f",[item.GoodsPrice floatValue]];
        self.money.textColor = [UIColor colorWithHex:0xF3AE79];
        self.money.font = [UIFont systemFontOfSize:14];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[dateFormatter dateFromString:item.CreateTime];
        NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
        [dateToStringFormatter setDateFormat:@"yy-MM-dd HH:mm"];
       
        self.number.text = [dateToStringFormatter stringFromDate:date];
    }
    else if(type == 6)
    {
        self.content.text = [NSString stringWithFormat:@"商品金额￥%.2f  %@",[item.GoodsPrice floatValue],@"幸运降临"];
        self.money.text = [NSString stringWithFormat:@"幸运价￥%.2f",[item.GoodsStartPrice floatValue]];
        self.money.textColor = [UIColor colorWithHex:0xF3AE79];
        self.money.font = [UIFont systemFontOfSize:14];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[dateFormatter dateFromString:item.CreateTime];
        NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
        [dateToStringFormatter setDateFormat:@"yy-MM-dd HH:mm"];
        
        self.number.text = [dateToStringFormatter stringFromDate:date];
    }
}


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
    self.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
    
    UIImage *headImage = [UIImage imageNamed:@"default_05"];
    UIImageView *headImgaeView = [[UIImageView alloc] init];
    headImgaeView.layer.masksToBounds = YES;
    headImgaeView.layer.cornerRadius = 4.0;
    headImgaeView.contentMode = UIViewContentModeScaleAspectFill;
    headImgaeView.clipsToBounds = YES;
    headImgaeView.image = headImage;
    self.headImgaeView = headImgaeView;
    [self addSubview:headImgaeView];
    [headImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((85-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:12];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = @" qwer6tyuiodfghjgqwertyuio321`12345u7iouytrewqqweg";
    title.numberOfLines = 0;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    title.textColor = [UIColor colorWithHex:0x9DA1AD];
    self.title = title;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(headImgaeView).offset(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-headImage.size.width-30, 20));
    }];
    
    UILabel *content = [[UILabel alloc] init];
    content.font = [UIFont systemFontOfSize:12];
    content.textAlignment = NSTextAlignmentLeft;
    content.text = @"商品型号 棕色 37码";
    content.textColor = [UIColor colorWithHex:0xBFC3CB];
    self.content = content;
    [self addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(title.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-headImage.size.width-30, 20));
    }];
    
    UILabel *money = [[UILabel alloc] init];
    money.font = [UIFont systemFontOfSize:12];
    money.textAlignment = NSTextAlignmentLeft;
    money.text = @"￥188.00";
    money.textColor = [UIColor colorWithHex:0xBFC3CB];
    self.money = money;
    [self addSubview:money];
    
    UILabel *number = [[UILabel alloc] init];
    number.font = [UIFont systemFontOfSize:12];
    number.textAlignment = NSTextAlignmentLeft;
    number.text = @"X 1";
    number.textColor = [UIColor colorWithHex:0xBFC3CB];
    self.number = number;
    [self addSubview:number];

    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(content.mas_bottom).offset(10);
        make.right.equalTo(number.mas_left).offset(-10);
    }];

    
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(content.mas_bottom).offset(10);
        make.baseline.equalTo(money.mas_baseline);
    }];
}

@end
