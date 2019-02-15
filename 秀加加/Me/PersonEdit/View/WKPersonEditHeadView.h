//
//  WKPersonEditHeadView.h
//  秀加加
//
//  Created by lin on 16/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKPersonEditHeadView : UIView

@property (nonatomic,copy)   UIImage *imageName;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIImageView *imageview;

-(void)setImageName:(UIImage *)imageName;

- (void)setHeight:(CGFloat)height;

@end
