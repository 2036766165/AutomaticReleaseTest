//
//  WKSearchTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/9/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSearchTableViewCell.h"
#import <MapKit/MapKit.h>

@interface WKSearchTableViewCell (){
    MKMapItem *_item;
}

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *locationLabel;

@end

@implementation WKSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    //位置图标
    UIImage *image = [UIImage imageNamed:@"location"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(image.size);
        make.left.mas_offset(30);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 位置名
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:16.0f];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_equalTo(imageView.mas_right).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_offset(30);
    }];
    
    // 位置
    UILabel *addressLabel = [UILabel new];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.font = [UIFont systemFontOfSize:14.0f];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:addressLabel];
    self.locationLabel = addressLabel;
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.mas_equalTo(imageView.mas_right).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_offset(30);
    }];
}

- (void)setModel:(id)model searchText:(NSString *)searchText{
    MKMapItem *item = model;
    _item = item;
    
    NSDictionary *dict = item.placemark.addressDictionary;
    
    NSLog(@"item address : %@",dict);
    
    self.nameLabel.text = item.name;
    self.locationLabel.text = item.placemark.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
