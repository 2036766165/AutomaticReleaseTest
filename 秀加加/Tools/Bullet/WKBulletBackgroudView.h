//
//  BulletBackgroudView.h
//  CommentDemo
//
//  Created by jia feng on 2016/12/24.
//  Copyright © 2016年 caishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKBulletView;
@interface WKBulletBackgroudView : UIView

- (void)dealTapGesture:(UITapGestureRecognizer *)gesture block:(void(^)(WKBulletView *bulletView))block;
@end
