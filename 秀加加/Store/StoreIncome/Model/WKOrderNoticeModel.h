//
//  WKOrderNoticeModel.h
//  wdbo
//
//  Created by lin on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKOrderNoticeModel : NSObject

@property (nonatomic,strong) NSArray *ListNoticeInfo;

@property (nonatomic,strong) NSArray *ListMemberNoticeInfo;

@end

@interface WKListNoticeInfo : NSObject

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,copy) NSString *CreateTimeStr;

@property (nonatomic,copy) NSString *CreateTime;

@property (nonatomic,copy) NSString *Message;

@property (nonatomic,copy) NSString *Url;

@property (nonatomic,copy) NSString *MemberCode;

@property (nonatomic,copy) NSString *NoticeType;

@property (nonatomic,copy) NSString *OrderCode;

@property (strong, nonatomic) NSString * ID;

@end
