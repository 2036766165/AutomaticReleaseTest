//
//  WKPickerImageView.h
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    WKPickerImageTypeNormal,
    WKPickerImageTypeVirtual
} WKPickerImageType;

@interface WKPickerImageView : UIView

@property (nonatomic,assign) NSInteger maxCount;

@property (nonatomic,copy) void(^refreshCount)(NSInteger);
@property (nonatomic,copy) void(^refreshImage)();

- (instancetype)initWithFrame:(CGRect)frame type:(WKPickerImageType)type;

- (void)setImageArr:(NSArray *)arr;

- (NSArray *)getImageArr;

@end
