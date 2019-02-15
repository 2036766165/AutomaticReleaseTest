//
//  WKEvaluateView.h
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKEvaluateTableModel.h"

typedef enum {
    picture = 1,
    voice,
    score,
    anonymous,
    timeLong,
}ContentType;
@interface WKEvaluateView : UIView

//1.评论 2.照片 3.匿名
typedef void (^ClickType) (ContentType,id);

@property (nonatomic,copy) ClickType clickType;

@property (strong, nonatomic) WKEvaluateTableModel * model;

@property (strong, nonatomic) NSMutableArray * starArr;

@property (strong, nonatomic) UILabel *name;

@property (strong, nonatomic) UIView *headView;

-(instancetype)initWithFrame:(CGRect)frame andModel:(WKEvaluateTableModel *)model;

@end
