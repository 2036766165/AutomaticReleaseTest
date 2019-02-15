//
//  WKLiveConfigView.m
//  秀加加
//
//  Created by sks on 2017/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKLiveConfigView.h"
#import "WKButton.h"

@interface WKLiveItem : NSObject
@property (nonatomic,copy) NSString *titleName;
@property (nonatomic,copy) NSString *imageN;
@property (nonatomic,copy) NSString *selectedImageN;

@end

@implementation WKLiveItem

@end

@interface WKLiveConfigView ()

@property (nonatomic,copy) void(^clickBlock)(NSInteger,WKShowConfigType);

@property (nonatomic,assign) WKShowConfigType viewType;
@property (nonatomic,strong) UIView *containView;
@property (nonatomic,assign) CGFloat backHeight;
//@property (nonatomic,strong) NSArray *btnArr;
@property (nonatomic,strong) WKButton *currentSelectedBtn;

@end

static WKLiveConfigView *configView = nil;

@implementation WKLiveConfigView

+ (void)showViewType:(WKShowConfigType)viewType defaultIndex:(NSInteger)index clickBlock:(void(^)(NSInteger,WKShowConfigType))clickBlock{

    if (!configView) {
        
        @synchronized (self) {
            
            configView = [WKLiveConfigView new];
            configView.clickBlock = clickBlock;
            configView.viewType = viewType;
            
            NSArray *names;
            NSArray *images;
            NSArray *selectedImages;
            CGFloat backHeight = 0;
            NSString *viewTitle;
            
            switch (viewType) {
                case WKShowConfigTypeCamera:{
                    names = @[@"反转",@"开镜像",@"分享"];
                    images = @[@"switch",@"mirror",@"share"];
                    selectedImages = @[@"switch_selected",@"mirror_selected",@"share_selected"];
                    
                    backHeight = WKScreenH * 0.2;
                    
                    viewTitle = @"";
                }
                    break;
                    
                case WKShowConfigTypeVoice:{
                    viewTitle = @"音效调节";
                    
//                    * 0 关闭
//                    * 1 录音棚
//                    * 2 KTV
//                    * 3 小舞台
//                    * 4 演唱会
                    names = @[@"录音棚",@"KTV",@"小舞台",@"演唱会"];
                    images = @[@"recoder",@"ktv",@"theatre",@"concert"];
                    selectedImages = @[@"recoder_selected",@"ktv_selected",@"theatre_selected",@"concert_selected"];
                    
                    backHeight = WKScreenH * 0.3;
                    
                }
                    break;
                    
                case WKShowConfigTypeFilter:{
                    viewTitle = @"美颜特效";

                    names = @[@"甜美可人",@"老照片",@"靓丽",@"小清新",@"蓝调",@"怀旧"];

                    images = @[@"sweet",@"oldPic",@"beauty",@"fresh",@"blues",@"nostalgic"];
                    selectedImages = @[@"sweet_selected",@"oldPic_selected",@"beauty_selected",@"fresh_selected",@"blues_selected",@"nostalgic_selected"];
                    
                    backHeight = WKScreenH * 0.3;
                    
                }
                    break;

                    
                    
                default:
                    break;
            }
            
            NSMutableArray *items = @[].mutableCopy;
            
            for (int i=0; i<names.count; i++) {
                
                WKLiveItem *item = [WKLiveItem new];
                item.titleName = names[i];
                item.imageN = images[i];
                item.selectedImageN = selectedImages[i];
                
                [items addObject:item];
            }
            
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame = keyWindow.bounds;
            [backBtn addTarget:configView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            backBtn.backgroundColor = [UIColor clearColor];
            [keyWindow addSubview:backBtn];
            
            // 显示的背景图
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, keyWindow.frame.size.height, keyWindow.frame.size.width, backHeight)];
            backView.backgroundColor = [UIColor whiteColor];
            [backBtn addSubview:backView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            titleLabel.center = CGPointMake(WKScreenW/2, 20);
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.text = viewTitle;
            [backView addSubview:titleLabel];
            
            configView.containView = backView;
            configView.backHeight = backHeight;
            
//            NSMutableArray *btnArr = @[].mutableCopy;
            for (int i=0; i<items.count; i++) {
                WKLiveItem *item = items[i];
                
                WKButton *btn = [WKButton buttonWithType:0];
                [btn setTitle:item.titleName forState:0];
                btn.tag = 100 + i;
                [btn setTitleColor:[UIColor darkGrayColor] forState:0];
                [btn setImage:[UIImage imageNamed:item.imageN] forState:0];
                [btn setImage:[UIImage imageNamed:item.selectedImageN] forState:UIControlStateSelected];
                [btn addTarget:configView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:btn];
                
                if (index - 1 == i) {
//                    [configView btnClick:btn];
                    btn.selected = YES;
                    configView.currentSelectedBtn = btn;
                }
                // 按钮布局
                CGFloat itemW = 0;
                CGFloat itemH = 0;
                CGFloat itemX;
                CGFloat itemY;
                
                if (viewType == WKShowConfigTypeCamera) {
                    
                    itemW = WKScreenW * 0.15;
                    itemH = itemW;
                    
                    itemX = (WKScreenW/3)/2 - itemW/2 + i * WKScreenW/3;
                    itemY = (backHeight - itemH)/2;
                    
                }else if (viewType == WKShowConfigTypeFilter){
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    itemW = WKScreenW * 0.15;
                    itemH = itemW;
                    
                    itemX = (WKScreenW/4)/2 - itemW/2 + i%4 * WKScreenW/4;
                    itemY = 40 + i/4 * (itemH + 30);
                    
                }else{
                    
                    btn.layer.cornerRadius = 5.0;
                    btn.layer.borderWidth = 2.0;
                    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    
                    itemW = (WKScreenW-50)/4;
                    itemH = backHeight * 0.6;
                    
                    itemX = 10 + i * (itemW + 10);
                    itemY = 50;
                    
                }
                
                btn.frame = CGRectMake(itemX, itemY, itemW, itemH);

            }
            
//            configView.btnArr = btnArr;
            
            [UIView animateWithDuration:0.3 animations:^{
                backView.frame = CGRectMake(0, keyWindow.frame.size.height - backHeight, keyWindow.frame.size.width, backHeight);
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
    
}

- (void)btnClick:(WKButton *)btn{
    
    NSInteger idx = 0;
    if (!configView.currentSelectedBtn) {
        configView.currentSelectedBtn = btn;
        configView.currentSelectedBtn.selected = YES;
        idx = btn.tag - 100 + 1;
    }else{
        
        if ([configView.currentSelectedBtn isEqual:btn]) {
            btn.selected = NO;
            
            configView.currentSelectedBtn = nil;
        }else{
            self.currentSelectedBtn.selected = NO;
            
            configView.currentSelectedBtn = btn;
            btn.selected = !btn.selected;
            
            idx = btn.tag - 100 + 1;
        }
    }
    
    if (self.viewType == WKShowConfigTypeVoice) {
        
        for (UIView *subview in self.containView.subviews) {
            if ([subview isKindOfClass:[WKButton class]]) {
                subview.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }
        
        btn.layer.borderColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor;
    }
    
    if (self.viewType == WKShowConfigTypeCamera) {
        idx = btn.tag - 100 + 1;
    }
    
    if (configView.clickBlock) {
        configView.clickBlock(idx,configView.viewType);
    }
}

- (void)dismissView:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        configView.containView.frame = CGRectMake(0, WKScreenH, WKScreenW, configView.backHeight);
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
        configView = nil;
    }];
}

//- (void)dealloc{
//    NSLog(@"释放配置弹窗");
//}

@end
