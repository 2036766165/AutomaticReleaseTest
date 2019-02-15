//
//  UIViewController+WKImagePicker.h
//  wdbo
//
//  Created by sks on 16/7/6.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerBrowserPhoto.h"
#import "ZLPhoto.h"

typedef enum : NSUInteger {
    WKCaptureImageTypeSingle, // 传单张图片
    WKCaptureImageTypeMutiple // 上传多张图片
} WKCaptureImageType;

typedef void(^CaptureBlock)(NSArray *arr);

typedef void(^captureBlock)(UIImage *image);


@interface NSObject (WKImagePicker) <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/*获取图片*/
- (void)captureImageWithCaptureType:(WKCaptureImageType)type maxCount:(NSInteger)count :(CaptureBlock)block;

// 查看图片
- (void)showImageWith:(NSArray <ZLPhotoPickerBrowserPhoto *>*)arr index:(NSInteger)index;

- (void)captureImageWith:(void(^)(UIImage *image))block;

- (UIViewController*)viewControllerWith:(UIView *)view;

@end
