//
//  WKLiveVirShopView.m
//  秀加加
//
//  Created by lin on 2016/10/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveVirShopView.h"
#import "UIImage+Gif.h"
#import "PresentView.h"
#import "GiftModel.h"
#import "WKHomePlayModel.h"

#import "WKVirtaulItemView.h"
#import "WKVirtualGiftModel.h"
#import "UIButton+MoreTouch.h"
//#import "WKRichTextView.h"
#import "NSObject+XWAdd.h"

@interface WKLiveVirShopView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *backGroundView;

@property (nonatomic,strong) UIScrollView *virScrollView;

@property (nonatomic,strong) UIButton *maskBtn;


@property (nonatomic,strong) UIView *hengView;

@property (nonatomic,strong) UILabel *number;

@property (nonatomic,strong) UIView *virView;

@property (nonatomic,strong) WKHomePlayModel *playModel;

@property (nonatomic,assign) WKGoodsLayoutType screenType;

@property (nonatomic,strong) WKVirtaulItemView *currentbackgroundView;

@property (nonatomic,strong) UIImageView *headImageView;

//@property (nonatomic,strong) UIButton *jianBtn;

//@property (nonatomic,strong) UIButton *jiaBtn;

@property (nonatomic,strong) WKHomePlayModel *model;

@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,strong) NSArray *rewardInfoArr;

@property (nonatomic,assign) NSUInteger position;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *money;

@property (nonatomic,strong) NSString *virName;

@property (nonatomic,strong) NSString *path;

@property (nonatomic,copy) NSNumber *totalBalance;    // 可用充值

@property (nonatomic,strong) UIImageView *arrowImage;
@property (nonatomic,strong) UIImageView *goldImage;

@property (nonatomic,strong) UIButton *rewardBtn; // 打赏
@property (nonatomic,strong) UIButton *balanceBtn;// 充值


@property (nonatomic,copy) void(^Block)(NSUInteger amount,WKVirtualGiftModel *gifModel,NSNumber *balanceNum);

@property (nonatomic,copy) void(^CompletionBlock)();

@end

static WKLiveVirShopView *virShopView = nil;

@implementation WKLiveVirShopView

- (instancetype)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]){
        self.modelArr = @[].mutableCopy;
    }
    return self;
}

+ (void)showWithPlayModel:(WKHomePlayModel *)playModel rewardInfo:(NSArray *)rewardInfo On:(UIView *)view layoutType:(WKGoodsLayoutType)layoutType selectedBlock:(void (^)(NSUInteger count, WKVirtualGiftModel *gifModel,NSNumber *num))block completionBlock:(void(^)())completionBlock{
    if (virShopView == nil) {
        
        @synchronized (self) {
            virShopView = [[WKLiveVirShopView alloc] initWithFrame:view.frame];
            virShopView.screenType = layoutType;
            [view addSubview:virShopView];
            
            virShopView.rewardInfoArr = rewardInfo;
            
            [playModel.iconImage sd_setImageWithURL:[NSURL URLWithString:playModel.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"zanwutouxiang"]];
            
            // 背景按钮
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = view.frame;
            [maskBtn addTarget:virShopView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            [virShopView addSubview:maskBtn];
            virShopView.maskBtn = maskBtn;

            // 容器view
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = [[UIColor colorWithHex:0x050505] colorWithAlphaComponent:0.72];
            virShopView.backGroundView = bgView;
            [virShopView addSubview:bgView];
            
            virShopView.playModel = playModel;
            if (block) {
                virShopView.Block = block;
            }
            
            if (completionBlock) {
                virShopView.CompletionBlock = completionBlock;
            }
            
            [virShopView getMemberIncome];
            
            // 打赏列表
            virShopView.virScrollView = [[UIScrollView alloc] init];
            virShopView.virScrollView.showsHorizontalScrollIndicator = false;
            virShopView.virScrollView.scrollsToTop = false;
            virShopView.virScrollView.bounces = false;
            virShopView.virScrollView.contentOffset = CGPointZero;
//            virShopView.virScrollView.delegate = self;
            virShopView.virScrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            [virShopView.backGroundView addSubview:virShopView.virScrollView];
            
            //打赏
//            UIView *daShangView = [[UIView alloc] init];
//            daShangView.layer.masksToBounds = YES;
//            daShangView.layer.cornerRadius = 8.0;
//            daShangView.backgroundColor = [UIColor colorWithHex:0xF5631F];
//            [virShopView.backGroundView addSubview:daShangView];
            
            //打赏
            UIButton *daShangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [daShangBtn setTitle:@"打赏" forState:UIControlStateNormal];
            daShangBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            daShangBtn.tag = 1001;
            daShangBtn.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
            [daShangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [daShangBtn addTarget:virShopView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [virShopView.backGroundView addSubview:daShangBtn];
            
            virShopView.rewardBtn = daShangBtn;
            
            // 充值
            UIButton *balanceFee = [UIButton buttonWithType:UIButtonTypeCustom];
            [balanceFee setTitleColor:[UIColor colorWithHexString:@"#F6D334"] forState:UIControlStateNormal];
            [balanceFee setTitle:@"充值" forState:UIControlStateNormal];
            balanceFee.tag = 1002;
            balanceFee.titleLabel.font = [UIFont systemFontOfSize:14];
            [balanceFee addTarget:virShopView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            balanceFee.backgroundColor = [UIColor clearColor];
            [virShopView.backGroundView addSubview:balanceFee];
            
            virShopView.balanceBtn = balanceFee;

            // 金币
            UIImageView *goldImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gold"]];
//            goldImg.backgroundColor = [UIColor redColor];
            [virShopView.backGroundView addSubview:goldImg];
            goldImg.userInteractionEnabled = YES;
            virShopView.goldImage = goldImg;
            
            // 箭头
            UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_recharge"]];
            arrowImg.userInteractionEnabled = YES;
//            arrowImg.backgroundColor = [UIColor redColor];

            [virShopView.backGroundView addSubview:arrowImg];
            virShopView.arrowImage = arrowImg;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:virShopView action:@selector(clickArrow)];
            [arrowImg addGestureRecognizer:tap];
            
            UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:virShopView action:@selector(clickArrow)];
            [goldImg addGestureRecognizer:tap0];
            
            [virShopView xw_addNotificationForName:@"RECHARGESUCCESS" block:^(NSNotification * _Nonnull notification) {
                [virShopView getMemberIncome];
            }];
            
//            [NSNotificationCenter defaultCenter] addObserver:virShopView selector:@selector(<#selector#>) name:<#(nullable NSNotificationName)#> object:<#(nullable id)#>
//            //打赏次数
//            UIView *number = [[UIView alloc] init];
//            number.layer.masksToBounds = YES;
//            number.layer.cornerRadius = 8.0;
//            number.backgroundColor = [UIColor whiteColor];
//          
//            UILabel *numberLabel = [UILabel new];
//            numberLabel.font = [UIFont systemFontOfSize:14.0];
//            numberLabel.text = @"1";
//            numberLabel.textColor = [UIColor colorWithHex:0xF5631F];
//            numberLabel.textAlignment = NSTextAlignmentCenter;
//            [number addSubview:numberLabel];
//            
//            virShopView.number = numberLabel;
//
//            //减法
//            UIImage *jianImage = [UIImage imageNamed:@"xiaoyu"];
//            UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            jianBtn.tag = numberJian;
//            jianBtn.isClose = NO;
//            [jianBtn setImage:jianImage forState:UIControlStateNormal];
//            [jianBtn addTarget:virShopView action:@selector(numberEvent:) forControlEvents:UIControlEventTouchUpInside];
//            virShopView.jianBtn = jianBtn;
//            [number addSubview:jianBtn];
//            
//            UIImage *jiaImage = [UIImage imageNamed:@"dayu"];
//            UIButton *jiaBtn = [[UIButton alloc] init];
//            jiaBtn.tag = numberJia;
//            jiaBtn.isClose = NO;
//            [jiaBtn setImage:jiaImage forState:UIControlStateNormal];
//            [jiaBtn addTarget:virShopView action:@selector(numberEvent:) forControlEvents:UIControlEventTouchUpInside];
//            virShopView.jiaBtn = jiaBtn;
//            [number addSubview:jiaBtn];
            
//            NSArray *moneyArray = @[@"￥0.20",@"￥0.50",@"￥1",@"￥2",@"￥5",@"￥9.90",@"￥16.80",@"￥52",@"￥75.80",@"￥99.90"];
            NSArray *nameArray = @[@"你最二",@"吾给跪了",@"十分了得",@"二到家了",@"吾林霸主",@"长长久久",@"一路发",@"我爱你",@"亲我吧",@"至死不渝"];
            
            for (int i=0; i<virShopView.rewardInfoArr.count; i++) {
                WKVirtualGiftModel *model = [[WKVirtualGiftModel alloc] init];
                
                WKLiveVirModel *item = virShopView.rewardInfoArr[i];
                
                model.virtualName = nameArray[i];
                model.virtualPrice = [NSString stringWithFormat:@"￥%0.02f",[item.Price floatValue]];
                
                model.virtualImage = [NSString stringWithFormat:@"vir%zd",i];
                model.virtualGif = [NSString stringWithFormat:@"vir%zd.gif",i];
                model.showGif = NO;
                [virShopView.modelArr addObject:model];
            }
            
            if (layoutType == WKGoodsLayoutTypeHoriztal) { // 横屏
                CGFloat itemWidth = 80;
                CGFloat itemHeight = WKScreenH * 0.25;

                if (WKScreenH == 320) {
                    itemHeight = 100;
                }
                
                daShangBtn.frame = CGRectMake(WKScreenW - 90, 8, 80, itemHeight/2 - 15);
                daShangBtn.layer.cornerRadius = CGRectGetHeight(daShangBtn.frame)/2;
                daShangBtn.clipsToBounds = YES;
                
                balanceFee.frame = CGRectMake(daShangBtn.frame.origin.x,daShangBtn.frame.size.height + daShangBtn.frame.origin.y + 15, daShangBtn.frame.size.width, daShangBtn.frame.size.height);
                
                goldImg.frame = CGRectMake(balanceFee.frame.origin.x + balanceFee.frame.size.width + 10 , balanceFee.frame.origin.y - 5, goldImg.image.size.width, goldImg.image.size.height);
                
                arrowImg.frame = CGRectMake(0, 0, arrowImg.image.size.width, arrowImg.image.size.height);
                
                goldImg.center = CGPointMake(balanceFee.frame.origin.x + balanceFee.frame.size.width + 30, balanceFee.center.y);
                arrowImg.center = CGPointMake(goldImg.frame.origin.x + goldImg.frame.size.width + 20, balanceFee.center.y);
                
//                number.backgroundColor = [UIColor clearColor];
//                number.layer.borderWidth = 1.0;
//                number.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
//                
                virShopView.backGroundView.frame = CGRectMake(0, WKScreenH, WKScreenW, 0);
                virShopView.virScrollView.frame = CGRectMake(0, 0, WKScreenW - 100, itemHeight);
                virShopView.virScrollView.contentSize = CGSizeMake(itemWidth * virShopView.modelArr.count + 2, itemHeight);
//                [virShopView.backGroundView addSubview:number];
//                [daShangView addSubview:daShangBtn];
//                
//                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WKScreenW - 100, itemHeight/2, 100, 1)];
//                lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
////                lineView.alpha = 0.5;
//                [virShopView.backGroundView addSubview:lineView];
//                
//                number.frame = CGRectMake(WKScreenW - 95, 5, 90, itemHeight/2 - 10);
//                daShangView.frame = CGRectMake(WKScreenW - 95, itemHeight/2 + 5, 90, itemHeight/2 - 10);
//                
//                numberLabel.frame = CGRectMake(jianBtn.frame.origin.x + jianBtn.frame.size.width + 2, 0, 40, 50);
//                numberLabel.center = CGPointMake(number.frame.size.width/2, number.frame.size.height/2);
//                
//                jianBtn.frame = CGRectMake(10, 0, jiaImage.size.width + 30, jiaImage.size.height);
//                jianBtn.center = CGPointMake(jiaImage.size.width/2 + 5, number.frame.size.height/2);
//                
//                jiaBtn.frame = CGRectMake(10, 0, jiaImage.size.width + 30, jiaImage.size.height);
//                jiaBtn.center = CGPointMake(number.frame.size.width - jianImage.size.width/2 - 5, number.frame.size.height/2);
//                
//                daShangBtn.frame = daShangView.bounds;
                
                for (int i=0; i<virShopView.modelArr.count; i++) {
                    
                    if (i != 0) {
                        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((itemWidth) * (i), 0, 0.5, itemHeight)];
//                        lineView.alpha = 0.5;
                        lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
                        [virShopView.virScrollView addSubview:lineView];
                    }
                    
                    WKVirtaulItemView *itemView = [[WKVirtaulItemView alloc] initWithFrame:CGRectMake((itemWidth) * i + 1, 0, itemWidth, itemHeight) virModel:virShopView.modelArr[i]];
                    
                    [virShopView.virScrollView addSubview:itemView];

                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:virShopView action:@selector(handleTap:)];
                    [itemView addGestureRecognizer:tap];
                    
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    virShopView.backGroundView.frame = CGRectMake(0, WKScreenH - itemHeight, WKScreenW, itemHeight);
                }];

            }else{
                
                CGFloat backHeight = 250;
                
//                [daShangView addSubview:number];
//                [daShangView addSubview:daShangBtn];
//
                virShopView.backGroundView.frame = CGRectMake(0, WKScreenH, WKScreenW, 0);
                virShopView.virScrollView.frame = CGRectMake(0, 0, WKScreenW, 200);
//
//                daShangView.frame = CGRectMake(WKScreenW - 160, virShopView.virScrollView.frame.size.height + 5, 150, 40);
//                number.frame = CGRectMake(2, 2, daShangView.frame.size.width/2, daShangView.frame.size.height - 4);
//                jianBtn.frame = CGRectMake(10, 0, jiaImage.size.width + 10, jiaImage.size.height + 10);
//                jianBtn.center = CGPointMake(jiaImage.size.width/2 + 5, number.center.y);
//                
//                jiaBtn.frame = CGRectMake(10, 0, jiaImage.size.width + 10, jiaImage.size.height + 10);
//                jiaBtn.center = CGPointMake(number.frame.size.width - jianImage.size.width/2 - 5, number.center.y);
//                
//                numberLabel.frame = CGRectMake(jianBtn.frame.origin.x + jianBtn.frame.size.width + 2, 0, 40, 40);
//                daShangBtn.frame = CGRectMake(number.frame.size.width, 0, 70, 40);

                balanceFee.frame = CGRectMake(10, 208, 60, 34);
                [balanceFee setTitle:@"充值 " forState:UIControlStateNormal];
                
                
                daShangBtn.frame = CGRectMake(WKScreenW - 100, balanceFee.frame.origin.y, 90, 34);
                daShangBtn.layer.cornerRadius = CGRectGetHeight(daShangBtn.frame)/2;
                daShangBtn.clipsToBounds = YES;
                
                goldImg.frame = CGRectMake(balanceFee.frame.origin.x + balanceFee.frame.size.width + 10 , balanceFee.frame.origin.y - 5, goldImg.image.size.width, goldImg.image.size.height);
                
                arrowImg.frame = CGRectMake(0, 0, arrowImg.image.size.width, arrowImg.image.size.height);
                
                goldImg.center = CGPointMake(balanceFee.frame.origin.x + balanceFee.frame.size.width + 30, balanceFee.center.y);
                arrowImg.center = CGPointMake(goldImg.frame.origin.x + goldImg.frame.size.width + 20, balanceFee.center.y);
                
                CGFloat itemWidth = WKScreenW/5;
                CGFloat itemHeight = 99;
                
                for (int i=0; i<2; i++) {
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99 * (i + 1), WKScreenW, 0.5)];
                    //                        lineView.alpha = 0.5;
                    lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
                    [virShopView.virScrollView addSubview:lineView];
                    
                    for (int j=0; j<5; j++) {
                        
                        NSInteger position = i * 5 + j;
                
                        if (j != 0) {
                            UIView *lineViewVertical = [[UIView alloc] initWithFrame:CGRectMake(j * itemWidth - 1, 0, 0.5, virShopView.virScrollView.frame.size.height-1)];
                            lineViewVertical.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
//                            lineViewVertical.alpha = 0.5;
                            [virShopView.virScrollView addSubview:lineViewVertical];
                        }
                        
                        WKVirtaulItemView *item = [[WKVirtaulItemView alloc] initWithFrame:CGRectMake(itemWidth * j, i * (itemHeight+1), itemWidth-1, itemHeight) virModel:virShopView.modelArr[position]];
                        item.backgroundColor = [UIColor clearColor];
                        [virShopView.virScrollView addSubview:item];
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:virShopView action:@selector(handleTap:)];
                        [item addGestureRecognizer:tap];
                    }
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    virShopView.backGroundView.frame = CGRectMake(0, WKScreenH - backHeight, WKScreenW, backHeight);
                }];
            }
            //刷新充值金额
            [virShopView xw_addNotificationForName:@"rechargeNumber" block:^(NSNotification * _Nonnull notification) {
                [virShopView getMemberIncome];
            }];
        }
    }
}

#pragma mark - 横竖屏布局
//点击打赏输出打赏的次数
-(void)btnClick:(UIButton *)sender
{
    if (sender.tag == 1001) {
        if (self.currentbackgroundView != nil) {
            
            if (virShopView.Block) {
                virShopView.Block(self.currentbackgroundView.virtualModel.gifCount,self.currentbackgroundView.virtualModel,self.totalBalance);
            }
            
        }else{
            [WKPromptView showPromptView:@"请选择打赏的礼物"];
        }
        
    }else{
        // 充值
        [virShopView toRechargeVC];
    }
}

// v@:
- (void)clickArrow{
    [virShopView toRechargeVC];
}

- (void)toRechargeVC{
    
    if (virShopView.Block) {
        virShopView.Block(-1,nil,virShopView.totalBalance);
    }
}
// 获取用户充值
- (void)getMemberIncome{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        
        virShopView.totalBalance = response.Data[@"MoneyCanTake"];
        NSString *str = [NSString stringWithFormat:@"充值: %0.2f",[virShopView.totalBalance doubleValue]];
        CGFloat width = [NSString sizeWithText:str font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(CGFLOAT_MAX, 35)].width;
        
        if (virShopView.screenType == WKGoodsLayoutTypeHoriztal) {
            
            virShopView.balanceBtn.frame = CGRectMake(virShopView.rewardBtn.frame.origin.x,virShopView.rewardBtn.frame.size.height + virShopView.rewardBtn.frame.origin.y + 15, virShopView.rewardBtn.frame.size.width - 30, virShopView.rewardBtn.frame.size.height);

            [virShopView.balanceBtn setTitle:str forState:UIControlStateNormal];

            virShopView.balanceBtn.frame = CGRectMake(virShopView.rewardBtn.frame.origin.x,virShopView.rewardBtn.frame.size.height + virShopView.rewardBtn.frame.origin.y + 15, virShopView.rewardBtn.frame.size.width + 10, virShopView.rewardBtn.frame.size.height);
            
            virShopView.arrowImage.frame = CGRectMake(virShopView.balanceBtn.frame.origin.x + virShopView.balanceBtn.frame.size.width + 10 , virShopView.balanceBtn.frame.origin.y - 5, virShopView.goldImage.image.size.width, virShopView.goldImage.image.size.height);
            
            virShopView.arrowImage.frame = CGRectMake(0, 0, virShopView.arrowImage.image.size.width, virShopView.arrowImage.image.size.height);
            
            virShopView.goldImage.center = CGPointMake(virShopView.balanceBtn.frame.origin.x + virShopView.balanceBtn.frame.size.width + 30, virShopView.balanceBtn.center.y);
            virShopView.arrowImage.center = CGPointMake(virShopView.goldImage.frame.origin.x + virShopView.goldImage.frame.size.width + 20, virShopView.balanceBtn.center.y);
            
        }else{
            virShopView.balanceBtn.frame = CGRectMake(10,208, width + 10, 34);
            [virShopView.balanceBtn setTitle:str forState:UIControlStateNormal];
            
            NSLog(@"%@",str);
            virShopView.goldImage.frame = CGRectMake(virShopView.balanceBtn.frame.origin.x + virShopView.balanceBtn.frame.size.width + 10 , virShopView.balanceBtn.frame.origin.y - 5, virShopView.goldImage.image.size.width, virShopView.goldImage.image.size.height);
            
            virShopView.arrowImage.frame = CGRectMake(0, 0, virShopView.arrowImage.image.size.width, virShopView.arrowImage.image.size.height);
            
            virShopView.goldImage.center = CGPointMake(virShopView.balanceBtn.frame.origin.x + virShopView.balanceBtn.frame.size.width + 10, virShopView.rewardBtn.center.y);
            virShopView.arrowImage.center = CGPointMake(virShopView.goldImage.frame.origin.x + virShopView.goldImage.frame.size.width + 10, virShopView.rewardBtn.center.y);
        }        
        
    } failure:^(WKBaseResponse *response) {
        
    }];
    
}

// 点击礼物
-(void)handleTap:(UITapGestureRecognizer *)sender
{
    
    if (self.currentbackgroundView == nil) {

        self.currentbackgroundView = (WKVirtaulItemView *)sender.view;

        self.currentbackgroundView.layer.borderWidth = 1;
        self.currentbackgroundView.layer.borderColor = [[UIColor colorWithHex:0xF5631F] CGColor];
        
        self.currentbackgroundView.virtualModel.showGif = YES;
        
        self.currentbackgroundView.virtualModel.gifCount = 1;

        
    }else{
        
        if (![sender.view isEqual:self.currentbackgroundView]) {
            self.currentbackgroundView.virtualModel.gifCount = 0;
        }
        
        self.currentbackgroundView.layer.borderWidth = 0;
        self.currentbackgroundView.virtualModel.showGif = NO;
        
        self.currentbackgroundView = (WKVirtaulItemView *)sender.view;
        self.currentbackgroundView.virtualModel.showGif = YES;
        
        self.currentbackgroundView.layer.borderWidth = 1;
        self.currentbackgroundView.layer.borderColor = [[UIColor colorWithHex:0xF5631F] CGColor];
        
        self.currentbackgroundView.virtualModel.gifCount += 1;

    }
}

- (void)dismissView:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        virShopView.backGroundView.frame = CGRectMake(0, WKScreenH, WKScreenW, 0);

    } completion:^(BOOL finished) {
        if (virShopView.CompletionBlock) {
            virShopView.CompletionBlock();
        }
        [virShopView.maskBtn removeFromSuperview];
        [virShopView.backGroundView removeFromSuperview];
        [virShopView removeFromSuperview];
        
        virShopView = nil;
        virShopView.CompletionBlock = nil;
        virShopView.Block = nil;
        
    }];
}

+ (void)dismiss{
    
    if (virShopView != nil) {
        [virShopView dismissView:virShopView.maskBtn];
    }
}

@end

@implementation WKLiveVirModel



@end
