//
//  WKOrderPayStatusModel.h
//  秀加加
//
//  Created by lin on 2016/11/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKOrderPayStatusModel : NSObject

@property (nonatomic,strong) NSString *OrderCode;

@property (nonatomic,strong) NSString *CreateTime;

@property (nonatomic,assign) NSInteger PayStatus;

@property (nonatomic,strong) NSString *PayAmount;

@end
