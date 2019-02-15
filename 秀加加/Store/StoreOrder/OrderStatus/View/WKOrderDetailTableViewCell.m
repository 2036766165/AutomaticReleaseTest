//
//  WKOrderDetailTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderDetailTableViewCell.h"
#import "WKPlayTool.h"
#import "WKOrderDetailModel.h"

@interface WKOrderDetailTableViewCell()

@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UILabel *content;

@property (nonatomic,strong) UILabel *money;

@property (nonatomic,strong) UILabel *number;

@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) UIImageView *backBtn;

@property (nonatomic,assign) BOOL isPlaying;

@property (nonatomic,strong) NSTimer *playAnimationTimer;

@property (nonatomic,strong) NSMutableArray *playAnimationArr;

@property (nonatomic,strong) WKOrderDetailModel *model;

@end


@implementation WKOrderDetailTableViewCell


-(void)setItem:(WKOrderProducts *)item  model:(WKOrderDetailModel *)model type:(NSInteger)type
{
    if (_model != model) {
        _model = model;
    }
    if(type == 1)
    {
        [self.headImgaeView sd_setImageWithURL:[NSURL URLWithString:item.GoodsPicUrl] placeholderImage:[UIImage imageNamed:@"default_05"]];
        self.title.text = item.GoodsName;
        if([item.GoodsModelName isEqualToString:@""])
        {
            self.content.text = @"";
        }
        else
        {
            self.content.text = [NSString stringWithFormat:@"型号:%@",item.GoodsModelName];
        }
        self.money.text = [NSString stringWithFormat:@"￥%.2f",[item.GoodsPrice floatValue]];
        self.number.text = [NSString stringWithFormat:@"X%ld",(long)item.GoodsNumber];
    }
    else if(type == 2)
    {
        if(item.GoodsModelCode == 0)//代表是语音
        {
            self.headImgaeView.image = [UIImage imageNamed:@"8luyin"];
            UITapGestureRecognizer *headGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioGesture)];
            [self.headImgaeView addGestureRecognizer:headGesture];
            self.playBtn.hidden = false;
            self.backBtn.hidden = false;
            
        }else{
            [self.headImgaeView sd_setImageWithURL:[NSURL URLWithString:item.GoodsPicUrl] placeholderImage:[UIImage imageNamed:@"default_05"]];
        }

        self.content.text = [NSString stringWithFormat:@"起拍价 ￥%.2f  竞拍成功",[item.GoodsStartPrice floatValue]];
        self.title.text = item.GoodsName;
        self.money.text = [NSString stringWithFormat:@"成交价￥%.2f",[item.GoodsPrice floatValue]];
        self.number.text = [NSString stringWithFormat:@"X%ld",(long)item.GoodsNumber];
        self.number.userInteractionEnabled = NO;
    }
    else if(type == 6)
    {
        if(item.GoodsModelCode == 0)//代表是语音
        {
            self.headImgaeView.image = [UIImage imageNamed:@"8luyin"];
            UITapGestureRecognizer *headGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioGesture)];
            [self.headImgaeView addGestureRecognizer:headGesture];
            self.playBtn.hidden = false;
            self.backBtn.hidden = false;
            
        }else{
            [self.headImgaeView sd_setImageWithURL:[NSURL URLWithString:item.GoodsPicUrl] placeholderImage:[UIImage imageNamed:@"default_05"]];
        }
        
        self.content.text = [NSString stringWithFormat:@"商品金额 ￥%.2f  幸运降临",[item.GoodsPrice floatValue]];
        self.title.text = item.GoodsName;
        self.money.text = [NSString stringWithFormat:@"幸运价￥%.2f",[item.GoodsStartPrice floatValue]];
        self.number.text = [NSString stringWithFormat:@"X%ld",(long)item.GoodsNumber];
        self.number.userInteractionEnabled = NO;
    }
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
    self.isPlaying = NO;
    self.playAnimationArr = [NSMutableArray new];
    self.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
    for (int i = 1 ; i < 15 ; i++) {
        [self.playAnimationArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%dluyin",i]]];
    }
    
    UIImage *headImage = [UIImage imageNamed:@"default_05"];
    UIImageView *headImgaeView = [[UIImageView alloc] init];
    headImgaeView.image = headImage;
    headImgaeView.animationDuration = 5;
    headImgaeView.animationImages = self.playAnimationArr;
    headImgaeView.clipsToBounds = YES;
    headImgaeView.userInteractionEnabled = YES;
    headImgaeView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImgaeView = headImgaeView;
    [self addSubview:headImgaeView];
    [headImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((85-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    UIImageView *backIm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backYuan"]];
    backIm.hidden = true;
    [self.headImgaeView addSubview:backIm];
    self.backBtn = backIm;
    backIm.userInteractionEnabled = YES;
    [backIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(15);
        make.right.bottom.mas_offset(-15);
    }];
    
    UIButton *playBtn = [[UIButton alloc]init];
    playBtn.hidden = true;
    [playBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
    self.playBtn = playBtn;
    playBtn.userInteractionEnabled = NO;
    [headImgaeView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:12];
    title.textAlignment = NSTextAlignmentLeft;
    title.numberOfLines = 0;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    title.text = @" qwer6tyuiodfghjgqwertyuio321`12345u7iouytrewqqweg";
    title.textColor = [UIColor colorWithHex:0x7e879d];
    self.title = title;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(headImgaeView).offset(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-headImage.size.width-30, 20));
    }];
    
    UILabel *content = [[UILabel alloc] init];
    content.font = [UIFont systemFontOfSize:12];
    content.textAlignment = NSTextAlignmentLeft;
    content.text = @"商品型号 棕色 37码";
    content.textColor = [UIColor colorWithHex:0xBFC3CB];
    self.content = content;
    [self addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(title.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-headImage.size.width-30, 20));
    }];
    
    UILabel *money = [[UILabel alloc] init];
    money.font = [UIFont systemFontOfSize:12];
    money.textAlignment = NSTextAlignmentLeft;
    money.text = @"￥188.00";
    money.textColor = [UIColor colorWithHex:0x7e879d];
    self.money = money;
    [self addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(content.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *number = [[UILabel alloc] init];
    number.font = [UIFont systemFontOfSize:12];
    number.textAlignment = NSTextAlignmentRight;
    number.text = @"X 1";
    number.textColor = [UIColor colorWithHex:0xBFC3CB];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editEvent)];
    [self addGestureRecognizer:gesture];
    self.number = number;
    [self addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(content.mas_bottom).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(40, 20));
    }];
}

-(void)editEvent
{
    if(_selectType)
    {
        _selectType(3);
    }
}

-(void)audioGesture
{
    if (!self.isPlaying) {
        //[PlayerManager sharedManager].delegate = nil;
        NSString *audioStr = ((WKOrderProducts*)self.model.Products[0]).GoodsPicUrl;
        [self.playBtn setImage:[UIImage imageNamed:@"kuai"] forState:UIControlStateNormal];
//        NSString *path = [WKPlayTool writeFileWithStr:audioStr];
        [WKPlayTool writeFileWithStr:audioStr :^(NSString *voicePath, NSString *requestMessage) {
            if ([requestMessage isEqualToString:@"写入成功"]) {
                [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:self];
                [self.headImgaeView startAnimating];
                self.isPlaying = YES;
            }else{
                NSLog(@"%@",requestMessage);
            }
        }];
    }else{
        [[PlayerManager sharedManager] stopPlaying];
    }
}

#pragma mark  playDelegate
- (void)playingStoped {
    self.isPlaying = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headImgaeView stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
    });
}
@end
