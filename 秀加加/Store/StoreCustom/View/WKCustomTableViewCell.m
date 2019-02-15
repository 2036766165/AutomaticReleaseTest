//
//  WKCustomTableViewCell.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKCustomTableViewCell.h"
@interface WKCustomTableViewCell ()

@property (strong, nonatomic) UIImageView *headIM;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *content;

@property (strong, nonatomic) UIImageView * levelImageView;

@end
@implementation WKCustomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createMainUI];
    }
    return self;
}

-(void)createMainUI{
    self.headIM = [[UIImageView alloc]init];
    self.headIM.image = [UIImage imageNamed:@"guanzhu"];
    [self.contentView addSubview:self.headIM];
    [self.headIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(12.5);
        make.size.sizeOffset(CGSizeMake(40, 40));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.text = @"三驴子";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIM.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.5, 15));
    }];
    
    self.content = [[UILabel alloc]init];
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textColor = [UIColor colorWithHexString:@"7e789d"];
    
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIM.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.5, 15));
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 65-1, WKScreenW, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:lineView];
    
    self.levelImageView = [[UIImageView alloc]init];
    self.levelImageView.layer.cornerRadius = 5;
    self.levelImageView.layer.masksToBounds = YES;
    [self.headIM addSubview:self.levelImageView];
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_offset(4);
        make.size.sizeOffset(CGSizeMake(13, 13));
    }];
    
    
}
-(void)setModel:(CustomInnerList *)model{
    if (_model != model) {
        _model = model;
        [self.headIM sd_setImageWithURL:[NSURL URLWithString:model.MemberPhoto] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
        self.nameLabel.text = model.MemberName;
        NSString *orderNum = model.OrderCount;
        NSString *orderPrice = [NSString stringWithFormat:@"%0.2f",[model.OrderAmount floatValue]];
        NSString *content = [NSString stringWithFormat:@"共%@笔交易 ¥%0.2f",orderNum,[orderPrice floatValue]];
        NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString:content];
        //颜色
        [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHexString:@"ff6600"] range: NSMakeRange(1, orderNum.length)];
        [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHexString:@"ff6600"] range: NSMakeRange(content.length-orderPrice.length-1, orderPrice.length+1)];
        //字号
        [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:15] range: NSMakeRange(content.length-orderPrice.length-1, orderPrice.length+1)];
        self.content.attributedText = attributedStr01;
        float level = floor([model.MemberLevel integerValue]%10);
        level = level == 0?1:level;
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"level%0.0f",level>10?10:level]];
        ;
    }
}
@end
