//
//  WKVideoPauseView.m
//  秀加加
//
//  Created by sks on 2016/10/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKVideoPauseView.h"
#import "UIImage+Gif.h"
#import "NSObject+XWAdd.h"
#import "WKScrollLabel.h"
#import "WKHomePlayModel.h"

@interface WKVideoPauseView (){
    ShowTypeEnum _showType; //1.直播加载 2.暂时离开
//    NSString *_memberPhoto;
    WKHomePlayModel *_tempMd;
}

@property (nonatomic,strong) UIImageView *bgImage;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *animationImage;
@property (nonatomic,strong) UILabel *reminderLabel;
@property (nonatomic,strong) UIVisualEffectView *VFView;

@property (nonatomic,strong) WKScrollLabel *nameLabel;

@property (nonatomic,strong) UIImageView *levelImageV;

@end

@implementation WKVideoPauseView

- (instancetype)initWithFrame:(CGRect)frame PlayModel:(WKHomePlayModel *)model
{
    if (self = [super initWithFrame:frame]) {
        _tempMd = model;
        [self setupViewsWithScreenType];
    }
    return self;
}

- (WKScrollLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[WKScrollLabel alloc] initWithSuperViewWidth:WKScreenW/3];
    }
    return _nameLabel;
}


- (void)setupViewsWithScreenType{
    //设置背景虚化
    self.bgImage = [[UIImageView alloc] init];
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:_tempMd.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
    self.VFView = [WKPromptView GetImageVisualView:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    [self.bgImage addSubview:self.VFView];
    [self addSubview:self.bgImage];
    [self.bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *bgView = [UIView new];
    [self addSubview:bgView];
    self.bgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(WKScreenW, WKScreenH));
    }];
    
    // 运动的图片
    UIImageView *animationImage = [[UIImageView alloc] init];
    NSString *gifName = _showType == StartShow ? @"login_wating" : @"leave";
    CGSize gifSize = _showType == StartShow ? CGSizeMake(160, 160 * 256 / 320) : CGSizeMake(100, 100 * 256 / 167);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    animationImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:filePath]];
    [bgView addSubview:animationImage];
    self.animationImage = animationImage;
    [self.animationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(self.bgView.mas_top).offset(WKScreenH * 0.25);
        make.size.sizeOffset(gifSize);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:14.0f];
    [bgView addSubview:label4];
    self.reminderLabel = label4;
    self.reminderLabel.text = _showType == StartShow ? @"" : @"店主暂时离开，不要走开，马上回来哦!";

    [self.bgView addSubview:self.nameLabel];
    self.nameLabel.hidden = YES;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.animationImage.mas_bottom).offset(5);
        make.left.and.right.mas_offset(0);
        make.height.mas_offset(25);
    }];
    self.nameLabel.text = _tempMd.MemberName;
    
    [self.reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(bgView);
        make.width.mas_equalTo(bgView);
        make.height.mas_offset(@25);
    }];
    
    NSString *imageName = [NSString stringWithFormat:@"level%@",_tempMd.LoginMemberLevel];
    
    UIImageView *levelImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.bgView addSubview:levelImageV];
    self.levelImageV = levelImageV;
    self.levelImageV.hidden = YES;
    
    [self.levelImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(15, 15));
        make.bottom.mas_equalTo(self.animationImage.mas_bottom).offset(-7);
        make.right.mas_equalTo(self.animationImage.mas_right).offset(-7);
    }];
    
}

- (void)setLiveType:(ShowTypeEnum)type rect:(CGRect)rect{
    _showType = type;

    if (type == StartShow) {
        // back show
        
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        NSString *gifName = _showType == StartShow ? @"login_wating" : @"leave";
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        self.animationImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:filePath]];
        self.animationImage.layer.cornerRadius = 0;
        self.animationImage.clipsToBounds = NO;
        
        [self.animationImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.top.mas_equalTo(self.bgView.mas_top).offset(WKScreenH * 0.25);
            make.size.mas_equalTo(CGSizeMake(100, 100 * self.animationImage.image.size.height/self.animationImage.image.size.width));
        }];
        
        self.nameLabel.hidden = YES;
        self.levelImageV.hidden = YES;
        self.reminderLabel.text =  _showType == StartShow ? @"" : @"店主暂时离开，不要走开，马上回来哦!";
        
        [self layoutIfNeeded];

    }else if (type == LeavingOnLive){
        
        self.VFView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH);
        
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        NSString *gifName = @"leave";
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        self.animationImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:filePath]];
        self.animationImage.layer.cornerRadius = 0;
        self.animationImage.clipsToBounds = NO;
        
        [self.animationImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.top.mas_equalTo(self.bgView.mas_top).offset(WKScreenH * 0.25);
            make.size.mas_equalTo(CGSizeMake(100, 100 * 256/167));
        }];
        
        self.nameLabel.hidden = YES;
        self.levelImageV.hidden = YES;
        self.reminderLabel.text =  @"店主暂时离开，不要走开，马上回来哦!";
        
        [self layoutIfNeeded];
    }
    else{
        self.VFView.frame = CGRectMake(0, 0, WKScreenW/3, WKScreenH/4);
        // to goods detail
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.centerX.mas_equalTo(self);
            make.size.sizeOffset(CGSizeMake(WKScreenW/3, WKScreenH/4));
        }];
        
        [self.animationImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.top.mas_equalTo(self.bgView.mas_top).offset(WKScreenH/4 * 0.2);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.levelImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(15, 15));
            make.bottom.mas_equalTo(self.animationImage.mas_bottom).offset(-1);
            make.right.mas_equalTo(self.animationImage.mas_right).offset(-1);
        }];
        
        self.animationImage.layer.cornerRadius = 25;
        self.animationImage.clipsToBounds = YES;
        self.nameLabel.hidden = NO;
        self.levelImageV.hidden = NO;
        [self.animationImage sd_setImageWithURL:[NSURL URLWithString:_tempMd.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"default_02"]];
        self.reminderLabel.text = @"店主暂时离开";
        [self layoutIfNeeded];
    }
    self.VFView.frame = rect;
}


@end
