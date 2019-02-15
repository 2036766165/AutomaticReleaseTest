//
//  WKTextField.m
//  show++
//
//  Created by sks on 16/7/25.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKTextField.h"

@implementation WKTextField

-(CGRect)textRectForBounds:(CGRect)bounds{ return CGRectInset(bounds, 5, 0); }

-(CGRect)editingRectForBounds:(CGRect)bounds{ return CGRectInset(bounds, 5, 0); }

@end
