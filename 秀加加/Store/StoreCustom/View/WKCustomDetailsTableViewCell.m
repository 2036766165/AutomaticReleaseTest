//
//  WKCustomDetailsTableViewCell.m
//  客户详情页面订单列表的Cell
//  Created by ZHAOHL on 2016/10/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCustomDetailsTableViewCell.h"
#import "WKCuntomAllOrder.h"

@implementation WKCustomDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createMainUI];
    }
    return self;
}

-(void)createMainUI{
    
    UIView * goodView = [[UIView alloc]init];
    goodView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [self.contentView addSubview: goodView];
    [goodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(WKScreenW, 90));
        make.left.mas_offset(0);
        make.top.mas_offset(0);
    }];
    
    self.goodImg = [[UIImageView alloc]init];
    CALayer *layer = [self.goodImg layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    [layer setBorderWidth:0.5];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [goodView addSubview:self.goodImg];
    [self.goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodView.mas_centerY);
        make.left.equalTo(goodView.mas_left).offset(10);
        make.size.sizeOffset(CGSizeMake(70, 70));
    }];
    
    self.goodName=[[UILabel alloc]init];
    self.goodName.text = @"";
    self.goodName.numberOfLines= 0;
    self.goodName.font = [UIFont systemFontOfSize:13];
    self.goodName.textColor = [UIColor colorWithHexString:@"7e879d"];
    [goodView addSubview:self.goodName];
    [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodView.mas_top).offset(2);
        make.left.equalTo(self.goodImg.mas_right).offset(10);
        make.right.equalTo(goodView.mas_right).offset(-10);
        make.height.mas_equalTo(32);
    }];
    
    self.goodtype=[[UILabel alloc]init];
    self.goodtype.text = @"";
    self.goodtype.font = [UIFont systemFontOfSize:11];
    self.goodtype.textColor = [UIColor colorWithHexString:@"7e879d"];
    [goodView addSubview:self.goodtype];
    [self.goodtype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodName.mas_bottom).offset(9);
        make.left.equalTo(self.goodImg.mas_right).offset(10);
        make.right.equalTo(goodView.mas_right).offset(-10);
        make.height.mas_equalTo(12);
    }];
    
    self.goodPrice=[[UILabel alloc]init];
    self.goodPrice.text = @"";
    self.goodPrice.font = [UIFont systemFontOfSize:13];
    self.goodPrice.textColor = [UIColor colorWithHexString:@"7e879d"];
    [goodView addSubview:self.goodPrice];
    [self.goodPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodImg.mas_bottom).offset(-2);
        make.left.equalTo(self.goodImg.mas_right).offset(10);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.4, 14));
    }];
    
    self.goodNum=[[UILabel alloc]init];
    self.goodNum.text = @"";
    self.goodNum.textAlignment = NSTextAlignmentRight;
    self.goodNum.font = [UIFont systemFontOfSize:13];
    self.goodNum.textColor = [UIColor colorWithHexString:@"7e879d"];
    [goodView addSubview:self.goodNum];
    [self.goodNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodImg.mas_bottom).offset(-2);
        make.right.equalTo(goodView.mas_right).offset(-10);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.2, 14));
    }];
}
-(void)setModel:(WKCustomerListProduct *)model{
    if (_model != model) {
        _model = model;
        self.goodNum.text = [NSString stringWithFormat:@"x %@",model.GoodsNumber];
        
        //如果是快捷商品
        if(model.GoodsCode.integerValue == 0)
        {
            self.goodName.text = @"语音拍卖";
            [self.goodImg setImage:[UIImage imageNamed:@"pingjiastore"]];
            self.goodtype.hidden = YES;
        }
        else
        {
            self.goodImg.image = [UIImage imageNamed:@""];
            [self.goodImg sd_setImageWithURL:[NSURL URLWithString:model.GoodsPicUrl]];
            self.goodName.text = model.GoodsName;
            
            if(model.GoodsModelName.length > 0 )
            {
                self.goodtype.hidden = NO;
                self.goodtype.text = [NSString stringWithFormat:@"型号 %@",model.GoodsModelName];
            }
            else
            {
                self.goodtype.hidden = YES;
            }
        }
        
        self.goodPrice.text = [NSString stringWithFormat:@"￥ %0.2f",model.GoodsPrice.floatValue];
        self.goodNum.text = [NSString stringWithFormat:@"x %@",model.GoodsNumber];
        
    }
}
@end
