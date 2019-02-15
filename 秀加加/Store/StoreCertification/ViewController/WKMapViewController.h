//
//  ViewController.h
//  原生地图
//
//  Created by sks on 16/8/30.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGetLocation.h"
#import "WKGetShopAuthenticationModel.h"

@interface WKMapViewController : UIViewController

@property (nonatomic,copy) void(^locationBlock)(id);

@property (nonatomic,strong) WKGetShopAuthenticationModel *addressModel;

//1.代表有搜索框
- (instancetype)initWith:(NSInteger)search;

@end

