//
//  WKLevelItemView.m
//  秀加加
//
//  Created by sks on 2017/2/27.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKLevelItemView.h"

@interface WKLevelItemView ()

@property (nonatomic,strong) UIImageView *levelIcon;
@property (nonatomic,strong) UILabel *levelLabel;

@end

@implementation WKLevelItemView

- (instancetype)init{
    if (self = [super init]) {
        
        // level label
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 53, 18)];
        
        lab.layer.borderWidth = 1.0;
        lab.font = [UIFont systemFontOfSize:13.0f];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.cornerRadius = 9;
        lab.clipsToBounds = YES;
        [self addSubview:lab];
        
        self.levelLabel = lab;
        
        // levelImageV
        UIImageView *levelImageV = [[UIImageView alloc] init];
        levelImageV.frame = CGRectMake(0, 7, 20, 20);
        [self addSubview:levelImageV];
        
        self.levelIcon = levelImageV;
    }
    return self;
}

- (void)setLevel:(NSUInteger)level{
    
    UIColor *bgColor;
    UIColor *borderColor;
    
    switch (level) {
        case 1:
        case 4:
        case 7:
            bgColor = [UIColor colorWithHexString:@"#D77922"];
            borderColor = [UIColor colorWithHexString:@"#ff9c20"];
            break;
            
        case 2:
        case 5:
        case 8:
            bgColor = [UIColor colorWithHexString:@"#DADAD8"];
            borderColor = [UIColor colorWithHexString:@"#bbbbb9"];
            break;
            
        case 3:
        case 6:
        case 9:
            bgColor = [UIColor colorWithHexString:@"#EBCA2D"];
            borderColor = [UIColor colorWithHexString:@"#ffe80e"];
            break;
            
        default:
            bgColor = [UIColor colorWithHexString:@"#A11DCC"];
            borderColor = [UIColor colorWithHexString:@"#8b02b4"];
            
            break;
    }

    self.levelLabel.text = [NSString stringWithFormat:@"V%lu",(unsigned long)level];
    self.levelLabel.backgroundColor = bgColor;
    self.levelLabel.layer.borderColor = borderColor.CGColor;
    
    NSString *imageName;
    if (level < 10) {
        imageName = [NSString stringWithFormat:@"level%lu",level];
    }else{
        imageName = [NSString stringWithFormat:@"level%d",10];
    }
    UIImage *image = [UIImage imageNamed:imageName];
    self.levelIcon.image = image;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
