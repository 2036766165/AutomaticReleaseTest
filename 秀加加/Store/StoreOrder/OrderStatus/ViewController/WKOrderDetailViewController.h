//
//  WKOrderDetailViewController.h
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKOrderStatusModel.h"

@interface WKOrderDetailViewController : ViewController

@property (nonatomic,strong) WKOrderStatusItemModel *model;

-(instancetype)initWithType:(NSInteger)type
              OrderListType:(NSInteger)OrderListType
                 CustomType:(NSInteger)CustomType;

typedef void (^SendShopBack) ();

@property (nonatomic,copy) SendShopBack sendShopBack;

@end
