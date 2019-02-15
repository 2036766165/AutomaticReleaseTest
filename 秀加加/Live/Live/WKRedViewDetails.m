//
//  WKRedViewDetails.m
//  秀加加
//
//  Created by Chang_Mac on 17/3/20.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKRedViewDetails.h"

@interface WKRedViewDetails ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WKRedViewDetails

-(instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
    }
    return self;
}

-(void)createUI{
    CGFloat headHeight;
    if (self.model.FromType.integerValue == 2) {//系统
        headHeight = WKScreenW*0.8;
    }else{
        headHeight = WKScreenW*0.55;
    }
    self.backgroundColor = [UIColor colorWithWholeRed:254 green:244 blue:222];
    self.tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, headHeight, WKScreenW, WKScreenH-64-headHeight) style:UITableViewStyleGrouped];
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablview.dataSource = self;
    self.tablview.delegate = self;
    self.tablview.backgroundColor = [UIColor colorWithWholeRed:254 green:244 blue:222];
    [self addSubview:self.tablview];
}

-(UIView *)createHeadView{
    [self createUI];
    if (self.model.FromType.integerValue == 2) {//系统
        UIView *systView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.8)];
        
        UIImage *image = [UIImage imageNamed:@"guanfang"];
        UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.6)];
        topView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 40, 0) resizingMode:UIImageResizingModeStretch];
        [systView addSubview:topView];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.08, WKScreenW*0.9, WKScreenW*0.05)];
        content.font = [UIFont systemFontOfSize:WKScreenW*0.05];
        content.textColor = [UIColor colorWithWholeRed:254 green:244 blue:202];
        content.text = self.model.BagMessage;
        content.textAlignment = NSTextAlignmentCenter;
        [systView addSubview:content];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.2, WKScreenW*0.9, WKScreenW*0.1)];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor colorWithWholeRed:254 green:244 blue:202];
        priceLabel.font = [UIFont systemFontOfSize:WKScreenW*0.05];
        NSString *attStr = [NSString stringWithFormat:@"共%@元",self.model.TotalAmount];
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:attStr];
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WKScreenW*0.1] range:NSMakeRange(1, attStr.length-2)];
        priceLabel.attributedText = attribut;
        [systView addSubview:priceLabel];
        
        UIImageView *iconIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.4, WKScreenW*0.4, WKScreenW*0.2, WKScreenW*0.2)];
        iconIM.layer.cornerRadius = WKScreenW*0.1;
        iconIM.layer.masksToBounds = YES;
        iconIM.layer.borderColor = [UIColor lightGrayColor].CGColor;
        iconIM.layer.borderWidth = 0.5;
        iconIM.image = [UIImage imageNamed:@"systemIcon"];
        [systView addSubview:iconIM];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.63, WKScreenW*0.9, WKScreenW*0.05)];
        name.font = [UIFont systemFontOfSize:WKScreenW*0.045];
        name.textColor = [UIColor colorWithHexString:@"7e879d"];
        name.text = @"秀加加的红包";
        name.textAlignment = NSTextAlignmentCenter;
        [systView addSubview:name];
        
        NSString * labelStr = [NSString stringWithFormat:@"已领取%lu/%@个,共%0.2f/%0.2f元  ",(unsigned long)self.model.InnerList.count,self.model.TotalCount,self.model.CurrentRobbedAmount.doubleValue,self.model.TotalAmount.doubleValue];
        labelStr = [labelStr stringByReplacingOccurrencesOfString:@"null" withString:@"0"];
        labelStr = [NSString stringWithFormat:@"%@%@",labelStr,self.model.CurrentStatus];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.73, WKScreenW*0.9, WKScreenW*0.05)];
        label.textColor = [UIColor colorWithHexString:@"7e879d"];
        label.alpha = 0.6;
        label.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        label.text = labelStr;
        [systView addSubview:label];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(systView.frame)-1, WKScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [systView addSubview:line];
        
        return systView;
    }else{
        UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.55)];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.44)];
        topView.backgroundColor = [UIColor colorWithHexString:@"fff9e9"];
        [userView addSubview:topView];
        
        UIImageView *backIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.33)];
        backIM.image = [UIImage imageNamed:@"receive"];
        [topView addSubview:backIM];
        
        UIImageView *iconIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.425, WKScreenW*0.08, WKScreenW*0.15, WKScreenW*0.15)];
        [iconIM sd_setImageWithURL:[NSURL URLWithString:self.model.HostPhoto] placeholderImage:[UIImage imageNamed:@"default_03"]];
        iconIM.layer.cornerRadius = WKScreenW*0.075;
        iconIM.layer.masksToBounds = YES;
        [topView addSubview:iconIM];
        
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.25, WKScreenW*0.9, WKScreenW*0.05)];
        userName.textColor = [UIColor colorWithHexString:@"7e879d"];
        userName.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        userName.textAlignment = NSTextAlignmentCenter;
        userName.text = [NSString stringWithFormat:@"%@的红包",self.model.HostName];
        [userView addSubview:userName];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.32, WKScreenW*0.9, WKScreenW*0.05)];
        content.alpha = 0.6;
        content.textColor = [UIColor colorWithHexString:@"7e879d"];
        content.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        content.textAlignment = NSTextAlignmentCenter;
        content.text = self.model.BagMessage;
        [userView addSubview:content];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, WKScreenW*0.44-1, WKScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [topView addSubview:line];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, WKScreenW*0.55-1, WKScreenW, 1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [userView addSubview:line2];

        NSString * labelStr = [NSString stringWithFormat:@"已领取%lu/%@个,共%0.2f/%0.2f元  ",(unsigned long)self.model.InnerList.count,self.model.TotalCount,self.model.CurrentRobbedAmount.doubleValue,self.model.TotalAmount.doubleValue];
        labelStr = [labelStr stringByReplacingOccurrencesOfString:@"null" withString:@"0"];
        labelStr = [NSString stringWithFormat:@"%@%@",labelStr,self.model.CurrentStatus];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.48, WKScreenW*0.9, WKScreenW*0.05)];
        label.textColor = [UIColor colorWithHexString:@"7e879d"];
        label.alpha = 0.6;
        label.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        label.text = labelStr;
        [userView addSubview:label];
        
        return userView;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.InnerList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKRedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKRedViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.model = self.model.InnerList[indexPath.row];
    if (self.model.BagType.integerValue == 1) {
        cell.luckBtn.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WKScreenW*0.19;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

@end

@interface WKRedViewCell ()

@property (strong, nonatomic) UIImageView * iconIM;
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UILabel * priceLabel;

@end

@implementation WKRedViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor colorWithHexString:@"fff9e9"];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, WKScreenW*0.19-1, WKScreenW, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
    [self.contentView addSubview:line];
    
    UIImageView *headIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.045, WKScreenW*0.1, WKScreenW*0.1)];
    headIM.layer.cornerRadius = WKScreenW*0.05;
    headIM.layer.masksToBounds = YES;
    [self.contentView addSubview:headIM];
    self.iconIM = headIM;
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.2, WKScreenW*0.04, WKScreenW*0.2, WKScreenW*0.05)];
    userName.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    userName.textColor = [UIColor colorWithHexString:@"7e879d"];
    [self.contentView addSubview:userName];
    self.userName = userName;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.2, WKScreenW*0.11, WKScreenW*0.7, WKScreenW*0.04)];
    timeLabel.textColor = [[UIColor colorWithHexString:@"7e879d"]colorWithAlphaComponent:0.6];
    timeLabel.font = [UIFont systemFontOfSize:WKScreenW*0.035];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.75, WKScreenW*0.05, WKScreenW*0.2, WKScreenW*0.05)];
    priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
    priceLabel.font = [UIFont systemFontOfSize:WKScreenW*0.045];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIButton *luckBtn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.75, WKScreenW*0.11, WKScreenW*0.25, WKScreenW*0.05)];
    [luckBtn setTitle:@" 手气最佳" forState:UIControlStateNormal];
    [luckBtn setImage:[UIImage imageNamed:@"best"] forState:UIControlStateNormal];
    [luckBtn setTitleColor:[UIColor colorWithHexString:@"ffd700"] forState:UIControlStateNormal];
    luckBtn.hidden = YES;
    luckBtn.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.03];
    [self.contentView addSubview:luckBtn];
    self.luckBtn = luckBtn;
}

-(void)setModel:(InnerList *)model{
    if (_model != model) {
        _model = model;
        [self.iconIM sd_setImageWithURL:[NSURL URLWithString:model.MemberPhoto] placeholderImage:[UIImage imageNamed:@"default_03"]];
        CGSize size = [model.MemberName sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW*0.04] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW*0.05)];
        self.userName.frame = CGRectMake(WKScreenW*0.2, WKScreenW*0.05, size.width>WKScreenW*0.45?WKScreenW*0.45:size.width, WKScreenW*0.05);
        self.userName.text = model.MemberName;
        self.timeLabel.text = model.RobTime;
        self.priceLabel.text =[NSString stringWithFormat:@"%0.2f 元",[model.RobAmount doubleValue]];
        [self.contentView addSubview:[self createLevelViewWithLevel:model.MemberLevel andX:CGRectGetMaxX(self.userName.frame)]];
        if (model.IsBest.boolValue) {
            self.luckBtn.hidden = NO;
        }
    }
}
-(UIView *)createLevelViewWithLevel:(NSString *)levelStr andX:(CGFloat)X{
    NSInteger level = levelStr.integerValue;
    NSString *imageName = @"";
    if (level>9) {
        imageName = @"level10";
    }else{
        imageName = [NSString stringWithFormat:@"level%ld",(long)level];
    }
    NSArray *colorArr = @[@"d9790b",@"e2e2e0",@"eecb00",@"a200d0"];
    NSArray *edgeColorArr = @[@"ff9c20",@"bbbbb9",@"ffe80e",@"8b02b4"];
    UIView *levelView = [[UIView alloc]initWithFrame:CGRectMake(X+5, 0.06*WKScreenW, WKScreenW*0.1, WKScreenW*0.035)];
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WKScreenW*0.1, WKScreenW*0.035)];
    switch (level) {
        case 1:case 4:case 7:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[0]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[0]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"f6ebab"];
            break;
        case 2:case 5:case 8:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[1]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[1]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
            break;
        case 3:case 6:case 9:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[2]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[2]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"ffeeb3"];
            break;
        default:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[3]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[3]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"f1cb66"];
            break;
    }
    
    levelLabel.layer.borderWidth = 1;
    levelLabel.layer.masksToBounds = YES;
    levelLabel.font = [UIFont systemFontOfSize:WKScreenW*0.025];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.text = [NSString stringWithFormat:@"    V%lu",(long)level];
    levelLabel.layer.cornerRadius = WKScreenW*0.035/2;
    levelLabel.adjustsFontSizeToFitWidth = YES;
    [levelView addSubview:levelLabel];
    
    UIImageView *levelIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, -WKScreenW*0.005, WKScreenW*0.043, WKScreenW*0.043)];
    levelIM.image = [UIImage imageNamed:imageName];
    [levelView addSubview:levelIM];
    
    return levelView;
}

@end




