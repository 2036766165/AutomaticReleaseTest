//
//  WKSelectAuctionView.m
//  秀加加
//
//  Created by sks on 2017/2/16.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKSelectAuctionView.h"

@interface WKSelectAuctionView (){
    NSUInteger _type; // 0 拍卖 1 筹卖
}
@property (nonatomic,strong) UIButton *startBtn;
@property (nonatomic,strong) UIButton *detailBtn;

@property (nonatomic,strong) UIView *descView;

@end

@implementation WKSelectAuctionView

- (instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        // background imageView
        UIImage *bgImage = [UIImage imageNamed:@"item_back"];
        
        UIImageView *bgImageV = [[UIImageView alloc] initWithImage:bgImage];
        bgImageV.frame = self.bounds;
        [self addSubview:bgImageV];
        
        // auction type
        NSString *imageName;
        NSString *btnTitle;
        if (type == 0) {
            btnTitle = @"发起拍卖";
            imageName = @"auction_type";
        }else{
            btnTitle = @"发起幸运购";
            imageName = @"crowd";
        }
        UIImage *typeImage = [UIImage imageNamed:imageName];
        
        UIImageView *infoImageV = [[UIImageView alloc] initWithImage:typeImage];
        infoImageV.frame = CGRectMake(0, 0, infoImageV.image.size.width, infoImageV.image.size.height);
        infoImageV.center = CGPointMake(self.bounds.size.width/2, 0);
        [self addSubview:infoImageV];
        
        // start auction
        UIImage *btnImage = [UIImage imageNamed:@"start_detail"];
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        startBtn.tag = 10;
        startBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [startBtn setTitle:btnTitle forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        startBtn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
        startBtn.center = CGPointMake(bgImage.size.width/2, bgImage.size.height/2);
        
        [self addSubview:startBtn];
        self.startBtn = startBtn;
        
        // show detail
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.tag = 11;
        detailBtn.backgroundColor = [UIColor clearColor];
        [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00] forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [detailBtn setImage:btnImage forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
        detailBtn.frame = CGRectMake(0, 0, 80, 30);
        detailBtn.center = CGPointMake(bgImage.size.width/2, startBtn.frame.origin.y + startBtn.frame.size.height + 15 + 10);
        [self addSubview:detailBtn];
        self.detailBtn = detailBtn;
        
        // arrow
        UIImage *arrowImage = [UIImage imageNamed:@"arrow_unselected"];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImage];
        arrow.frame = CGRectMake(detailBtn.frame.origin.x + detailBtn.frame.size.width , detailBtn.frame.origin.y + (detailBtn.frame.size.height - arrow.image.size.height)/2, arrowImage.size.width, arrowImage.size.height);
//        arrow.center = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
        arrow.tag = 1001;
        [self addSubview:arrow];
        
        // 描述
        self.descView = [self setupDescView];
        [self addSubview:self.descView];
        self.descView.hidden = YES;
        
//        if (_type == 0) {
//            [self startClick:detailBtn];
//        }
    }
    return self;
}

- (void)showDescription:(BOOL)isShow{
    
    self.descView.hidden = !isShow;
    
    UIImageView *arrow = [self viewWithTag:1001];
    CGFloat transAngle = isShow?M_PI/2:0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.detailBtn.selected = !self.detailBtn.selected;
        arrow.transform = CGAffineTransformMakeRotation(transAngle);
    } completion:^(BOOL finished) {
    }];
    
//    [self startClick:];
}

- (UIView *)setupDescView{
    UIImage *bgImage = [UIImage imageNamed:@"item_back"];
    // 标题
    CGRect rect = CGRectMake(0, bgImage.size.height + 30, bgImage.size.width * 2 + 20, 180);

    NSString *imageName = _type == 0?@"item_backgroud":@"item_backgroundright";
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((rect.size.width - 100)/2, 15, 100, 25)];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    // 介绍
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 50, rect.size.width - 20, rect.size.height - 100)];
    descLabel.numberOfLines = 0;
    descLabel.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    descLabel.font = [UIFont systemFontOfSize:14.0f];
    descLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    descLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:descLabel];
    
    // 介绍
    NSString *title = @"";
    NSString *desc = @"";
//    CGFloat height;
    
    if (_type == 0) {
        title = @"拍卖说明";
//        desc = @"宝贝虽昂贵，人人有机会，幸运购教你玩儿！通过幸运购，把一件宝贝分成若干份，让小伙伴们一起来的筹集购买，再由一位幸运者拔得头筹。\n 1.幸运购期间,幸运购总额未达到设定额度，则失败，退还所有筹卖金\n 2.幸运购成功,平台收取10%服务费，幸运购失败无任何费用\n 3.幸运购宝贝随机发放，购买额度越高，中奖几率越大\n 4.幸运购发起后，不可强制结束";
        
        NSArray *reminderListArr = @[
                                     @"宝贝身价飙升，物尽其值，直播间即是拍卖场，全民举牌，价高者得！ ",
                                     @"1.起拍价即为保证金，参与拍卖需要提交保证金.",
                                     @"2.拍卖成功，平台收取10%服务费，拍卖失败无任何费用.",
                                     @"3.拍卖结束时，出价最高者获得宝贝",
                                     @"4.拍卖发起后，不可强制结束"
                                     ];
        
        desc = [reminderListArr componentsJoinedByString:@"\n"];
        CGFloat height = [NSString sizeWithText:desc font:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(rect.size.width - 20, MAXFLOAT)].height;

        rect = CGRectMake(0, bgImage.size.height + 15, bgImage.size.width * 2 + 20, 70 + height);

        CGFloat cornerRadius = 5.0,triangle = 8.0;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.0;
        [path moveToPoint:CGPointMake(cornerRadius+1, triangle)];
        [path addLineToPoint:CGPointMake((rect.size.width-20)/4 - 5, triangle)];
        [path addLineToPoint:CGPointMake((rect.size.width-20)/4, 0)];
        [path addLineToPoint:CGPointMake((rect.size.width-20)/4 + 5, triangle)];
        [path addLineToPoint:CGPointMake(rect.size.width - cornerRadius - 1, triangle)];
        
        [path addQuadCurveToPoint:CGPointMake(rect.size.width - 1, triangle + cornerRadius) controlPoint:CGPointMake(rect.size.width - 1, triangle)]; //
        
        [path addLineToPoint:CGPointMake(rect.size.width - 1, rect.size.height - cornerRadius)];
        
        [path addQuadCurveToPoint:CGPointMake(rect.size.width - cornerRadius - 1, rect.size.height-1) controlPoint:CGPointMake(rect.size.width - 1, rect.size.height - 1)]; //
        
        [path addLineToPoint:CGPointMake(cornerRadius+1, rect.size.height-1)];
        
        [path addQuadCurveToPoint:CGPointMake(1, rect.size.height - cornerRadius) controlPoint:CGPointMake(1, rect.size.height)]; //
        
        [path addLineToPoint:CGPointMake(1, cornerRadius + triangle)];
        [path addQuadCurveToPoint:CGPointMake(cornerRadius+1, triangle) controlPoint:CGPointMake(1, triangle)]; //
        [path closePath];
        
        descLabel.frame = CGRectMake(8, 40, rect.size.width - 20, height);
        
    }else{
        title = @"幸运购说明";
        desc = @"宝贝虽昂贵，人人有机会，幸运购教你玩儿！通过幸运购，把一件宝贝分成若干份，让小伙伴们一起来的筹集购买，再由一位幸运者拔得头筹。\n 1.幸运购期间,幸运购总额未达到设定额度，则失败，退还所有筹卖金\n 2.幸运购成功,平台收取10%服务费，幸运购失败无任何费用\n 3.幸运购宝贝随机发放，购买额度越高，中奖几率越大\n 4.幸运购发起后，不可强制结束";
        
        CGFloat height = [NSString sizeWithText:desc font:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(rect.size.width - 20, MAXFLOAT)].height;
        
        rect = CGRectMake( -(20 + bgImage.size.width), bgImage.size.height + 15, bgImage.size.width * 2 + 20, 70 + height);
        
        CGFloat cornerRadius = 5.0,triangle = 8.0;

        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.0;
        [path moveToPoint:CGPointMake(cornerRadius+1, triangle)];
        [path addLineToPoint:CGPointMake((rect.size.width-20)/4 - 5 + bgImage.size.width + 20, triangle)];
        [path addLineToPoint:CGPointMake((rect.size.width-20)/4 + bgImage.size.width + 20, 0)];
        [path addLineToPoint:CGPointMake((rect.size.width-20)/4 + 5 + bgImage.size.width + 20, triangle)];
        [path addLineToPoint:CGPointMake(rect.size.width - cornerRadius - 1, triangle)];
        
        [path addQuadCurveToPoint:CGPointMake(rect.size.width - 1, triangle + cornerRadius) controlPoint:CGPointMake(rect.size.width - 1, triangle)]; //
        
        [path addLineToPoint:CGPointMake(rect.size.width - 1, rect.size.height - cornerRadius)];
        
        [path addQuadCurveToPoint:CGPointMake(rect.size.width - cornerRadius - 1, rect.size.height-1) controlPoint:CGPointMake(rect.size.width - 1, rect.size.height - 1)]; //
        
        [path addLineToPoint:CGPointMake(cornerRadius+1, rect.size.height-1)];
        
        [path addQuadCurveToPoint:CGPointMake(1, rect.size.height - cornerRadius) controlPoint:CGPointMake(1, rect.size.height)]; //
        
        [path addLineToPoint:CGPointMake(1, cornerRadius + triangle)];
        [path addQuadCurveToPoint:CGPointMake(cornerRadius+1, triangle) controlPoint:CGPointMake(1, triangle)]; //
        [path closePath];
        
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        shapeLayer.path = path.CGPath;
//        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
//        shapeLayer.fillColor = [[UIColor colorWithRed:0.29 green:0.26 blue:0.28 alpha:1.00] colorWithAlphaComponent:0.6].CGColor;
//        
//        [bgView.layer addSublayer:shapeLayer];
//        bgView.clipsToBounds = YES;
        
        descLabel.frame = CGRectMake(8, 40, rect.size.width - 20, height);
    }
    
    bgView.frame = rect;
    
    titleLabel.text = title;
    descLabel.text = desc;
    
    return bgView;
}

- (void)startClick:(UIButton *)btn{
    if (btn.tag == 10) {
        // 发起拍卖
        self.descView.hidden = YES;
        btn.selected = !btn.selected;
        if ([_delegate respondsToSelector:@selector(selectedType:)]) {
            [_delegate selectedType:_type];
        }
    }else{
        // 查看详情
//        if (btn.selected) {
//            
//        }else{
//            
//        }
        btn.selected = !btn.selected;
        if ([_delegate respondsToSelector:@selector(showInfoType:)]) {
            [_delegate showInfoType:_type];
        }
//        [self showDescription:YES];
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
