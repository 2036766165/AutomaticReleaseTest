//
//  WKInputGifView.h
//  秀加加
//
//  Created by sks on 2016/10/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WKGifModel : NSObject

@property (nonatomic,copy) NSString *ImageName;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,copy) NSString *gifName;

@end

@interface WKInputGifView : UIView

@property (nonatomic,strong) WKGifModel *gifModel;

- (instancetype)initWithFrame:(CGRect)frame gifModel:(WKGifModel *)gifModel;

@end
