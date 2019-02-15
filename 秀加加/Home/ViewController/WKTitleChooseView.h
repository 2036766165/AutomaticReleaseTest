//
//  WKTitleChooseView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^titleChooseBlock)(NSString * colorStr,NSString* string);
typedef void(^tagNumberBlock)();
typedef enum {
    buttonCircle,
    buttonNone
}titleChooseType;

@interface WKTitleChooseView : UIView

-(instancetype)initWithData:(NSArray *)titleArr andColor:(NSArray *)colorArr type:(titleChooseType)type block:(titleChooseBlock)block;

@property (copy, nonatomic) titleChooseBlock block;

@property (assign, nonatomic) NSInteger type;//1.选一个  2.选多个

-(void)circleHidden;

@property (copy, nonatomic) tagNumberBlock tagNumBlock;

@end
