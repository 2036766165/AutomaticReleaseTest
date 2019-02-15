//
//  WKContributorTableViewCell.m
//  秀加加
//
//  Created by sks on 2017/2/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKContributorTableViewCell.h"
#import "WKRankListModel.h"

@interface WKContributorTableViewCell ()

@property (nonatomic,strong) UIImageView *medalView;
@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblMoney;
@property (nonatomic,strong) UILabel *lblRank;
@property (nonatomic,strong) UIImageView *crownImage;

@end
@implementation WKContributorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    // 用户头像
    UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:iconImageV];
    self.headView = iconImageV;
    
    // 名字
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLab.textColor = [UIColor darkGrayColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:nameLab];
    self.lblName = nameLab;
    
    // 消费金额
    UILabel *consumeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    consumeLab.textColor = [UIColor darkGrayColor];
    consumeLab.textAlignment = NSTextAlignmentCenter;
    consumeLab.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:consumeLab];
    self.lblMoney = consumeLab;
    
    // 排名
    UILabel *rankListLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rankListLab.textColor = [UIColor darkGrayColor];
    rankListLab.textAlignment = NSTextAlignmentCenter;
    rankListLab.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:rankListLab];
    self.lblRank = rankListLab;
    
    //皇冠
    UIImageView *crownImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:crownImageV];
    self.crownImage = crownImageV;
    
    //金牌，银牌，铜牌
    UIImageView *medalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:medalImage];
    self.medalView = medalImage;
}

- (void)setRanklist:(WKRankListModel *)rankList{
    
    //皇冠图片
    NSDictionary *crownDict = @{
                               @1:@"top",
                               @2:@"second",
                               @3:@"third"
                               };
    
    //排名图片
    NSDictionary *flagDict = @{
                               @1:@"top_flag",
                               @2:@"second_flag",
                               @3:@"third_flag"
                               };
    
    //排名前三，头像有皇冠，其他没有皇冠
    if (rankList.Sort.integerValue == 1 || rankList.Sort.integerValue == 2 || rankList.Sort.integerValue == 3)
    {
        self.crownImage.image = [UIImage imageNamed:crownDict[rankList.Sort]];
        self.medalView.image = [UIImage imageNamed:flagDict[rankList.Sort]];
    }
    
    if(rankList.Sort.integerValue == 1)
    {
        self.lblName.textAlignment = NSTextAlignmentCenter;
        self.lblMoney.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.lblName.textAlignment = NSTextAlignmentLeft;
        self.lblMoney.textAlignment = NSTextAlignmentLeft;
    }
    
    self.lblName.text = rankList.MemberName;
    self.lblRank.text = [NSString stringWithFormat:@"NO.%@",rankList.Sort];
    self.lblMoney.text = [NSString stringWithFormat:@"消费总额:￥%.2f",rankList.Amount.floatValue];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:rankList.MemberPicUrl] placeholderImage:[UIImage imageNamed:@"default_02"]];
    
    //设置排版
    [self layoutUIWithSort:rankList.Sort];
}

- (void)layoutUIWithSort:(NSNumber *)sort{
    if (sort.integerValue == 1 || sort.integerValue == 2 || sort.integerValue == 3)
    {
        self.lblRank.hidden = YES;

        //设置头像圆形
        self.headView.layer.cornerRadius = 70 / 2.0f;
        self.headView.layer.masksToBounds = YES;
        
        //设置金牌
        [self.medalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.mas_offset(10);
            make.size.mas_offset(self.medalView.image.size);
        }];
        
        //进行排版第一的样式控制
        if (sort.integerValue == 1)
        {
            [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_offset(0);
                make.top.mas_offset(15);
                make.size.mas_offset(CGSizeMake(70,70));
            }];
            
            [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headView.mas_bottom).offset(5);
                make.centerX.equalTo(self.mas_centerX);
                make.size.sizeOffset(CGSizeMake(WKScreenW - 70, 15));
            }];
            
            [self.lblMoney mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lblName.mas_bottom).offset(5);
                make.centerX.equalTo(self.mas_centerX);
                make.size.sizeOffset(CGSizeMake(WKScreenW - 70, 15));
            }];
            
        }
        else
        {
            [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_offset(0);
                make.left.equalTo(self.mas_left).offset(65);
                make.size.sizeOffset(CGSizeMake(70, 70));
            }];
            
            [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headView.mas_top).offset(10);
                make.left.equalTo(self.headView.mas_right).offset(15);
                make.size.sizeOffset(CGSizeMake(WKScreenW - 65 - 70 - 25,15));
            }];
            
            [self.lblMoney mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.headView.mas_bottom).offset(-10);
                make.left.equalTo(self.headView.mas_right).offset(15);
                make.size.sizeOffset(CGSizeMake(WKScreenW - 65 - 70 - 25, 15));
            }];
        }
        
        //设置皇冠
        [self.crownImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_top).offset(-6);
            make.right.mas_equalTo(self.headView.mas_right).offset(6);
            make.size.mas_offset(self.crownImage.image.size);
        }];
        
    }
    else
    {
        self.crownImage.hidden = YES;
        self.lblRank.hidden = NO;
        
        self.headView.layer.cornerRadius = 60 / 2.0f;
        self.headView.layer.masksToBounds = YES;
        
        CGSize RankSize = [self.lblRank.text sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 15)];
        [self.lblRank mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.mas_offset(10);
            make.size.sizeOffset(CGSizeMake(RankSize.width + 1, 15));
        }];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.equalTo(self.mas_left).offset(65);
            make.size.sizeOffset(CGSizeMake(60, 60));
        }];
        
        [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_top).offset(10);
            make.left.equalTo(self.headView.mas_right).offset(15);
            make.size.sizeOffset(CGSizeMake(WKScreenW - 65 - 60 - 25, 15));
        }];
        
        [self.lblMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headView.mas_bottom).offset(-10);
            make.left.equalTo(self.headView.mas_right).offset(15);
            make.size.sizeOffset(CGSizeMake(WKScreenW - 65 - 60 - 25, 15));
        }];
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 1));
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
