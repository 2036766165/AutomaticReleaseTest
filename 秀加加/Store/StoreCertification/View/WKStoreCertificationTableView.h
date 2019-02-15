//
//  WKStoreCertificationTableView.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@class WKAuthShopModel;

@interface WKStoreCertificationTableView : WKBaseTableView

typedef void (^SelectPhoto)(int type);

@property (nonatomic,strong) UIViewController *obserview;

@property (nonatomic,copy) SelectPhoto selectPhoto;

@property (nonatomic,strong) WKAuthShopModel *dataModel;
@property (strong, nonatomic) UIView *promptView;

@property (strong, nonatomic) UILabel * promptLabel;

- (NSDictionary *)getUploadInfo;

@end
