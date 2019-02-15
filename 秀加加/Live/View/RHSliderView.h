//
//  RHSliderView.h
//  RHSliderView
//
//  Created by sks on 2017/2/22.
//  Copyright © 2017年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHSliderView : UIView

@property (nonatomic,assign) NSInteger minValue;
@property (nonatomic,assign) NSInteger maxValue;

@property (nonatomic,assign) NSInteger currentValue;

- (void)addTarget:(id)target selector:(SEL)selector;
-(void)reloadDataWithCurrentValue:(NSInteger)currentVal;

@end
