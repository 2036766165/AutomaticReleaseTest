//
//  WKOrderTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKOrderStatusModel.h"

typedef enum
{
    StoreType = 1, //商品
    AuctionType,    //拍卖品
}ShopType;

@interface WKOrderTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImgaeView;

-(void)productItem:(WKOrderProduct*)item type:(NSInteger)type;

@end
