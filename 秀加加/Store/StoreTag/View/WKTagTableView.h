//
//  WKTagTableView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
@interface WKTagTableView : WKBaseTableView

@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray * callBackArr;

@property (copy, nonatomic) void(^tagTableCallBack)(NSMutableArray *callBackArr);

@property (strong, nonatomic) UILabel * promptLabel;

@property (assign, nonatomic) NSInteger time;

-(void)promptViewShow:(NSString *)message;


@end
