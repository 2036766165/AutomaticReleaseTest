//
//  WKLiveShopTableView.h
//  秀加加
//
//  Created by lin on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKLiveShopListModel.h"
#import "WKLiveShopCommentModel.h"
#import "WKGoodsModel.h"
#import "WKLiveShopEvaluateTableViewCell.h"
#import "WKHomePlayModel.h"

@class WKAuctionStatusModel;

@interface WKLiveShopTableView : UIView

//1.地址  2.立即支付
typedef void (^ClickAddress) (NSInteger type);

typedef void (^ShowPicBlock) (LiveShopAudioType type,NSInteger row);

@property (nonatomic,copy) ClickAddress clickAddress;

//商品型号集合
@property (strong, nonatomic) NSArray *picarray;

@property (nonatomic,strong) NSMutableArray *commentArray;  // 评论数组

@property (nonatomic,copy) ShowPicBlock showPicBlock;

@property (nonatomic,strong) WKHomePlayModel *model;

-(instancetype)initWithFrame:(CGRect)frame withGoodsDetail:(WKLiveShopListModel *)goodsDetail playModel:(WKHomePlayModel *)playModel auctionModel:(WKAuctionStatusModel *)auctionMd showGoods:(BOOL)showGoods;

@end
