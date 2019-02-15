//
//  WKLiveSelectShopView.h
//  秀加加
//
//  Created by lin on 2016/10/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKLiveShopListModel.h"
#import "WKAddressModel.h"
#import "NumberSlider.h"

@interface WKLiveSelectShopView : UIView

//1.微信支付        2.支付宝支付         3.跳转地址
typedef void (^ClickPayType) (NSInteger type);

@property (nonatomic,copy) ClickPayType clickPayType;

//typedef void (^CellClick)  (NSInteger row);
typedef void (^CellClick)  (NSIndexPath *index);

@property (nonatomic,copy) CellClick cellClick;

- (instancetype)initWithFrame:(CGRect)frame
                        model:(WKLiveShopListModel*)model;

@property (nonatomic,strong) WKAddressListItem *addressItem;

@property (nonatomic,strong) UILabel *priceName;

@property (nonatomic,strong) UILabel *sliderNum;

@property (nonatomic,strong) UILabel *allMoney;

@property (nonatomic,strong) UILabel *messageCon;


@property (nonatomic,strong) UILabel *tranFee;

@property (nonatomic,strong) NumberSlider *slider;

@property (nonatomic,strong) UIButton *balanceBtn;

- (void)closeEvent;

@end
