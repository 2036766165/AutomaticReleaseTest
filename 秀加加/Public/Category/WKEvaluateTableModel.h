//
//  WKEvaluateTableModel.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKEvaluateTableModel : NSObject

@property (strong, nonatomic) NSString * CreateTime;

@property (strong, nonatomic) NSString * GoodsCode;

@property (strong, nonatomic) NSString * GoodsName;

@property (assign, nonatomic) NSInteger GoodsNumber;

@property (copy, nonatomic) NSString * GoodsPicUrl;

@property (strong, nonatomic) NSString * GoodsPrice;

@property (assign, nonatomic) NSInteger GoodsModelCode;

@property (strong, nonatomic) NSString * GoodsModelName;

@property (strong, nonatomic) NSString * OrderCode;

@property (strong, nonatomic) NSString * ShopOwnerBPOID;

@property (strong, nonatomic) NSString * ShopOwnerNo;

@property (strong, nonatomic) NSString * ShopOwnerName;

@property (strong, nonatomic) NSString * ShopOwnerPicUrl;

@property (strong, nonatomic) NSString * IsShow;

@property (strong, nonatomic) NSString * GoodsStartPrice;

@property (assign, nonatomic) NSInteger type;//6.幸运

@property (assign, nonatomic) NSInteger IsVirtual;//虚拟

@end
