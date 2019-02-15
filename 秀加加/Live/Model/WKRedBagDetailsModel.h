//
//  WKRedBagDetailsModel.h
//  秀加加
//
//  Created by Chang_Mac on 17/3/21.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKRedBagDetailsModel : NSObject

@property (copy, nonatomic) NSString * ID;
@property (copy, nonatomic) NSString * HostName;
@property (copy, nonatomic) NSString * HostPhoto;
@property (copy, nonatomic) NSString * HostNo;
@property (copy, nonatomic) NSString * HostBPOID;
@property (copy, nonatomic) NSString * HostMemberLevel;
@property (copy, nonatomic) NSString * FromType;
@property (copy, nonatomic) NSString * BagType;
@property (copy, nonatomic) NSString * TotalAmount;
@property (copy, nonatomic) NSString * TotalCount;
@property (copy, nonatomic) NSString * BagMessage;
@property (copy, nonatomic) NSString * EmptySecond;
@property (copy, nonatomic) NSString * SendTime;
@property (copy, nonatomic) NSString * IsEnd;
@property (copy, nonatomic) NSString * CurrentRobbedAmount;
@property (copy, nonatomic) NSString * CurrentStatus;
@property (copy, nonatomic) NSArray * InnerList;

@end

@interface InnerList : NSObject

@property (copy, nonatomic) NSString * MemberName;
@property (copy, nonatomic) NSString * MemberPhoto;
@property (copy, nonatomic) NSString * MemberLevel;
@property (copy, nonatomic) NSString * MemberNo;
@property (copy, nonatomic) NSString * BPOID;
@property (copy, nonatomic) NSString * RobAmount;
@property (copy, nonatomic) NSString * RobTime;
@property (copy, nonatomic) NSString * IsBest;


@end





