//
//  WKPageControl.m
//  秀加加
//
//  Created by Chang_Mac on 16/11/16.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPageControl.h"

@implementation WKPageControl

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIView *subview = [self.subviews objectAtIndex:subviewIndex];
        subview.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = nil;
        if (subviewIndex == page) {
            CGFloat w = 20;
            CGFloat h = 10;
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 0, w, h)];
            imageView.image = [UIImage imageNamed:@"currentPage"];
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, w, h)];
        } else {
            CGFloat w = 10;
            CGFloat h = 10;
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
            imageView.image = [UIImage imageNamed:@"otherPage"];
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, w, h)];
        }
        imageView.tag = 10010;
        UIImageView *lastImageView = (UIImageView *) [subview viewWithTag:10010];
        [lastImageView removeFromSuperview]; //把上一次添加的view移除
        [subview addSubview:imageView];
    }
}
@end
