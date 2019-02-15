//
//  PromptView.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKPromptView : UIView

+(void)showPromptView:(NSString *)message;

+(void)showPromptView:(NSString *)message clickBlock:(void(^)())block;

@property (strong, nonatomic) UIView * promptView;

@property (strong, nonatomic) UILabel * promptLabel;

@property (assign, nonatomic) NSInteger time;

//没有数据时默认图片
+(UIView *)createDefaultMessage:(NSString *)content andPic:(NSString *)picName andFrame:(CGRect)frame;

+(UIVisualEffectView *)GetImageVisualView:(CGRect)rect;
@end
