//
//  WKAddAddressTableView.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKAddressModel.h"
#import "WKAddressViewController.h"

@interface WKAddAddressTableView : UIView

@property (nonatomic,strong) UIViewController *oberveView;

- (instancetype)initWithFrame:(CGRect)frame from:(WKAddressFrom)from;

- (NSDictionary *)getAddressInfo;

- (void)setDataModel:(WKAddressModel *)model;

-(void)promptViewShow:(NSString *)message;


@end
