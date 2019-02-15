//
//  UIBarButtonItem+Extension.m
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "UIButton+MoreTouch.h"
@implementation UIBarButtonItem (Extension)


+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];

    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (highImageName != nil) {
        [button setImage: [UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    CGSize size = button.currentImage.size;
    button.frame = CGRectMake(-size.width,0,size.width*3, size.height*2);
    button.adjustsImageWhenHighlighted = NO;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -size.width, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width*1.5, image.size.height*1.5)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.touchInterval = 1.5;
    UIView * redPointView = [[UIView alloc]init];
    redPointView.layer.cornerRadius = 4;
    redPointView.backgroundColor = [UIColor colorWithRed:238/255.0 green:120/255.0 blue:32/255.0 alpha:1];
    redPointView.hidden = YES;
    redPointView.tag = 1000001;
    [btn addSubview:redPointView];
    [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-2);
        make.top.mas_offset(2);
        make.size.sizeOffset(CGSizeMake(8, 8));
    }];
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (instancetype)itemWithImageAndTitle:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn titleLabel].font = [UIFont systemFontOfSize:12];
    [btn sizeToFit];
    btn.titleEdgeInsets = UIEdgeInsetsMake(-1, -image.size.width-25, 0.0, 0.0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -(btn.bounds.size.width-image.size.width+25));
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithHex:0xB1B6C3] forState:UIControlStateNormal];
    
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}
@end
