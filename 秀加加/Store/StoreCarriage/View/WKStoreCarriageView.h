//
//  WKStoreCarriageView.h
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKStoreCarriageView : UIView

typedef void (^TranFeeBlock)(NSString *price);

@property (nonatomic,copy) TranFeeBlock tranFeeBlock;

@property (nonatomic,strong) UITextField *money;

@end
