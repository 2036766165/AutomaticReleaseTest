//
//  WKCustomTableModel.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCustomTableModel : NSObject

@property (strong, nonatomic) NSArray * InnerList;

@property (strong, nonatomic) NSString * TotalCount;

@property (strong, nonatomic) NSString * TotalPageCount;

@end

@interface CustomInnerList : NSObject

@property (strong, nonatomic) NSString * BPOID;

@property (strong, nonatomic) NSString * MemberName;

@property (strong, nonatomic) NSString * MemberNo;

@property (strong, nonatomic) NSString * MemberLevel;

@property (strong, nonatomic) NSString * Location;

@property (strong, nonatomic) NSString * Sex;

@property (strong, nonatomic) NSString * ShopAuthenticationStatus;

@property (strong, nonatomic) NSString * TotalPoint;

@property (strong, nonatomic) NSString * MemberPhoto;

@property (strong, nonatomic) NSString * MemberMinPhoto;

//购买次数
@property (strong, nonatomic) NSString * OrderCount;

//订单总金额
@property (strong, nonatomic) NSString * OrderAmount;

//打赏次数
@property (strong, nonatomic) NSString * RewardCount;



@end
