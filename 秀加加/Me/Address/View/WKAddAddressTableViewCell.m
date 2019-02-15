//
//  WKAddAddressTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddAddressTableViewCell.h"

@implementation WKAddAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{

    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 101;
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.height.mas_offset(20);
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    // 其他的输入
    CGFloat textWidth;
    if (WKScreenH > WKScreenW) {
        // 竖屏
        textWidth = WKScreenW - 90 - 20;
    }else{
        // 横屏
        textWidth = WKScreenH - 90 -20;
    }
    
    // 地址输入
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:textView];
    self.contentTextView = textView;
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY).offset(0);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.width.mas_offset(textWidth);
        make.height.mas_equalTo(20);
    }];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:textField];
    self.contentTextField = textField;
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(textWidth, 20));
    }];
    
    
}

//-(void)setLabelText:(NSString *)labelText
//{
//    CGSize lblSize = [labelText sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 15)];
//    self.titleLabel.text = labelText;
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.centerY.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(lblSize.width + 1, 15));
//    }];
//    
//    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self);
//        make.left.mas_equalTo(self.titleLabel.mas_right).offset(0);
//        make.size.mas_equalTo(CGSizeMake(WKScreenW - lblSize.width - 10 - 10, 15));
//    }];
//    
//    [self.titleLabel layoutIfNeeded];
//    [self.contentTextView layoutIfNeeded];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
