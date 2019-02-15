//
//  WKPersonalCenterView.h
//  秀加加
//
//  Created by Chang_Mac on 17/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPersonalCenterModel.h"

typedef enum {
    userMessageType,//用户信息
    tagType,//标签
    attentionType,//关注
    fansType,//粉丝
    walletType,//钱包
    goodsType, //商品
    deliverGoodsType,//发货管理
    customType,//客户
    shopCertificateType,//店铺认证
    levelType,//等级
    orderType,//订单
    hadSeenType,//我看过的
    addressType,//地址
    virtualWordType,//虚拟世界
    settingType,//设置
}SelectType;

typedef void (^personalCenterSelect)(SelectType);

@interface WKPersonalCenterView : UITableView

@property (copy, nonatomic) personalCenterSelect selectBlock;
@property (strong, nonatomic) WKPersonalCenterModel * model;

@end
