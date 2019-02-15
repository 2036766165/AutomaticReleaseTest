//
//  WKMyIntegralModel.h
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMyIntegralModel : NSObject

@property (nonatomic,strong) NSArray *InnerList;

@property (nonatomic,assign) NSInteger TotalPageCount;

@end

@interface WKMyIntegralItemModel : WKMyIntegralModel

@property (nonatomic,strong) NSString *Point;
@property (nonatomic,strong) NSString *FromWay;
@property (nonatomic,strong) NSString *CreateTime;
@property (nonatomic,strong) NSString *CreateTimeStr;
@property (nonatomic,strong) NSString *Remark;

@end
