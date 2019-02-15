//
//  WKQrScanningViewController.h
//  wdbo
//
//  Created by Chang_Mac on 16/7/4.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "ViewController.h"

@interface WKQrScanningViewController : ViewController

@property (nonatomic, copy) void (^scnningBlock)(NSString *);

@end
