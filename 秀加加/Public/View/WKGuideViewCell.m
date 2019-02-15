//
//  WKGuideViewCell.m
//  show++
//
//  Created by lin on 16/7/25.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKGuideViewCell.h"

@implementation WKGuideViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *startImg = [UIImage imageNamed:@"guideBtn"];
        [self.startBtn setImage:startImg forState:UIControlStateNormal];
        self.startBtn.tag= 100;
        self.startBtn.showsTouchWhenHighlighted = YES;
        self.startBtn.frame = CGRectMake((WKScreenW-startImg.size.width)/2,WKScreenH-182,startImg.size.width, startImg.size.height);
        self.startBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.startBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.startBtn];
    }
    return self;
}
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self.contentView addSubview:imageV];
        
        _imageView = imageV;
    }
    return _imageView;
}

@end
