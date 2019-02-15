//
//  WKAddressItemTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddressItemTableViewCell.h"
#import "WKAddressItem.h"

@interface WKAddressItemTableViewCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (strong, nonatomic)  UIImageView *selectFlagImgView;
@end

@implementation WKAddressItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
      
                [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UILabel *lab = [UILabel new];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:lab];
 
    UIImage *flagImage = [UIImage imageNamed:@"btn_check"];
    UIImageView *imgv=[[UIImageView alloc] init];
    imgv.image=flagImage;
    [self.contentView addSubview:imgv];
    imgv.hidden=YES;
    self.titleLabel = lab;
    self.selectFlagImgView=imgv;
   
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView);
//        make.left.mas_offset(20);
//        make.top.mas_offset(10);
//        make.width.mas_greaterThanOrEqualTo(50);
//    }];
//    
//    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.titleLabel.mas_right).offset(-20);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
//         //make.top.mas_offset(10);
//        
//        make.size.mas_equalTo(imgv.image.size);
//    }];
}

- (void)setItem:(WKAddressItem *)item{
    self.titleLabel.text = item.name;
    
    self.selectFlagImgView.hidden = !item.isSelected;
    
      CGSize contentSize = [NSString sizeWithText:self.titleLabel.text font:self.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_offset(20);
        make.top.mas_offset(10);
        make.width.mas_greaterThanOrEqualTo(contentSize.width);
    }];
    
    [self.selectFlagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(0);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
        //make.top.mas_offset(10);
        
        make.size.mas_equalTo(self.selectFlagImgView.image.size);
    }];
     if (item.isSelected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
           }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#2E2E2E"];
       
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
