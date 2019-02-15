//
//  WKRankListModel.h
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRankListModel : NSObject

@property (nonatomic,copy) NSString *Amount;
@property (nonatomic,copy) NSString *BPOID;
@property (nonatomic,assign) BOOL IsSelf;
@property (nonatomic,copy) NSString *MemberName;
@property (nonatomic,copy) NSString *MemberNo;
@property (nonatomic,copy) NSString *MemberPicUrl;

@property (nonatomic,strong) NSNumber *Sort;

@end
