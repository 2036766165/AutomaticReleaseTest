//
//  WKLiveShopCommentModel.h
//  秀加加
//
//  Created by lin on 2016/10/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKLiveShopCommentModel : NSObject

@property (nonatomic,strong) NSArray *InnerList;

@property (nonatomic,assign) NSInteger TotalPageCount;

@end

@interface WKLiveShopCommentModelItem : WKLiveShopCommentModel

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *BPOID;

@property (nonatomic,strong) NSString *MemberNo;

@property (nonatomic,strong) NSString *MemberName;

@property (nonatomic,strong) NSString *MemberPhotoUrl;

@property (nonatomic,strong) NSString *ShopOwnerBPOID;

@property (nonatomic,strong) NSString *ShopOwnerNo;

@property (nonatomic,strong) NSString *OrderCode;

@property (nonatomic,assign) NSInteger GoodsCode;

@property (nonatomic,strong) NSString *GoodsName;

@property (nonatomic,assign) NSInteger ModelCode;

@property (nonatomic,strong) NSString *ModelName;

@property (nonatomic,strong) NSString *GoodsPicUrl;

@property (nonatomic,assign) NSInteger GoodsPrice;

@property (nonatomic,assign) BOOL IsAnoymous;

@property (nonatomic,strong) NSString *Content;

@property (nonatomic,assign) NSInteger ContentDuration;

@property (nonatomic,strong) NSString *ContentBrief;

@property (nonatomic,strong) NSArray *PicUrls;

@property (nonatomic,assign) NSInteger Score;

@property (nonatomic,strong) NSString *Reply;

@property (nonatomic,assign) NSInteger ReplyDuration;

@property (nonatomic,strong) NSString *ReplyBrief;

@property (nonatomic,strong) NSString *ReplyTime;

@property (nonatomic,assign) BOOL IsRead;

@property (nonatomic,strong) NSString *CreateTime;

@end

//@interface WKLiveShopCommentPicUrlItem : WKLiveShopCommentModelItem
//
//@end
