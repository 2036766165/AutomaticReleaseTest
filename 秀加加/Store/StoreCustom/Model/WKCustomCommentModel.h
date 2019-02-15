//
//  WKCustomCommentModel.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCustomCommentModel : NSObject
/**
 *  评论内容
 */
@property (strong, nonatomic) NSString * Content;
/**
 *  物品名
 */
@property (strong, nonatomic) NSString * GoodsName;
/**
 *  物品照片
 */
@property (strong, nonatomic) NSString * GoodsPicUrl;
/**
 *  物品价格
 */
@property (strong, nonatomic) NSString * GoodsPrice;
/**
 *  型号
 */
@property (strong, nonatomic) NSString * ModelName;
/**
 *  订单号
 */
@property (strong, nonatomic) NSString * OrderCode;
/**
 *  PicUrls
 */
@property (strong, nonatomic) NSArray * PicUrls;
/**
 *  回复
 */
@property (strong, nonatomic) NSString * Reply;
/**
 *  评分
 */
@property (assign, nonatomic) NSInteger Score;
/**
 *  id
 */
@property (strong, nonatomic) NSString * ID;

@property (strong, nonatomic) NSString * MemberName;

@property (strong, nonatomic) NSString * MemberPhotoUrl;

@property (strong, nonatomic) NSString * CreateTime;

@property (strong, nonatomic) NSString * ReplyDuration;

@property (strong, nonatomic) NSString * ReplyTime;

@property (strong, nonatomic) NSString * GoodsCode ;//=0快捷商品

@property (strong, nonatomic) NSString * ContentDuration;//商品时长

@property (strong, nonatomic) NSString * ReplyBrief;

@property (strong, nonatomic) NSString * ContentBrief;


@end
