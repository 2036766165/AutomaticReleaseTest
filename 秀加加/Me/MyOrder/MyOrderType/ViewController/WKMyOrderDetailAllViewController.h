//
//  WKMyOrderDetailAllViewController.h
//  秀加加
//
//  Created by lin on 2016/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKOrderStatusModel.h"

@interface WKMyOrderDetailAllViewController : ViewController

@property (nonatomic,strong) WKOrderStatusItemModel *model;

-(instancetype)initWithType:(NSInteger)type OrderListType:(NSInteger)OrderListType;

@end
