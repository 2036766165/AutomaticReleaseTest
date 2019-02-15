//
//  WKRongBPOIDModel.h
//  秀加加
//
//  Created by lin on 2016/10/15.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRongBPOIDModel : NSObject

@property (nonatomic,strong) NSArray *Data;

@end

@interface WKRongBPOIDItem : NSObject

@property (nonatomic,strong) NSString *BPOID;

@property (nonatomic,strong) NSString *MemberName;

@property (nonatomic,strong) NSString *MemberNo;

@property (nonatomic,strong) NSString *MemberMinPhoto;

@property (nonatomic,strong) NSString *MemberLevel;

@property (nonatomic,strong) NSString *ShopAuthenticationStatus;

@property (nonatomic,strong) NSString *Location;

@property (nonatomic,assign) NSInteger LiveStatus;

@end
