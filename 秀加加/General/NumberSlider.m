//
//  NumberSlider.m
//  秀加加
//
//  Created by liuliang on 2016/10/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberSlider.h"


@implementation NumberSlider

@synthesize label;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];//[UIFont systemFontOfSize:13*WKScaleW];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHex:0xF26C1F];
        [self addSubview:label];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self bringSubviewToFront:label];
}

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    CGRect imageRect =[super thumbRectForBounds:bounds trackRect:rect value:value];
    NSString* text = [NSString stringWithFormat:@"%d",(int)value];
    
    label.text = text;
    label.frame = CGRectMake(imageRect.origin.x+20, imageRect.origin.y+imageRect.size.height/2, imageRect.size.width, imageRect.size.height);
    label.center = CGPointMake(imageRect.origin.x+imageRect.size.width/2+1, imageRect.origin.y+imageRect.size.height/2+5);
    return imageRect;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    if(self.type == 1)
    {
        return CGRectMake(0, 0, WKScreenW-195*WKScaleW-40-30-40, 5);
    }
    else
    {
        return CGRectMake(0, 0, WKScreenW-40-30-45, 5);
    }
}
@end
