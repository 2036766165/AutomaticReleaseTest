//
//  WKTagCell.m
//  aa
//
//  Created by Chang_Mac on 16/9/21.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import "WKTagCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "NSObject+XCTag.h"
@implementation WKTagCell{
    UIView *_borderView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"tagNum" object:nil];
    
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
    [self.contentView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(WKScreenW/3);
        make.top.mas_offset(0);
        make.width.mas_offset(1);
        make.bottom.mas_offset(-10);
    }];
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
    [self.contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(WKScreenW/3*2);
        make.top.mas_offset(0);
        make.width.mas_offset(1);
        make.bottom.mas_offset(-10);
    }];
}

-(void)setModel:(WKTagModel *)model{
    if (_model != model) {
        _model = model;
        NSDictionary *tagDic = [NSDictionary dicWithJsonStr:User.ShopTag];
        NSArray *titleArr = [tagDic objectForKey:@"titleArr"];
        for (int i = 0 ;i < model.TagList.count; i++ ) {
            WkTagTitle *item = model.TagList[i];
            NSInteger buttonY = i/3;
            UIButton *button = [[UIButton alloc]init];
            [button setTitleColor:[UIColor colorWithHexString:item.TagColor] forState:UIControlStateNormal];
            button.titleModel = item;
            [button setTitle:item.TagName forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tagCellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(WKScreenW/3*(i%3));
                make.top.mas_offset(50*buttonY);
                make.size.mas_equalTo(CGSizeMake(WKScreenW/3, 50));
            }];
            _borderView = [[UIView alloc]init];
            _borderView.layer.borderColor = [UIColor colorWithHexString:@"ff6600"].CGColor;
            _borderView.tag = button.tag;
            _borderView.layer.borderWidth = 1;
            _borderView.layer.cornerRadius = 18;
            _borderView.layer.masksToBounds = YES;
            [button addSubview:_borderView];
            [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(8);
                make.top.mas_offset(5);
                make.right.mas_offset(-8);
                make.bottom.mas_offset(-8);
            }];
            _borderView.userInteractionEnabled = NO;
            _borderView.hidden = YES;
            for (NSString *tagName in titleArr) {
                if ([item.TagName isEqualToString:tagName]) {
                    _borderView.hidden = NO;
                    button.selected = !button.selected;
                    break;
                }
            }
            if (buttonY <(NSInteger)(model.TagList.count-1)/3) {
                NSLog(@"%lu,,,%lu",(long)buttonY,model.TagList.count/3);
                _lineView = [[UIView alloc]init];
                _lineView.tag = 1000000;
                _lineView.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
                [button addSubview:_lineView];
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(0);
                    make.bottom.equalTo(button.mas_bottom).offset(-1);
                    make.size.mas_equalTo(CGSizeMake(WKScreenW/3, 1));
                }];
            }
        }
    }
}

-(void)tagCellButtonAction:(UIButton *)tagButton{
    for (UIView *view in tagButton.subviews) {
        if (view.tag == tagButton.tag) {
            view.hidden = tagButton.selected;
        }
    }
    tagButton.selected = !tagButton.selected;
    
    if (self.tagBlock) {
        self.tagBlock(tagButton.selected,tagButton.titleModel,tagButton);
    }
}
-(void)notificationAction:(NSNotification *)noti{
    UIButton *tagBtn = [noti.userInfo objectForKey:@"btn"];
    for (UIView *view in tagBtn.subviews) {
        if (view.tag == tagBtn.tag) {
            view.hidden = tagBtn.selected;
        }
    }
}

@end






