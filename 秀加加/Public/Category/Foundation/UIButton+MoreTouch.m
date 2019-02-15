//
//  UIButton+MoreTouch.m
//  秀加加
//
//  Created by Chang_Mac on 16/11/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//  SEL 方法编号  @selector 方法名

#import "UIButton+MoreTouch.h"

@interface UIButton ()

@property (assign, nonatomic) BOOL isResponse;

@end

@implementation UIButton (MoreTouch)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSend = @selector(sendAction:to:forEvent:);
        SEL mySend = @selector(mySendAction:to:forEvent:);
        Method systemMethod = class_getInstanceMethod(self, systemSend);
        Method myMethod = class_getInstanceMethod(self, mySend);
        BOOL isAdd = class_addMethod(self, systemSend, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
        if (isAdd) {
            class_replaceMethod(self, mySend, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            method_exchangeImplementations(systemMethod, myMethod);
        }
    });
}

-(void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event{
    if (self.isClose) {
        [self mySendAction:action to:target forEvent:event];
        return;
    }
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"] || [NSStringFromClass(self.class) isEqualToString:@"UINavigationButton"]) {
        self.touchInterval = self.touchInterval == 0?0.5:self.touchInterval;
        //NSLog(@"%f,%@",self.touchInterval,self);
        if (self.isResponse) {
            return;
        }else if(self.touchInterval>0){
            [self performSelector:@selector(changeisClose) withObject:nil afterDelay:self.touchInterval];
        }
    }
    self.isResponse = YES;
    [self mySendAction:action to:target forEvent:event];
}
-(void)setIsClose:(BOOL)isClose{
    objc_setAssociatedObject(self, @selector(isClose), @(isClose), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isClose{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setIsResponse:(BOOL)isResponse{
    objc_setAssociatedObject(self, @selector(isResponse), @(isResponse), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isResponse{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setTouchInterval:(NSTimeInterval)touchInterval{
    objc_setAssociatedObject(self, @selector(touchInterval), @(touchInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSTimeInterval)touchInterval{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
-(void)changeisClose{
    [self setIsResponse:NO];
}
@end
