//
//  WKProgressHUD.m
//  秀加加
//
//  Created by sks on 2016/9/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKProgressHUD.h"
#import "MBProgressHUD.h"
#import "UIImage+Gif.h"

const NSTimeInterval lastTime = 2;

@implementation WKProgressHUD

+ (void)showText:(NSString *)text{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 16.f;
    hud.mode = MBProgressHUDModeText;
    hud.labelColor = [UIColor whiteColor];
    [hud hide:YES afterDelay:1.5];
}

+ (void)showLoadingText:(NSString *)text{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showLoadingText:(NSString *)text on:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showSuccessWith:(NSString *)text{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    hud.labelText = text;
    [hud show:YES];
}

+ (void)showErrorWith:(NSString *)text{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    hud.labelText = text;
}

+ (void)showLoadingGifText:(NSString *)text{

    if (text == nil) {
        text = @"";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        [keyWindow addSubview:hud];
        hud.removeFromSuperViewOnHide = YES;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"login_wating" ofType:@"gif"];
        UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 160, 160 * 256 / 320);
        imageView.center = hud.center;
        hud.customView = imageView;
        hud.color = [UIColor clearColor];
        hud.labelText = text;
        [hud show:YES];
    });
}

+(void)showWatchShowLoadingGifText:(NSString *)text{

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        [keyWindow addSubview:hud];
        hud.removeFromSuperViewOnHide = YES;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"watchShowLoading" ofType:@"gif"];
        UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 60, 60);
        imageView.center = hud.center;
        hud.customView = imageView;
        hud.color = [UIColor clearColor];
        hud.labelText = text;
        [hud show:YES];
    });
}

+ (void)showTopMessage:(NSString *)msg{
    [self dismiss];
    @synchronized (self) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            keyWindow.userInteractionEnabled = NO;
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, WKScreenW, 40)];
            lab.text = msg;
            keyWindow.windowLevel = UIWindowLevelStatusBar+1.0f;
            
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:14.0f];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [keyWindow addSubview:lab];
            
            [UIView animateWithDuration:0.3 animations:^{
                lab.frame = CGRectMake(0, 0, WKScreenW, 40);
            } completion:^(BOOL finished) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        lab.frame = CGRectMake(0, -40, WKScreenW, 40);
                    } completion:^(BOOL finished) {
                        [lab removeFromSuperview];
                        keyWindow.windowLevel = UIWindowLevelStatusBar-1.0f;
                        keyWindow.userInteractionEnabled = YES;
                    }];
                });
            }];
            
        });
    }
}

+ (void)dismiss{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
//    [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];
    
    for (UIView *subview in keyWindow.subviews) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            [hud hide:YES];
            [hud removeFromSuperview];
        }
    }
}

+ (void)dismissOn:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
