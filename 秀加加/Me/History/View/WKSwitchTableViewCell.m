//
//  WKSwitchTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/11/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSwitchTableViewCell.h"
#import "WKShowRemindModel.h"

@interface WKSwitchTableViewCell (){
    WKShowItemModel *_item;
}

@property (nonatomic,strong) UIImageView *iconImageV; // 头像
@property (nonatomic,strong) UIImageView *iconLevel; // 等级

@property (nonatomic,strong) UILabel *userInfo;       // 信息

@property (nonatomic,strong) UILabel *username;       // 名字

@property (nonatomic,strong) UIButton *switchBtn;      // 切换按钮



@end

@implementation WKSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    UIImageView *iconImageV = [UIImageView new];
    [self.contentView addSubview:iconImageV];
    self.iconImageV = iconImageV;
    
    UIImageView *levelImageV = [UIImageView new];
    [self.contentView addSubview:levelImageV];
    self.iconLevel = levelImageV;
    
    
    UILabel *nameLab = [UILabel new];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:16.0f];
    nameLab.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:nameLab];
    self.username = nameLab;
    
    UILabel *infoLab = [UILabel new];
    infoLab.textAlignment = NSTextAlignmentLeft;
    infoLab.font = [UIFont systemFontOfSize:14.0f];
    infoLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:infoLab];
    self.userInfo = infoLab;
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchBtn setImage:[UIImage imageNamed:@"开播通知按钮_normal"] forState:UIControlStateNormal];
    [switchBtn setImage:[UIImage imageNamed:@"开播通知按钮"] forState:UIControlStateSelected];
    [switchBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:switchBtn];
    self.switchBtn = switchBtn;
    
    [self.iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_offset(5);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    
    [self.iconLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(18, 18));
        make.bottom.mas_equalTo(self.iconImageV.mas_bottom).offset(5);
        make.right.mas_equalTo(self.iconImageV.mas_right).offset(5);
    }];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageV.mas_right).offset(10);
        make.top.mas_equalTo(self.iconImageV.mas_top).offset(0);
        make.size.mas_offset(CGSizeMake(180, 30));
    }];

    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageV.mas_right).offset(10);
        make.bottom.mas_equalTo(self.iconImageV.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(180, 15));
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(30 * 113/70, 30));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
}

- (void)switchClick:(UIButton *)btn{
    // 关注或取消关注
    btn.selected = !btn.selected;
    _item.IsAccept = @(btn.selected);
    
    if ([_delegate respondsToSelector:@selector(switchDelegateWithItem:)]) {
        [_delegate switchDelegateWithItem:_item];
    }
    
}

- (void)setItem:(WKShowItemModel *)item{
    _item = item;
    
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:item.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"bianjizanwutouxiang"]];
    self.username.text = item.MemberName;
    self.userInfo.text = [NSString stringWithFormat:@"粉丝 %@ %@",item.FunsCount,item.Location];
    
    NSString *levelName = [NSString stringWithFormat:@"dengji_%ld",(long)item.MemberLevel.integerValue];
    self.iconLevel.image = [UIImage imageNamed:levelName];

    self.switchBtn.selected = item.IsAccept.boolValue;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
