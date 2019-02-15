//
//  WKParticipateCollectionViewCell.m
//  秀加加
//
//  Created by sks on 2017/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKParticipateCollectionViewCell.h"
#import "WKAuctionStatusModel.h"

@interface WKParticipateCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UIImageView *levelImageV;

@end
@implementation WKParticipateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // user icon
        UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:iconImageV];
        self.iconImageV = iconImageV;
        
        // level mark image
        UIImageView *levelImageV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 12, frame.size.height - 12, 12, 12)];
        levelImageV.image = [UIImage imageNamed:@"higest"];
        [self.contentView addSubview:levelImageV];
        self.levelImageV = levelImageV;
        
        self.iconImageV.layer.cornerRadius = self.iconImageV.frame.size.width/2;
        self.iconImageV.clipsToBounds = YES;
        
    }
    return self;
}

- (void)setParticipate:(WKAuctionJoinModel *)person{
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:person.CustomerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
    
    if (person.isFirst) {
        self.iconImageV.layer.borderColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor;
        self.iconImageV.layer.borderWidth = 1.0;
        self.levelImageV.hidden = NO;
    }else{
        self.iconImageV.layer.borderColor = [UIColor clearColor].CGColor;
        self.levelImageV.hidden = YES;
    }
}

@end
