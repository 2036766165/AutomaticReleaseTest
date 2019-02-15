//
//  WKLiveMarginView.h
//  秀加加
//
//  Created by lin on 2016/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKLiveMarginView : UIView

typedef enum{
    WeiXinPayType = 1,
    ZhiFuBaoPayType,
}PayType;

typedef void (^ClickPayType) (NSInteger type);

@property (nonatomic,copy) ClickPayType clickPayType;

@end
