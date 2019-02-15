//
//  WKLiveRecordingView.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/26.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveRecordingView.h"
#import "UIButton+ImageTitleSpacing.h"
#import <AVFoundation/AVFoundation.h>
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "UIImage+Gif.h"
#import "UIButton+MoreTouch.h"
#import "NSObject+XWAdd.h"

@interface WKLiveRecordingView ()<RecordingDelegate, PlayingDelegate>

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;
@property (assign, nonatomic) BOOL isHorizontal;

@property (nonatomic, copy) NSString *filename;
@property (assign, nonatomic) NSInteger timeLong;
@property (strong, nonatomic) NSTimer *timeCount;
@property (assign, nonatomic) NSInteger timeDown;

@property (strong, nonatomic) NSMutableArray * lineAnimatArr;
@property (strong, nonatomic) NSMutableArray * circleAnimatArr;

@end

@implementation WKLiveRecordingView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.isRecording = NO;
    self.isPlaying = NO;
    self.isTimeLong = NO;
    self.isHorizontal = NO;
    self.lineAnimatArr = [NSMutableArray new];
    self.circleAnimatArr = [NSMutableArray new];
    self.timeLong = 0;
    self.layer.masksToBounds = YES;
    [self xw_addNotificationForName:@"StopVoice" block:^(NSNotification * _Nonnull notification) {
        [[RecorderManager sharedManager] stopRecording];
        self.timeLong = 0;
        [self stopTheRecordingAnimation];
        
    }];
    
    self.lineAnimatIM = [[UIImageView alloc]init];
    self.lineAnimatIM.animationDuration = 1;
    [self addSubview:self.lineAnimatIM];
    [self.lineAnimatIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(-20);
        make.left.right.mas_offset(0);
        make.height.mas_offset(30);
    }];
    
    self.backIM = [[UIImageView alloc]init];
    self.backIM.animationDuration = 5;
    [self addSubview:self.backIM];
    self.backIM.userInteractionEnabled = YES;
    [self.backIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-20);
        make.size.sizeOffset(CGSizeMake(80*WKScaleW, 80*WKScaleW));
    }];
    
    self.countDownLabel = [[UILabel alloc]init];
    self.countDownLabel.textColor = [UIColor colorWithHexString:@"FE8E4D"];
    self.countDownLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.countDownLabel];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.height.width.mas_offset(28);
    }];
    
    self.backBtn = [[UIButton alloc]init];
    [self.backBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchDown];
    self.backBtn.isClose = YES;
    self.backBtn.adjustsImageWhenHighlighted = NO;
    [self.backBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchDragExit];
    [self.backBtn setImage:[UIImage imageNamed:@"backYuan"] forState:UIControlStateNormal];
    [self.backIM addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(55*WKScaleW, 55*WKScaleW));
    }];
    
    self.playType = [[UIImageView alloc]init];
    self.playType.userInteractionEnabled = NO;
    [self.backBtn addSubview:self.playType];
    [self.playType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(25*WKScaleW, 35*WKScaleW));
    }];
    
    self.promptLabel = [[UILabel alloc]init];
    self.promptLabel.textColor = [UIColor colorWithHexString:@"#FE8E4D"];
    self.promptLabel.font = [UIFont systemFontOfSize:13*WKScaleW];
    [self addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIM.mas_bottom).offset(10);
        make.centerX.mas_offset(0);
        make.width.mas_greaterThanOrEqualTo(5);
        make.height.mas_offset(14*WKScaleW);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"FE8E4D"];
    self.timeLabel.font = [UIFont systemFontOfSize:13*WKScaleW];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backIM.mas_centerY).offset(-10);
        make.left.equalTo(self.backIM.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(5);
        make.height.mas_offset(14*WKScaleW);
    }];
    
    self.rerecordingBtn = [[UIButton alloc]init];
    [self.rerecordingBtn setTitle:@"重录" forState:UIControlStateNormal];
    self.rerecordingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.rerecordingBtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    [self.rerecordingBtn addTarget:self action:@selector(RerecordingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rerecordingBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:13];
    [self.rerecordingBtn setImage:[UIImage imageNamed:@"chonglu"] forState:UIControlStateNormal];
    [self addSubview: self.rerecordingBtn];
    [self.rerecordingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-7);
        make.left.mas_offset(5);
        make.width.mas_offset(40);
        make.height.mas_offset(20);
    }];
    
    self.startSale = [[UIButton alloc]init];
    [self.startSale setBackgroundColor:[UIColor colorWithHexString:@"ff6600"]];
    [self.startSale setTitle:@"开始拍卖" forState:UIControlStateNormal];
    self.startSale.titleLabel.font = [UIFont systemFontOfSize:12];
    self.startSale.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.startSale.userInteractionEnabled = NO;
    [self.startSale addTarget:self action:@selector(StartSaleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startSale];
    [self.startSale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-7);
        make.bottom.mas_offset(-7);
        make.size.sizeOffset(CGSizeMake(60, 20));
    }];
    
    self.playingIM = [[UIImageView alloc]init];
    self.playingIM.hidden = YES;
    [self addSubview:self.playingIM];
    [self sendSubviewToBack:self.playingIM]; 
    [self.playingIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_offset((WKScreenW/2 - 15)/2);
        make.centerY.mas_offset(-20);
    }];
    
    self.timeDownView = [[UIView alloc]init];
    self.timeDownView.hidden = YES;
    self.timeDownView.backgroundColor = [UIColor colorWithHexString:@"FE8E4D"];
    [self addSubview:self.timeDownView];
    [self.timeDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(WKScreenW * 0.328 - 20);
        make.height.mas_offset(5);
        make.bottom.mas_offset(1);
        make.centerX.mas_offset(0);
    }];
    
    for (int i = 1 ; i < 15 ; i++) {
        [self.circleAnimatArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%dluyin",i]]];
    }
    for (int i = 1 ; i < 9 ; i++ ) {
        [self.lineAnimatArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"xian_o%d",i]]];
    }
    [self normalViewStyle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifationAction) name:@"startSalr" object:nil];
}
-(void)setType:(NSInteger)type{
    if (type == 2) {
        self.promptLabel.text = @"长按说话,发起幸运购";
        [self.startSale setTitle:@"开始幸运购" forState:UIControlStateNormal];
    }
}
//默认样式
-(void)normalViewStyle{
    self.rerecordingBtn.hidden = YES;
    self.lineAnimatIM.hidden = YES;
    self.countDownLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.startSale.hidden = YES;
    self.backIM.image = [UIImage imageNamed:@"8luyin"];
    self.playType.image = [UIImage imageNamed:@"luyin-1"];
    self.promptLabel.text = @"长按说话,发起快捷拍卖";
    self.countDownLabel.text = @"10";
    self.timeLabel.text = @"0\"";
    if (!self.isHorizontal) {
        [self.playType mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(25*WKScaleW, 35*WKScaleW));
        }];
    }else{
        [self.playType mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(15*WKScaleW, 20*WKScaleW));
        }];
        [self.playType layoutIfNeeded];
    }
}
//开始录音动画
-(void)startTheRecordingAnimation{
    self.backIM.animationImages = self.circleAnimatArr;
    [self.backIM startAnimating];
    self.lineAnimatIM.animationImages = self.lineAnimatArr;
    self.lineAnimatIM.hidden = NO;
    if (self.isHorizontal) {
        self.promptLabel.hidden = YES;
    }
    [self.lineAnimatIM startAnimating];
    self.timeCount = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(recordingTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timeCount forMode:NSDefaultRunLoopMode];
    if (self.isHorizontal) {
        self.timeDownView.hidden = NO;
    }
}
//录音完成样式
-(void)recordingFinishViewStyle{
    self.rerecordingBtn.hidden = NO;
    self.lineAnimatIM.hidden = NO;
    self.countDownLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.startSale.hidden = NO;
    [self.backIM stopAnimating];
    self.backIM.image = [UIImage imageNamed:@"8luyin"];
    if (self.isHorizontal) {
        [self.playType mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(10*WKScaleW, 10*WKScaleW));
        }];
    }else{
        [self.playType mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(15*WKScaleW, 15*WKScaleW));
        }];
    }
    self.playingIM.hidden = YES;
    self.playType.image = [UIImage imageNamed:@"play1"];
    self.promptLabel.text = @"点击播放";
    self.countDownLabel.hidden = YES;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)self.timeLong];
}
//结束录音动画
-(void)stopTheRecordingAnimation{
    [self.backIM stopAnimating];
    self.backIM.image = [UIImage imageNamed:@"8luyin"];
    self.lineAnimatIM.hidden = YES;
    self.promptLabel.hidden = NO;
    [self.lineAnimatIM stopAnimating];
    [self.timeDownView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset((WKScreenW * 0.328 - 20));
    }];
    self.timeDownView.hidden = YES;
}
//播放动画
-(void)playingTheTapeAnimation{
    self.playType.image = [UIImage imageNamed:@"kuai"];
    self.timeDown = self.timeLong;
    [self.backIM startAnimating];
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"saleing" ofType:@"gif"];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gitPath]];
    self.playingIM.hidden = NO;
    self.playingIM.image = image;
    self.promptLabel.text = @"点击暂停";
    if (self.isHorizontal) {
        [self.playType mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(10*WKScaleW, 10*WKScaleW));
        }];
    }else{
        [self.playType mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(15*WKScaleW, 15*WKScaleW));
        }];
    }
    self.timeCount = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(playingTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timeCount forMode:NSDefaultRunLoopMode];
}
-(void)notifationAction{
    if (self.timeLong > 2 && self.filename.length>0 && !self.isPlaying && !self.isRecording) {
        [self StartSaleAction:nil];
    }
}
-(void)RerecordingBtnAction:(UIButton *)rerecordingBtn{
    if (self.isPlaying) {
        return;
    }
    [self normalViewStyle];
    self.timeLong = 0;
}
-(void)StartSaleAction:(UIButton *)startSale{
    if (self.startSaleBlock) {
        self.startSaleBlock([@(self.timeLong) stringValue],self.filename);
    }
}

-(void)playBtnAction:(UIButton *)playBtn{
    if (self.isRecording) {
        [self startTheRecording];
    }else{
        [self playTheTape];
    }
}

-(void)recordAction:(UIButton *)recordBtn{
    if (self.timeLong > 2) {
        return;
    }
    [self startTheRecording];
}

-(void)startTheRecording{
    if (self.isPlaying) {
        return;
    }
    if ( ! self.isRecording) {
        self.isRecording = YES;
//        NSLog(@"record user: %p",User);

        User.recordType = WKRecordingTypeStart;
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecording];
        [self startTheRecordingAnimation];
    }
    else {
        User.recordType = WKRecordingTypeNO;
        self.isRecording = NO;
        [[RecorderManager sharedManager] stopRecording];
        [self stopTheRecordingAnimation];
        [self.timeCount invalidate];
    }
}

-(void)playTheTape{
    if (self.isRecording) {
        return;
    }
    if (self.isTimeLong) {
        self.isTimeLong = NO;
        return;
    }
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        self.isPlaying = YES;
        [self playingTheTapeAnimation];
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
    }
    else {
        self.isPlaying = NO;
        [self.timeCount invalidate];
        [self recordingFinishViewStyle];
        [[PlayerManager sharedManager] stopPlaying];
    }
}
-(void)recordingTimer:(NSTimer *)timer{
    self.timeLong ++;
    if (self.timeLong == 50) {
        self.countDownLabel.hidden = NO;
    }
    if (self.timeLong > 50) {
        self.countDownLabel.text = @(60 - self.timeLong).stringValue;
    }
    if (self.timeLong == 60) {
        [[RecorderManager sharedManager] stopRecording];
        [self stopTheRecordingAnimation];
        self.isTimeLong = YES;
        [timer invalidate];
    }
    [self.timeDownView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset((WKScreenW * 0.328 - 20)/60*(60-self.timeLong));
    }];
}
-(void)playingTimer:(NSTimer *)timer{
    self.timeDown --;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",(long)self.timeDown];
    if (self.timeDown == 0) {
        [timer invalidate];
    }
}
#pragma mark - Recording & Playing Delegate

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    if (interval < 3) {
        self.filename = @"";
        self.timeLong = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [WKPromptView showPromptView:@"录音时间最短3秒"];
        });
    }else{
        self.filename = filePath;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self recordingFinishViewStyle];
        });
    }
}

- (void)recordingTimeout {
    self.isRecording = NO;
    User.recordType = WKRecordingTypeStop;
}

- (void)recordingStopped {
    self.isRecording = NO;
    User.recordType = WKRecordingTypeStop;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    User.recordType = WKRecordingTypeNO;

}

- (void)levelMeterChanged:(float)levelMeter {
//    NSLog(@"音量:%f",levelMeter);
    
}

- (void)playingStoped {
    self.isPlaying = NO;
    [self recordingFinishViewStyle];
}

#pragma mark 横向布局
-(void)refreshLayoutWityHorizontal{
    self.isHorizontal = YES;
    [self.lineAnimatIM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(-7);
        make.left.right.mas_offset(0);
        make.height.mas_offset(30);
    }];
    [self.backIM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-7);
        make.size.sizeOffset(CGSizeMake(45*WKScaleW, 45*WKScaleW));
    }];
    [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(30*WKScaleW, 30*WKScaleW));
    }];
    [self.countDownLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.height.width.mas_offset(28);
    }];
    [self.playType mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(15*WKScaleW, 20*WKScaleW));
    }];
    self.promptLabel.font = [UIFont systemFontOfSize:10];
    [self.promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIM.mas_bottom).offset(0);
        make.centerX.mas_offset(0);
        make.width.mas_greaterThanOrEqualTo(5);
        make.height.mas_offset(11*WKScaleW);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.equalTo(self.backIM.mas_right).offset(-5);
        make.width.mas_greaterThanOrEqualTo(5);
        make.height.mas_offset(14*WKScaleW);
    }];
    [self.rerecordingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-7);
        make.top.mas_offset(0);
        make.width.mas_offset(40);
        make.height.mas_offset(30);
    }];
    [self.startSale mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-5);
        make.bottom.mas_offset(-5);
        make.size.sizeOffset(CGSizeMake(40, 15));
    }];
    [self.playingIM mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_offset(100 * WKScaleH);
        make.bottom.mas_offset(50 * WKScaleH);
    }];
    
}
-(void)dealloc{
    [self.timeCount invalidate];
}
@end



