//
//  WKStoreRechargeViewController.h
//  秀加加
//
//  Created by Chang_Mac on 16/12/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
typedef void (^backBlock)();
@interface WKStoreRechargeViewController : ViewController

@property (copy, nonatomic) backBlock block;

@end
