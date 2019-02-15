//
//  WKHistoryModel.h
//  秀加加
//
//  Created by lin on 2016/9/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKHistoryModel : NSObject

@property (nonatomic,assign) NSInteger TotalPageCount;

@property (nonatomic,assign) NSInteger TotalCount;

@property (nonatomic,strong) NSArray *InnerList;

@end


@interface WKHistoryItemModel : WKHistoryModel

@property (nonatomic,strong) NSString *MemberCode;

@property (nonatomic,strong) NSString *MemberName;

@property (nonatomic,strong) NSString *MemberNo;

@property (nonatomic,strong) NSString *MemberPhoto;

@property (nonatomic,strong) NSString *MemberMinPhoto;

@property (nonatomic,strong) NSString *MemberLevel;

@property (nonatomic,assign) NSInteger FunsCount;

@property (nonatomic,assign) BOOL ShopAuthenticationStatus;

@property (nonatomic,strong) NSString *Location;

@property (nonatomic,assign) NSInteger *IsFollow;

@property (nonatomic,strong) NSString *FollowTime;

@property (strong, nonatomic) NSString * BPOID;

@property (assign , nonatomic) NSInteger LiveStatus;

@property (strong , nonatomic) NSString *LastShowTime;

@end
