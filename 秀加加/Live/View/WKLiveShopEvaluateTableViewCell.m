//
//  WKLiveShopEvaluateTableViewCell.m
//  秀加加
//  标题：直播 商品评价 竖屏
//  Created by lin on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopEvaluateTableViewCell.h"
#import "NSString+Size.h"
#import "UIImage+Gif.h"
#import "WKPlayTool.h"
#import "PlayerManager.h"
#import "NSObject+WKImagePicker.h"

@interface WKLiveShopEvaluateTableViewCell(){
    WKLiveShopCommentModelItem *_item;
}

@property (nonatomic,strong) UIView *backGroundView ;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *commetTime;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *colourName;
@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *audioTime;
@property (nonatomic,strong) UILabel *replyContent;
@property (nonatomic,strong) UILabel *replyTime;
@property (nonatomic,strong) UIButton *evaBtn;
@property (nonatomic,strong) UILabel *evaName;
@property (nonatomic,strong) UILabel *eva;
@property (nonatomic,strong) UIImage *evaImage;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UIImage *audioNo;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,strong) UIView *endView;
@property (nonatomic,strong) UILabel *replyName;
@property (nonatomic,strong) UIView *xianView;
@property (nonatomic,assign) BOOL ClickAudio;
@property (nonatomic,strong) UIImageView *showBuyGoodsView;//晒单图片
@property (nonatomic,strong) UILabel *showBuyGoodsNum; //晒单数量
@property (nonatomic,strong) UIButton *audioBtn; //语音播放按钮
@property (nonatomic,assign) CGFloat voiceWidth; //语音的宽度
@property (nonatomic,assign) CGFloat headH; //昵称一行的高度
@property (nonatomic,assign) CGFloat bodyH; //中间一行的高度
@property (nonatomic,assign) CGFloat footH; //主播回复一行的高度
@property (nonatomic,strong) NSMutableArray *starRedArr; //红星数量集合

@end

@implementation WKLiveShopEvaluateTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubView];
    }
    return self;
}

-(void)addSubView
{
    self.ClickAudio = YES;
    self.starRedArr = @[].mutableCopy;
    
    self.evaImage = [UIImage imageNamed:@"audioBg"];
    self.audioNo = [UIImage imageNamed:@"audiono"];
    
    UIView *backGroundView = [[UIView alloc] init];
    self.backGroundView = backGroundView;
    [self addSubview:backGroundView];
    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.headH = 70 ;
    self.bodyH = 120 ;
    self.footH = 95 ;
    self.voiceWidth = WKScreenW > WKScreenH ? WKScreenW * 0.5 * 0.3 : WKScreenW * 0.3;
    
    //用户头像
    UIImageView *headImgView = [[UIImageView alloc] init];
    self.headImgView = headImgView;
    [backGroundView addSubview:headImgView];
    
    //昵称
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = [UIColor colorWithHex:0xCACCD1];
    self.name = name;
    [backGroundView addSubview:name];
    
    //评论时间
    UILabel *commetTime = [[UILabel alloc] init];
    commetTime.textAlignment = NSTextAlignmentRight;
    commetTime.font = [UIFont systemFontOfSize:14];
    commetTime.textColor = [UIColor colorWithHex:0xCACCD1];
    self.commetTime = commetTime;
    [backGroundView addSubview:commetTime];
    
    //线
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHex:0xE7E7E9];
    self.xianView = xianView;
    [backGroundView addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(self.headH);
        make.height.mas_equalTo(1);
    }];
    
    //评分
    UILabel *eva = [[UILabel alloc] init];
    eva.font = [UIFont systemFontOfSize:12];
    eva.text = @"评分: ";
    eva.textColor = [UIColor colorWithHex:0x9E9FA4];
    eva.textAlignment = NSTextAlignmentLeft;
    self.eva = eva;
    [backGroundView addSubview:eva];
    [eva mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(xianView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 13));
    }];
    
    //评分的灰色星星
    for (int i = 0 ; i < 5; i++)
    {
        UIImage *huiImage = [UIImage imageNamed:@"huixing"];
        UIButton *huiBtn = [[UIButton alloc] init];
        [huiBtn setBackgroundImage:huiImage forState:UIControlStateNormal];
        huiBtn.adjustsImageWhenHighlighted = NO;
        [backGroundView addSubview:huiBtn];
        [huiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(eva.mas_right).offset((20)*i+5);
            make.top.equalTo(xianView.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }

    //评分的红色星星
    for (int i = 0 ; i < 5; i++)
    {
        UIImage *redImage = [UIImage imageNamed:@"honhxing"];
        UIButton *redBtn = [[UIButton alloc] init];
        [redBtn setBackgroundImage:redImage forState:UIControlStateNormal];
        redBtn.adjustsImageWhenHighlighted = NO;
        redBtn.hidden = YES;
        [self.backGroundView addSubview:redBtn];
        [self.starRedArr addObject:redBtn];
        [redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.eva.mas_right).offset((20)*i+5);
            make.top.equalTo(self.xianView.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    
    //评价
    UILabel *evaName = [[UILabel alloc] init];
    evaName.font = [UIFont systemFontOfSize:12];
    evaName.text = @"评价: ";
    evaName.textColor = [UIColor colorWithHex:0x9E9FA4];
    evaName.textAlignment = NSTextAlignmentLeft;
    self.evaName = evaName;
    [backGroundView addSubview:evaName];
    [evaName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(eva.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 13));
    }];
    
    //评价图标
    UIButton *evaBtn = [[UIButton alloc] init];
    evaBtn.titleLabel.textColor = [UIColor clearColor];
    evaBtn.tag = ClickLiveShopAudioType ;
    [evaBtn addTarget:self action:@selector(evaEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.evaBtn = evaBtn;
    [backGroundView addSubview:evaBtn];
    
    //评价语音图标
    UIButton *audioBtn = [[UIButton alloc] init];
    audioBtn.tag = 100001;
    [audioBtn setImage:self.audioNo forState:UIControlStateNormal];
    [evaBtn addSubview:audioBtn];
    self.audioBtn = audioBtn;
    
    //评价语音内容
    UILabel *content = [[UILabel alloc] init];
    content.font = [UIFont systemFontOfSize:14];
    content.textColor = [UIColor colorWithHex:0xC4C9D3];
    content.textAlignment = NSTextAlignmentLeft;
    self.content = content;
    [evaBtn addSubview:content];
    
    //语音时长
    UILabel *audioTime = [[UILabel alloc] init];
    audioTime.font = [UIFont systemFontOfSize:14];
    audioTime.textColor = [UIColor colorWithHex:0xBFC0C6];
    audioTime.textAlignment = NSTextAlignmentLeft;
    self.audioTime = audioTime;
    [backGroundView addSubview:audioTime];
    
    //型号
    UILabel *colourName = [[UILabel alloc] init];
    colourName.font = [UIFont systemFontOfSize:12];
    colourName.textColor = [UIColor colorWithHex:0x9E9FA4];
    colourName.textAlignment = NSTextAlignmentLeft;
    self.colourName = colourName;
    [backGroundView addSubview:colourName];
    
    //晒单图片
    UIImageView *showBuyGoodsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopLiveZan"]];
    showBuyGoodsView.userInteractionEnabled = YES;
    showBuyGoodsView.clipsToBounds = YES;
    showBuyGoodsView.contentMode = UIViewContentModeScaleAspectFill;
    showBuyGoodsView.tag = ClickLiveShopPicType;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopGesture:)];
    [showBuyGoodsView addGestureRecognizer:gesture];
    showBuyGoodsView.hidden = YES;
    [self.backGroundView addSubview:showBuyGoodsView];
    self.showBuyGoodsView = showBuyGoodsView;
    
    //图片右上角的数量标志
    UILabel *showBuyGoodsNum = [UILabel new];
    showBuyGoodsNum.backgroundColor = [UIColor redColor];
    showBuyGoodsNum.textColor = [UIColor whiteColor];
    showBuyGoodsNum.textAlignment = NSTextAlignmentCenter;
    showBuyGoodsNum.layer.cornerRadius = 15/2;
    showBuyGoodsNum.clipsToBounds = YES;
    showBuyGoodsNum.font = [UIFont systemFontOfSize:10.0];
    showBuyGoodsNum.hidden = YES;
    [self.backGroundView addSubview:showBuyGoodsNum];
    self.showBuyGoodsNum = showBuyGoodsNum;
    
    #pragma 下面的是回复的内容
    UIView *endView = [[UIView alloc] init];
    endView.backgroundColor = [UIColor colorWithHex:0xEEF2FB];
    endView.hidden = YES;
    self.endView = endView;
    [backGroundView addSubview:endView];
    
    UIView *downView = [[UIView alloc] init];
    downView.backgroundColor = [UIColor colorWithHex:0xEEF2FB];
    self.downView = downView;
    [backGroundView addSubview:downView];
    
    UILabel *replyName = [[UILabel alloc] init];
    replyName.font = [UIFont systemFontOfSize:13];
    replyName.text = @"主播回复";
    replyName.textColor = [UIColor colorWithHex:0x9EA4AF];
    replyName.textAlignment = NSTextAlignmentLeft;
    self.replyName = replyName;
    [downView addSubview:replyName];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView = whiteView;
    [downView addSubview:whiteView];

    //回复信息
    UIButton *replyBtn = [[UIButton alloc] init];
    replyBtn.titleLabel.textColor = [UIColor clearColor];
    replyBtn.tag = ClickLiveShopReplyAudioType;
    self.replyBtn = replyBtn;
    [replyBtn addTarget:self action:@selector(evaEvent:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:replyBtn];
    
    //回复喇叭
    UIButton *replyHornBtn = [[UIButton alloc] init];
    [replyHornBtn setImage:self.audioNo forState:UIControlStateNormal];
    replyHornBtn.tag = 100002;
    self.replyHornBtn = replyHornBtn;
    [replyBtn addSubview:replyHornBtn];

    //回复内容
    UILabel *replyContent = [[UILabel alloc] init];
    replyContent.font = [UIFont systemFontOfSize:14];
    replyContent.textColor = [UIColor colorWithHex:0xB4B6C2];
    replyContent.textAlignment = NSTextAlignmentLeft;
    self.replyContent = replyContent;
    [replyBtn addSubview:replyContent];
    
    //回复时间
    UILabel *replyTime = [[UILabel alloc] init];
    replyTime.font = [UIFont systemFontOfSize:14];
    replyTime.textColor = [UIColor colorWithHex:0x7D889D];
    self.replyTime = replyTime;
    [replyBtn addSubview:replyTime];
    
    [self layoutUI];
}

- (void)layoutUI
{
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((self.headH - 50)/2);
        make.size.mas_equalTo(CGSizeMake(50,50));
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(WKScreenW - 50 - 80 - 40, 20));
    }];
    
    [self.commetTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.headImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    
    [self.evaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.evaName.mas_right).offset(0);
        make.centerY.equalTo(self.evaName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.voiceWidth + self.audioNo.size.width, self.evaImage.size.height));
    }];
    
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.evaBtn).offset(10);
        make.top.equalTo(self.evaBtn).offset((self.evaImage.size.height-self.audioNo.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(self.audioNo.size.width, self.audioNo.size.height));
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.audioBtn.mas_right).offset(5);
        make.right.equalTo(self.evaBtn.mas_right).offset(-5);
        make.centerY.equalTo(self.audioBtn.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    [self.audioTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.evaBtn.mas_right).offset(5);
        make.centerY.equalTo(self.audioBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    
    [self.colourName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.evaBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 13));
    }];
    
    [self.showBuyGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.xianView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.showBuyGoodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.showBuyGoodsView.mas_right).offset(-4);
        make.centerY.mas_equalTo(self.showBuyGoodsView.mas_top).offset(4);
        make.size.mas_offset(CGSizeMake(15, 15));
    }];
    
    [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(self.headH + self.bodyH);
        make.height.mas_equalTo(10);
    }];
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(self.headH + self.bodyH);
        make.height.mas_equalTo(self.footH);
    }];
    
    [self.replyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView).offset(10);
        make.top.equalTo(self.downView).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView).offset(0);
        make.right.equalTo(self.downView.mas_right).offset(0);
        make.top.equalTo(self.replyName.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView).offset(20);
        make.top.equalTo(self.whiteView).offset((50-self.evaImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(self.voiceWidth + self.audioNo.size.width, self.evaImage.size.height));
    }];
    
    [self.replyHornBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyBtn).offset(10);
        make.centerY.equalTo(self.replyBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.audioNo.size.width, self.audioNo.size.height));
    }];
    
    [self.replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyHornBtn.mas_right).offset(10);
        make.right.equalTo(self.replyBtn.mas_right).offset(-10);
        make.centerY.equalTo(self.replyHornBtn.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    [self.replyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyBtn.mas_right).offset(5);
        make.centerY.equalTo(self.replyContent.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
}

-(void)setModelItem:(WKLiveShopCommentModelItem *)modelItem setRowIndex:(NSInteger)rowIndex
{
    _item = modelItem;
    
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:modelItem.MemberPhotoUrl] placeholderImage:[[UIImage imageNamed:@"default_08"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //昵称
    self.name.text = modelItem.MemberName;
    
    //评论时间
    NSString *timeStr = @"";
    if(modelItem.CreateTime.length > 10)
    {
        timeStr = [modelItem.CreateTime substringToIndex:10];
    }
    self.commetTime.text = timeStr;
    
    //星评
    for (int i = 0 ; i < modelItem.Score; i++)
    {
        UIButton *btn = self.starRedArr[i];
        btn.hidden = NO;
    }
    
    //语音背景图片
    [self.evaBtn setBackgroundImage:self.evaImage forState:UIControlStateNormal];
    self.evaBtn.titleLabel.text = [NSString stringWithFormat:@"%ld_%@",(long)rowIndex,@"eva"];
    
    //评论内容
    self.content.text = modelItem.ContentBrief;
    
    //语音时长
    self.audioTime.text = [NSString stringWithFormat:@"%ld\"",(long)modelItem.ContentDuration];
    
    //型号
    self.colourName.text = modelItem.ModelName;
    
    //晒单图片
    if(modelItem.PicUrls.count > 0)
    {
        [self.showBuyGoodsView sd_setImageWithURL:[NSURL URLWithString:modelItem.PicUrls[0]] placeholderImage:[UIImage imageNamed:@"shopLiveZan"]];
        self.showBuyGoodsView.hidden = NO;
    }
    else
    {
        self.showBuyGoodsView.hidden = YES;
    }
    
    if(modelItem.PicUrls.count > 1)
    {
        self.showBuyGoodsNum.text = [NSString stringWithFormat:@"%zd",modelItem.PicUrls.count];
        self.showBuyGoodsNum.hidden = NO;
    }
    else
    {
        self.showBuyGoodsNum.hidden = YES;
    }
    
    //回复背景图
    [self.replyBtn setBackgroundImage:self.evaImage forState:UIControlStateNormal];
    self.replyBtn.titleLabel.text = [NSString stringWithFormat:@"%ld_%@",(long)rowIndex,@"reply"];
    
    //回复的内容
    self.replyContent.text = modelItem.ReplyBrief;
    
    //回复时长
    self.replyTime.text = [NSString stringWithFormat:@"%ld\"",(long)modelItem.ReplyDuration];
    
    //判断是否有主播回复
    if(modelItem.Reply.length == 0)
    {
        self.downView.hidden = YES;
        self.endView.hidden = NO;
    }
    else
    {
        self.downView.hidden = NO;
        self.endView.hidden = YES;
    }
    
    [self layoutUI];
}

-(void)shopGesture:(UITapGestureRecognizer *)gesture
{
    if(gesture.view.tag == ClickLiveShopPicType)
    {
        _clickLiveShopType(ClickLiveShopPicType);
    }
}

//评分等级和点击语音的回调
-(void)evaEvent:(UIButton*)sender
{
//    if(sender.tag == ClickLiveShopXinType)//星星
//    {
//        _clickLiveShopType(ClickLiveShopXinType);
//    }
    
    self.listenBlock(sender);
}

@end
