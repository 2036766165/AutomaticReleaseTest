//
//  WKIncomeDetailsViewController.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "ViewController.h"

@interface WKIncomeDetailsViewController : ViewController

/**
 *  type
 */
@property (strong, nonatomic) NSString * orderID;

//收入创建时间
@property (strong,nonatomic) NSString * createTime;

@property (strong, nonatomic) NSString * type;

@property (strong ,nonatomic) UIImageView * auctionView;

@end
