//
//  WKMeTableView.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBaseTableView.h"
#import "WKMeModel.h"

@interface WKMeTableView : WKBaseTableView

//1.点击退出    2.点击头像     3.点击标签
typedef void (^QuitCallBack)(NSInteger type);

@property (nonatomic,copy) QuitCallBack quitCallBack;

typedef void (^SelectViewConotroller)(NSIndexPath *indexPath);

@property (nonatomic,copy) SelectViewConotroller selectViewConotroller;

@property (nonatomic,strong) WKMeModel *model;

@property (assign , nonatomic) NSInteger funsCount ;

@property (assign, nonatomic) BOOL isRed;

-(void)promptViewShow:(NSString *)message;

@end
