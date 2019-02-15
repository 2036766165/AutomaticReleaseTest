//
//  WKCustomCommentView.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCustomCommentView.h"
#import "WKCustomCommentCell.h"
#import "NSString+Size.h"
#import "WKTimeCalcute.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "UIImage+Gif.h"
#import "UIButton+MoreTouch.h"
#import "WKPlayTool.h"
#import "ZLPhoto.h"
#import "NSObject+WKImagePicker.h"

@interface WKCustomCommentView ()<PlayingDelegate,RecordingDelegate>

@property (strong, nonatomic) UIView * commentView;

@property (strong, nonatomic) UIImageView * recoredingIM;

@property (strong, nonatomic) UIButton * recordingBtn;

@property (strong, nonatomic) UILabel * timeLongLabel;

@property (strong, nonatomic) UIButton * rerecordingBtn;

@property (strong, nonatomic) UIImageView * lineAnimaIM;

@property (strong, nonatomic) UILabel * voiceLabel;

@property (assign, nonatomic) NSInteger voiceTime;

@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) NSTimer * playAnimation;

@property (strong, nonatomic) NSTimer * animationTimer;

@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) BOOL isRecording;

@property (strong, nonatomic) NSTimer * timer;

@property (assign, nonatomic) NSInteger time;

@property (strong, nonatomic) NSString * filename;

@property (strong, nonatomic) NSTimer * playTimer;

@property (strong, nonatomic) NSString * orderCode;

@property (strong, nonatomic) NSMutableArray * btnArr;

@property (assign, nonatomic) NSInteger beforeTag;

@property (assign, nonatomic) NSInteger playSection;

@property (strong, nonatomic) NSMutableArray * cellArr;

@property (strong, nonatomic) NSString * playCode;

@property (strong, nonatomic) UIButton *maskButton;

@end

@implementation WKCustomCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.playSection = -1;
        self.cellArr = [NSMutableArray new];
        self.btnArr = [NSMutableArray new];
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}
#pragma mark tableView Dategate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKCustomCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKCustomCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    WKCustomCommentModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentBlock = ^(NSArray *imageArr,NSIndexPath *index){
//        
//        UIViewController *contrller = [self viewControllerWith:self.view];
//        
//        [contrller showImageWith:imageArr index:index type:LGShowImageTypeImageBroswer];
    };
    [self.cellArr addObject:cell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 170;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WKCustomCommentModel *model = self.dataArray[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, 60)];
    view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WKScreenW, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    
    UIImageView *headIM = [[UIImageView alloc]init];
    headIM.layer.cornerRadius = 15;
    headIM.layer.masksToBounds = YES;
    [headIM sd_setImageWithURL:[NSURL URLWithString:model.MemberPhotoUrl]placeholderImage:[UIImage imageNamed:@"default_03"]];
    [backView addSubview:headIM];
    [headIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    NSArray *timeArr = [model.CreateTime componentsSeparatedByString:@" "];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = timeArr[0];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(20);
        make.right.mas_offset(-10);
        make.centerY.mas_offset(0);
        make.height.mas_offset(15);
    }];
    
    UILabel *ownerLabel = [[UILabel alloc]init];
    ownerLabel.text = model.MemberName;
    ownerLabel.font = [UIFont systemFontOfSize:12];
    ownerLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [backView addSubview:ownerLabel];
    [ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headIM.mas_right).offset(10);
        make.centerY.mas_offset(0);
        make.right.equalTo(timeLabel.mas_left).offset(0);
        make.height.mas_offset(15);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, WKScreenW, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [backView addSubview:lineView];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WKCustomCommentModel *model = self.dataArray[section];
    BOOL showBool = model.PicUrls.count>0?NO:YES;
    BOOL commentBool = model.Reply.length>0?NO:YES;
    NSInteger footHeight = 40 + model.PicUrls.count>0?70:0 + model.Reply.length>0?30:0;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, footHeight)];
    footView.backgroundColor = [UIColor whiteColor];
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.text = @"晒单: ";
    showLabel.hidden = showBool;
    showLabel.font = [UIFont systemFontOfSize:11];
    showLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [footView addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_offset(0);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_offset(12);
    }];
    CGSize size = [@"晒单: " sizeOfStringWithFont:[UIFont systemFontOfSize:11] withMaxSize:CGSizeMake(MAXFLOAT, 12)];
   
        
    for (int i = 0 ; i < model.PicUrls.count; i++ ) {
        UIImageView *showIM = [[UIImageView alloc]init];
        showIM.tag = i;
        showIM.userInteractionEnabled = YES;
        showIM.animationRepeatCount = section;
        [showIM sd_setImageWithURL:[NSURL URLWithString:model.PicUrls[i]]];
        [footView addSubview:showIM];
        [showIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showLabel.mas_right).offset(5+(WKScreenW-size.width-30-40)/4*i+10*i);
            make.top.equalTo(showLabel.mas_top).offset(0);
            make.size.sizeOffset(CGSizeMake((WKScreenW-size.width-30-40)/4, (WKScreenW-size.width-30-40)/4));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [showIM addGestureRecognizer:tap];
    }
    
    CGFloat microHeight;
    if (showBool) {
        microHeight = 0;
    }else{
        microHeight = 0 + (WKScreenW-size.width-30-40)/4;
    }
    
    UIButton *microPhone = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW-35, microHeight, 25, 35)];
    microPhone.hidden = !commentBool;
    [microPhone setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [microPhone setTitle:model.ID forState:UIControlStateNormal];
    [microPhone addTarget:self action:@selector(microAction:) forControlEvents:UIControlEventTouchUpInside];
    [microPhone setImage:[UIImage imageNamed:@"micro"] forState:UIControlStateNormal];
    [footView addSubview:microPhone];

    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = [NSString stringWithFormat:@"     %@",model.ReplyTime];
    timeLabel.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    timeLabel.hidden = commentBool;
    [footView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.equalTo(microPhone.mas_bottom).offset(5);
        make.width.mas_offset(WKScreenW);
        make.height.mas_offset(25);
    }];
    
    UIButton *playBackBtn = [[UIButton alloc]init];
    playBackBtn.backgroundColor = [UIColor whiteColor];
    playBackBtn.hidden = commentBool;
//    playBackBtn.tag = section;
    [footView addSubview:playBackBtn];
    [playBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.equalTo(timeLabel.mas_bottom).offset(0);
        make.width.mas_offset(WKScreenW);
        make.bottom.mas_offset(0);
    }];
    
    UIButton * playBtn = [[UIButton alloc]init];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playKuang"] forState:UIControlStateNormal];
    playBtn.tag = section;
    [playBtn setTitle:model.Reply forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [playBackBtn addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(3);
        make.width.mas_offset(160);
        make.bottom.mas_offset(-3);
    }];
    
    UILabel *playTimeLabel = [[UILabel alloc]init];
    playTimeLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    playTimeLabel.text = [NSString stringWithFormat:@"%@\"",model.ReplyDuration];
    playTimeLabel.font = [UIFont systemFontOfSize:12];
    [playBackBtn addSubview:playTimeLabel];
    [playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playBtn.mas_right).offset(10);
        make.centerY.equalTo(playBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 13));
    }];
    
    UIImageView * playIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"laba"]];
    playIM.tag = 11111;
    [playBtn addSubview:playIM];
    [playIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(10, 15));
    }];
    
    UILabel * playLabel = [[UILabel alloc]init];
    playLabel.text = model.ReplyBrief;
    playLabel.tag = 11101;
    playLabel.font = [UIFont systemFontOfSize:12];
    playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [playBtn addSubview:playLabel];
    [playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playIM.mas_right).offset(5);
        make.centerY.mas_offset(0);
        make.right.equalTo(playBtn.mas_right).offset(-5);
        make.height.mas_offset(13);
    }];
    [self.btnArr addObject:playBtn];
    
    if (section == self.playSection) {
        NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"liveStatus" ofType:@"gif"];
        UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gitPath]];
        playIM.image = image;
        playLabel.textColor = [UIColor orangeColor];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti) name:@"FootPlay" object:nil];
    
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger height = 40;
    WKCustomCommentModel *model = self.dataArray[section];
    if (model.PicUrls.count>0) {
        height += 70;
    }
    if (model.Reply.length>0) {
        height += 60;
    }
    return height;
}
-(void)microAction:(UIButton *)button{
    self.orderCode = button.currentTitle;
    [self createCommentsView];
}
-(void)footerRequestWithData{
    if (self.requestBlock) {
        self.requestBlock();
    }
}
-(void)headerRequestWithData{
    if (self.requestBlock) {
        self.requestBlock();
    }
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView *im = (UIImageView *)tap.view;
    WKCustomCommentModel *model = self.dataArray[im.animationRepeatCount];
    NSMutableArray *arr = @[].mutableCopy;
    for (int i=0; i < model.PicUrls.count; i++)
    {
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:model.PicUrls[i]];
        [arr addObject:photo];
    }
    [self showImageWith:arr index:im.tag];
}
#pragma mark 录音
-(void)noti{//关闭所有foot中播放的动画
    int i = 0 ;
    for (UIButton *btn in self.btnArr) {
        UIImageView *btnIM = (UIImageView *)[btn viewWithTag:11111];
        UILabel *btnLabel = (UILabel *)[btn viewWithTag:11101];
        btnIM.image = [UIImage imageNamed:@"laba"];
        btnLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        NSLog(@"%d,%lu",i++,(unsigned long)self.btnArr.count);
    }
    self.playSection = -1;
}
-(void)stopCellPlay{
    self.playSection = -1;
    for (WKCustomCommentCell *item in self.cellArr) {
        item.playLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        item.playIM.image = [UIImage imageNamed:@"laba"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"playCord"];
    }
}
-(void)playBtnAction:(UIButton *)button{
    [self stopCellPlay];
    if (!self.isPlaying) {
        UIImageView *playIM;
        UILabel *playLabel;
        for (UIButton *btn in self.btnArr) {
            UIImageView *btnIM = [btn viewWithTag:11111];
            UILabel *btnLabel = [btn viewWithTag:11101];
            if (btn.tag == button.tag) {
                playIM = btnIM;
                playLabel = btnLabel;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CellPlay" object:nil];
        self.isPlaying = YES;
        self.playSection = button.tag;
        [WKPlayTool writeFileWithStr:button.currentTitle :^(NSString *voicePath, NSString *requestMessage) {
            if ([requestMessage isEqualToString:@"写入成功"]) {
                [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:self];
                NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"liveStatus" ofType:@"gif"];
                UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gitPath]];
                playIM.image = image;
                playLabel.textColor = [UIColor orangeColor];
            }else{
                NSLog(@"%@",requestMessage);
            }
        }];
    }
    else {
        self.isPlaying = NO;
        self.playSection = -1;
        [[PlayerManager sharedManager] stopPlaying];
    }
}
-(void)ReplyToCommentAction{
    if (self.voiceTime<2) {
        self.promptBlock(@"请添加回复");
        return;
    }
    if (self.clickType) {
        self.clickType([NSString stringWithFormat:@"%ld",(long)self.voiceTime],self.filename,self.orderCode);
        [self maskButAciton:self.maskButton];
    }
}
-(void)createCommentsView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.maskButton = [[UIButton alloc]init];
    self.maskButton.backgroundColor = [UIColor clearColor];
    [self.maskButton addTarget:self action:@selector(maskButAciton:) forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview:self.maskButton];
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [keyWindow addSubview:self.maskButton];
    
    self.commentView = [[UIView alloc]init];
    self.commentView.backgroundColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:0.74];
    [keyWindow addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 250));
    }];
    
    UIButton *replyBtn = [[UIButton alloc]init];
    [replyBtn setTitle:@"回复评论" forState:UIControlStateNormal];
    [replyBtn setTitleColor:[UIColor colorWithRed:254/255.0 green:142/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [replyBtn addTarget:self action:@selector(ReplyToCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView addSubview:replyBtn];
    [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_offset(5);
        make.size.sizeOffset(CGSizeMake(70, 30));
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
    self.recordingBtn.isClose = YES;
    self.recordingBtn.adjustsImageWhenHighlighted = NO;
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
}
-(void)maskButAciton:(UIButton *)button{
    self.voiceTime = 0;
    [button removeFromSuperview];
    [self.commentView removeFromSuperview];
    self.isPlaying = NO;
    [self.playAnimation invalidate];
    self.count = 1;
    [[PlayerManager sharedManager] stopPlaying];
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
        self.promptBlock(@"录音时间最短3秒");
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
    self.playSection = -1;
    //UIImageView *playIM;
    //UILabel *playLabel;
    for (UIButton *btn in self.btnArr) {
        UIImageView *btnIM = [btn viewWithTag:11111];
        UILabel *btnLabel = [btn viewWithTag:11101];
        if (btn.tag == self.playSection) {
            //playIM = btnIM;
            //playLabel = btnLabel;
        }
        btnIM.image = [UIImage imageNamed:@"laba"];
        btnLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    }
}
@end
