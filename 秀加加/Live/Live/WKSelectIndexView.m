//
//  WKSelectIndexView.m
//  秀加加
//
//  Created by sks on 2016/11/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSelectIndexView.h"

static WKSelectIndexView *showInput = nil;

@interface WKSelectIndexView ()

@property (nonatomic,strong) UILabel *selectTime; // 旋转的时间
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITableView *timeTable;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy)   void (^block)(NSInteger index);

@end


@implementation WKSelectIndexView

+ (void)showWithText:(NSString *)text btnTitles:(NSArray *)btnTitles SelectIndex:(void (^)(NSInteger index))block{

    if (!showInput) {
        showInput = nil;
    }
    if (showInput == nil) {
        
        @synchronized (self) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            
            showInput = [[WKSelectIndexView alloc] initWithFrame:keyWindow.bounds];
            
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = keyWindow.bounds;
            maskBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
            [maskBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            [keyWindow addSubview:showInput];
            
            showInput.maskBtn = maskBtn;
            
            [showInput addSubview:maskBtn];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 130)];
            [showInput addSubview:bgView];
            
            bgView.backgroundColor = [UIColor whiteColor];
            bgView.center = CGPointMake(WKScreenW/2, WKScreenH/2 - 50);
            bgView.layer.cornerRadius = 10.0;
            bgView.clipsToBounds = YES;
            showInput.bgView = bgView;
            
            [UIView animateWithDuration:0.3 animations:^{
                showInput.bgView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                showInput.bgView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                showInput.bgView.transform = CGAffineTransformMakeScale(1, 1);
            }];
            
            // 起拍价
            UILabel *title = [UILabel new];
            title.frame = CGRectMake(0, 0, 80, 25);
            title.center = CGPointMake(bgView.frame.size.width/2, 20);
            title.textColor = [UIColor darkTextColor];
            title.font = [UIFont systemFontOfSize:16.0];
            title.text = @"提示";
            title.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:title];
            
            // 拍卖时间
            UILabel *time = [UILabel new];
            time.frame = CGRectMake(10,title.frame.origin.y + title.frame.size.height, bgView.frame.size.width - 20, 50);
            time.textColor = [UIColor lightGrayColor];
            time.textAlignment = NSTextAlignmentCenter;
            time.numberOfLines = 0;
            time.font = [UIFont systemFontOfSize:14.0];
            time.text = text;
            [bgView addSubview:time];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - 45, bgView.frame.size.width, 0.6)];
            [bgView addSubview:lineView];
            lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
            
            // 按钮
//            NSArray *btnTitles = @[@"取消",@"立即查看"];
            for (int i=0; i<btnTitles.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn addTarget:showInput action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
                btn.tag = 10 + i;
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                
                if (i == 0) {
                    btn.backgroundColor = [UIColor whiteColor];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(0, lineView.frame.size.height + lineView.frame.origin.y, showInput.bgView.frame.size.width/2, showInput.bgView.frame.size.height - (lineView.frame.size.height + lineView.frame.origin.y));
                }else{
                    btn.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
                    btn.frame = CGRectMake(showInput.bgView.frame.size.width/2, lineView.frame.size.height + lineView.frame.origin.y, showInput.bgView.frame.size.width/2, showInput.bgView.frame.size.height - (lineView.frame.size.height + lineView.frame.origin.y));
                }
                
                [bgView addSubview:btn];
            }
            
            if (block) {
                showInput.block = block;
            }
        }
    }
}


- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 11) {
        // 取消
        if (self.block) {
            self.block(1);
        }
    }
    
    [[self class] dismissView:nil];

}

+ (void)dismissView:(UIButton *)btn{
    
    [UIView animateWithDuration:0.2 animations:^{
        showInput.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        showInput.bgView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        showInput.block = nil;
        [showInput removeFromSuperview];
        showInput = nil;
    }];
}

- (void)dealloc{
    NSLog(@"释放了弹窗");
}


@end
