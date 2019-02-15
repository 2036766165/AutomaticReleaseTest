//
//  UIViewController+WKTrack.m
//  wdbo
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "UIViewController+WKTrack.h"
#import "WKItemBtn.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
//#import "WKLiveViewController.h"
#import "WKNavigationController.h"

//static char *kImageBlock = "selectedImage";

//static UIView *promptView;

@implementation UIViewController (WKTrack)

- (UIViewController*)viewControllerWith:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+(void)load{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        Class cls = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        SEL dis_originalSelector = @selector(viewWillDisappear:);
        SEL dis_swizzledSelector = @selector(xxx_viewWillDisAppear:);
        
        
        Method dis_originalMethod = class_getInstanceMethod(cls, dis_originalSelector);
        Method dis_swizzledMethod = class_getInstanceMethod(cls, dis_swizzledSelector);
        
        BOOL dis_didAddMethod = class_addMethod(cls, dis_originalSelector, method_getImplementation(dis_swizzledMethod), method_getTypeEncoding(dis_swizzledMethod));
        
        if (dis_didAddMethod) {
            class_replaceMethod(cls, dis_swizzledSelector, method_getImplementation(dis_originalMethod), method_getTypeEncoding(dis_originalMethod));
        }else{
            method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
        }
        
    });
}

-(void)xxx_viewWillAppear:(BOOL)animated{
    [self xxx_viewWillAppear:animated];
}

- (void)xxx_viewWillDisAppear:(BOOL)animated{
    [self.view endEditing:YES];
}


- (void)setItemBtn:(WKItemBtn *)itemBtn{
    if (itemBtn) {
        objc_setAssociatedObject(self, @selector(itemBtn), itemBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (WKItemBtn *)itemBtn{
    WKItemBtn *btn = objc_getAssociatedObject(self, @selector(itemBtn));

    return btn;
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end
