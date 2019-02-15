//
//  WKPayView.h
//  秀加加
//
//  Created by lin on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKAuctionStatusModel;

@interface WKPayView : UIView

//1.微信支付    2.支付宝支付     3.关闭  4.选择地址 5 余额支付
typedef void (^PayTypeCallBlock) (NSInteger type);

@property (nonatomic,copy) PayTypeCallBlock payTypeCallBlock;

//1.普通商品订单界面 2.拍卖商品订单界面 direction(1.竖屏  0.横屏)
-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type direction:(NSInteger)direction;


//订单支付
@property (nonatomic,strong) UILabel *money;//总价

//直播间(自己拍卖成功)
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *dropValue;//落槌价
@property (nonatomic,strong) UILabel *marginValue;// my price
@property (nonatomic,strong) UILabel *payValue;//还需补交
@property (nonatomic,strong) UILabel *name;//名字
@property (nonatomic,strong) UILabel *address;//地址
@property (nonatomic,strong) UIButton *defaultBtn;

@property (nonatomic,strong) WKAuctionStatusModel *auctionModel;


//- (void)setAuctionModel:(WKAuctionStatusModel *)model;

@end
