//
//  BulletBackgroudView.m
//  CommentDemo
//
//  Created by jia feng on 2016/12/24.
//  Copyright © 2016年 caishi. All rights reserved.
//

#import "WKBulletBackgroudView.h"
#import "WKBulletView.h"

@implementation WKBulletBackgroudView

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self findClickBulletView:point]) {
        return self;
    }
    return nil;
}

- (WKBulletView *)findClickBulletView:(CGPoint)point {
    WKBulletView *bulletView = nil;
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[WKBulletView class]]) {
            if ([v.layer.presentationLayer hitTest:point]) {
                bulletView = (WKBulletView *)v;
                break;
            }
        }
    }
    
    return bulletView;
}

- (void)dealTapGesture:(UITapGestureRecognizer *)gesture block:(void (^)(WKBulletView *bulletView))block {
    CGPoint clickPoint =  [gesture locationInView:self];
    
    WKBulletView *bulletView = [self findClickBulletView:clickPoint];
    if (bulletView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        });
        if (block) {
            block(bulletView);
        }
    }

}

@end
