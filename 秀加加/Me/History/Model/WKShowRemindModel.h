//
//  WKShowRemindModel.h
//  秀加加
//
//  Created by sks on 2016/12/1.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKShowRemindModel : NSObject

@property (nonatomic,copy) NSNumber *TotalPageCount;
@property (nonatomic,copy) NSString *TotalCount;
@property (nonatomic,copy) NSArray  *InnerList;

@end

@interface WKShowItemModel : NSObject

@property (nonatomic,copy) NSString *BPOID;
@property (nonatomic,copy) NSString *MemberName;
@property (nonatomic,copy) NSString *MemberNo;
@property (nonatomic,copy) NSString *MemberMinPhoto;
@property (nonatomic,copy) NSNumber *MemberLevel;
@property (nonatomic,copy) NSNumber *FunsCount;
@property (nonatomic,copy) NSString *FollowTime;
@property (nonatomic,copy) NSNumber *IsAccept;
@property (nonatomic,copy) NSString *Location;
@end
