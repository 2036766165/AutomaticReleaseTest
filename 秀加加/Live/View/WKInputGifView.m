//
//  WKInputGifView.m
//  秀加加
//
//  Created by sks on 2016/10/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKInputGifView.h"
#import "UIImage+Gif.h"

@interface WKInputGifView ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation WKInputGifView

- (instancetype)initWithFrame:(CGRect)frame gifModel:(WKGifModel *)gifModel{
    if (self = [super initWithFrame:frame]) {
        
        // GIF 图
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:gifModel.ImageName];
        [self addSubview:imageView];
        
        self.imageView = imageView;
        
        self.gifModel = gifModel;
        
        [self.gifModel addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(imageView.image.size.width * 0.6, imageView.image.size.height * 0.6));
        }];
        
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isSelected"]) {
        
        BOOL isSelected = [change[NSKeyValueChangeNewKey] integerValue];
        if (isSelected) {
            NSString *gifPath = [[NSBundle mainBundle] pathForResource:self.gifModel.gifName ofType:@"gif"];
            self.imageView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gifPath]];
            self.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        }else{
            self.backgroundColor = [UIColor clearColor];
            self.imageView.image = [UIImage imageNamed:self.gifModel.ImageName];
        }

    }
}

- (void)dealloc{
    [self.gifModel removeObserver:self forKeyPath:@"isSelected"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation WKGifModel


@end
