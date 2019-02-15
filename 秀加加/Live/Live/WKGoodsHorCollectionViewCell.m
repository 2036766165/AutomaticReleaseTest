//
//  WKGoodsHorCollectionViewCell.m
//  秀加加
//  标题：直播页商品列表
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsHorCollectionViewCell.h"
#import "WKGoodsModel.h"
#import <QuartzCore/QuartzCore.h>

@interface WKGoodsHorCollectionViewCell (){
    WKGoodsLayoutType _type;
    WKGoodsListItem *_tempMd;
}

//第一种情况
//@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *name;                // 名字
@property (nonatomic,strong) UILabel *value;               // 价格
@property (nonatomic,strong) UIImageView *iconImageView;   // 图片
@property (nonatomic,strong) UIButton *confirmBtn;         // 操作按钮
@property (nonatomic,strong) UIButton *noBtn;

@property (nonatomic,strong) UIView *bgFrame;
@property (nonatomic,assign) BOOL reommandClick;

@property (nonatomic,strong) UIImageView *outlineImageV;

@property (nonatomic,strong) UIButton *VirtualBtn;

@property (nonatomic,strong) UIImageView *officalImageV;

@end

@implementation WKGoodsHorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithHex:0x191919];
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = 4.0;
    self.contentView.clipsToBounds = YES;
    
    // out line
    UIImageView *outLineImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_list_outline"]];
    [self.contentView addSubview:outLineImageV];
    [outLineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //商品图片
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.iconImageView.layer.cornerRadius = 2.0f;
    self.iconImageView.clipsToBounds = YES;
    
    //商品名称
    self.name = [[UILabel alloc] init];
//    self.name.text = @"";
//    self.name.numberOfLines = 1;
    self.name.textColor = [UIColor whiteColor];
    self.name.font = [UIFont systemFontOfSize:16];
//    [self.name setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:self.name];
    
    //商品价格
    self.value = [[UILabel alloc] init];
    self.value.text = @"";
    self.value.textAlignment = NSTextAlignmentLeft;
    self.value.textColor = [UIColor colorWithHexString:@"#FC6620"];
    self.value.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.value];
    
    //详情按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
    btn.layer.borderWidth = 2.0;
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:btn];
    self.confirmBtn = btn;
    
    self.confirmBtn.layer.cornerRadius = 2.0;
    self.confirmBtn.clipsToBounds = YES;
    
    //详情按钮
    UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noBtn.backgroundColor = [UIColor whiteColor];
    noBtn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
    noBtn.layer.borderWidth = 1.0;
    noBtn.userInteractionEnabled = NO;
    noBtn.backgroundColor = [UIColor clearColor];
    [noBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    noBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:noBtn];
    self.noBtn = noBtn;
//    self.noBtn.layer.borderWidth = 1.0;
    self.noBtn.layer.borderColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor;
    self.noBtn.layer.cornerRadius = 2.0;
    self.noBtn.clipsToBounds = YES;
    
    UIView *bgFrameView = [[UIView alloc] init];
    bgFrameView.backgroundColor = [UIColor clearColor];
    bgFrameView.layer.borderWidth = 1.0;
    bgFrameView.layer.borderColor = [UIColor clearColor].CGColor;
    [self.contentView addSubview:bgFrameView];
    
    // whether is offical goods
    UIImageView *officeImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"isOffical"]];
    self.officalImageV = officeImageV;
    [self.contentView addSubview:self.officalImageV];
    
    [self.officalImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_offset(2);
        make.size.mas_offset(self.officalImageV.image.size);
    }];
    
    self.bgFrame = bgFrameView;
    
    self.recommand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_recommended"]];
    self.recommand.layer.cornerRadius = 4.0;
    self.recommand.layer.masksToBounds = YES;
    [self.bgFrame addSubview:self.recommand];
    
    self.recordView = [[WKLiveRecordingView alloc]init];
    self.recordView.hidden = YES;
    [self.contentView addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.VirtualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.VirtualBtn setTitle:@"虚拟" forState:UIControlStateNormal];
    self.VirtualBtn.layer.cornerRadius = 15;
    self.VirtualBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.VirtualBtn.layer.borderWidth = 1.0;
    self.VirtualBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.VirtualBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.VirtualBtn];
    
    [self.VirtualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.size.mas_offset(CGSizeMake(40, 30));
    }];
}

#pragma mark - 横竖屏布局
- (void)layoutVerticalUI{
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.height.mas_offset(self.contentView.bounds.size.height * 0.75);
    }];
    
    [self.name mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(3 * WKScaleH);
        make.left.equalTo(self.iconImageView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_greaterThanOrEqualTo(20*WKScaleW);
    }];
    
    [self.noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        make.size.mas_equalTo(CGSizeMake(50*WKScaleW, 30*WKScaleW));
    }];
    
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.left.mas_equalTo(self.noBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(50*WKScaleW, 30*WKScaleW));
    }];
    
    [self.value mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left).offset(0);
        make.centerY.equalTo(self.confirmBtn.mas_centerY);
        make.right.mas_equalTo(self.confirmBtn.mas_left).offset(-5);
        make.height.mas_offset(15);
    }];
    
    
    [self.recommand mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.bgFrame.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(86, 70));
    }];
    
    [self.bgFrame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setModel:(id)model type:(WKGoodsLayoutType)type clientType:(WKClientType)clientType{
    _tempMd = model;
    _type = type;
    self.bgFrame.backgroundColor = [UIColor clearColor];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_tempMd.PicUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.name.text = _tempMd.GoodsName;
    
    self.officalImageV.hidden = !_tempMd.IsOfficial;
    NSString *str = [NSString stringWithFormat:@"￥%0.2f",[_tempMd.Price floatValue]];
    
    self.value.text = str;
    self.value.textColor = [UIColor redColor];
    self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.noBtn setTitle:[NSString stringWithFormat:@"%@号",_tempMd.Sort] forState:UIControlStateNormal];
    
    if (_tempMd.IsVirtual) {
        self.VirtualBtn.hidden = NO;
    }else{
        self.VirtualBtn.hidden = YES;
    }
    
    if (clientType == WKClientTypePushFlow) {
        self.confirmBtn.hidden = YES;
        self.noBtn.hidden = YES;
    }else{
        self.confirmBtn.hidden = NO;
        self.noBtn.hidden = NO;
    }
    
    if (!_tempMd.IsAuction) {
        // 商品
        NSString *titleStr = clientType == WKClientTypePlay?@"详情":@"推荐";
        [self.confirmBtn setTitle:titleStr forState:UIControlStateNormal];
        
        if (!_tempMd.IsRecommend) {
            self.bgFrame.hidden = YES;
        }else{
            self.bgFrame.hidden = NO;
            [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
        }
        
    }else{
        // 拍卖品
        self.confirmBtn.hidden = NO;
        self.recommand.hidden = YES;
        self.bgFrame.hidden = YES;
        
//        self.bgView.layer.borderWidth = 0.0f;
//        self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.confirmBtn setTitle:@"拍卖" forState:UIControlStateNormal];
    }
    
    if (_type == WKGoodsLayoutTypeHoriztal) {
        //[self layoutHoriztalUI];
    }else{
        [self layoutVerticalUI];
    }
}
@end
