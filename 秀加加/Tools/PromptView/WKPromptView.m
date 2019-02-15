//
//  PromptView.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPromptView.h"

@interface WKPromptView ()
@property (strong, nonatomic) NSMutableArray * messageArr;
@property (strong, nonatomic) UIWindow * keyWindow;
@property (nonatomic,copy) void(^block)();

@end

static WKPromptView *promptView;
@implementation WKPromptView

+(void)showPromptView:(NSString *)message{
    if (!promptView) {
        CGFloat fontScale;
        if (WKScreenH>WKScreenW) {
            fontScale = WKScaleW;
        }else{
            fontScale = WKScreenH/375;
        }
        promptView = [[WKPromptView alloc]initWithFrame:CGRectMake(0,-40,WKScreenW,40)];
        promptView.backgroundColor = [UIColor clearColor];
        promptView.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WKScreenW-40, 40)];
        promptView.promptLabel.font = [UIFont systemFontOfSize:14*fontScale];
        promptView.promptLabel.textColor = [UIColor whiteColor];
        promptView.promptLabel.adjustsFontSizeToFitWidth = YES;
        promptView.promptLabel.textAlignment = NSTextAlignmentCenter;
        [promptView addSubview:promptView.promptLabel];
        promptView.messageArr = [NSMutableArray new];
        promptView.time = 1;
        promptView.keyWindow = [UIApplication sharedApplication].keyWindow;
        promptView.keyWindow.windowLevel = UIWindowLevelStatusBar+1.0f;
        [promptView.keyWindow addSubview:promptView];
        [promptView.keyWindow bringSubviewToFront:promptView];
    }
    NSString *lastStr = [promptView.messageArr lastObject];
    if (![lastStr isEqualToString:message] && message != nil) {
        [promptView.messageArr addObject:message];
    }
    if (promptView.time == 1) {
        [promptView removeSelf];
    }
}

-(void)removeSelf{
    promptView.time = 2;
    if (promptView.messageArr.count>0) {
        [promptView promptViewShow:promptView.messageArr[0]];
    }else{
        promptView.time = 1;
        promptView.keyWindow.windowLevel = UIWindowLevelStatusBar-1.0f;
        [promptView removeFromSuperview];
        promptView = nil;
    }
}

-(void)promptViewShow:(NSString *)message{
    promptView.promptLabel.text = message;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            promptView.frame = CGRectMake(0, 0,WKScreenW,40);
            promptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        } completion:^(BOOL finished) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.5 *NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    promptView.frame = CGRectMake(0, -40,WKScreenW,40);
                    promptView.backgroundColor = [UIColor clearColor];
                } completion:^(BOOL finished) {
                    [promptView.messageArr removeObjectAtIndex:0];
                    [promptView removeSelf];
                }];
            });
        }];
    });
}

+(UIView *)createDefaultMessage:(NSString *)content andPic:(NSString *)picName andFrame:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:picName];
    UIImageView *im = [[UIImageView alloc]initWithImage:image];
    [view addSubview:im];
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.sizeOffset(CGSizeMake(image.size.width, image.size.height));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = content;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(im.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(10);
    }];
    return view;
}

+ (void)showPromptView:(NSString *)message clickBlock:(void (^)())block{
    
    if (!promptView) {
        CGFloat fontScale;
        if (WKScreenH>WKScreenW) {
            fontScale = WKScaleW;
        }else{
            fontScale = WKScreenH/375;
        }
        
        
        promptView = [[WKPromptView alloc]initWithFrame:CGRectMake(0,-40,WKScreenW,40)];
        promptView.backgroundColor = [UIColor clearColor];
        promptView.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WKScreenW-40, 40)];
        promptView.promptLabel.font = [UIFont systemFontOfSize:14*fontScale];
        promptView.promptLabel.textColor = [UIColor whiteColor];
        promptView.promptLabel.adjustsFontSizeToFitWidth = YES;
        promptView.promptLabel.textAlignment = NSTextAlignmentCenter;
        [promptView addSubview:promptView.promptLabel];
        promptView.messageArr = [NSMutableArray new];
        promptView.time = 1;
        promptView.keyWindow = [UIApplication sharedApplication].keyWindow;
        promptView.keyWindow.windowLevel = UIWindowLevelStatusBar+1.0f;
        [promptView.keyWindow addSubview:promptView];
        [promptView.keyWindow bringSubviewToFront:promptView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:promptView action:@selector(handleTap)];
        [promptView addGestureRecognizer:tap];
        
    }
    NSString *lastStr = [promptView.messageArr lastObject];
    if (![lastStr isEqualToString:message]) {
        [promptView.messageArr addObject:message];
    }
    if (promptView.time == 1) {
        [promptView removeSelf];
    }
    
    if (block) {
        promptView.block = block;
    }
}

- (void)handleTap{
    promptView.block();
}

//返回图层后，需要虚化的图片，添加此层
+(UIVisualEffectView *)GetImageVisualView:(CGRect)rect{
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = rect;
    visualEffectView.alpha = 0.9;
    //    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:rect];
    //    toolbar.barStyle = UIBarStyleBlackTranslucent;
    //    [backGroundView addSubview:toolbar];
    return visualEffectView ;
}

//- (void)dealloc{
//    NSLog(@"释放顶部提示框");
//}

@end
