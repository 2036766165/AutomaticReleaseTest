//
//  UIViewController+WKImagePicker.m
//  wdbo
//
//  Created by sks on 16/7/6.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "NSObject+WKImagePicker.h"
#import <objc/runtime.h>
#import <TZImagePickerController/TZImagePickerController.h>

static char* kCaptureImage = "IMAGEBLOCK";
static char* kImagesArr = "IMAGEARR";

static char *kImageBlock = "selectedImage";

@implementation NSObject (WKImagePicker)

- (void)captureImageWithCaptureType:(WKCaptureImageType)type maxCount:(NSInteger)count :(CaptureBlock)block{
    if (block) {
        objc_setAssociatedObject(self, kCaptureImage, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    switch (type) {
        case WKCaptureImageTypeSingle:
            
            break;
            
        case WKCaptureImageTypeMutiple:
            [self presentPhotoPickerViewControllerMaxCount:count];
            break;
            
        default:
            break;
    }
}

- (void)presentPhotoPickerViewControllerMaxCount:(NSInteger)count{
//    __block NSMutableArray *imageArr = [NSMutableArray new];
//    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
//    pickerVc.maxCount = count;
//    pickerVc.status = PickerViewShowStatusCameraRoll;
//    pickerVc.photoStatus = PickerPhotoStatusPhotos;
//    pickerVc.selectPickers = imageArr;
//    pickerVc.topShowPhotoPicker = YES;
//    pickerVc.isShowCamera = YES;
//    // CallBack
//    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
//        for (ZLPhotoAssets *item in status) {
//            [imageArr addObject:item.originImage];
//        }
//        CaptureBlock block = objc_getAssociatedObject(self, kCaptureImage);
//        if (block) {
//            block(imageArr);
//        }
//    };
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
//    if (self.maxCountTF.text.integerValue > 1) {
//        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        for (ZLPhotoAssets *item in status) {
//            [imageArr addObject:item.originImage];
//        }
        CaptureBlock block = objc_getAssociatedObject(self, kCaptureImage);
        if (block) {
            block(photos);
        }

    }];
    
//    [self presentViewController:imagePickerVc animated:YES completion:nil];

    
    UIViewController *observeVC;
    if ([self isKindOfClass:[UIView class]]) {
        observeVC = [self viewControllerWith:(UIView *)self];
    }else if ([self isKindOfClass:[UIViewController class]]){
        observeVC = (UIViewController *)observeVC;
    }else{
        NSCAssert([self isKindOfClass:[UIViewController class]], @"obj must be a UIViewController or UIView Class");
    }
    
    [observeVC presentViewController:imagePickerVc animated:YES completion:nil];

//    [pickerVc showPickerVc:observeVC];
}

- (void)showImageWith:(NSArray<ZLPhotoPickerBrowserPhoto *> *)arr index:(NSInteger)index{
    if (arr) {
        objc_setAssociatedObject(self, kImagesArr, arr, OBJC_ASSOCIATION_RETAIN);
    }
    UIViewController *observeVC;
    if ([self isKindOfClass:[UIView class]]) {
        observeVC = [self viewControllerWith:(UIView *)self];
    }else if ([self isKindOfClass:[UIViewController class]]){
        UIViewController *controller = (UIViewController *)self;
        observeVC = [self viewControllerWith:controller.view];
    }else{
        NSCAssert([self isKindOfClass:[UIViewController class]], @"obj must be a UIViewController or UIView Class");
    }
    
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.editing = YES;
    pickerBrowser.currentIndex = index;
    pickerBrowser.photos = arr;
    pickerBrowser.editing = NO;
    [pickerBrowser showPickerVc:observeVC];
}

- (UIViewController*)viewControllerWith:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 选择系统相册
- (void)captureImageWith:(void (^)(UIImage *))block{
    
    if (block) {
        objc_setAssociatedObject(self, kImageBlock, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UIViewController *observeVC;
    if ([self isKindOfClass:[UIView class]]) {
        observeVC = [self viewControllerWith:(UIView *)self];
    }else if ([self isKindOfClass:[UIViewController class]]){
        UIViewController *controller = (UIViewController *)self;
        observeVC = [self viewControllerWith:(UIView *)controller.view];
    }else{
        NSCAssert([self isKindOfClass:[UIViewController class]], @"obj must be a UIViewController or UIView Class");
    }

    
    
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addPhoto];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertcontroller addAction:takePhoto];
    [alertcontroller addAction:photo];
    [alertcontroller addAction:cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [observeVC presentViewController:alertcontroller animated:YES completion:nil];
    });
}

/**
 *  调用相册
 */
- (void)addPhoto {
    
    UIViewController *observeVC;
    if ([self isKindOfClass:[UIView class]]) {
        observeVC = [self viewControllerWith:(UIView *)self];
    }else if ([self isKindOfClass:[UIViewController class]]){
        UIViewController *controller = (UIViewController *)self;
        observeVC = [self viewControllerWith:(UIView *)controller.view];
    }else{
        NSCAssert([self isKindOfClass:[UIViewController class]], @"obj must be a UIViewController or UIView Class");
    }
    
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor blackColor];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [observeVC presentViewController:imagePickerController animated:YES completion:nil];
    
}
/**
 *  调用相机
 */
- (void)takePhoto {
    
    UIViewController *observeVC;
    if ([self isKindOfClass:[UIView class]]) {
        observeVC = [self viewControllerWith:(UIView *)self];
    }else if ([self isKindOfClass:[UIViewController class]]){
        UIViewController *controller = (UIViewController *)self;
        observeVC = [self viewControllerWith:(UIView *)controller.view];
    }else{
        NSCAssert([self isKindOfClass:[UIViewController class]], @"obj must be a UIViewController or UIView Class");
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"该设备不支持照相功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [observeVC presentViewController:alert animated:NO completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        
        

        
        [observeVC presentViewController:imagePickerController animated:YES completion:nil];
    }
}

/**
 *  相册和相机回调方法
 */
#pragma mark --UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    captureBlock block = objc_getAssociatedObject(self, kImageBlock);
    
    if (block) {
        block(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end
