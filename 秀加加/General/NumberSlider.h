//
//  NumberSlider.h
//  秀加加
//
//  Created by liuliang on 2016/10/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#ifndef NumberSlider_h
#define NumberSlider_h

@interface NumberSlider : UISlider

@property (nonatomic,strong) UILabel* label;

//1.横屏
@property (nonatomic,assign) NSInteger type;

@end

#endif /* NumberSlider_h */
