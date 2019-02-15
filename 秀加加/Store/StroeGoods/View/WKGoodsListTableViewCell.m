//
//  WKGoodsListTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsListTableViewCell.h"
#import "WKGoodsItemProtocol.h"
#import "WKGoodsModel.h"

@interface WKGoodsListTableViewCell (){
    WKGoodsListItem *_tempModel;
}

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *salesLabel;

@property (nonatomic,strong) UILabel *stockLabel;
@property (nonatomic,strong) UIButton *groundingBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *topBtn;

@property (nonatomic,strong) UIView *cellBackgroundView;

@end

@implementation WKGoodsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setModel:(WKGoodsListItem *)md{
    _tempModel = md;
    
    //设置商品图片
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:md.PicUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
    //设置商品名称
    self.nameLabel.text = md.GoodsName;
    
    //设置商品价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f",[md.Price floatValue]];
    
    //设置库存
    self.stockLabel.text = [NSString stringWithFormat:@"库存 %@",md.Stock];
    if(md.IsVirtual)
    {
        self.stockLabel.hidden = YES;
    }
    else
    {
        self.stockLabel.hidden = NO;
    }

    //设置销量
    self.salesLabel.text = [NSString stringWithFormat:@"销量 %@",md.SaleCount];
    
    //设置上下架按钮
    [self.groundingBtn setTitle:md.IsMarketable? @" 下架" : @" 上架" forState:UIControlStateNormal];
    [self.groundingBtn setImage:[UIImage imageNamed:md.IsMarketable ? @"pro_down" : @"shangjia"] forState:UIControlStateNormal];
    
    //如果是下架操作
    if(md.IsMarketable == 0)
    {
        [self.cellBackgroundView removeFromSuperview];
        
        self.cellBackgroundView = [[UIView alloc]init];
        
        //实现遮罩
        //设置属性可以穿透
        self.cellBackgroundView.userInteractionEnabled = NO;
        self.cellBackgroundView.backgroundColor=[UIColor clearColor];
        
        //设置颜色
        self.cellBackgroundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:249/255.0 blue:255/255.0 alpha:0.5];
        
        //添加
        [self.contentView addSubview:self.cellBackgroundView];
        
        //设置大小
        [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(WKScreenW,130));
        }];

        [self.groundingBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.groundingBtn setImage:[UIImage imageNamed:@"shangjia"] forState:UIControlStateNormal];

    }
    else
    {
        [self.groundingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.cellBackgroundView removeFromSuperview];
    }
}

- (void)setupViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor lightGrayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.priceLabel];

    self.stockLabel = [UILabel new];
    self.stockLabel.textColor = [UIColor lightGrayColor];
    self.stockLabel.font = [UIFont systemFontOfSize:11];
    self.stockLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.stockLabel];

    self.salesLabel = [UILabel new];
    self.salesLabel.textColor = [UIColor lightGrayColor];
    self.salesLabel.font = [UIFont systemFontOfSize:11];
    self.salesLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.salesLabel];

    NSArray *titles = @[@" 上架",@" 分享",@" 置顶"];
    NSArray *images = @[@"",@"pro_share",@"pro_top"];
    
    UIView *btnBgView = [UIView new];
    [self.contentView addSubview:btnBgView];
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.salesLabel.mas_bottom).offset(0);
    }];
  
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.tag = 10 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:btn];
        
        if (i == 0)
        {
            self.groundingBtn = btn;
        }
        else if (i == 1)
        {
            self.shareBtn = btn; 
        }
        else
        {
            self.topBtn = btn;
        }
    }
    
    [self layoutUI];
}

- (void)layoutUI{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(self.iconImage.mas_height);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_top).offset(2);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(13);
    }];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW * 0.4, 15));
    }];

    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.size.mas_offset(CGSizeMake(WKScreenW * 0.2, 12));
    }];

    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(6);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(12);
    }];

    [self.groundingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.groundingBtn.superview.mas_bottom).offset(7);
        make.left.mas_offset(-11);
        make.size.mas_offset(CGSizeMake(60,30));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.shareBtn.superview.mas_bottom).offset(7);
        make.centerX.mas_equalTo(self.shareBtn.superview.mas_centerX);
        make.size.mas_offset(CGSizeMake(60, 30));
    }];

    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topBtn.superview.mas_bottom).offset(7);
        make.right.mas_equalTo(self.topBtn.superview.mas_right).offset(11);
        make.size.mas_offset(CGSizeMake(60, 30));
    }];
}

- (void)btnClick:(UIButton *)btn{
    WKOperateType type;
    
    if (btn.tag == 10)
    {
        // 上架
        if (_tempModel.IsMarketable)
        {
            type = WKOperateTypeDown;
        }
        else
        {
            type = WKOperateTypeUp;
        }
    }
    else if (btn.tag == 11)
    {
        type = WKOperateTypeShare; // 分享
    }
    else
    {
        type = WKOperateTypeTop; // 置顶
    }
    
    if ([_delegate respondsToSelector:@selector(operateGoods: obj:)])
    {
        [_delegate operateGoods:type obj:_tempModel];
    }
}


@end
