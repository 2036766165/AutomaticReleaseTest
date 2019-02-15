//
//  WKLiveMessageTableViewCell.m
//  wdbo
//
//  Created by lin on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLiveMessageTableViewCell.h"

@interface WKLiveMessageTableViewCell(){
    WKListNoticeInfo *_tempMd;
}

@property (nonatomic,strong) UIImageView *backGroundView;

@end

@implementation WKLiveMessageTableViewCell

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
    self.backGroundView = [[UIImageView alloc] init];
    [self addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(150);
    }];
    
    self.nameType = [[UILabel alloc] init];
    self.nameType.text = @"交易信息";
    self.nameType.textAlignment = NSTextAlignmentLeft;
    self.nameType.textColor = [UIColor colorWithHex:0xFE7300];
    self.nameType.font = [UIFont systemFontOfSize:20];
    [self.backGroundView addSubview:self.nameType];
    [self.nameType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(5);
        make.top.equalTo(self.backGroundView).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.time = [[UILabel alloc] init];
    self.time.text = @"1分钟前";
    self.time.font = [UIFont systemFontOfSize:14];
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.textColor = [UIColor colorWithHex:0xC2C2C2];
    [self.backGroundView addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backGroundView.mas_right).offset(-5);
        make.top.equalTo(self.backGroundView).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.shopName = [[UILabel alloc] init];
    self.shopName.text = @"下单提醒:三驴子 下单成功";
    self.shopName.textColor = [UIColor colorWithHex:0x6A6A6A];
    self.shopName.textAlignment = NSTextAlignmentLeft;
    self.shopName.font = [UIFont systemFontOfSize:16];
    [self.backGroundView addSubview:self.shopName];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(5);
        make.top.equalTo(self.nameType.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(290, 20));
    }];
    
//    self.shopValue = [[UILabel alloc] init];
//    self.shopValue.text = @"商  品:别墅男士莫代尔豪华家居服";
//    self.shopValue.font = [UIFont systemFontOfSize:16];
//    self.shopValue.textColor = [UIColor colorWithHex:0x6A6A6A];
//    [self.backGroundView addSubview:self.shopValue];
//    [self.shopValue mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backGroundView).offset(5);
//        make.top.equalTo(self.shopName.mas_bottom).offset(5);
//        make.size.mas_equalTo(CGSizeMake(290, 20));
//    }];
    
//    self.headImg = [[UIImageView alloc] init];
//    self.headImg.backgroundColor = [UIColor greenColor];
//    [self.backGroundView addSubview:self.headImg];
//    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backGroundView).offset(5);
//        make.top.equalTo(self.shopValue.mas_bottom).offset(5);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
    
//    self.modelType = [[UILabel alloc] init];
//    self.modelType.textColor = [UIColor colorWithHex:0x949494];
//    self.modelType.text = @"型号：白色 M码";
//    self.modelType.textAlignment = NSTextAlignmentLeft;
//    self.modelType.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.modelType];
//    [self.modelType mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backGroundView.mas_left).offset(5);
//        make.top.equalTo(self.shopValue.mas_bottom).offset(5);
//        make.size.mas_equalTo(CGSizeMake(200, 20));
//    }];
//    
//    self.number = [[UILabel alloc] init];
//    self.number.textColor = [UIColor colorWithHex:0x949494];
//    self.number.text = @"数量:1";
//    self.number.textAlignment = NSTextAlignmentLeft;
//    self.number.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.number];
//    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backGroundView.mas_left).offset(5);
//        make.top.equalTo(self.modelType.mas_bottom).offset(10);
//        make.size.mas_equalTo(CGSizeMake(40, 20));
//    }];
//
//    self.valueName = [[UILabel alloc] init];
//    self.valueName.text = @"￥999.00";
//    self.valueName.textColor = [UIColor colorWithHex:0xFD5E00];
//    self.valueName.textAlignment = NSTextAlignmentRight;
//    self.valueName.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.valueName];
//    [self.valueName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backGroundView.mas_right).offset(-5);
//        make.bottom.equalTo(self.backGroundView.mas_bottom).offset(-20);
//        make.size.mas_equalTo(CGSizeMake(80, 20));
//    }];
}
-(void)setModel:(WKListNoticeInfo *)md{
    
    if (md) {
        _tempMd = md;
    }
    NSString *str = [_tempMd.CreateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *str2 = [str stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    NSString *str1 = [self compareCurrentTime:str2];
    self.time.text = str1;
    
    NSLog(@"%@",_tempMd.NoticeType);
    if ([_tempMd.NoticeType integerValue]== 3) {
        self.nameType.text = @"物流信息";
        self.shopName.text = [NSString stringWithFormat:@"支付提醒:%@",_tempMd.Message];
    }else if([_tempMd.NoticeType integerValue]== 2){
        self.nameType.text = @"订单信息";
        self.shopName.text = [NSString stringWithFormat:@"下单提醒:%@",_tempMd.Message];
    }
}
-(NSString *) compareCurrentTime:(NSString*) timeStr
//
{
    /**
     格式转换
     */
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* compareDate = [formater dateFromString:timeStr];
    /**
     *  计算时间
     */
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}
@end
