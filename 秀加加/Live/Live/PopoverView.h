//
//  PopoverView.h
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^selectedIndex)(NSInteger index);

typedef enum : NSUInteger {
    WKPopverTypeShare,
    WKPopverTypeCamera,
} WKPopverType;
@interface WKPopverItem : NSObject

@property (nonatomic,copy) NSString *itemImage;
@property (nonatomic,copy) NSString *itemSelctedImage;

@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,assign) BOOL isSelected;

@end

@interface PopoverView : UIImageView

- (instancetype)initFrom:(UIView *)view On:(UIView *)superView titles:(NSArray *)titles images:(NSArray *)images selectedImages:(NSArray *)selectedImages type:(WKPopverType)type;

//-(id)initWithPoint:(UIView *)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;

- (void)setSelectedIndex:(NSInteger)index;

//@property (nonatomic, copy) UIColor *borderColor;

@property (nonatomic,copy) void (^dismissCompletion)();

@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
