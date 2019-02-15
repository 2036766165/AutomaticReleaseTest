//
//  WKGuideViewCell.h
//  show++
//
//  Created by lin on 16/7/25.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKGuideViewCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *startBtn;

@property(retain, nonatomic)UIImage *image;

@property(retain, nonatomic) UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
