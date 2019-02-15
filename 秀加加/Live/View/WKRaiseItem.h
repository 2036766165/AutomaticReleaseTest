//
//  WKRaiseItem.h
//  秀加加
//
//  Created by sks on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

@interface WKRaiseItem : UIButton

@property (nonatomic,copy) NSString *price;

//- (instancetype)initWithPrice:(NSString *)price screenType:(WKGoodsLayoutType)screenType;

- (instancetype)initWithFrame:(CGRect)frame price:(NSString *)price screenType:(WKGoodsLayoutType)screenType;

- (void)setFontWith:(CGFloat)font;

@end
