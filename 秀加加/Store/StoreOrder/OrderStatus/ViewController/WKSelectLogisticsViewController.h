//
//  WKSelectLogisticsViewController.h
//  秀加加
//
//  Created by lin on 2016/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKOrderFixExpressModel.h"

typedef void(^bankChoose)(NSString *,NSString *);

@interface WKSelectLogisticsViewController : ViewController

/**
 *  block
 */
@property (copy, nonatomic) bankChoose block;

@property (nonatomic,strong) NSArray *array;

@end
