//
//  WKLiveShopDetailTableViewCell.m
//  秀加加
//  标题：直播 商品详情图片列表 竖屏
//  Created by lin on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopDetailTableViewCell.h"
#import "NSObject+XWAdd.h"

@interface WKLiveShopDetailTableViewCell()

@end

@implementation WKLiveShopDetailTableViewCell

-(void)setItem:(WKLiveShopPicModelItem *)item{
    _item = item;
    self.shopImageView.image = item.imageView.image;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubView];
    }
    return self;
}

-(void)addSubView
{
    self.backgroundColor = [UIColor colorWithHex:0xF0F2FF];
    UIImage *shopLiveImage = [UIImage imageNamed:@"shopLive"];
    UIImageView *shopImageView = [[UIImageView alloc] init];
    shopImageView.image = shopLiveImage;
    shopImageView.clipsToBounds = YES;
    shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView = shopImageView;
    [self addSubview:shopImageView];
    [shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(8, 0, 0, 0));
    }];
}

@end
