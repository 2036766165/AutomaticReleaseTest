//
//  WKStoreView.h
//  秀加加
//
//  Created by lin on 16/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKStoreModel.h"
#import "WKFlowButton.h"
#import "WKGoodsInfoModel.h"

typedef enum{
    SelectShop = 1001,  //商品
    SelectCustom,       //客户
    SelectOrder,        //订单
    SelectFee,          //运费
    SelectIncome,       //收入
    SelectShare ,        //分享
    SelectTitles,         //标签
    SelectAuthentiaction,  // 店铺认证
    SelectEditPerson      //编辑个人信息
}ClickType;

@interface WKStoreView : UIView

//定义点击时间
typedef void (^SelectClickType) (ClickType type);

@property (nonatomic,copy) SelectClickType selectClickType;

//定义标签
@property (strong, nonatomic) WKFlowButton *flowButton;

-(void)promptViewShow:(NSString *)message;

//定义页面属性
@property (strong , nonatomic) UIImageView *leftImgView ;
@property (strong , nonatomic) UIImageView *levelImageView;
@property (strong , nonatomic) UILabel *userName;
@property (strong , nonatomic) UILabel *fan;
@property (strong , nonatomic) UILabel *liveNum;
@property (strong , nonatomic) UIImageView *backGroundView;
@property (strong , nonatomic) UILabel *renzhengLab;
@property (strong , nonatomic) UIImageView *renzhengImgView ;
@property (strong , nonatomic) UIButton *goodsBtn ;
@end



