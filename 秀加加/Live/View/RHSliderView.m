//
//  RHSliderView.m
//  RHSliderView
//
//  Created by sks on 2017/2/22.
//  Copyright © 2017年 sks. All rights reserved.
//

#import "RHSliderView.h"
#import <objc/message.h>

@interface RHSliderView (){
    SEL _sel;
    id _target;
}
@property (nonatomic,strong) UILabel *valueLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *lineLayer;
@property (nonatomic,strong) UIView *dragView;

@property (nonatomic,strong) UIImageView *labBgImageV;

@property (nonatomic,strong) UILabel *minLabel;
@property (nonatomic,strong) UILabel *maxLabel;

@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat itemWidth;

@end

@implementation RHSliderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _itemHeight = 30;
    _itemWidth = WKScreenW - 60;
    
    // slider line
    UIView *sliderLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, 8)];
    sliderLineView.layer.cornerRadius = 8/2;
    sliderLineView.clipsToBounds = YES;
    sliderLineView.layer.shadowColor = [UIColor blackColor].CGColor;
    sliderLineView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    sliderLineView.center = CGPointMake(_itemWidth/2,_itemHeight/2);
    sliderLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sliderLineView];
    
    self.lineView = sliderLineView;
    
    UIView *layer = [UIView new];
    layer.frame = CGRectMake(0, 0, 0, 10);
    layer.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
//    layer.position = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
//    layer.colors = @[(__bridge id)[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor];
//    layer.locations = @[@0];
    layer.layer.cornerRadius = 10/2;
//    layer.startPoint = CGPointMake(0, 1);
//    layer.endPoint = CGPointMake(1, 1);
    [self.lineView addSubview:layer];
    
    self.lineLayer = layer;
    
    // slider drag view
    UIView *sliderDragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _itemHeight, _itemHeight)];
    sliderDragView.center = CGPointMake(self.lineView.frame.origin.x, _itemHeight/2);
    sliderDragView.backgroundColor = [[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00] colorWithAlphaComponent:0.2];
    sliderDragView.layer.cornerRadius = _itemHeight/2;
    sliderDragView.clipsToBounds = YES;
    
    [self addSubview:sliderDragView];
    self.dragView = sliderDragView;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTap:)];
    [self.dragView addGestureRecognizer:gesture];
    
    CALayer *layer1 = [CALayer layer];
    layer1.backgroundColor = [[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00] colorWithAlphaComponent:0.6].CGColor;
    layer1.frame = CGRectMake(0, 0, _itemHeight - 10, _itemHeight - 10);
    layer1.position = CGPointMake(_itemHeight/2, _itemHeight/2);
    layer1.cornerRadius = (_itemHeight - 10)/2;
    [self.dragView.layer addSublayer:layer1];
    
    CALayer *layer0 = [CALayer layer];
    layer0.backgroundColor = [[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00] colorWithAlphaComponent:0.8].CGColor;
    layer0.frame = CGRectMake(0, 0, _itemHeight - 20, _itemHeight - 20);
    layer0.position = CGPointMake(_itemHeight/2, _itemHeight/2);
    layer0.cornerRadius = (_itemHeight - 20)/2;
    [self.dragView.layer addSublayer:layer0];
    
    UIImage *bgImage = [UIImage imageNamed:@"lab_bg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    bgImageView.center = CGPointMake(0, - bgImage.size.height/2 - 3);
    [self addSubview:bgImageView];
    bgImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    bgImageView.alpha = 0.0;
    self.labBgImageV = bgImageView;
    
    // value label
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:self.labBgImageV.bounds];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.layer.cornerRadius = 3.0;
    valueLabel.clipsToBounds = YES;
    valueLabel.text = @"0";
    self.valueLabel = valueLabel;
    [self.labBgImageV addSubview:self.valueLabel];
    
    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _itemHeight - 5, 100, 10)];
    minLabel.textColor = [UIColor redColor];
    minLabel.font = [UIFont systemFontOfSize:14.0];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:minLabel];
    self.minLabel = minLabel;

    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(_itemWidth - 110, _itemHeight - 5, 100, 10)];
    maxLabel.font = [UIFont systemFontOfSize:14.0];
    maxLabel.textColor = [UIColor redColor];
    maxLabel.backgroundColor = [UIColor clearColor];
    maxLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:maxLabel];
    self.maxLabel = maxLabel;
}

- (void)setMaxValue:(NSInteger)maxValue{
    self.maxLabel.text = [NSString stringWithFormat:@"%ld",maxValue];
    _maxValue = maxValue;
}

- (void)setMinValue:(NSInteger)minValue{
    self.minLabel.text =[NSString stringWithFormat:@"%ld",minValue];
    _minValue = minValue;
}

-(void)reloadDataWithCurrentValue:(NSInteger)currentVal;{
    if (currentVal>self.maxValue) {
        currentVal = self.maxValue;
    }else if(currentVal< self.maxValue){
        currentVal = self.maxValue;
    }
    self.lineLayer.frame =CGRectMake(0, 0, currentVal/self.maxValue *_itemWidth, 10) ;
    self.labBgImageV.center = CGPointMake(self.lineLayer.frame.size.width, self.labBgImageV.center.y);
    self.dragView.center = CGPointMake(self.lineLayer.frame.size.width, self.dragView.center.y);
    self.currentValue = currentVal;
}
- (void)panTap:(UIPanGestureRecognizer *)pan{
//    CGPoint point = [tap translationInView:self.lineView];
    CGPoint point = [pan locationInView:self.lineView];
    
    switch (pan.state) {
//        case UIGestureRecognizerStateBegan:{
////            [UIView animateWithDuration:0.2 animations:^{
////                self.labBgImageV.alpha = 1.0;
////                self.labBgImageV.transform = CGAffineTransformMakeScale(1.0,1.0);
////            }];
//        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            NSInteger currentValue = 0;
            
            if (point.x < self.lineView.frame.size.width + self.lineView.frame.origin.x  && point.x > self.lineView.frame.origin.x) {
                self.dragView.center = CGPointMake(point.x, self.dragView.center.y);
                self.labBgImageV.center = CGPointMake(point.x, self.labBgImageV.center.y);
                
                CGFloat tickLength = (WKScreenW - 60)/(self.maxValue - self.minValue);
                NSInteger leastValue = point.x/tickLength;
                
                currentValue = ((point.x - leastValue * tickLength) > (tickLength * (leastValue + 1))) ? leastValue : leastValue + 1;
            }else{
                if (point.x > self.lineView.frame.size.width + self.lineView.frame.origin.x) {
                    currentValue = self.maxValue;
                }else{
                    currentValue = self.minValue;
                }
            }
            self.currentValue = currentValue;
            self.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)currentValue];
            self.lineLayer.frame = CGRectMake(0, 0, point.x, 8);
            
            if ([_target respondsToSelector:_sel]) {
                // runtime msg send
                ((void(*)(id,SEL,id))objc_msgSend)((id)_target,_sel,self);
            }
        }
            break;
        
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:{
            [UIView animateWithDuration:0.2 animations:^{
                self.labBgImageV.alpha = 0.0;
                self.labBgImageV.transform = CGAffineTransformMakeScale(0.2,0.2);
            }];

        }
            break;
            
        default:
            break;
    }
}

//// 事件的传递链
////- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
////    
////}
////
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return self.dragView;
//}
//
//// 事件的响应链
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [touches.anyObject locationInView:self];
    self.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentValue];

    if (CGRectContainsPoint(self.dragView.frame, point) || CGRectContainsPoint(self.lineLayer.frame, point)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.labBgImageV.alpha = 1.0;
            self.labBgImageV.transform = CGAffineTransformMakeScale(1.0,1.0);
        }];
    }
}

//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint point = [touches.anyObject locationInView:self];
//
//    self.dragView.center = CGPointMake(point.x, self.dragView.center.y);
//    self.labBgImageV.center = CGPointMake(point.x, self.labBgImageV.center.y);
//    
//    CGFloat tickLength = self.frame.size.width/(self.maxValue - self.minValue);
//    NSInteger leastValue = point.x/tickLength;
//    
//    NSInteger currentValue = ((point.x - leastValue * tickLength) > (tickLength * (leastValue + 1))) ? leastValue : leastValue + 1;
//    self.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)currentValue];
//    self.lineLayer.frame = CGRectMake(0, 0, point.x, 10);
//    
//    self.currentValue = currentValue;
//    
//    if ([_target respondsToSelector:_sel]) {
//        // runtime msg send
//        ((void(*)(id,SEL,id))objc_msgSend)((id)_target,_sel,self);
//        
//        //    ((void (*)(id, SEL, id))objc_msgSend)((id)_target,_sel,self);
//
//        [_target performSelector:_sel withObject:self afterDelay:0.0];
//    }
//}
//
- (void)addTarget:(id)target selector:(SEL)selector{
    _sel = selector;
    _target = target;
}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.labBgImageV.alpha = 0.0;
//    }];
//    
////    CGPoint point = [touches.anyObject locationInView:self];
////
////    CGFloat tickLength = self.frame.size.width/(self.maxValue - self.minValue);
////    NSInteger leastValue = point.x/tickLength;
////    
////    NSInteger currentValue = ((point.x - leastValue * tickLength) > (tickLength * (leastValue + 1))) ? leastValue : leastValue + 1;
////    self.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)currentValue];
////    self.lineLayer.frame = CGRectMake(0, 0, point.x, 10);
////    
////    self.currentValue = currentValue;
//    
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.labBgImageV.alpha = 0.0;
//    }];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
