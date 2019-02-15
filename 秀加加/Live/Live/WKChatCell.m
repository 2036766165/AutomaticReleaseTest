//
//  WKChatCell.m
//  wdbo
//  
//  Created by sks on 16/7/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKChatCell.h"
#import "WKMessage.h"
#import "WKTopLeftLabel.h"
#import "YYAnimatedImageView.h"
#import "YYImage.h"
#import "WKLevelItemView.h"

@interface WKChatCell (){
//    UIButton *_nameBtn;
    UILabel *_contentLabel;
    YYAnimatedImageView *_animatedImage;
    UIView *_bgView;
    WKLevelItemView *_usericon;
    UIImageView *_redBagImageV;
    UIImageView *_systemIcon;
    
    UILabel *_descLabel;
    UILabel *_getLabel;
    UILabel *_redTypeLabel;
}

@end

@implementation WKChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 背景图
        UIView *bgView = [UIView new];
        [self.contentView addSubview:bgView];
        _bgView = bgView;
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_bgView addGestureRecognizer:bgTap];
        
        // 聊天用户头像
        WKLevelItemView *usericon = [[WKLevelItemView alloc] init];
        [_bgView addSubview:usericon];

        _usericon = usericon;
        
        UILabel *contentLab = [UILabel new];
        contentLab.font = [UIFont systemFontOfSize:14.0f];
        contentLab.textColor = [UIColor blackColor];
        contentLab.numberOfLines = 0;
        [contentLab sizeToFit];
        contentLab.lineBreakMode = NSLineBreakByCharWrapping;
        contentLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:contentLab];
        _contentLabel = contentLab;
        
        _animatedImage = [[YYAnimatedImageView alloc] init];
        [self.contentView addSubview:_animatedImage];
        
        _redBagImageV = [[UIImageView alloc] init];
        _redBagImageV.userInteractionEnabled = YES;
        [self.contentView addSubview:_redBagImageV];
        
        UITapGestureRecognizer *redTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_redBagImageV addGestureRecognizer:redTap];
        
        
        _systemIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redtopush_icon"]];
        [self.contentView addSubview:_systemIcon];
        
        // desc
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont systemFontOfSize:13.0f];
        _descLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:1.00];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.frame = CGRectMake(35, -7, 130, 40);
        [_redBagImageV addSubview:_descLabel];
        
        // get label
        _getLabel = [UILabel new];
        _getLabel.font = [UIFont systemFontOfSize:11.0f];
        _getLabel.textColor = [UIColor colorWithRed:0.98 green:0.79 blue:0.50 alpha:0.8];
        _getLabel.textAlignment = NSTextAlignmentLeft;
        _getLabel.frame = CGRectMake(35, 18, 100, 20);
        [_redBagImageV addSubview:_getLabel];
        
        _redTypeLabel = [UILabel new];
        _redTypeLabel.font = [UIFont systemFontOfSize:10.0f];
        _redTypeLabel.textColor = [UIColor lightGrayColor];
        _redTypeLabel.textAlignment = NSTextAlignmentLeft;
        _redTypeLabel.frame = CGRectMake(10, 37, 100, 15);
        [_redBagImageV addSubview:_redTypeLabel];
    }
    
    return self;
}

- (void)setMessage:(WKMessage *)message{
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    _contentLabel.text = message.content;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = YES;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];    
    _contentLabel.textColor = [UIColor whiteColor];
    _redBagImageV.hidden = YES;
    _systemIcon.hidden = YES;
    _bgView.hidden = NO;
    
    if (message.type == WKMessageTypeSystem) {
        _animatedImage.hidden = YES;
        _usericon.hidden = YES;
        _bgView.frame = CGRectMake(0, 2, message.labelWidth + 30, message.labelHeight);
        _contentLabel.frame = CGRectMake(15, 0, message.labelWidth, message.labelHeight);

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:message.content];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f9ac53"] range:NSMakeRange(0, message.name.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6600"] range:NSMakeRange(message.name.length + 1, message.content.length - message.name.length -1)];
        _contentLabel.attributedText = str;
        
    }else if (message.type == WKMessageTypeUser){
        _usericon.hidden = NO;
        _bgView.frame = CGRectMake(0, 2, message.labelWidth + 73, message.labelHeight);
        _contentLabel.frame = CGRectMake(70, 0, message.labelWidth, message.labelHeight);
        _usericon.frame = CGRectMake(7, -3, 60, 24);
        [_usericon setLevel:message.ml.integerValue];
        
        if ([message.usericon isKindOfClass:[NSNull class]]) {
            message.usericon = @"";
        }

        if (message.isGif) {
            _animatedImage.hidden = YES;
            _contentLabel.text = message.name;
            _contentLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
            _animatedImage.hidden = NO;
            _bgView.frame = CGRectMake(0, 2, message.labelWidth + 40, message.labelHeight);
            if (_bgView.frame.size.width >= _bgView.superview.frame.size.width - 10) {
                _animatedImage.frame = CGRectMake(_bgView.frame.size.width - 90 + 10, 30, 60, 60);
            }else{
                _animatedImage.frame = CGRectMake(_bgView.frame.size.width + _bgView.frame.origin.x + 10, 30, 60, 60);
            }
            
            _animatedImage.image = [YYImage imageNamed:message.gif];
            
        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",message.content]];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FC6620"] range:NSMakeRange(0, message.name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(message.name.length + 1, message.content.length - message.name.length -1)];
            _contentLabel.attributedText = str;
            _animatedImage.hidden = YES;
        }
        
    }else if (message.type == WKMessageTypeUserRedBag){
        _redBagImageV.hidden = NO;
        // red bag message
        _usericon.hidden = NO;
        _bgView.frame = CGRectMake(0, 2, message.labelWidth + 73, message.labelHeight);
        _contentLabel.frame = CGRectMake(70, 0, message.labelWidth, message.labelHeight);
        _usericon.frame = CGRectMake(7, -3, 60, 24);
        [_usericon setLevel:message.ml.integerValue];
        
        if ([message.usericon isKindOfClass:[NSNull class]]) {
            message.usericon = @"";
        }
        
        _contentLabel.text = message.name;
        _contentLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
        _animatedImage.hidden = YES;
        _bgView.frame = CGRectMake(0, 2, message.labelWidth + 40, message.labelHeight);
        
        UIImage *redBagImage = [UIImage imageNamed:@"redtopush_user"];
        if ((message.labelWidth + redBagImage.size.width + 70) > WKScreenW * 0.8) {
            _redBagImageV.frame = CGRectMake(_bgView.frame.origin.x, 33, redBagImage.size.width, redBagImage.size.height);
        }else{
            _redBagImageV.frame = CGRectMake(_bgView.frame.size.width + _bgView.frame.origin.x + 10, _bgView.frame.origin.y, redBagImage.size.width, redBagImage.size.height);
        }

        _redBagImageV.image = redBagImage;
        _redTypeLabel.text = message.desc;

        _getLabel.text = @"领取红包";
        if (message.tp.integerValue == 1) {
            _descLabel.text = @"群红包(普通)";
        }else{
            _descLabel.text = @"群红包(拼手气)";
        }
        
        _redTypeLabel.textColor = [UIColor lightGrayColor];
        
    }else if (message.type == WKMessageTypeSystemRedBag){
        UIImage *redBagImage = [UIImage imageNamed:@"redtopush_system"];
        _redBagImageV.image = redBagImage;

        _systemIcon.hidden = NO;
        _redBagImageV.hidden = NO;
        _bgView.hidden = YES;

        _systemIcon.frame = CGRectMake(5, 5, _systemIcon.image.size.width, _systemIcon.image.size.height);
        _redBagImageV.frame = CGRectMake(_systemIcon.frame.size.width + _systemIcon.frame.origin.x + 10, 5, redBagImage.size.width, redBagImage.size.height);
        
        _getLabel.text = @"领取红包";
        _descLabel.text = @"秀加加红包";
        _redTypeLabel.text = message.desc;

        _redTypeLabel.textColor = [UIColor whiteColor];
        
    }else{
        NSLog(@"ignore this message");
    }
    
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    if ([tap.view isKindOfClass:[UIImageView class]]) {
        if ([_delegate respondsToSelector:@selector(chatClick:type:)]) {
            [_delegate chatClick:self type:WKMessageClickTypeRed];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(chatClick:type:)]) {
            [_delegate chatClick:self type:WKMessageClickTypeInfo];
        }
    }
}

@end
