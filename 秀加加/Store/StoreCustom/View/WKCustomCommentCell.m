//
//  WKCustomCommentTableViewCell.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKCustomCommentCell.h"
#import "PlayerManager.h"
#import "WKPlayTool.h"
#import "UIImage+Gif.h"

@interface WKCustomCommentCell ()<PlayingDelegate>

@property (strong, nonatomic) UIButton * headImageBtn;

@property (strong, nonatomic) UILabel * timeLabel;

@property (strong, nonatomic) UILabel * goodsName;

@property (strong, nonatomic) UILabel * biddingPrice;

@property (strong, nonatomic) UILabel * priceLabel;

@property (strong, nonatomic) UIButton * playBtn;

@property (strong, nonatomic) UILabel * playTimeLabel;

@property (strong, nonatomic) UILabel *storeLabel;

@property (strong, nonatomic) UIView *lineView;

@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) NSMutableArray * starArr;

@end

@implementation WKCustomCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    self.backgroundColor = [UIColor whiteColor];
    self.starArr = [NSMutableArray new];
    self.headImageBtn = [[UIButton alloc]init];
    self.headImageBtn.layer.borderColor = [UIColor colorWithHexString:@"f3f6ff"].CGColor;
    self.headImageBtn.layer.borderWidth = 1;
    self.headImageBtn.layer.cornerRadius = 3;
    self.headImageBtn.layer.masksToBounds = YES;
    [self.headImageBtn setImage:[UIImage imageNamed:@"zanwu@2x_03"] forState:UIControlStateNormal];
    [self.headImageBtn addTarget:self action:@selector(headImageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.headImageBtn];
    [self.headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(15);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor orangeColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"0''";
    [self.headImageBtn addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_offset(5);
        make.size.sizeOffset(CGSizeMake(30, 13));
    }];
    
    self.goodsName = [[UILabel alloc]init];
    self.goodsName.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.goodsName.font = [UIFont systemFontOfSize:12];
    self.goodsName.numberOfLines = 0;
    self.goodsName.text = @"快捷商品";
    [self.contentView addSubview:self.goodsName];
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageBtn.mas_right).offset(10);
        make.top.equalTo(self.headImageBtn.mas_top).offset(2);
        make.right.mas_offset(10);
        make.height.mas_lessThanOrEqualTo(30);
    }];
    
    self.biddingPrice = [[UILabel alloc]init];
    self.biddingPrice.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.biddingPrice.font = [UIFont systemFontOfSize:11];
    self.biddingPrice.text = @"起拍价 ¥0.00";
    [self.contentView addSubview:self.biddingPrice];
    [self.biddingPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageBtn.mas_right).offset(10);
        make.top.equalTo(self.goodsName.mas_bottom).offset(6);
        make.right.mas_offset(10);
        make.height.mas_offset(14);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.priceLabel.font = [UIFont systemFontOfSize:11];
    self.priceLabel.text = @"¥ 0.00";
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageBtn.mas_right).offset(10);
        make.top.equalTo(self.biddingPrice.mas_bottom).offset(6);
        make.right.mas_offset(10);
        make.height.mas_offset(14);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.equalTo(self.headImageBtn.mas_bottom).offset(15);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 1));
    }];
    
    self.storeLabel = [[UILabel alloc]init];
    self.storeLabel.text = @"评分: ";
    self.storeLabel.font = [UIFont systemFontOfSize:11];
    self.storeLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [self.contentView addSubview:self.storeLabel];
    [self.storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_offset(12);
    }];
    
    UILabel *commentLabel = [[UILabel alloc]init];
    commentLabel.text = @"评价: ";
    commentLabel.font = [UIFont systemFontOfSize:11];
    commentLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [self.contentView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.equalTo(self.storeLabel.mas_bottom).offset(15);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_offset(12);
    }];
    
    self.playBtn = [[UIButton alloc]init];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playKuang"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentLabel.mas_right).offset(5);
        make.top.equalTo(self.storeLabel.mas_bottom).offset(10);
        make.width.mas_offset(160);
        make.height.mas_offset(35);
    }];
    
    self.playTimeLabel = [[UILabel alloc]init];
    self.playTimeLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.playTimeLabel.text = @"0''";
    self.playTimeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.playTimeLabel];
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 13));
    }];
    
    self.playIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"laba"]];
    self.playIM.tag = 11;
    [self.playBtn addSubview:self.playIM];
    [self.playIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(10, 15));
    }];
    
    self.playLabel = [[UILabel alloc]init];
    self.playLabel.text = @"店家人特别细心,所得税法法师的";
    self.playLabel.tag = 10;
    self.playLabel.font = [UIFont systemFontOfSize:12];
    self.playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [self.playBtn addSubview:self.playLabel];
    [self.playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playIM.mas_right).offset(5);
        make.centerY.mas_offset(0);
        make.right.equalTo(self.playBtn.mas_right).offset(-5);
        make.height.mas_offset(13);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti) name:@"PlayVoice" object:nil];
}
-(void)noti{
    self.playIM.image = [UIImage imageNamed:@"laba"];
    self.playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
}

-(void)playBtnAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FootPlay" object:nil];
    if ( ! self.isPlaying) {
//        NSString *path = [WKPlayTool writeFileWithStr:self.model.Content];
        [WKPlayTool writeFileWithStr:self.model.Content :^(NSString *voicePath, NSString *requestMessage) {
            if ([requestMessage isEqualToString:@"写入成功"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PlayVoice" object:nil userInfo:@{@"orderCode":self.model.OrderCode}];
                [PlayerManager sharedManager].delegate = nil;
                self.isPlaying = YES;
                [[NSUserDefaults standardUserDefaults] setObject:self.model.OrderCode forKey:@"playCord"];
                [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:self];
                NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"liveStatus" ofType:@"gif"];
                UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gitPath]];
                self.playIM.image = image;
                self.playLabel.textColor = [UIColor orangeColor];
            }else{
                NSLog(@"%@",requestMessage);
            }
        }];
    }else{
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
        self.playIM.image = [UIImage imageNamed:@"laba"];
        self.playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    }
}
- (void)playingStoped {
   self.isPlaying = NO;
    [PlayerManager sharedManager].delegate = nil;
    self.playIM.image = [UIImage imageNamed:@"laba"];
    self.playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [[NSUserDefaults standardUserDefaults] setObject:@""forKey:@"playCord"];
}

-(void)setModel:(WKCustomCommentModel *)model{
    if (_model!=model) {
        _model = model;
        //yes普通商品,no快捷商品
        BOOL goodsBool = model.GoodsCode.integerValue == 0?NO:YES;
        if (goodsBool) {
            [self.headImageBtn sd_setImageWithURL:[NSURL URLWithString:model.GoodsPicUrl] forState:UIControlStateNormal];
            self.timeLabel.hidden = goodsBool;
            self.goodsName.text = model.GoodsName;
            self.biddingPrice.hidden = goodsBool;
        }else{
            [self.headImageBtn setImage:[UIImage imageNamed:@"play01"] forState:UIControlStateNormal];
            self.timeLabel.hidden = goodsBool;
            self.timeLabel.text = [NSString stringWithFormat:@"%@''",model.ContentDuration];
            self.goodsName.text = @"快捷商品";
            self.biddingPrice.text = [NSString stringWithFormat:@"起拍价 ¥%0.2f",[model.GoodsPrice floatValue]];
            self.biddingPrice.hidden = goodsBool;
        }
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[model.GoodsPrice floatValue]];
        for (UIButton *btn in self.starArr) {
            [btn removeFromSuperview];
        }
        for (int i = 0 ; i < 5; i++) {
            UIImage *huiImage;
            if (i >= model.Score) {
                huiImage = [UIImage imageNamed:@"huixing"];
            }else{
                huiImage = [UIImage imageNamed:@"honhxing"];
            }
            UIButton *huiBtn = [[UIButton alloc] init];
            [huiBtn setBackgroundImage:huiImage forState:UIControlStateNormal];
            huiBtn.tag = i+1;
            huiBtn.adjustsImageWhenHighlighted = NO;
            [self.contentView addSubview:huiBtn];
            [huiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.storeLabel.mas_right).offset((15)*i+5);
                make.top.equalTo(self.lineView.mas_bottom).offset(14);
                make.size.mas_equalTo(CGSizeMake(12, 12));
            }];
            [self.starArr addObject:huiBtn];
        }
        self.playTimeLabel.text = [NSString stringWithFormat:@"%@''",model.ContentDuration];
        self.playLabel.text = model.ContentBrief;
        NSString *playCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playCord"];
        if ([model.OrderCode isEqualToString: playCode]){
            NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"liveStatus" ofType:@"gif"];
            UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gitPath]];
            self.playIM.image = image;
            self.playLabel.textColor = [UIColor orangeColor];
        }else{
            self.playIM.image = [UIImage imageNamed:@"laba"];
            self.playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        }
    }
}

@end






