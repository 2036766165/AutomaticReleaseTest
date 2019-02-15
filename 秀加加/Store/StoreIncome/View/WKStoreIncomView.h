//
//  WKStoreIncomView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKIncomeModel.h"

typedef enum {
    rechargeType,//充值
    withDrawType,//提现
    copyType,//复制
    incomeDetailsType,//收支明细
}incomeType;
typedef void (^storeIncomeBlock)(incomeType);

@interface WKStoreIncomView : UIView

@property (copy, nonatomic) storeIncomeBlock block;

-(void)refreshDataWithData:(WKIncomeModel *)model;

@end
