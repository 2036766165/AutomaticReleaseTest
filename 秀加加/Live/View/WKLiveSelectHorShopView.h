//
//  WKLiveSelectHorShopView.h
//  秀加加
//
//  Created by lin on 2016/10/25.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKLiveShopListModel.h"
#import "WKAddressModel.h"
#import "NumberSlider.h"

@interface WKLiveSelectHorShopView : UIView

//1.跳转地址
typedef void (^ClickPayType) (NSInteger type);

@property (nonatomic,copy) ClickPayType clickPayType;

typedef void (^CellClick)  (NSIndexPath *index);

@property (nonatomic,copy) CellClick cellClick;

- (instancetype)initWithFrame:(CGRect)frame
                        model:(WKLiveShopListModel*)model;

@property (nonatomic,strong) UILabel *priceName;
@property (nonatomic,strong) UILabel *allMoney;
//@property (nonatomic,strong) UILabel *addressName;
//@property (nonatomic,strong) UIButton *defaultBtn;
//@property (nonatomic,strong) UILabel *addressCon;
@property (nonatomic,strong) UILabel *sliderNum;
@property (nonatomic,strong) NumberSlider *slider ;

@property (nonatomic,strong) WKAddressListItem *addressItem;

@end
