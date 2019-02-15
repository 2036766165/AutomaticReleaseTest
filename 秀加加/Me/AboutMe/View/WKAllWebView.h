//
//  WKAllWebView.h
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKAllWebView : UIView

@property (nonatomic,strong) NSString *urlString;

-(instancetype)initWithFrame:(CGRect)frame UrlString:(NSString *)UrlString;

@end
