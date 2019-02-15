//
//  WKHomePlayCell.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomePlayCell.h"
#import "WKTagModel.h"
#import "WKCircleView.h"
#import "NSObject+XCTag.h"
#import "UIButton+ImageTitleSpacing.h"
@implementation WKHomePlayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.iconImageView = [[UIButton alloc]init];
    self.iconImageView.layer.cornerRadius = 37/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 1.0;
    self.iconImageView.layer.borderColor = [[UIColor colorWithHex:0xEE9357] CGColor];
    [self.iconImageView addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(37);
    }];
    
    self.levelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"level_yellow"]];
    [self.backView addSubview:self.levelImageView];
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView.mas_right).offset(0);
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.userNameLabel.text = @"SHEUFbasj";
    [self.backView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.top.equalTo(self.backView.mas_top).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(17);
    }];
    
    self.fansLabel = [[UILabel alloc]init];
    self.fansLabel.font = [UIFont systemFontOfSize:10];
    self.fansLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.fansLabel.text = @"粉丝 886";
    [self.backView addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(3);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(13);
    }];
    
    self.cityLabel = [[UILabel alloc]init];
    self.cityLabel.font = [UIFont systemFontOfSize:10];
    self.cityLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.cityLabel.text = @"北京";
    [self.backView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right).offset(3);
        make.centerY.equalTo(self.userNameLabel.mas_centerY).offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
    }];
    
    self.onlineNumber = [[UILabel alloc]init];
    self.onlineNumber.font = [UIFont systemFontOfSize:12];
    self.onlineNumber.textColor = [UIColor colorWithHexString:@"ff6600"];
    self.onlineNumber.text = @"8989再看";
    self.onlineNumber.textAlignment = NSTextAlignmentRight;
    [self.backView addSubview:self.onlineNumber];
    [self.onlineNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-8);
        make.bottom.equalTo(self.fansLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(13);
    }];
    
    self.showImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default_01"]];
    self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backView addSubview:self.showImageView];
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(8);
        make.right.equalTo(self.backView.mas_right).offset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.certificationButton = [[UIButton alloc]init];
    [self.certificationButton setImage:[UIImage imageNamed:@"renzheng"] forState:UIControlStateNormal];
    [self.certificationButton setTitle:@"实体店认证" forState:UIControlStateNormal];
    self.certificationButton.titleLabel.font = [UIFont systemFontOfSize:11];
    self.certificationButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.certificationButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.certificationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
    [self.showImageView addSubview:self.certificationButton];
    [self.certificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-5);
        make.top.equalTo(self.showImageView.mas_top).offset(8);
        make.size.sizeOffset(CGSizeMake(80, 17));
    }];
    
    self.masksView = [[UIView alloc]init];
    self.masksView.backgroundColor = [UIColor blackColor];
    self.masksView.alpha = 0.5;
    [self.showImageView addSubview:self.masksView];
    [self.masksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImageView.mas_left).offset(0);
        make.bottom.equalTo(self.showImageView.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(88);
    }];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 2;
    backView.layer.masksToBounds = YES;
    [self.backView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.showImageView.mas_bottom).offset(-3);
        make.width.mas_equalTo(82);
        make.right.mas_equalTo(-3);
        make.height.mas_equalTo(82);
    }];
    
    self.goodsImageView = [[UIImageView alloc]init];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:@""]placeholderImage:[UIImage imageNamed:@"zanwu@2x_03"]];
    self.goodsImageView.clipsToBounds = YES;
    self.goodsImageView.layer.borderWidth = 3;
    self.goodsImageView.layer.cornerRadius = 2;
    self.goodsImageView.layer.masksToBounds = YES;
    self.goodsImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backView addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(0.5);
        make.right.bottom.mas_offset(-0.5);
    }];
    
    self.circleView = [[WKCircleView alloc]initWithFrame:CGRectMake(0, 0, 82, 82)];
    [self.goodsImageView addSubview:self.circleView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownMethod:) name:@"timeCount" object:nil];
}
-(void)countDownMethod:(NSNotification *)noti{
    [self setRemindTime: [noti.userInfo[@"timeCount"] stringValue]];
}

-(void)iconButtonAction:(UIButton *)button{
    self.block(button.currentTitle);
}

-(void)setModel:(WKHomePlayModel *)model{
    if (_model!=model) {
        _model = model;
        if ([model.ShopAuthenticationStatus integerValue] == 0)
        {
            self.certificationButton.hidden = YES;
        }
        else
        {
            self.certificationButton.hidden = NO;
//            [self.certificationButton setImage:[UIImage imageNamed:@"renzheng"] forState:UIControlStateNormal];
//            [self.certificationButton setTitle:@" 实体店认证" forState:UIControlStateNormal];
        }
        //动态计算Button的宽度
//        CGSize buttonSize = [self.certificationButton.titleLabel.text sizeOfStringWithFont:[UIFont systemFontOfSize:11] withMaxSize:CGSizeMake(MAXFLOAT, 12)];
//        [self.certificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.backView.mas_right).offset(-8);
//            make.top.equalTo(self.showImageView.mas_top).offset(8);
//            make.size.sizeOffset(CGSizeMake(buttonSize.width + self.certificationButton.imageView.image.size.width + 3, 17));
//        }];
//        [self.certificationButton layoutIfNeeded];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.MemberMinPhoto] forState:UIControlStateNormal placeholderImage:[UIImage circleImageWithName:@"default_03" borderWidth:0.25 borderColor:[UIColor colorWithHexString:@"ff6600"]]];
        
        [self.iconImageView setTitle:model.BPOID forState:UIControlStateNormal];
        
        CGSize size = [model.MemberName sizeOfStringWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(200, MAXFLOAT)];
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(8);
            make.top.equalTo(self.backView.mas_top).offset(10);
            make.width.mas_equalTo(size.width+5);
            make.height.mas_equalTo(17);
        }];
        
        float level = floor([model.MemberLevel integerValue]%10);
        level = level == 0?1:level;
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"level%0.0f",level>10?10:level]];
 
        self.userNameLabel.text = model.MemberName;
        self.cityLabel.text = model.Location.length > 0 ? model.Location : @"火星";
        
        NSString *lineNumber;
        if (self.isSearch) {
            self.fansLabel.hidden = YES;
            self.onlineNumber.hidden = YES;
        }else{
            self.fansLabel.hidden = NO;
            self.onlineNumber.hidden = NO;
        }
        self.fansLabel.text = [NSString stringWithFormat:@"粉丝 %@",model.FunsCount];
        lineNumber= [NSString stringWithFormat:@"%@在看",model.CurrentOnlineNumber];
        if(model.LiveStatus.integerValue == 0)
        {
            lineNumber = [WKTimeCalcute compareCurrentTime:model.LastShowTime];
        }
        self.onlineNumber.text = lineNumber;
        
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.MemberPhoto]placeholderImage:[UIImage imageNamed:@"shouyezanwu"]];
        NSString *imageName = [NSString stringWithFormat:@"mai%d",arc4random()%2+1];
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.GoodsPhoto] placeholderImage:[UIImage imageNamed:imageName]];
        
        if (self.model.SaleType.integerValue == 2) {//筹卖
            [self.circleView setLucklySaleMoney:self.model.GoodsPrice.integerValue and:self.model.CurrentPrice.floatValue];
        }
        if (self.model.TotalSaleSecond.integerValue>0) {
            self.circleView.hidden = NO;
        }else{
            self.circleView.hidden = YES;
        }
        if (model.MemberMood.length>0) {
            self.flowButton.hidden = YES;
            [self.memberMood removeFromSuperview];
            [self.flowButton removeFromSuperview];
            self.memberMood.hidden = NO;
            self.memberMood = [[UILabel alloc]init];
            self.memberMood.text = model.MemberMood;
            self.memberMood.font = [UIFont systemFontOfSize:14];
            self.memberMood.numberOfLines = 0;
            self.memberMood.textColor = [UIColor whiteColor];
            [self.backView addSubview:self.memberMood];
            [self.memberMood mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.showImageView.mas_left).offset(6);
                make.bottom.equalTo(self.showImageView.mas_bottom).offset(-10);
                make.right.mas_equalTo(-91);
                make.height.mas_equalTo(68);
            }];
        }else{

            NSDictionary *dic = [NSDictionary dicWithJsonStr:model.ShopTag];
            NSArray *titleArr = dic[@"titleArr"];
            NSArray *colorArr = dic[@"colorArr"];
            self.memberMood.hidden = YES;
            [self.memberMood removeFromSuperview];
            [self.flowButton removeFromSuperview];
            self.flowButton.hidden = NO;
            self.flowButton = [[WKFlowButton alloc]initWithFrame:CGRectMake(0, 0, WKScreenW-91, 88) andTitleArr:titleArr andColorArr:colorArr andFont:13 andType:flowButtonLeft :^(NSInteger index, NSString *title) {
                
            }];
            [self.backView addSubview:self.flowButton];
            [self.flowButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.showImageView.mas_left).offset(0);
                make.bottom.equalTo(self.showImageView.mas_bottom).offset(0);
                make.right.mas_equalTo(-91);
                make.height.mas_equalTo(88);
            }];
        }
    }
}

-(void)setRemindTime:(NSString *)remindTime{
    if (self.model.SaleType.integerValue == 2) {//筹卖
        
    }else if (self.model.TotalSaleSecond.integerValue>0) {
        [self.circleView setAuctionTime:self.model.TotalSaleSecond.integerValue and:self.model.RemainTime.integerValue - remindTime.integerValue ];
    }
}

@end








