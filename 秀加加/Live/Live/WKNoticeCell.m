//
//  WKNoticeCell.m
//  wdbo
//
//  Created by sks on 16/7/4.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKNoticeCell.h"
#import "WKOrderNoticeModel.h"

@interface WKNoticeCell (){
    
    UILabel *_timeLabel;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    WKListNoticeInfo *_tempMd;
}

@end


@implementation WKNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        self.backgroundColor = [UIColor clearColor];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(2 * WKScaleH, 4 * WKScaleH, 2, 4 * WKScaleH));
        }];
        
        // 标题
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = MAIN_COLOR;
        [bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_offset(2);
            make.left.mas_offset(2);
            make.size.mas_offset(CGSizeMake(80, 40));
        }];
        
        // 时间
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        //_timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(_titleLabel.mas_centerY).offset(0);
            make.right.mas_equalTo(bgView.mas_right).offset(-5);
            make.height.mas_offset(30);
            make.left.mas_equalTo(_titleLabel.mas_right).offset(3);
        }];
        
        // 内容
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(4);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(3);
            make.right.mas_offset(-2);
            make.width.mas_offset(WKScaleH * 160 - 4);
        }];
        
    }

    return self;
}

- (void)setModel:(WKListNoticeInfo *)md{
    if (md) {
        _tempMd = md;
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *newsTitle = @"";
    
    switch (_tempMd.NoticeType.integerValue) {
        case 1:
            newsTitle = @"订单信息";
            break;
        case 2:
            newsTitle = @"物流信息";
            break;
        case 3:
            newsTitle = @"打赏信息";
            break;
            
        default:
            break;
    }
    
    _titleLabel.text = newsTitle;
    
    _timeLabel.text = [_tempMd.CreateTime substringWithRange:NSMakeRange(0, 10)];
    _contentLabel.text = _tempMd.Message;

}

@end
