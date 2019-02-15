//
//  WKEvaluateView.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKEvaluateView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "NSObject+WKImagePicker.h"
#import "UIButton+MoreTouch.h"

@interface WKEvaluateView ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,RecordingDelegate, PlayingDelegate>

@property (strong, nonatomic) UIView * commentView;

@property (assign, nonatomic) CGFloat headHeight;

@property (strong, nonatomic) UILabel * voiceLabel;

@property (nonatomic, assign) BOOL isRecording;

@property (strong, nonatomic)  NSURL * url;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *filename;

@property (strong, nonatomic) AVAudioRecorder * audioRecorder;

@property (strong, nonatomic) AVAudioPlayer * audioPlayer;

@property (assign, nonatomic) NSInteger voiceTime;

@property (strong, nonatomic) NSTimer * timer;

@property (strong, nonatomic) UIButton *recordingBtn;

@property (strong, nonatomic) UIButton * rerecordingBtn;

@property (strong, nonatomic) UIImageView * lineAnimaIM;

@property (strong, nonatomic) NSTimer * animationTimer;

@property (strong, nonatomic) UIImageView * recoredingIM;

@property (strong, nonatomic) UILabel * timeLongLabel;

@property (strong, nonatomic) NSTimer * playTimer;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) NSMutableArray * picArr;

@property (strong, nonatomic) NSMutableArray * picIMArr;

@property (strong, nonatomic) NSTimer * playAnimation;

@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) NSInteger time;

@end

@implementation WKEvaluateView

-(instancetype)initWithFrame:(CGRect)frame andModel:(WKEvaluateTableModel *)model
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
        self.model = model;
        self.voiceTime = 0;
        self.picArr = [NSMutableArray new];
        self.starArr = [NSMutableArray new];
        self.picIMArr = [NSMutableArray new];
        [self addSubView];
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 5;
        [self redEvent:btn];
    }
    return self;
}

-(void)addSubView
{
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headView];

    UIImage *headimage = [UIImage imageNamed:@"default_06"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = headimage;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.GoodsPicUrl] placeholderImage:headimage];
    headImageView.layer.cornerRadius = 5.0;
    headImageView.layer.masksToBounds = YES;
    [self.headView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(10);
        make.top.equalTo(self.headView).offset(10);
        make.size.mas_equalTo(CGSizeMake(headimage.size.width, headimage.size.height));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"虚拟";
    label.alpha = self.model.IsVirtual == 1?1:0;
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    [headImageView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(16);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:14];
    title.text = self.model.GoodsName;
    title.textColor = [UIColor colorWithHexString:@"7e879d"];
//    title.numberOfLines = 0;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    [self.headView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.top.equalTo(headImageView).offset(0);
        make.width.mas_equalTo(WKScreenW-headimage.size.width-30);
        make.height.mas_greaterThanOrEqualTo(20);
        
    }];
    
    UILabel *content = [[UILabel alloc] init];
    if ([self.model.GoodsStartPrice integerValue]>0) {
        content.text = [NSString stringWithFormat:@"起拍价 ￥ %0.2f  竞拍成功",self.model.GoodsStartPrice.floatValue];
    }else{
        if( self.model.GoodsModelName.length < 1)
        {
            content.text = [NSString stringWithFormat:@"数量：%ld",(long)self.model.GoodsNumber];
        }
        else
        {
            content.text = [NSString stringWithFormat:@"型号：%@  数量：%ld",self.model.GoodsModelName,(long)self.model.GoodsNumber];
        }
    }
    if (self.model.type == 6) {
        content.text = [NSString stringWithFormat:@"商品金额 ¥ %ld 幸运降临",(long)self.model.GoodsNumber];
    }
    content.font = [UIFont systemFontOfSize:12];
    content.textColor = [UIColor colorWithHex:0xA4AAB9];
    content.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.top.equalTo(title.mas_bottom).offset(15);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(WKScreenW-headimage.size.width-30, 13));
    }];
    
    UILabel *money = [[UILabel alloc] init];
    NSString *moneyStr;
    if (self.model.GoodsStartPrice.integerValue > 0) {
        moneyStr = [NSString stringWithFormat:@"成交价 ￥ %.2f",[self.model.GoodsPrice floatValue]];
    }else{
        moneyStr = [NSString stringWithFormat:@"￥ %.2f",[self.model.GoodsPrice floatValue]];
    }
    if (self.model.type == 6) {
        moneyStr = [NSString stringWithFormat:@"幸运价 ¥ %0.2f",[self.model.GoodsPrice floatValue]];;
    }
    money.text = moneyStr;
    money.font = [UIFont systemFontOfSize:12];
    money.textColor = [UIColor colorWithHex:0xA4AAB9];
    money.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.bottom.equalTo(headImageView).offset(0);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(100, 13));
    }];
    
    UILabel *xiaoxin = [[UILabel alloc] init];
    xiaoxin.text = @"*";
    xiaoxin.textColor = [UIColor colorWithHex:0xF90D29];
    xiaoxin.font = [UIFont systemFontOfSize:12];
    [self.headView addSubview:xiaoxin];
    [xiaoxin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(10);
        make.top.equalTo(headImageView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(6, 15));
    }];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"评分： ";
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textColor = [UIColor colorWithHex:0xA0A7B6];
    [self.headView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiaoxin.mas_right).offset(0);
        make.top.equalTo(headImageView.mas_bottom).offset(13);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    for (int i = 0 ; i < 5; i++) {
        UIImage *huiImage = [UIImage imageNamed:@"huixing"];
        UIButton *huiBtn = [[UIButton alloc] init];
        [huiBtn setBackgroundImage:huiImage forState:UIControlStateNormal];
        [huiBtn addTarget:self action:@selector(redEvent:) forControlEvents:UIControlEventTouchUpInside];
        huiBtn.tag = i+1;
        huiBtn.adjustsImageWhenHighlighted = NO;
        [self.headView addSubview:huiBtn];
        [huiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.mas_right).offset((20)*i+5);
            make.top.equalTo(self.name.mas_top).offset(2);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }

    for (int i = 0 ; i < 2 ; i ++) {
        UIImage *cameraImage = [UIImage imageNamed:@[@"luyin",@"+"][i]];
        UIButton *cameraBtn = [[UIButton alloc] init];
        cameraBtn.layer.borderColor = [UIColor colorWithHexString:@"f3f6ff"].CGColor;
        cameraBtn.tag = 100+i;
        cameraBtn.layer.borderWidth = 1;
        [cameraBtn setImage:cameraImage forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(cameraEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cameraBtn setTitleColor: [UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
        cameraBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cameraBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.headView addSubview:cameraBtn];
        [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView).offset(10+(WKScreenW-50)/4*i+10*i);
            make.top.equalTo(self.name.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake((WKScreenW-50)/4, (WKScreenW-50)/4));
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = @[@"点击评论",@"晒单"][i];
        label.tag = 111;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"7e879d"];
        [cameraBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        if (i == 0) {
            self.timeLabel = [[UILabel alloc]init];
            self.timeLabel.textColor = [UIColor colorWithRed:254/255.0 green:142/255.0 blue:77/255.0 alpha:1];
            self.timeLabel.font = [UIFont systemFontOfSize:12];
            self.timeLabel.text = @"";
            [cameraBtn addSubview:self.timeLabel];
            [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((WKScreenW-50)/8-10);
                make.right.mas_equalTo(0);
                make.centerY.mas_equalTo(-17);
                make.height.mas_equalTo(15);
            }];
        }
    }
    
    UIButton *commentBtn = [[UIButton alloc] init];
    [commentBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [commentBtn setTitle:@" 匿名评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentBtn addTarget:self action:@selector(commentEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(0);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(100,18));
    }];
    
    self.headHeight = headimage.size.height+10+33+(WKScreenW-50)/4+10+28+5;
    self.headView.frame = CGRectMake(0, 64, WKScreenW, headimage.size.height+10+33+(WKScreenW-50)/4+10+28+5);
}

-(void)redEvent:(UIButton *)button
{
    [self starAction];
    for (int i = 0 ; i < button.tag; i++) {
        UIImage *huiImage = [UIImage imageNamed:@"honhxing"];
        UIButton *huiBtn = [[UIButton alloc] init];
        [huiBtn setBackgroundImage:huiImage forState:UIControlStateNormal];
        huiBtn.tag = i+1;
        [huiBtn addTarget:self action:@selector(redEvent:) forControlEvents:UIControlEventTouchUpInside];
        huiBtn.adjustsImageWhenHighlighted = NO;
        [self.headView addSubview:huiBtn];
        [huiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.mas_right).offset((20)*i+5);
            make.top.equalTo(self.name.mas_top).offset(2);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        [self.starArr addObject:huiBtn];
    }
    
    if(_clickType)
    {
        _clickType(score,[NSString stringWithFormat:@"%lu",(long)button.tag]);
    }
}
-(void)starAction{
    for (UIButton *item in self.starArr) {
        [item removeFromSuperview];
    }
}
-(void)cameraEvent:(UIButton *)button
{
    if(button.tag == 100){
        [button setImage:[UIImage imageNamed:@"luyinzhong"] forState:UIControlStateNormal];
        self.timeLabel.text = @"";
        UILabel *label = [button viewWithTag:111];
        label.textColor = [UIColor colorWithRed:254/255.0 green:142/255.0 blue:77/255.0 alpha:1];
        label.text = @"点击评论";
        [self createCommentsView];
    }else{
        [self captureImageWithCaptureType:WKCaptureImageTypeMutiple maxCount:4 :^(NSArray *arr) {
            if (arr.count + self.picArr.count >4) {
                [WKPromptView showPromptView:@"最多添加4张图片"];
            }else{
                [self.picArr addObjectsFromArray:arr];
                if (self.clickType) {
                    self.clickType(picture,self.picArr);
                }
            }
            [self createPicture];
        }];
    }
}
-(void)removeImageAction:(UIButton *)button{
    [self.picArr removeObjectAtIndex:button.tag -1];
    [self createPicture];
    [button removeFromSuperview];
}
-(void)createPicture{
    UIButton *addPicBtn = [self.headView viewWithTag:101];
    if((self.picArr.count < 1 )){
        [addPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(10+(WKScreenW-50)/4+10);
        make.top.equalTo(self.name.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((WKScreenW-50)/4, (WKScreenW-50)/4));
        }];
        [addPicBtn layoutIfNeeded];
    }else if(self.picArr.count>2) {
        self.headView.frame = CGRectMake(0, 64, WKScreenW, (self.headHeight+(WKScreenW-50)/4)+20);
    }else if(self.picArr.count < 3){
        self.headView.frame = CGRectMake(0, 64, WKScreenW, self.headHeight);
    }
    for (UIImageView *item in self.picIMArr) {
        [item removeFromSuperview];
    }
    for (int i = 1 ; i < self.picArr.count+1; i ++) {
        UIImageView *picIM = [[UIImageView alloc]initWithImage:self.picArr[i-1]];
        [self.headView addSubview:picIM];
        [picIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView).offset(10+(WKScreenW-50)/4*i+10*i);
            make.top.equalTo(self.name.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake((WKScreenW-50)/4, (WKScreenW-50)/4));
        }];
        if (i == 4) {
            [picIM mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).offset(10);
                make.top.equalTo(self.name.mas_bottom).offset(20+(WKScreenW-50)/4);
                make.size.mas_equalTo(CGSizeMake((WKScreenW-50)/4, (WKScreenW-50)/4));
            }];
            addPicBtn.hidden = YES;
        }else if(i == 3){
            [addPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).offset(10);
                make.top.equalTo(self.name.mas_bottom).offset(20+(WKScreenW-50)/4);
                make.size.mas_equalTo(CGSizeMake((WKScreenW-50)/4, (WKScreenW-50)/4));
            }];
            addPicBtn.hidden = NO;
        }else{
            addPicBtn.hidden = NO;
            [addPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).offset(10+(WKScreenW-50)/4*(self.picArr.count+1)+10*(self.picArr.count+1));
                make.top.equalTo(self.name.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake((WKScreenW-50)/4, (WKScreenW-50)/4));
            }];
            [addPicBtn layoutIfNeeded];
        }
        UIButton *XButton = [[UIButton alloc]init];
        XButton.tag = i;
        [XButton addTarget:self action:@selector(removeImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [XButton setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
        [self.headView addSubview:XButton];
        [XButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(picIM.mas_right).offset(-15);
            make.top.equalTo(picIM.mas_top).offset(-15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.picIMArr addObject:picIM];
    }
}
-(void)commentEvent:(UIButton *)button
{
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:button.selected?@"pro_select":@"xuanzhong"] forState:UIControlStateNormal];
    if (self.clickType) {
        self.clickType(anonymous,[NSString stringWithFormat:@"%d",button.selected]);
    }
}
#pragma mark 录音
-(void)createCommentsView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(maskButAciton:) forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [keyWindow addSubview:button];
    
    self.commentView = [[UIView alloc]init];
    self.commentView.backgroundColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:0.74];
    [keyWindow addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 250));
    }];
    
    self.recoredingIM = [[UIImageView alloc]init];
    self.recoredingIM.userInteractionEnabled = YES;
    self.recoredingIM.image = [UIImage imageNamed:@"dayuan"];
    [self.commentView addSubview:self.recoredingIM];
    [self.recoredingIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.commentView.mas_centerX);
        make.centerY.mas_equalTo(self.commentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backYuan"]];
    [self.recoredingIM addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.commentView.mas_centerX);
        make.centerY.mas_equalTo(self.commentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    self.recordingBtn = [[UIButton alloc]init];
    [self.recordingBtn setImage:[UIImage imageNamed:@"luyin-1"] forState:UIControlStateNormal];
    self.recordingBtn.selected = YES;
    [self.recordingBtn addTarget:self action:@selector(recordingButtonAction:) forControlEvents:UIControlEventTouchDown];
    self.recordingBtn.adjustsImageWhenHighlighted = NO;
    self.recordingBtn.isClose = YES;
    [self.recordingBtn addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordingBtn addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchDragExit];
    [self.recoredingIM addSubview:self.recordingBtn];
    [self.recordingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.recoredingIM.mas_centerX);
        make.centerY.mas_equalTo(self.recoredingIM.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(35, 45));
    }];
    
    self.timeLongLabel = [[UILabel alloc]init];
    self.timeLongLabel.font = [UIFont systemFontOfSize:14];
    self.timeLongLabel.textColor = [UIColor colorWithHexString:@"fdf4c7"];
    self.timeLongLabel.textAlignment = NSTextAlignmentCenter;
    [self.recoredingIM addSubview:self.timeLongLabel];
    [self.timeLongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordingBtn.mas_bottom).offset(-7);
        make.left.equalTo(self.recordingBtn.mas_left).offset(0);
        make.right.equalTo(self.recordingBtn.mas_right).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    self.rerecordingBtn = [[UIButton alloc]init];
    [self.rerecordingBtn setTitle:@"重录" forState:UIControlStateNormal];
    self.rerecordingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rerecordingBtn setTitleColor:[UIColor colorWithHexString:@"fdf4c7"] forState:UIControlStateNormal];
    [self.rerecordingBtn setBackgroundImage:[UIImage imageNamed:@"yuan-1"] forState:UIControlStateNormal];
    self.rerecordingBtn.hidden = YES;
    self.rerecordingBtn.adjustsImageWhenHighlighted = NO;
    [self.rerecordingBtn addTarget:self action:@selector(rerecordingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:self.rerecordingBtn];
    [self.rerecordingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.recoredingIM.mas_right).offset(50);
        make.bottom.equalTo(self.recoredingIM.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    self.lineAnimaIM = [[UIImageView alloc]init];
    self.lineAnimaIM.hidden = YES;
    [self.commentView addSubview:self.lineAnimaIM];
    [self.lineAnimaIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 40));
    }];
    
    self.voiceLabel = [[UILabel alloc]init];
    self.voiceLabel.text = @"长按开始说话";
    self.voiceLabel.alpha = 0.5;
    self.voiceLabel.font = [UIFont systemFontOfSize:16];
    self.voiceLabel.textAlignment = NSTextAlignmentCenter;
    self.voiceLabel.textColor = [UIColor colorWithRed:254/255.0 green:142/255.0 blue:77/255.0 alpha:1];
    [self.commentView addSubview:self.voiceLabel];
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recoredingIM.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 17));
    }];
    
    if (self.voiceTime>2) {
        self.recoredingIM.image = [UIImage imageNamed:@"dayuan"];
        self.voiceLabel.text = @"点击播放";
        [self.recordingBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
        self.rerecordingBtn.hidden = NO;
        self.recordingBtn.selected = NO;
        self.timeLongLabel.text = [NSString stringWithFormat:@"%lu''",(long)self.voiceTime];
    }
}

-(void)maskButAciton:(UIButton *)button{
    [self stopRecording];
    [self playingStoped];
    UIButton *voiceBtn =  [self.headView viewWithTag:100];
    UILabel *label = [voiceBtn viewWithTag:111];
    if ([self.voiceLabel.text isEqualToString:@"点击播放"]) {
        [voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        label.text=@"我的评论";
        self.timeLabel.text = [NSString stringWithFormat:@"%lu''",(long)self.voiceTime];
    }else{
        [voiceBtn setImage:[UIImage imageNamed:@"luyin"] forState:UIControlStateNormal];
        label.text=@"点击评论";
        label.textColor = [UIColor colorWithHexString:@"7e879d"];
        self.timeLabel.text = @"";
    }
    [button removeFromSuperview];
    [self.commentView removeFromSuperview];
    self.commentView = nil;
    if(self.clickType){
        self.clickType(voice,self.filename);
        self.clickType(timeLong,[NSString stringWithFormat:@"%lu",(long)self.voiceTime]);
    }
}
-(void)recordingButtonAction:(UIButton *)button{
    if (button.selected) {
        [self startRecordinga];
    }else{
        [self playVoice];
    }
}
-(void)startRecordinga{
    if (self.isPlaying) {
        return;
    }
    if ( ! self.isRecording) {
        self.isRecording = YES;
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecording];
        self.voiceTime = 0;
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        self.voiceLabel.text = @"松开结束语音";
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    self.count = 1;
    self.animationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(animationTimerAciton:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
}
-(void)timerAction:(NSTimer *)timer{
    self.voiceTime++;
    if (self.voiceTime==60) {
        [timer invalidate];
        [self stopRecording];
    }
}
-(void)animationTimerAciton:(NSTimer *)timer{
    self.count++;
    if (self.count == 15) {
        self.count = 1;
    }
    self.lineAnimaIM.hidden = NO;
    self.lineAnimaIM.image = [UIImage imageNamed:[NSString stringWithFormat:@"%luxian",(long)self.count]];
    self.recoredingIM.image = [UIImage imageNamed:[NSString stringWithFormat:@"%luluyin",(long)self.count]];
}
-(void)stopRecording{
    [[RecorderManager sharedManager] stopRecording];
    [self.animationTimer invalidate];
    self.count = 1;
    self.isRecording = NO;
    [self.timer invalidate];
    self.recoredingIM.image = [UIImage imageNamed:@"dayuan"];
    self.lineAnimaIM.hidden = YES;
    if (self.voiceTime<3) {
        [WKPromptView showPromptView:@"录音时间最短3秒"];
        [self.recordingBtn setImage:[UIImage imageNamed:@"luyin-1"] forState:UIControlStateNormal];
        self.voiceTime = 0;
        self.timeLongLabel.text = @"";
        self.voiceLabel.text = @"长按开始说话";
        self.recordingBtn.selected = YES;
    }else{
        self.voiceLabel.text = @"点击播放";
    }
}
-(void)playVoice{
    if (self.isRecording) {
        return;
    }
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        self.isPlaying = YES;
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
        
        [self.recordingBtn setImage:[UIImage imageNamed:@"kuai"] forState:UIControlStateNormal];
        self.time = self.voiceTime;
        self.playTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(playTimerAciton:) userInfo:nil repeats:YES];
        self.count = 1;
        self.playAnimation = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(PlayAnimation:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.playAnimation forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:self.playTimer forMode:NSDefaultRunLoopMode];
    }
    else {
        self.isPlaying = NO;
        [self.playAnimation invalidate];
        self.count = 1;
        [[PlayerManager sharedManager] stopPlaying];
    }
}
-(void)playTimerAciton:(NSTimer *)timer{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.time == 0) {
            [timer invalidate];
        }else{
            self.timeLongLabel.text = [NSString stringWithFormat:@"%lu''",(long)--self.time];
        }
    });
}
-(void)PlayAnimation:(NSTimer *)playAnimation{
    self.count++;
    if (self.count == 15) {
        self.count = 1;
    }
    self.recoredingIM.image = [UIImage imageNamed:[NSString stringWithFormat:@"%luluyin",(long)self.count]];
}
-(void)rerecordingBtnAction:(UIButton *)button{
    if (self.isPlaying) {
        return;
    }
    [self.recordingBtn setImage:[UIImage imageNamed:@"luyin-1"] forState:UIControlStateNormal];
    self.voiceTime = 0;
    self.timeLongLabel.text = @"";
    self.voiceLabel.text = @"长按开始说话";
    self.recordingBtn.selected = YES;
    button.hidden = YES;
}
#pragma mark - Recording & Playing Delegate

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    if (self.voiceTime<3) {
        return;
    }
    self.isRecording = NO;
    self.filename = filePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.filename]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordingBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
            self.rerecordingBtn.hidden = NO;
            self.recordingBtn.selected = NO;
            self.timeLongLabel.text = [NSString stringWithFormat:@"%lu''",(long)self.voiceTime];
        });
    }
}

- (void)recordingTimeout {
    self.isRecording = NO;
}

- (void)recordingStopped {
    self.isRecording = NO;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
}

- (void)levelMeterChanged:(float)levelMeter {
    NSLog(@"音量:%f",levelMeter);
}

- (void)playingStoped {
    [self.playTimer invalidate];
    [self.playAnimation invalidate];
    self.count = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeLongLabel.text = [NSString stringWithFormat:@"%lu''",(long)self.voiceTime];
        self.isPlaying = NO;
        [self.recordingBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
    });
}
-(void)dealloc{
    [self.timer invalidate];
    [self.playTimer invalidate];
    [self.playAnimation invalidate];
    [self.animationTimer invalidate];
}
@end
