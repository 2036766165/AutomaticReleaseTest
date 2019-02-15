//
//  WKGuideViewController.h
//  show++
//
//  Created by lin on 16/7/25.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPageControl.h"
@interface WKGuideViewController : UICollectionViewController <UIScrollViewDelegate>

@property(retain, nonatomic) UIImageView *guide;
@property(assign, nonatomic) CGFloat lastOffsetX;
@property (strong, nonatomic) WKPageControl *pageControl;

@end
