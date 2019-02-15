//
//  WKGoodsBaseCell.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomeGoodsBaseCell.h"

@implementation WKHomeGoodsBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor colorWithRed:232/255.0 green:237/255.0 blue:250/255.0 alpha:1];
    
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zanwu@2x_03"]];
    self.goodsImageView.layer.borderColor = [UIColor colorWithHexString:@"dae0ed"].CGColor;
    self.goodsImageView.clipsToBounds = YES;
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImageView.layer.borderWidth = 1;
    [self.backView addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(6);
        make.top.equalTo(self.backView.mas_top).offset(6);
        make.width.mas_equalTo(140-18);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-6);
    }];
    
    self.goodsNameLabel = [[UILabel alloc]init];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:12];
    self.goodsNameLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.goodsNameLabel.numberOfLines = 0;
    self.goodsNameLabel.text = @"测试商品名称测试商品名称";
    [self.backView addSubview:self.goodsNameLabel];
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(6);
        make.top.equalTo(self.backView.mas_top).offset(10);
        make.width.mas_equalTo(WKScreenW-140-6);
        make.height.mas_equalTo(13);
    }];
    
    //店主的头像和等级
    self.iconImageView = [[UIButton alloc]init];
    self.iconImageView.layer.cornerRadius = 37/2;
    [self.iconImageView setImage:[UIImage imageNamed:@"default_03"] forState:UIControlStateNormal];
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.borderColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    [self.backView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(6);
        make.bottom.equalTo(self.backView).offset(-15);
        make.size.sizeOffset(CGSizeMake(37, 37));
    }];
    
    self.levelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"level_yellow"]];
    [self.backView addSubview:self.levelImageView];
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView.mas_right).offset(0);
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    
    //商品价格
    self.goodsPriceLabel = [[UILabel alloc]init];
    self.goodsPriceLabel.font = [UIFont systemFontOfSize:11];
    self.goodsPriceLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.goodsPriceLabel.text = @"起拍价¥ 2000000";
    [self.backView addSubview:self.goodsPriceLabel];
    [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(6);
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-20);
        make.size.sizeOffset(CGSizeMake(WKScreenW -self.goodsImageView.image.size.width - 30, 12));
    }];
    
    //用户昵称
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.userNameLabel.text = @"SHEUFbasj";
    [self.backView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.equalTo(self.backView.mas_right).offset(-6);
        make.top.equalTo(self.iconImageView).offset((self.iconImageView.imageView.image.size.height * 0.5 - 13) * 0.6);
    }];
    
    //认证
    self.certLabel = [[UILabel alloc]init];
    self.certLabel.text = @"实体店认证";
    self.certLabel.font = [UIFont systemFontOfSize:10];
    self.certLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    CGSize lblSize = [self.certLabel.text sizeOfStringWithFont:[UIFont systemFontOfSize:10] withMaxSize:CGSizeMake(MAXFLOAT, 11)];
    [self.backView addSubview:self.certLabel];
    [self.certLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView).offset(-(self.iconImageView.imageView.image.size.height * 0.5 - 13) * 0.6);
        make.right.equalTo(self.backView.mas_right).offset(-6);
        make.size.sizeOffset(CGSizeMake(lblSize.width + 1, 11));
    }];
    
    self.certImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"renzheng"]];
    [self.backView addSubview:self.certImageView];
    [self.certImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.certLabel.mas_left).offset(-1);
        make.size.sizeOffset(CGSizeMake(self.certImageView.image.size.width,self.certImageView.image.size.height));
        make.centerY.equalTo(self.certLabel.mas_centerY);
    }];
    
    //定位地址
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:10];
    self.locationLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.locationLabel.text = @"北京";
    [self.backView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.equalTo(self.certImageView.mas_left).offset(-6);
        make.centerY.equalTo(self.certLabel.mas_centerY);
    }];
    
    self.circleView = [[WKCircleView alloc]init];
    self.circleView.layer.borderWidth = 3;
    self.circleView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.goodsImageView addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownMethod:) name:@"goodsCount" object:nil];
}
-(void)countDownMethod:(NSNotification *)noti{
    [self setRemindTime: [noti.userInfo[@"goodsCount"] stringValue]];
}
-(void)setRemindTime:(NSString *)remindTime{
    if (self.model.SaleType.integerValue == 2) {//筹卖
        
    }else if (self.model.Duration.integerValue>0) {
        [self.circleView setAuctionTime:self.model.Duration.integerValue and:self.model.RemainTime.integerValue - remindTime.integerValue ];
    }
}
-(void)setModel:(WKHomeGoodsModel *)model{
    if (_model != model) {
        _model = model;
        
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.GoodsPicUrl] placeholderImage:[UIImage imageNamed:@"zanwu@2x_03"]];
        
        self.goodsNameLabel.text = model.GoodsName;
        NSString *auctionStr;
        if (model.IsAuction.boolValue) {
            auctionStr = [NSString stringWithFormat:@"起拍价:¥ %0.2f",[model.Price floatValue]];
        }else{
            auctionStr = [NSString stringWithFormat:@"¥ %0.2f",[model.Price floatValue]];
        }
        self.goodsPriceLabel.text = auctionStr;
        
        if(model.IsAuction.integerValue == 1)
        {
            self.goodsPriceLabel.text = [NSString stringWithFormat:@"起拍价¥ %0.2f",[model.Price floatValue]];
        }
        else
        {
            self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[model.Price floatValue]];
        }
        
        if (self.model.SaleType.integerValue == 2) {//筹卖
            [self.circleView setLucklySaleMoney:self.model.Price.integerValue and:self.model.CurrentPrice.floatValue];
        }
        if (self.model.Duration.integerValue>0) {
            self.circleView.hidden = NO;
        }else{
            self.circleView.hidden = YES;
        }
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.ShopOwnerPhoto] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_03"]];
        
        self.userNameLabel.text = model.ShopOwnerName;
        
        self.locationLabel.text = model.Location.length == 0 ? @"火星" : model.Location;
        
        if(model.ShopAuthenticationStatus.integerValue == 1){
            self.certLabel.text = @"实体店认证";
            [self.certImageView setImage:[UIImage imageNamed:@"renzheng"]];
        }else{
            self.certLabel.text = @"非实体店";
            [self.certImageView setImage:[UIImage imageNamed:@"renzheng_def"]];
        }
    
        float level = floor([model.ShopOwnerLevel integerValue]%10);
        level = level == 0?1:level;
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"level%0.0f",level>10?10:level]];
    }
}

@end







