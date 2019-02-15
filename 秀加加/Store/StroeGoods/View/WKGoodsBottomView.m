//
//  WKGoodsBottomView.m
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsBottomView.h"
#import "WKGoodsPatchViewController.h"
#import "WKAddGoodsViewController.h"

@interface WKGoodsBottomView (){
    WKGoodsType _type;
}

@end

@implementation WKGoodsBottomView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles type:(WKGoodsType)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self setupViewsWithArr:titles];
    }
    return self;
}

- (void)setupViewsWithArr:(NSArray *)arr{
    
    self.backgroundColor = [UIColor whiteColor];
//    CGFloat centerY=WKScreenW/4;

    for (int i=0; i<arr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10+i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //添加加号图片        
        if([arr[i] isEqualToString:@"添加新商品"]||[arr[i] isEqualToString:@"添加拍卖品"]){
            [btn setImage:[UIImage imageNamed:@"goods_add"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,30)]; 
        }
        [self addSubview:btn];
        
        
        if (i==0) {
            if(arr.count==1){
                btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];               
            }else{
                 [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        
        }else{
//            centerY = -WKScreenW/4;
            btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
        }
        if(arr.count==1){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(WKScreenW, 50));
                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                make.left.mas_offset(i * WKScreenW/2);
            }];
            btn.tag = 11;
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(WKScreenW/2, 50));
                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                make.left.mas_offset(i * WKScreenW/2);
            }];
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    
    WKGoodsManage type;
    if (btn.tag == 10) {
        // 批量管理
        type = WKGoodsManagePatch;        
    }else{
        // 添加商品
        type = WKGoodsManageAdd;
    }
    
    if ([_delegate respondsToSelector:@selector(goodsBottomType:)]) {
        [_delegate goodsBottomType:type];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
