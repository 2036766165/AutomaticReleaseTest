//
//  WKSelectAuctionView.h
//  秀加加
//
//  Created by sks on 2017/2/16.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKAuctionSelectDelegate ;

@interface WKSelectAuctionView : UIView

@property (nonatomic,weak) id<WKAuctionSelectDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type;

- (void)showDescription:(BOOL)isShow;

@end

@protocol WKAuctionSelectDelegate <NSObject>
- (void)showInfoType:(NSInteger)type;
- (void)selectedType:(NSUInteger)type;
@end
