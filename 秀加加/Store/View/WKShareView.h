//
//  WKStoreShareView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKShareTool.h"
@interface WKShareView : UIView

+(void)shareViewWithModel:(WKShareModel *)model;

@property (strong, nonatomic) WKShareModel * model;

@end
