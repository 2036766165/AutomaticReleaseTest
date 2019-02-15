//
//  WKIncomeDetailsView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBaseTableView.h"
#import "WKIncomeDetailsModel.h"
#import "WKAuctionDetailsModel.h"

@interface WKIncomeDetailsView : WKBaseTableView

@property (assign, nonatomic) NSInteger type;

@property (assign,nonatomic) NSString* createTime;

@property (strong, nonatomic) WKIncomeDetailsModel * model;

@property (strong,nonatomic) WKAuctionDetailsModel  * auctionModel;

@end
