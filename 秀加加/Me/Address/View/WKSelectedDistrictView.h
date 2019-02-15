//
//  WKSelectedDistrictView.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(NSArray *arr);

@interface WKSelectedDistrictView : UIView
// 默认地址
+ (void)showWithDefaultProvince:(NSString *)province city:(NSString *)city country:(NSString *)country completion:(CompletionBlock)block;

@end


