//
//  WKPopverCell.m
//  show++
//
//  Created by sks on 16/8/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKPopverCell.h"
#import "PopoverView.h"

@interface WKPopverCell (){
    UILabel *_titleLabel;
    UIImageView *_iconImage;
}

@end

@implementation WKPopverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImage = [UIImageView new];
//        _iconImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconImage];
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.mas_offset(10);
            make.size.mas_offset(CGSizeMake(23, 23));
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImage.mas_right).offset(5);
            make.centerY.mas_equalTo(_iconImage.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-5);
            make.height.mas_offset(25);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    
//    if ([_delegate respondsToSelector:@selector(itemSelectedWith:)]) {
//        [_delegate itemSelectedWith:self];
//    }
    if (self.selectedInex) {
        self.selectedInex(self);
    }
}

- (void)setItem:(WKPopverItem *)item{
    _titleLabel.text = item.itemName;

//    UIImage *image = [UIImage imageNamed:item.itemImage];
//    [_iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_offset(image.size);
//    }];
    
    if (item.isSelected) {
        _titleLabel.textColor = MAIN_COLOR;
        _iconImage.image = [UIImage imageNamed:item.itemSelctedImage];
    }else{
        _titleLabel.textColor = [UIColor whiteColor];
        _iconImage.image = [UIImage imageNamed:item.itemImage];
    }
}

@end
