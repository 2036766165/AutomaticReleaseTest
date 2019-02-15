//
//  WKImageItemView.h
//  wdbo
//
//  Created by sks on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKDeleteImageDelegate <NSObject>

- (void)deleteImageWith:(id)obj;
@end

@interface WKImageItemView : UIView

@property (nonatomic,assign) BOOL hiddenClose;

@property(nonatomic,strong) UIImageView *imageView;

@property (nonatomic,weak) id <WKDeleteImageDelegate> delegate;

@end
