//
//  XCFlowButton.h
//  XCUserMessage
//
//  Created by Chang_Mac on 16/8/31.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^flowBlock)(NSInteger , NSString *);
typedef enum{
    flowButtonCenter,
    flowButtonLeft
}locationType;
@interface WKFlowButton : UIView
-(instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr andColorArr:(NSArray *)colorArr andFont:(CGFloat)font andType:(locationType)locationType :(flowBlock)block;

@property (copy, nonatomic) flowBlock block;

@end
