//
//  WKImageCollectionViewCell.h
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKImageModel;
@protocol WKCellOperationProtocol;

@interface WKImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) id<WKCellOperationProtocol> delegate;

- (void)setImageMd:(WKImageModel *)md;

@end
