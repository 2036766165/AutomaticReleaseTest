//
//  WKVirtualWorldModel.h
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKVirtualWorldModel : NSObject

@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *GoodsName;
@property (nonatomic,copy) NSString *Memo;
@property (nonatomic,copy) NSString *OrderCode;
@property (nonatomic,copy) NSString *ShopOwnerBPOID;
@property (nonatomic,copy) NSString *ShopOwnerName;
@property (nonatomic,copy) NSString *ShopOwnerNo;
@property (nonatomic,copy) NSString *ShopOwnerPicUrl;
@property (nonatomic,copy) NSString *VirtualInfo;
@property (nonatomic,copy) NSArray *VirtualInfoList;

@end
