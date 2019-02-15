//
//  WKTitleChooseView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKTitleChooseView.h"

@interface WKTitleChooseView ()

@property (strong, nonatomic) NSArray * titleArr;

@property (strong, nonatomic) NSArray * colorArr;

@property (strong, nonatomic) UIView * circleView;

@property (strong, nonatomic) NSMutableArray * circleArr;

@property (strong, nonatomic) NSMutableArray * buttonArr;

@property (assign, nonatomic) NSInteger count;

@end

@implementation WKTitleChooseView

-(instancetype)initWithData:(NSMutableArray *)titleArr andColor:(NSMutableArray *)colorArr type:(titleChooseType)type block:(titleChooseBlock)block{
    if (self = [super init]) {
        self.block = block;
        self.titleArr = titleArr;
        self.colorArr = colorArr;
        self.circleArr = [NSMutableArray new];
        self.buttonArr = [NSMutableArray new];
        self.count = 0;
        [self createUI:type];
    }
    return self;
}
-(void)createUI:(titleChooseType)type{
    self.alpha = 0.9;
    for (int i = 0 ; i < self.titleArr.count ; i ++) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor colorWithHexString:self.colorArr[i]] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        button.layer.borderWidth = 0.5;
        NSLog(@"%lu,%d",(unsigned long)self.titleArr.count,i);
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.buttonArr addObject:button];
        NSInteger list = i/3;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i%3*WKScreenW/3);
            make.top.mas_equalTo(list*55);
            make.width.mas_equalTo(WKScreenW/3);
            make.height.mas_equalTo(55);
        }];
    
        if (type == buttonCircle) {
            self.circleView = [[UIView alloc]init];
            self.circleView.backgroundColor = [UIColor clearColor];
            self.circleView.layer.cornerRadius = 35/2;
            self.circleView.layer.borderColor = [UIColor colorWithHexString:self.colorArr[i]].CGColor;
            self.circleView.userInteractionEnabled = NO;
            self.circleView.layer.borderWidth = 1;
            [self.circleArr addObject:self.circleView];
            [button addSubview:self.circleView];
            [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_left).offset(3);
                make.right.equalTo(button.mas_right).offset(-3);
                make.top.equalTo(button.mas_top).offset(3);
                make.bottom.equalTo(button.mas_bottom).offset(-3);
            }];
            self.circleView.hidden = YES;
        }
    }
}
-(void)buttonAction:(UIButton *)button{
    if (self.type!=2) {
        [self circleHidden];
    }
    if (button.selected) {
        self.count --;
        NSLog(@"%ld",(long)self.count);
    }else{
        self.count ++;
        NSLog(@"%ld",(long)self.count);
    }
    if (self.count > 5) {
        if (self.tagNumBlock) {
            self.tagNumBlock();
        }
        self.count = 5;
        return;
    }
    if (button.selected) {
        for (UIView *item in button.subviews) {
            if ([item isKindOfClass:[UIView class]]) {
                item.hidden = YES;
            }
        }
    }else{
        for (UIView *item in button.subviews) {
            if ([item isKindOfClass:[UIView class]]) {
                if (self.type == 2) {
                    item.layer.borderColor = [UIColor colorWithHexString:@"ff6600"].CGColor;
                }
                item.hidden = NO;
            }
        }
    }
    button.selected = !button.selected;
    self.block(self.colorArr[button.tag-1],button.currentTitle);
}

-(void)circleHidden{
    self.count = 0;
    for (UIView *item in self.circleArr) {
        item.hidden = YES;
    }
    for (UIButton *item in self.buttonArr) {
        item.selected = NO;
    }
}

@end
