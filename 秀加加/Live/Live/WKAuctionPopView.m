//
//  WKAuctionPopView.m
//  秀加加
//
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionPopView.h"

static NSString *cellId = @"cell";

typedef void(^AuctionBlock)(NSString *price,NSString *time);

@interface WKAuctionPopView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *selectTime; // 旋转的时间
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITableView *timeTable;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy)   AuctionBlock block;

@end

static WKAuctionPopView *showInput = nil;

@implementation WKAuctionPopView

+ (void)showAuctionViewWithPrice:(NSNumber *)price goodsType:(WKGoodsType)type Completion:(void (^)(NSString *, NSString *))block{
    if (!showInput) {
        showInput = nil;
    }
    if (showInput == nil) {
        
        @synchronized (self) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            
            showInput = [[WKAuctionPopView alloc] initWithFrame:keyWindow.bounds];
            
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = keyWindow.bounds;
            maskBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
            [maskBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            [keyWindow addSubview:showInput];
            
            showInput.maskBtn = maskBtn;
            
            [showInput addSubview:maskBtn];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
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
            
            
            // 起拍/筹价
            NSString *titleStr = type == WKGoodsTypeAuction?@"起拍价":@"幸运购金额";
            UILabel *title = [UILabel new];
            title.frame = CGRectMake(30, 10, 80, 25);
            title.textColor = [UIColor darkGrayColor];
            title.font = [UIFont systemFontOfSize:14.0];
            title.text = titleStr;
            title.textAlignment = NSTextAlignmentLeft;

            [bgView addSubview:title];
            
            UITextField *text = [UITextField new];
            text.frame = CGRectMake(title.frame.origin.x + title.frame.size.width + 10, title.frame.origin.y, 100, 25);
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.placeholder = @"请输入起拍价";
            text.text = [NSString stringWithFormat:@"%.0f",price.floatValue];
            text.font = [UIFont systemFontOfSize:14.0f];
            [bgView addSubview:text];
            showInput.textField = text;
            
            // 拍卖时间
            NSString *timeStr = type == WKGoodsTypeAuction?@"拍卖时间":@"幸运购时间";
            UILabel *time = [UILabel new];
            time.frame = CGRectMake(30,title.frame.origin.y + title.frame.size.height + 15, 80, 25);
            time.textColor = [UIColor darkGrayColor];
            time.textAlignment = NSTextAlignmentLeft;
            time.font = [UIFont systemFontOfSize:14.0];
            time.text = timeStr;
            [bgView addSubview:time];
            
            UILabel *selectedTime = [UILabel new];
            selectedTime.frame = CGRectMake(time.frame.origin.x + time.frame.size.width + 10, time.frame.origin.y, 120, 25);
            selectedTime.userInteractionEnabled = YES;
            selectedTime.textColor = [UIColor darkGrayColor];
            selectedTime.font = [UIFont systemFontOfSize:14.0];
            selectedTime.text = type == WKGoodsTypeAuction?@"请选择拍卖时间":@"请选择幸运购时间";;
            selectedTime.textAlignment = NSTextAlignmentLeft;
            [bgView addSubview:selectedTime];
            
            showInput.selectTime = selectedTime;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:showInput action:@selector(selectedTime:)];
            [selectedTime addGestureRecognizer:tap];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, selectedTime.frame.size.height + selectedTime.frame.origin.y + 20, bgView.frame.size.width, 1)];
            [bgView addSubview:lineView];
            lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            
            // 按钮
            NSArray *btnTitles = @[@"取消",@"确定"];
            for (int i=0; i<btnTitles.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn addTarget:showInput action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
                btn.tag = 10 + i;
                
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
            
            [text becomeFirstResponder];
            if (block) {
                showInput.block = block;
            }
        }
    }
}

- (void)selectedTime:(UITapGestureRecognizer *)tap{
    
    [showInput endEditing:YES];
    
    if (showInput.timeTable == nil) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,WKScreenH, WKScreenW, 0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [showInput addSubview:tableView];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        showInput.timeTable = tableView;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        showInput.timeTable.frame = CGRectMake(0,WKScreenH - 44 * 6, WKScreenW, 44 *6);

    }];
    
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 10) {
        // 取消
        [[self class] dismissView:nil];
        
    }else{
        
        if(showInput.textField.text.length == 0 || showInput.textField.text.floatValue <= 0)
        {
            [WKPromptView showPromptView:@"请输入正确的起拍价！"];
            return;
        }
        else if(![showInput.selectTime.text containsString:@"min"])
        {
            [WKPromptView showPromptView:@"请填写拍卖价格和时间"];
            return;
        }
        else
        {
            if (self.block) {
                CGFloat price = showInput.textField.text.floatValue;
                if ([showInput.textField.text containsString:@"."]) {
                    [WKPromptView showPromptView:@"金额不能是小数"];
                    return;
                }
                self.block([NSString stringWithFormat:@"%.0f",price],showInput.selectTime.text);
            }
            [[self class] dismissView:nil];
        }
    }
}


#pragma mark - UITableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.text = [NSString stringWithFormat:@"%zdmin",(indexPath.row + 1) * 10];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    showInput.selectTime.text = [NSString stringWithFormat:@"%zdmin",(indexPath.row + 1) * 10];
    tableView.frame = CGRectMake(0, WKScreenH, WKScreenW, 0);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
