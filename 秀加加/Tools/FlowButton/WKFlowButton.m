//
//  XCFlowButton.m
//  XCUserMessage
//
//  Created by Chang_Mac on 16/8/31.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import "WKFlowButton.h"
#import "NSString+Size.h"
#import <Masonry/Masonry.h>
@interface WKFlowButton ()

@property (strong, nonatomic) NSMutableArray * buttonWidthArr;

@property (strong, nonatomic) NSMutableArray * buttonWidthArrCopy;

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSMutableArray * groupArr;

@property (strong, nonatomic) NSMutableArray * numberArr;

@property (strong, nonatomic) NSMutableArray * titleArr;

@property (strong, nonatomic) NSMutableArray * colorArr;

@property (assign, nonatomic) CGFloat font;
//行
@property (assign, nonatomic) CGFloat list;
//列
@property (assign, nonatomic) CGFloat line;

@property (assign, nonatomic) CGFloat interval;

@property (strong, nonatomic) NSMutableArray * buttonArr;

@property (assign, nonatomic) locationType type;

@end

@implementation WKFlowButton
//static int buttonIndex = 0;
-(instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr andColorArr:(NSArray *)colorArr andFont:(CGFloat)font andType:(locationType)locationType :(flowBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        self.width = frame.size.width;
        self.height = frame.size.height;
        self.buttonWidthArr = [NSMutableArray new];
        self.groupArr = [NSMutableArray new];
        self.numberArr = [NSMutableArray new];
        self.buttonArr = [NSMutableArray new];
        self.titleArr = titleArr.mutableCopy;
        self.colorArr = colorArr.mutableCopy;
        self.type = locationType;
        
        if([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width)
        {
            self.font = font*WKScaleW;
        }
        else
        {
            self.font = font *WKScreenH/375;
        }
        [self caculateWidth];
        [self createLeftButton:frame];
    }
    return self;
}
-(void)createLeftButton:(CGRect)frame{
    if (self.titleArr.count < 5)
    {
        CGFloat allWidth = [self caculateLineWidth:2 andIndex:0];
        CGFloat twoAllWidth = [self caculateLineWidth:4 andIndex:2];
        CGFloat gapWidth;
        CGFloat twoGapWidth;
        CGFloat topHeight   = (self.height - self.font*2 - 4)/3;
        CGFloat originX = 10;
        CGFloat twoOriginX = 10;
        CGFloat count = self.titleArr.count <= 3 ? 2 : 3;
        
        if (self.type == flowButtonLeft)
        {
            gapWidth = (self.width - allWidth - 10) /2;
            twoGapWidth = (self.width - twoAllWidth - 10) /2;
        }else
        {
            gapWidth = (self.width - allWidth) /3;
            twoGapWidth = (self.width - twoAllWidth) /count;
            originX = gapWidth;
            twoOriginX = twoGapWidth;
        }
        
        for (int i = 0; i < self.titleArr.count; i ++ )
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(originX, topHeight, [self.buttonWidthArr[i] floatValue], self.font+2)];
            [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:self.colorArr[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:self.font];
            [self addSubview:button];
            
            if (self.titleArr.count == 1 && self.type == flowButtonCenter) {
                button.frame = CGRectMake((self.width - [self.buttonWidthArr[0] floatValue])/2, topHeight, [self.buttonWidthArr[0] floatValue], self.font+2);
            }
            if (i == 1) {
                button.frame = CGRectMake(originX+[self.buttonWidthArr[0] floatValue]+gapWidth, topHeight, [self.buttonWidthArr[1] floatValue], self.font+2);
            }
            if (i == 2) {
                button.frame = CGRectMake(twoOriginX, topHeight*2+self.font+2, [self.buttonWidthArr[2] floatValue], self.font+2);
            }
            if (i == 3) {
                button.frame = CGRectMake(twoOriginX+[self.buttonWidthArr[2] floatValue]+twoGapWidth, topHeight*2+self.font+2, [self.buttonWidthArr[3] floatValue], self.font+2);
            }
            NSLog(@"%f",button.frame.origin.x);
        }
    }
    else
    {
        for (int i = 1 ; i < self.titleArr.count; i ++ ) {
            for (int j = 0 ; j < self.titleArr.count - i; j++ ) {
                if ([self.titleArr[j] length] > [self.titleArr[j+1] length]) {
                    NSString *item = self.titleArr[j];
                    self.titleArr[j] = self.titleArr[j+1];
                    self.titleArr[j+1] = item;
                    
                    NSString *colorItem = self.colorArr[j];
                    self.colorArr[j] = self.colorArr[j+1];
                    self.colorArr[j+1] = colorItem;
                }
            }
        }
        [self caculateWidth];
        CGFloat allWidth = [self caculateLineWidth:3 andIndex:0];
        CGFloat twoAllWidth = [self caculateLineWidth:5 andIndex:3];
        CGFloat gapWidth;
        CGFloat twoGapWidth;
        CGFloat topHeight = (self.height - self.font*2 - 4)/3;
        CGFloat originX = 10;
        CGFloat twoOriginX = 10;
        if (self.type == flowButtonLeft) {
            gapWidth = (self.width - allWidth - 10) /3;
            twoGapWidth = (self.width - twoAllWidth - 10) /2;
        }else{
            gapWidth = (self.width - allWidth)/4;
            twoGapWidth = (self.width - twoAllWidth)/3;
            originX = gapWidth;
            twoOriginX = twoGapWidth;
        }
        
        for (int i = 0; i < self.titleArr.count; i ++ )
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(originX, topHeight, [self.buttonWidthArr[i] floatValue], self.font+2)];
            [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:self.colorArr[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:self.font];
            [self addSubview:button];
            if (i == 1) {
                button.frame = CGRectMake(originX+[self.buttonWidthArr[0] floatValue]+gapWidth, topHeight, [self.buttonWidthArr[1] floatValue], self.font+2);
            }
            if (i == 2) {
                button.frame = CGRectMake(originX+[self.buttonWidthArr[0] floatValue]+gapWidth*2 + [self.buttonWidthArr[1] floatValue], topHeight, [self.buttonWidthArr[2] floatValue], self.font+2);
            }
            if (i == 3) {
                button.frame = CGRectMake(twoOriginX, topHeight*2+self.font+2, [self.buttonWidthArr[3] floatValue], self.font+2);
            }
            if (i == 4) {
                button.frame = CGRectMake(twoOriginX+[self.buttonWidthArr[3] floatValue]+twoGapWidth, topHeight*2+self.font+2, [self.buttonWidthArr[4] floatValue], self.font+2);
            }
        }
    }
}

#pragma mark 计算宽度
-(CGFloat)caculateLineWidth:(int)count andIndex:(int)index{
    
    CGFloat lineWidth = 0;
    if (count>self.buttonWidthArr.count) {
        count = (int)self.buttonWidthArr.count;
    }
    for (int i = index ; i < count ; i ++ ) {
        lineWidth += [self.buttonWidthArr[i] floatValue];
    }
    
    return lineWidth;
}

#pragma mark buttonAction
-(void)titleButtonAction:(UIButton *)button{
    if (self.block) {
         self.block(button.tag,button.currentTitle);
    }
}

-(NSMutableArray *)caculateWidth{
    self.buttonWidthArr = [NSMutableArray new];
    for (NSString *item in self.titleArr) {
        CGSize size = [item sizeOfStringWithFont:[UIFont systemFontOfSize:self.font] withMaxSize:CGSizeMake(MAXFLOAT, self.font+1)];
        [self.buttonWidthArr addObject:[NSNumber numberWithFloat:size.width]];
    }
    return self.buttonWidthArr;
}
@end
