//
//  WKItemBtn.h
//  wdbo
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPagesView.h"

@interface WKItemBtn : UIButton

@property (nonatomic,assign) WKPageType btnType;

@property (nonatomic,copy) NSNumber *badgeText;

@end
