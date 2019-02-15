//
//  WKLiveVirShopView.h
//  秀加加
//
//  Created by lin on 2016/10/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

typedef enum{
    numberJian = 1002,
    numberJia,
}numberType;



@class WKHomePlayModel,WKVirtualGiftModel;

@interface WKLiveVirShopView : UIView

+ (void)showWithPlayModel:(WKHomePlayModel *)playModel rewardInfo:(NSArray *)rewardInfo On:(UIView *)view layoutType:(WKGoodsLayoutType)layoutType selectedBlock:(void (^)(NSUInteger count, WKVirtualGiftModel *gifModel,NSNumber *num))block completionBlock:(void(^)())completionBlock;

+ (void)dismiss;

@end

@interface WKLiveVirModel : NSObject

@property (nonatomic,copy) NSNumber *Price;
@property (nonatomic,copy) NSNumber *RewordCode;

@end
