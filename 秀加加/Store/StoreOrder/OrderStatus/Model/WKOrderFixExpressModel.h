//
//  WKOrderFixExpressModel.h
//  秀加加
//
//  Created by lin on 2016/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKOrderFixExpressModel : NSObject

@property (nonatomic,strong) NSArray *Data;

@end

@interface WKOrderFixExpressItemModel : WKOrderFixExpressModel

@property (nonatomic,strong) NSString *ExpressCompanyNo;

@property (nonatomic,strong) NSString *ExpressCompanyName;

@property (nonatomic,assign) NSInteger Sort;

@end
