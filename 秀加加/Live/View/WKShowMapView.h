//
//  WKShowMapView.h
//  秀加加
//
//  Created by lin on 2016/10/18.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKGetShopAuthenticationModel;

@interface WKShowMapView : UIView

//- (instancetype)initWith:(WKGetShopAuthenticationModel *)location;

- (instancetype)initWithFrame:(CGRect)frame location:(WKGetShopAuthenticationModel *)location showBlock:(void(^)())block;

@end
