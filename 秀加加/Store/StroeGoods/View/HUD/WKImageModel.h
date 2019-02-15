//
//  WKImageModel.h
//  wdbo
//
//  Created by sks on 16/6/28.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKImageModel : NSObject

@property (nonatomic,copy) NSString *CreateTime;

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *PicUrl;
@property (nonatomic,copy) NSNumber *Sort;

@property (nonatomic,copy) NSString *FileUrl;
@property (nonatomic,strong) NSNumber *FileType;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) BOOL isNormal;

@end

//@interface WKImageVirtualModel : NSObject
//
//
//@end
