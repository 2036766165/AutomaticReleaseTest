//
//  WKOnlinePerson.m
//  wdbo
//
//  Created by sks on 16/7/2.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKOnlinePerson.h"
#import "WKOnLineMd.h"

@interface WKOnlinePerson (){
    UIImageView *_imageView;
//    UILabel *_nameLabel;
    UILabel *_lab;
    UIView *_bgView;
}
@end

@implementation WKOnlinePerson

@synthesize person = _person;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview];
    }
    return self;
}

- (void)addSubview{
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 35/2;
    bgView.clipsToBounds = YES;
    bgView.tag = 1005;
    bgView.backgroundColor = [UIColor colorWithRed:0.27 green:0.26 blue:0.28 alpha:0.6];
    [self addSubview:bgView];
    _bgView = bgView;

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_offset(CGSizeMake(35, 35));
    }];
    
    
    CGFloat imageWidth = 35;

    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = imageWidth/2;
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [UIColor clearColor].CGColor;
    _imageView.frame = CGRectMake(0, 0, imageWidth, imageWidth);
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
        
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
    }];
    
    UIImageView *level = [[UIImageView alloc]init];
    level.tag = 1001;
    [self addSubview:level];
    [level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_offset(imageWidth*0.1);
        make.size.sizeOffset(CGSizeMake(imageWidth*0.4, imageWidth*0.4));
    }];
    
    UILabel *numLab = [UILabel new];
    numLab.textColor = [UIColor whiteColor];
    numLab.font = [UIFont systemFontOfSize:10.0f];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.tag = 1002;
    [self addSubview:numLab];
    
    _lab = numLab;

    
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_imageView.center radius:imageWidth/2 startAngle:M_PI * 3/4 endAngle:M_PI/4 clockwise:YES];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    [_imageView.layer setMask:layer];
    
//    _nameLabel = [UILabel new];
//    _nameLabel.textColor = [UIColor whiteColor];
////    _nameLabel.text = @"123";
//    _nameLabel.clipsToBounds = YES;
//    _nameLabel.font = [UIFont systemFontOfSize:10.0f];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_nameLabel];
//    
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(20 *WKScaleH);
//        make.width.mas_offset(imageWidth * WKScaleH);
//        make.centerX.mas_equalTo(_imageView.mas_centerX).offset(0);
//        make.top.mas_equalTo(_imageView.mas_bottom).offset(-5 * WKScaleH);
//    }];
    
}

- (void)setPerson:(WKOnLineMd *)person{
    
    if (person) {
        if (person.isAddItem) {
            _bgView.hidden = NO;
            _lab.hidden = NO;
            UIImageView *preImageV = [self viewWithTag:1001];
            preImageV.hidden = YES;
            
            _imageView.image = [UIImage imageNamed:@"online_audience"];
            _imageView.layer.borderColor = [UIColor clearColor].CGColor;
            _imageView.layer.cornerRadius = 0;
            _imageView.layer.borderWidth = 1.5;
            
            [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(20, 20));
                make.center.mas_offset(CGPointMake(0, -5));
            }];
            
            _lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)person.totalPerson];

            [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(35, 10));
                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                make.centerX.mas_equalTo(_imageView);
            }];
            
        }else{
            UIImageView *preImageV = [self viewWithTag:1001];
            preImageV.hidden = NO;

            _lab.hidden = YES;
            _bgView.hidden = YES;
            
            _person = person;
            //        _nameLabel.text = person.MemberName;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:person.MemberPhotoMinUrl] placeholderImage:[UIImage imageNamed:@"zanwutouxiang"]];
            _imageView.layer.cornerRadius = 35/2;
            _imageView.layer.borderWidth = 1.5;
            _imageView.layer.borderColor = [UIColor whiteColor].CGColor;

            
            [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.size.mas_offset(CGSizeMake(35, 35));
            }];
            
            UIImageView *im = (UIImageView*)[self viewWithTag:1001];
            im.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",person.ml.integerValue>10?@"10":person.ml]];
            if (person.BanType.integerValue != 0) {
                
                UIImageView *preImageV = [self viewWithTag:100];
                [preImageV removeFromSuperview];
                
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.tag = 100;
                [self addSubview:imageView];
                
                CGFloat imageWidth = 35;
                
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self);
                    make.size.mas_offset(CGSizeMake(imageWidth, imageWidth));
                }];
                
                if (person.BanType.integerValue == 1){
                    imageView.image = [UIImage imageNamed:@"mute_owner"];
                    
                }else{
                    imageView.image = [UIImage imageNamed:@"mute_system"];
                }
                
            }else{
                
                UIImageView *preImageV = [self viewWithTag:100];
                if (preImageV) {
                    [preImageV removeFromSuperview];
                }
            }
        }
        
    }
}

- (WKOnLineMd *)person{
    return _person;
}

@end
