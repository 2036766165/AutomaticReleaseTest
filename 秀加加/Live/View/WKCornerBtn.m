//
//  WKCornerBtn.m
//  秀加加
//
//  Created by sks on 2016/12/16.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCornerBtn.h"
#import <objc/message.h>

//void (*sendMsg)(id obj,SEL sel) = objc_msgSend();

@interface WKCornerBtn (){
    UIColor *_borderColor;
    
    UILabel *_titleLabel;
    
    id _target;
    SEL _sel;
}

@end

@implementation WKCornerBtn

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName borderColor:(UIColor *)borderColor{
    if (self = [super initWithFrame:frame]) {
        // 161216164552115542 161216164642131454
        
        self.backgroundColor = [UIColor whiteColor];
        _borderColor = borderColor;
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        imageView.center = CGPointMake(frame.size.width/2, frame.size.height/2 - 20);
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.size.mas_offset(image.size);
            make.centerX.mas_equalTo(self);
        }];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:lab];
        
        _titleLabel = lab;
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(imageView.mas_centerX);
            make.left.mas_equalTo(self.mas_left).offset(5);
            make.right.mas_equalTo(self.mas_right).offset(-5);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
//    sendMsg(_target,_sel);
    if ([_target respondsToSelector:_sel]) {
        //objc_msgSend(_target,_sel);
//        (void (*)(id,SEL)objc_msgSend)(_target,_sel);
       // ((void (*)(id, SEL))objc_msgSend)((id)msg, @selector(noArgumentsAndNoReturnValue));
        ((void (*)(id,SEL,id))objc_msgSend)((id)_target,_sel,self);
    }
}

- (void)addTarget:(id)target sel:(SEL)sel{
    _target = target;
    _sel = sel;
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)drawRect:(CGRect)rect{
    self.layer.cornerRadius = CGRectGetWidth(rect)/2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = _borderColor.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
