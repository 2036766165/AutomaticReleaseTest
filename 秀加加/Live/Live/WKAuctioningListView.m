//
//  WKAuctioningListView.m
//  秀加加
//  
//  Created by sks on 2017/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKAuctioningListView.h"
#import "WKParticipateCollectionViewCell.h"
#import "StopRaiseSaleAnimation.h"
#import "StopAuctionAnimation.h"
#import "WKQuene.h"

@interface WKAuctioningListView () <UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate>{
    WKAuctionStatusModel *_auctionModel;
    NSTimer *_timer;
    NSInteger _remainTime;
    WKQuene *_animationQueue;
    BOOL _animtionStoped;
    NSTimer *_animationTimer;
}

@property (nonatomic,strong) UIImageView *lineBgView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UILabel *onlineLabel;
@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIView *timeBgView;

@property (nonatomic,strong) UIView *animationView;
@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UIView *progressBgView;

@property (nonatomic,strong) UILabel *progressLabel;

//@property (nonatomic,retain) dispatch_queue_t myQueue;

@property (nonatomic,strong) WKAuctionJoinModel *currentJoinMd;
@property (assign, nonatomic) BOOL isShow;//判断是否播放动画


@end

@implementation WKAuctioningListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self xw_addNotificationForName:@"LIVEEND" block:^(NSNotification * _Nonnull notification) {
            [_timer invalidate];
            _timer = nil;
        }];
    }
    return self;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (void)setupViews{
    // left bg
    UIImage *lineBgImage = [UIImage imageNamed:@"numbers_bg"];
    UIImageView *lineBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, lineBgImage.size.width, lineBgImage.size.height)];
    lineBgView.userInteractionEnabled = YES;
    lineBgView.image = lineBgImage;
//    self.backgroundColor = [UIColor greenColor];
    [self addSubview:lineBgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [lineBgView addGestureRecognizer:tap];
    
    self.lineBgView = lineBgView;
    
    // auction icon
    CGFloat imageViewH = lineBgImage.size.height - 10;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 5, imageViewH, imageViewH)];
    iconImageView.layer.cornerRadius = imageViewH/2;
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImageView.layer.borderWidth = 1.0;
    iconImageView.image = [UIImage imageNamed:@"default_03"];
    [lineBgView addSubview:iconImageView];
    self.iconImageV = iconImageView;
    UIImage *image = [UIImage imageNamed:@"direct_arrow"];

    // number of participated person
    UILabel *onLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x + imageViewH + 2, iconImageView.frame.origin.y + (imageViewH-20)/2, lineBgView.frame.size.width - imageViewH - 10 - image.size.width, 20)];
    onLineLabel.font = [UIFont systemFontOfSize:12.0f];
    onLineLabel.textAlignment = NSTextAlignmentCenter;
    onLineLabel.text = @"0人参与";
//    onLineLabel.backgroundColor = [UIColor redColor];
    onLineLabel.textColor = [UIColor whiteColor];
    [lineBgView addSubview:onLineLabel];
    self.onlineLabel = onLineLabel;
    
    // switch btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"direct_arrow_select"] forState:UIControlStateSelected];
    btn.frame = CGRectMake(onLineLabel.frame.origin.x + onLineLabel.frame.size.width, (iconImageView.frame.size.height - image.size.height)/2 + 5, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [lineBgView addSubview:btn];
    btn.tag = 1001;
    UIImage *clockBg = [UIImage imageNamed:@"clock_bg"];

    // participate persons
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.frame.size.height - 15, self.frame.size.height - 15);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 3;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumInteritemSpacing = 0
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(lineBgView.frame.origin.x + lineBgImage.size.width + 10, -3, WKScreenW - lineBgImage.size.width - clockBg.size.width - 20, lineBgView.frame.size.height + 6) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[WKParticipateCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WKParticipateCollectionViewCell class])];
    
    // show remain time
//    UIImage *clockBg = [UIImage imageNamed:@"clock_bg"];
    UIImageView *timeBgView = [[UIImageView alloc] initWithFrame:CGRectMake(WKScreenW - clockBg.size.width, 0, clockBg.size.width, clockBg.size.height)];
    timeBgView.image = clockBg;
    [self addSubview:timeBgView];
    self.timeBgView = timeBgView;
    
    UIImage *clockImage = [UIImage imageNamed:@"clock_red"];
    UIImageView *clockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(4, (clockBg.size.height - clockImage.size.height)/2, clockImage.size.width, clockImage.size.height)];
    clockImageV.image = clockImage;
    [self.timeBgView addSubview:clockImageV];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockImageV.frame.size.width + clockImageV.frame.origin.x + 1, clockImageV.frame.origin.y , timeBgView.frame.size.width - clockImageV.frame.origin.x - clockImageV.frame.size.width , 20)];
    timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    timeLabel.text = @"00:00:00";
    timeLabel.textColor = [UIColor colorWithRed:0.71 green:0.28 blue:0.39 alpha:1.00];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.timeBgView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // progress bg view
    UIView *progressBgView = [[UIView alloc] initWithFrame:CGRectMake(WKScreenW - WKScreenW * 0.3, self.timeBgView.frame.size.height + self.timeBgView.frame.origin.y + 10, WKScreenW * 0.3, 40)];
//    progressBgView.backgroundColor = [UIColor redColor];
    [self addSubview:progressBgView];
    
    self.progressBgView = progressBgView;
    self.progressBgView.hidden = YES;
    
    // progress label
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WKScreenW * 0.3, 20)];
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:12.0f];
    lab.shadowColor = [UIColor blackColor];
    lab.shadowOffset = CGSizeMake(1, 1);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.adjustsFontSizeToFitWidth = YES;
    [progressBgView addSubview:lab];
    self.progressLabel = lab;
    
    // progress line view
    UIView *progressLine = [[UIView alloc] initWithFrame:CGRectMake(7, 25, WKScreenW * 0.3 - 10, 8)];
    progressLine.backgroundColor = [UIColor colorWithHexString:@"#CFC2C9"];
    progressLine.layer.cornerRadius = 4.0;
    progressLine.clipsToBounds = YES;
    [progressBgView addSubview:progressLine];
    
    // progress view
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, progressLine.frame.size.width, 8)];
    progressView.layer.cornerRadius = 4.0;
    progressView.clipsToBounds = YES;
    [progressLine addSubview:progressView];
    progressView.backgroundColor = [UIColor colorWithHexString:@"#FC6621"];
    self.progressView = progressView;
    
    _animtionStoped = YES;
}

- (void)btnClick{
    WKAuctionStatusModel *md = [[WKAuctionStatusModel alloc] init];
    md.MemberPhotoUrl = User.MemberPhotoUrl;
    
    UIButton *btn = [self.lineBgView viewWithTag:1001];
    btn.selected = !btn.selected;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (btn.isSelected) {
            self.progressBgView.frame = CGRectMake(WKScreenW, self.timeBgView.frame.size.height + self.timeBgView.frame.origin.y + 10, WKScreenW * 0.3, 40);
            self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
            self.collectionView.alpha = 0.0;
            self.timeBgView.frame = CGRectMake(WKScreenW, self.timeBgView.frame.origin.y, self.timeBgView.frame.size.width, self.timeBgView.frame.size.height);
        }else{
            
            self.progressBgView.frame = CGRectMake(WKScreenW - WKScreenW * 0.3, self.timeBgView.frame.size.height + self.timeBgView.frame.origin.y + 10, WKScreenW * 0.3, 40);
            self.collectionView.frame = CGRectMake(self.lineBgView.frame.origin.x + self.lineBgView.frame.size.width + 10, -3, WKScreenW - self.lineBgView.frame.size.width - self.timeBgView.frame.size.width - 20, self.lineBgView.frame.size.height + 6);
            self.collectionView.alpha = 1.0;
            UIImage *clockBg = [UIImage imageNamed:@"clock_bg"];
            self.timeBgView.frame = CGRectMake(WKScreenW - clockBg.size.width, 0, clockBg.size.width, clockBg.size.height);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

//MARK: Auction Start
- (void)setAuctionerInfo:(id)model{
    _auctionModel = model;
    
    _remainTime = _auctionModel.RemainTime.integerValue;
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    if (_auctionModel.VoiceDuration.integerValue > 0) {
        self.iconImageV.image = [UIImage imageNamed:@"yuyin"];
    }else{
        [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:_auctionModel.GoodsPic] placeholderImage:[UIImage imageNamed:@"default_03"]];
    }
    
    self.onlineLabel.text = [NSString stringWithFormat:@"%@参与",_auctionModel.Count];
    self.progressBgView.hidden = NO;
    self.progressLabel.text = [NSString stringWithFormat:@"目标￥%@",_auctionModel.GoodsStartPrice];
    CGFloat scale = _auctionModel.CurrentPrice.floatValue/_auctionModel.GoodsStartPrice.floatValue;
    CGFloat width = (WKScreenW * 0.3 - 10)*scale;
    self.progressView.frame = CGRectMake(0, 0, width, 8);
    if (_auctionModel.SaleType.integerValue == 1) {
        self.progressBgView.hidden = YES;
    }
    [self formatShowRemainTime];
}

- (void)timeCount:(NSTimer *)timer{
    if (_remainTime <= 0) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    _remainTime -= 1;
    [self formatShowRemainTime];
}

- (void)crowdEedWith:(WKAuctionStatusModel *)md superView:(UIView *)superView{
    // alloc a view view addself
    if (md.SaleType.integerValue == 1) {
        // auction end
        StartAuctionModel *endInfoMd = [[StartAuctionModel alloc] init];
        endInfoMd.goodsPrice = [NSString stringWithFormat:@"%@",md.CurrentPrice];
        endInfoMd.goodsPic = md.GoodsPic;
        endInfoMd.goodsName = md.GoodsName;
        endInfoMd.auctionTime = [NSString stringWithFormat:@"%ldmin",md.RemainTime.integerValue/60];
        endInfoMd.memberName = md.CurrentMemberName;
        endInfoMd.memberPic = md.MemberPhotoUrl;
        if (self.isShow) {
            [StopAuctionAnimation stopAcutionAnimation:endInfoMd superView:superView];
        }
        
    }else{
        // luck buy end
        NSMutableArray *memberNameArr = [NSMutableArray new];
        for (WKAuctionJoinModel*item in self.dataArr) {
            [memberNameArr addObject:item.CustomerName];
        }
        for (;;) {
            if (memberNameArr.count<20) {
                [memberNameArr addObjectsFromArray:memberNameArr];
            }else{
                break;
            }
        }
        [memberNameArr insertObject:md.CurrentMemberName atIndex:memberNameArr.count-2];
        WKAuctioningListView *listView = [[WKAuctioningListView alloc] initWithFrame:CGRectMake(0, 80, WKScreenW, 50)];
        StartAuctionModel *StopRaiseModel = [StartAuctionModel new];
        StopRaiseModel.memberArr = memberNameArr;
        StopRaiseModel.memberName = md.CurrentMemberName;
        StopRaiseModel.memberPic = md.MemberPhotoUrl;
        StopRaiseModel.goodsPic = md.GoodsPic;
        StopRaiseModel.goodsName = md.GoodsName;
        if (self.isShow) {
            [StopRaiseSaleAnimation StopAcutionAnimation:StopRaiseModel andMessageView:listView superView:superView];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}

// Auction Joined
- (void)participatePersons:(NSArray *)persons showAnimation:(BOOL)show{
    
    if (_auctionModel.SaleType.integerValue == 1) {
        if (!self.isShow) {
            show = NO;
        }
        if (show) {
            // enqueue
            if (!_animationQueue) {
                _animationQueue = [[WKQuene alloc] init];
            }
            [_animationQueue enqueueWith:persons[0]];
            [self showAnimation];
            
        }else{
            for (int i=0; i<persons.count; i++) {
                WKAuctionJoinModel *md = persons[i];
                md.isFirst = NO;
                [self.dataArr addObject:md];
            }
            
            WKAuctionJoinModel *md = [self.dataArr firstObject];
            md.isFirst = YES;
            
            [self.collectionView reloadData];
        }

    }else{
        // luck buy
        if ([persons firstObject]) {
            WKAuctionJoinModel *joinMd = persons[0];
            self.progressLabel.text = [NSString stringWithFormat:@"目标￥%@",_auctionModel.GoodsStartPrice];
            CGFloat scale = (joinMd.CurrentPrice.floatValue==0?_auctionModel.CurrentPrice.floatValue:joinMd.CurrentPrice.floatValue)/_auctionModel.GoodsStartPrice.floatValue;
            self.progressView.frame = CGRectMake(0, 0, (WKScreenW * 0.3 - 10) * scale, 8);
        }
        
        [self.dataArr addObjectsFromArray:persons];

        for (int i=0; i<self.dataArr.count; i++) {
            
            WKAuctionJoinModel *md = self.dataArr[i];
            md.isFirst = NO;
            for (int j= i+1; j<self.dataArr.count; j++) {
                WKAuctionJoinModel *md1 = self.dataArr[j];
                
                if ([md1.CustomerBPOID isEqualToString:md.CustomerBPOID]) {
                    if (md.Price.integerValue < md1.Price.integerValue) {
//                        md.Price = md1.Price;
                        [self.dataArr removeObjectAtIndex:i];
                    }else{
//                        md1.Price = md.Price;
                        [self.dataArr removeObjectAtIndex:j];
                    }
                }
            }
        }
        
        [self.dataArr sortUsingComparator:^NSComparisonResult(WKAuctionJoinModel * _Nonnull obj1, WKAuctionJoinModel  * _Nonnull obj2) {
          return  obj1.Price.integerValue < obj2.Price.integerValue;
        }];
    
        
        WKAuctionJoinModel *firstPerson = [self.dataArr firstObject];
        firstPerson.isFirst = YES;
        [self.collectionView reloadData];
    }
    
    self.onlineLabel.text = [NSString stringWithFormat:@"%lu参与",(unsigned long)_dataArr.count];
}

- (void)bidWith:(WKAuctionStatusModel *)md{
    if (md.SaleType.integerValue == 1) {
        WKAuctionJoinModel *joinMd = [[WKAuctionJoinModel alloc] init];
        joinMd.CustomerBPOID = md.CurrentMemberBPOID;
        joinMd.Price = md.Price;
        joinMd.CustomerPicUrl = md.MemberPhotoUrl;
        
        joinMd.CurrentPrice = md.CurrentPrice;
        
        for (int i=0; i<self.dataArr.count; i++) {
            WKAuctionJoinModel *listMd = self.dataArr[i];
            listMd.isFirst = NO;
            if ([listMd.CustomerBPOID isEqualToString:joinMd.CustomerBPOID]) {
                listMd.Price = joinMd.Price;
                [self.dataArr removeObject:listMd];
                [self.dataArr insertObject:listMd atIndex:0];
            }
        }
        
        WKAuctionJoinModel *firstMd = [self.dataArr firstObject];
        firstMd.isFirst = YES;
    }
    
    [self.collectionView reloadData];
}

- (void)showAnimation{
    if (!_animtionStoped) {
        return;
    }
    WKAuctionJoinModel *md = [_animationQueue dequeue];
    UIView *animationView;
    if (md) {
        animationView = [self participateViewWith:md];
        _animtionStoped = NO;
    }else{
        return;
    }
    self.animationView = animationView;
    self.currentJoinMd = md;
    
    NSLog(@"执行了");
    animationView.center = CGPointMake(WKScreenW/2, WKScreenH * 0.3);
    [self.superview addSubview:animationView];
    
    // Group Animation
    CABasicAnimation *firstOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    firstOpacity.fromValue = @0.2;
    firstOpacity.toValue = @1.0;
    firstOpacity.duration = 0.4;
    firstOpacity.beginTime = 0.0;
    firstOpacity.fillMode = kCAFillModeForwards;
    firstOpacity.removedOnCompletion = NO;
    firstOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    scaleAni.fromValue = @1;
    scaleAni.toValue = @1.3;
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAni.beginTime = 0.6;
    scaleAni.fillMode = kCAFillModeForwards;
    scaleAni.removedOnCompletion = NO;
    scaleAni.duration = 0.5;
    
    CABasicAnimation *scaleAni0 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAni0.duration = 0.5;
    scaleAni0.beginTime = 1.2;
    scaleAni0.toValue = @0.8;
    scaleAni0.fillMode = kCAFillModeForwards;
    scaleAni0.removedOnCompletion = NO;
    scaleAni0.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:animationView.center];
    [linePath addLineToPoint:CGPointMake(50,120)];
    //    [linePath stroke];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = linePath.CGPath;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.beginTime =  2.0;
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *scaleLast = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleLast.beginTime = 2.0;
    scaleLast.duration = 0.5;
    //    scaleLast.fromValue = @1.0;
    scaleLast.removedOnCompletion = NO;
    scaleLast.fillMode = kCAFillModeForwards;
    scaleLast.toValue = @0.2;
    scaleLast.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *hidden = [CABasicAnimation animationWithKeyPath:@"opacity"];
    hidden.toValue = @0.2;
    hidden.beginTime = 2.0;
    hidden.duration = 0.5;
    hidden.removedOnCompletion = NO;
    hidden.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.animations = @[firstOpacity,scaleAni,scaleAni0,pathAnimation,scaleLast,hidden];
    group.duration = 2.5;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [animationView.layer addAnimation:group forKey:@"groupAni"];
}

#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        NSLog(@"动画结束");
        [self.animationView removeFromSuperview];

        if (self.dataArr.count > 0) {
            WKAuctionJoinModel *md = [self.dataArr firstObject];
            md.isFirst = NO;
        }
        self.currentJoinMd.isFirst = YES;
        [self.dataArr insertObject:self.currentJoinMd atIndex:0];
        
        [self.collectionView reloadData];
        _animtionStoped = YES;
        [self showAnimation];
    }
    self.onlineLabel.text = [NSString stringWithFormat:@"%lu参与",(unsigned long)_dataArr.count];
}

- (UIView *)participateViewWith:(WKAuctionJoinModel *)md{
    
    UIImage *bgImage = [UIImage imageNamed:@"light_back"];
    UIImage *bottomLineImage = [UIImage imageNamed:@"bottomLine"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height + bottomLineImage.size.height - 30)];
    
    UIImageView *bgImageV = [[UIImageView alloc] initWithImage:bgImage];
    bgImageV.frame = bgView.bounds;
    [bgView addSubview:bgImageV];
    
    UIImageView *bottomLineImageV = [[UIImageView alloc] initWithImage:bottomLineImage];
    bottomLineImageV.clipsToBounds = YES;
    bottomLineImageV.frame = CGRectMake(0, 0, bottomLineImage.size.width, bottomLineImage.size.height);
    bottomLineImageV.center = CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height - bottomLineImage.size.height + bottomLineImage.size.height/2);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, bottomLineImage.size.width - 10, bottomLineImage.size.height - 10)];
    lab.font = [UIFont boldSystemFontOfSize:16.0f];
    lab.text = md.CustomerName;
    lab.textColor = [UIColor colorWithHexString:@"#612822"];
    lab.textAlignment = NSTextAlignmentCenter;
    [bottomLineImageV addSubview:lab];
    
    
    
    UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bottomLineImage.size.width * 0.6, bottomLineImage.size.width * 0.6)];
    iconImageV.center = CGPointMake(bgView.frame.size.width/2, bgImageV.frame.size.height/2 + 20);
    iconImageV.layer.cornerRadius = bottomLineImage.size.width * 0.6/2;
    iconImageV.clipsToBounds = YES;
    iconImageV.layer.borderColor = [UIColor colorWithRed:0.27 green:0.00 blue:0.02 alpha:1.00].CGColor;
    iconImageV.layer.borderWidth = 1.0f;
    [bgView addSubview:iconImageV];
    [iconImageV sd_setImageWithURL:[NSURL URLWithString:md.CustomerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
    
    [bgView addSubview:bottomLineImageV];
    
    return bgView;
}

- (void)delayTime:(NSInteger)delaySeconds{
    _remainTime = delaySeconds;
    NSLog(@"remain time %ld",(long)_remainTime);
    [self formatShowRemainTime];
}

- (void)formatShowRemainTime{
    
//    NSInteger time = _remainTime;
    NSInteger hour = _remainTime/3600;
    NSInteger minute = (_remainTime - 3600 * hour)/60;
    NSInteger second = _remainTime - hour * 3600 - 60 * minute;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
    if (_remainTime <= 60) {
        [UIView animateWithDuration:0.3 animations:^{
            self.timeLabel.textColor = [UIColor colorWithRed:0.71 green:0.28 blue:0.39 alpha:0.5];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.timeLabel.textColor = [UIColor colorWithRed:0.71 green:0.28 blue:0.39 alpha:1.00];
            }];
        }];
    }
}

//MARK: CollectionView delegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKParticipateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WKParticipateCollectionViewCell class]) forIndexPath:indexPath];
    [cell setParticipate:_dataArr[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block(_dataArr[indexPath.row]);
    }
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    if (newWindow) {
        self.isShow = YES;
    }else{
        self.isShow = NO;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
