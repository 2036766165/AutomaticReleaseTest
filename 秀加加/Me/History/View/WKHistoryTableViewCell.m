//
//  WKHistoryTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHistoryTableViewCell.h"
#import "WKTimeCalcute.h"

@interface WKHistoryTableViewCell()

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *levelImageView;
//名字
@property (nonatomic,strong) UILabel *name;

//粉丝+人数
@property (nonatomic,strong) UILabel *fanAndNum;
@property (nonatomic,strong) UIView *renView;

@property (nonatomic,strong) UIImageView *renImageView;
@property (nonatomic,strong) UILabel *renCon;

@end


@implementation WKHistoryTableViewCell


-(void)setItem:(WKHistoryItemModel *)item
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    self.name.text = item.MemberName;
    self.address.text = item.Location.length == 0 ? @"火星" : item.Location;
    
    self.fanAndNum.text = [NSString stringWithFormat:@"粉丝 %ld",(long)item.FunsCount];
    self.renImageView.image = item.ShopAuthenticationStatus == 1 ? [UIImage imageNamed:@"renzheng"] : [UIImage imageNamed:@"renzheng_def"];
    self.renCon.text = item.ShopAuthenticationStatus == 1 ? @"实体店验证" : @"非实体店";
    
    float level = floor([item.MemberLevel integerValue]%10);
    level = level == 0?1:level;
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"level%0.0f",level>10?10:level]];    

    NSString *currentStatus = @"";
    if(item.LiveStatus == 1)
    {
        currentStatus = @"正在直播";
    }
    else
    {
        currentStatus = [WKTimeCalcute compareCurrentTime:item.LastShowTime];
    }
    self.liveCon.text = currentStatus;
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
    UIImage *headImage = [UIImage imageNamed:@"guanzhu"];
    self.headImageView= [[UIImageView alloc] init];
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.image = headImage;
    UITapGestureRecognizer *headGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headEvent)];
    
    headGesture.delegate = self;
    [self.headImageView addGestureRecognizer:headGesture];
    [self.headImageView setUserInteractionEnabled:YES];
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((65-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    UIImage *levelImage = [UIImage imageNamed:@"level_yellow"];
    UIImageView *levelImageView = [[UIImageView alloc] init];
    levelImageView.image = levelImage;
    self.levelImageView = levelImageView;
    
    [self.headImageView addSubview:levelImageView];
    [levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(-10);
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(levelImage.size.width, levelImage.size.height));
    }];
    
    self.liveCon = [[UILabel alloc] init];
    self.liveCon.text = @"11个小时前直播过";
    self.liveCon.textAlignment = NSTextAlignmentRight;
    self.liveCon.font = [UIFont systemFontOfSize:10];
    self.liveCon.textColor = [UIColor colorWithHex:0x7e879d];
    [self addSubview:self.liveCon];
    CGSize conWidth = [self.liveCon.text sizeOfStringWithFont:[UIFont systemFontOfSize:10] withMaxSize:CGSizeMake(MAXFLOAT, 11)];
    [self.liveCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset((65 * 0.5 - conWidth.height) * 0.6);
        make.size.mas_equalTo(CGSizeMake(conWidth.width, 11));
    }];
    
    CGFloat labelWidth = WKScreenW - headImage.size.width - levelImage.size.width + 10 - conWidth.width - 50;
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"动力三驴子";
    self.name.font = [UIFont systemFontOfSize:14];
    self.name.textColor = [UIColor colorWithHex:0x7e879d];
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.centerY.equalTo(self.liveCon.mas_centerY);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(labelWidth * 0.7, 15));
    }];
    
    self.address = [[UILabel alloc] init];
    self.address.text = @"北京";
    self.address.font = [UIFont systemFontOfSize:11];
    self.address.textColor = [UIColor colorWithHex:0x7e879d];
    [self addSubview:self.address];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(10);
        make.centerY.equalTo(self.liveCon.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(labelWidth * 0.3, 12));
    }];
    
    CGFloat fanWidth = WKScreenW - headImage.size.width - levelImage.size.width + 10 - 10 - 10;
    self.fanAndNum = [[UILabel alloc] init];
    self.fanAndNum.text = @"粉丝 886";
    self.fanAndNum.font = [UIFont systemFontOfSize:12];
    self.fanAndNum.textColor = [UIColor colorWithHex:0x7e879d];
    CGSize fanSize = [self.fanAndNum.text sizeOfStringWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 13)];
    [self addSubview:self.fanAndNum];
    [self.fanAndNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.bottom.equalTo(self).offset( - (65 * 0.5 - fanSize.height) * 0.6);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(fanWidth * 0.6, 13));
    }];
    
    UIImage *renImage = [UIImage imageNamed:@"renzheng"];
    UIImageView *renImageView = [[UIImageView alloc] init];
    renImageView.image = renImage;
    self.renImageView = renImageView;
    [self addSubview:renImageView];
    [renImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fanAndNum.mas_right).offset(10);
        make.centerY.equalTo(self.fanAndNum.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(renImage.size.width, renImage.size.height));
    }];
    
    UILabel *renCon = [[UILabel alloc] init];
    renCon.text = @"实体店认证";
    renCon.font = [UIFont systemFontOfSize:10];
    renCon.textColor = [UIColor colorWithHex:0x7e879d];
    self.renCon = renCon;
    [self addSubview:renCon];
    [renCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(renImageView.mas_right).offset(5);
        make.centerY.equalTo(self.fanAndNum.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(fanWidth * 0.3, 11));
    }];
}

//点击头像
-(void)headEvent
{
    if(_clickHistoryType)
    {
        _clickHistoryType(1);
    }
}

@end
