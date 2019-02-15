//
//  WKOnlineTableViewCell.m
//  秀加加
//
//  Created by sks on 2017/2/26.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKOnlineTableViewCell.h"
#import "WKAllOnlineViewController.h"
#import "WKLevelItemView.h"
@interface WKOnlineTableViewCell ()

@property (nonatomic,strong) UILabel *noLabel;
@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *memberNoLabel;
@property (nonatomic,strong) WKLevelItemView *levelImageV;

@end

@implementation WKOnlineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // no
        UILabel *no = [UILabel new];
        no.font = [UIFont systemFontOfSize:14];
//        no.backgroundColor = [UIColor redColor];
        no.textAlignment = NSTextAlignmentCenter;
        no.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:no];
        self.noLabel = no;
        
        // icon
        UIImageView *iconImageV = [UIImageView new];
        iconImageV.layer.cornerRadius = 25;
        iconImageV.clipsToBounds = YES;
        [self.contentView addSubview:iconImageV];
        
        self.iconImageV = iconImageV;
        
        // name
        UILabel *nameLab = [UILabel new];
//        nameLab.backgroundColor = [UIColor redColor];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:nameLab];
        
        self.nameLabel = nameLab;
        
        // member no
        UILabel *memberNO = [UILabel new];
//        memberNO.backgroundColor = [UIColor redColor];
        memberNO.font = [UIFont systemFontOfSize:14];
        memberNO.textAlignment = NSTextAlignmentLeft;
        memberNO.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:memberNO];
        
        self.memberNoLabel = memberNO;
        
        WKLevelItemView *levelImage = [[WKLevelItemView alloc] init];
        [self.contentView addSubview:levelImage];
        self.levelImageV = levelImage;
        
        // layout
        [no mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
            make.size.mas_offset(CGSizeMake(30, 30));
            make.left.mas_offset(20);
        }];
        
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.size.mas_offset(CGSizeMake(50, 50));
            make.left.mas_equalTo(no.mas_right).offset(20);
        }];
        
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(100, 20));
            make.left.mas_equalTo(iconImageV.mas_right).offset(20);
            make.top.mas_equalTo(iconImageV.mas_top).offset(0);
        }];
        
        [memberNO mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(120, 20));
            make.top.mas_equalTo(nameLab.mas_bottom).offset(2);
            make.left.mas_equalTo(iconImageV.mas_right).offset(20);
        }];
        
        [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLab.mas_centerY).offset(-4);
            make.size.mas_offset(CGSizeMake(60, 20));
            make.left.mas_equalTo(nameLab.mas_right).offset(5);
        }];
    }
    
    return self;
}

- (void)setOnlineListMd:(WKOnlineListMd *)md{
    self.noLabel.text = [NSString stringWithFormat:@"%ld",md.no.integerValue + 1];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:md.murl] placeholderImage:[UIImage imageNamed:@"default_02"]];
    self.nameLabel.text = md.mn;
    self.memberNoLabel.text = [NSString stringWithFormat:@"门牌号:%@",md.mno];
    [self.levelImageV setLevel:md.ml.integerValue];
    
    CGFloat width = [NSString sizeWithText:md.mn font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(1000, 25)].width;
    if (width > WKScreenW * 0.5) {
        width = WKScreenW * 0.5;
    }
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(width + 10, 20));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
