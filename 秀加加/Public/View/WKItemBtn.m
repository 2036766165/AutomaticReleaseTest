//
//  WKItemBtn.m
//  wdbo
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKItemBtn.h"
#import "UIView+Extension.h"


@interface WKItemBtn ()
#define TabBarButtonImageRatio 0.6
@property (nonatomic,strong) UILabel *badgeLabel;

@end


@implementation WKItemBtn

@synthesize btnType = _btnType,badgeText = _badgeText;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.badgeLabel = [UILabel new];
        self.badgeLabel.layer.cornerRadius = 15/2;
        self.badgeLabel.clipsToBounds = YES;
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.badgeLabel.backgroundColor = MAIN_COLOR;
        self.badgeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.badgeLabel];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)setBtnType:(WKPageType)btnType{
    _btnType = btnType;
    
    if (_btnType == WKPageTypeNormal) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (WKPageType)type{
    return _btnType;
}

- (void)setBadgeText:(NSNumber *)badgeText{
    
    if ([badgeText integerValue] == 0) {
        self.badgeLabel.hidden = YES;
    }else{
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [NSString stringWithFormat:@"%@",badgeText];
    }
    
    _badgeText = badgeText;
}

- (NSNumber *)badgeText{
    return _badgeText;
}

- (void)layoutSubviews{
    self.imageView.image = self.currentImage;

    if (_btnType == WKPageTypeOrder) {
        self.imageView.frame = CGRectMake(self.frame.size.width/2 - self.currentImage.size.width/2, self.frame.size.height/2 - 15, self.currentImage.size.width, self.currentImage.size.height);
        
        self.titleLabel.frame = CGRectMake(0, self.imageView.frame.size.height + self.imageView.frame.origin.y + 6, self.frame.size.width, 20);
        
        self.badgeLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width - 6, self.imageView.frame.origin.y - 6, 15, 15);
        
    }else{
        
        CGFloat width = [self.titleLabel.text boundingRectWithSize:CGSizeMake(10000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:NULL].size.width;
        
        self.titleLabel.frame = CGRectMake(self.frame.size.width/2 - width/2,self.frame.size.height/2 - 10, width + 10, 20);
        
        self.imageView.frame = CGRectMake(self.titleLabel.frame.origin.x - self.currentImage.size.width - 4, self.frame.size.height/2 - self.currentImage.size.height/2, self.currentImage.size.width, self.currentImage.size.height);
        self.badgeLabel.hidden = YES;
    }
    
}

@end