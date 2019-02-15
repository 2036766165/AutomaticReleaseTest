//
//  WKInputView.m
//  秀加加
//
//  Created by sks on 2016/10/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKInputView.h"
#import "WKMessage.h"
#import "WKLiveView.h"

const char *kTextField = "textField";
static char *kInputContent = "inputStatus";

@interface WKInputView () <UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton    *maskBtn;

@property (nonatomic,weak)   WKLiveView *superView;

@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIButton *gifBtn;
@property (nonatomic,strong) UIButton *switchBtn;

@property (nonatomic,strong) UIView *containView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,assign) WKGoodsLayoutType screenType;

@property (nonatomic,strong) WKInputGifView *currentItem;

@property (nonatomic,assign) WKInputType type;

@property (nonatomic,assign) WKInputType preType;           // 以前的输入状态

@property (nonatomic,copy) void(^sendBlock)(WKMessage *msg);

@property (assign, nonatomic) NSInteger saleStatus;

@end

static WKInputView *inputView = nil;

@implementation WKInputView

+ (void)showTextViewOn:(UIView *)superView screenType:(WKGoodsLayoutType)screenType inputType:(WKInputType)inputType WithInputBlock:(void(^)(WKMessage *message))block{

    if (inputView == nil) {
        @synchronized (self) {
            
            inputView = [[WKInputView alloc] init];
            inputView.frame = superView.bounds;
            [superView addSubview:inputView];
            
            inputView.superView = (WKLiveView *)superView;
            
            inputView.screenType = screenType;
            
            if (block) {
                inputView.sendBlock = block;
            }
            
            inputView.type = inputType;
            
            [[NSNotificationCenter defaultCenter] addObserver:inputView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:inputView selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.frame = superView.bounds;
//            maskBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            [maskBtn addTarget:inputView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            inputView.maskBtn = maskBtn;
            [inputView addSubview:maskBtn];
            
            UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]init];
            [maskBtn addGestureRecognizer:panGR];
            [inputView addGestureRecognizer:panGR];
        
            // 显示输入
            UIView *containView = [UIView new];
            [inputView addSubview:containView];
            inputView.containView = containView;
            
            // 输入框背景
            UIView *inputBgView = [UIView new];
            inputBgView.backgroundColor = [UIColor whiteColor];
            [containView addSubview:inputBgView];
            
            // 输入框
            UITextField *textField = [UITextField new];
            textField.placeholder = @"和主播说点什么";
            textField.textAlignment = NSTextAlignmentLeft;
            textField.font = [UIFont systemFontOfSize:14.0f];
            [inputBgView addSubview:textField];
            [textField addTarget:inputView action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            textField.delegate = inputView;
            inputView.textField = textField;
            
            // 切换按钮
            UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [switchBtn setImage:[UIImage imageNamed:@"barrage_off"] forState:UIControlStateNormal];
            [switchBtn setImage:[UIImage imageNamed:@"barrage_on"] forState:UIControlStateSelected];
            [switchBtn addTarget:inputView action:@selector(switchInputType:) forControlEvents:UIControlEventTouchUpInside];
            [inputBgView addSubview:switchBtn];
            
            inputView.switchBtn = switchBtn;
            
            if (User.isReviewID) {
                inputView.switchBtn.hidden = YES;
            }
            
            UIView *lineView = [UIView new];
            lineView.backgroundColor = [UIColor lightGrayColor];
            lineView.alpha = 0.7;
            [inputBgView addSubview:lineView];
            
            // gif图按钮
            UIButton *gifBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            gifBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [gifBtn setImage:[UIImage imageNamed:@"switchType"] forState:UIControlStateNormal];
            [gifBtn addTarget:inputView action:@selector(sendGif:) forControlEvents:UIControlEventTouchUpInside];
            [inputBgView addSubview:gifBtn];
            
            inputView.gifBtn = gifBtn;
            
            // 发送按钮
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            [sendBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateSelected];
            [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [sendBtn addTarget:inputView action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
            [inputBgView addSubview:sendBtn];
            
            inputView.sendBtn = sendBtn;
            
            UIView *lineView0 = [UIView new];
            lineView0.backgroundColor = [UIColor lightGrayColor];
            lineView0.alpha = 0.7;
            [inputBgView addSubview:lineView0];
            
            // GIF图背景
            UIView *gifBackView = [UIView new];
            gifBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [containView addSubview:gifBackView];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.delegate = inputView;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.pagingEnabled = YES;
            [gifBackView addSubview:scrollView];
            
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
            [gifBackView addSubview:pageControl];
            
            inputView.pageControl = pageControl;
            
            NSString *text = objc_getAssociatedObject(self, kInputContent);
            if (text) {
                textField.text = text;
                [sendBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
            }
            
            objc_setAssociatedObject(self, kTextField, textField, OBJC_ASSOCIATION_RETAIN);
            
            if (inputType == WKInputTypeBarrage) {
                inputView.type = WKInputTypText;
                [inputView switchInputType:switchBtn];
            }
            
            NSMutableArray *itemArr = @[].mutableCopy;
            // 实例化GIF图显示
            for (int i=1; i<25; i++) {
                WKGifModel *md = [[WKGifModel alloc] init];
                NSString *str = i<10?@"0":@"";
                NSString *name = [NSString stringWithFormat:@"%@%d",str,i];
                
                md.ImageName = [NSString stringWithFormat:@"pbq%@",name];
                md.gifName = [NSString stringWithFormat:@"bq%@",name];
                
                WKInputGifView *inputGifItem = [[WKInputGifView alloc] initWithFrame:CGRectZero gifModel:md];
                [scrollView addSubview:inputGifItem];
                [itemArr addObject:inputGifItem];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:inputView action:@selector(hanleTap:)];
                [inputGifItem addGestureRecognizer:tap];
                
            }
            
            // 横竖屏共有布局
            [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.mas_equalTo(0);
                make.width.mas_equalTo(WKScreenW);
                make.height.mas_equalTo(50);
            }];
            
            //
            [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0.15 * WKScreenW - 2, 40));
                make.left.mas_offset(1);
                make.centerY.mas_equalTo(inputBgView.mas_centerY);
            }];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(inputBgView.mas_centerY);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(inputBgView.mas_bottom).offset(-10);
                make.width.mas_equalTo(1);
                make.left.mas_equalTo(WKScreenW * 0.15);
            }];
            
            [lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(inputBgView.mas_right).offset(-WKScreenW * 0.15);
                make.centerY.mas_equalTo(inputBgView.mas_centerY);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(inputBgView.mas_bottom).offset(-10);
                make.width.mas_equalTo(1);
            }];
            
            [gifBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(30, 30));
                make.centerY.mas_equalTo(inputBgView.mas_centerY);
                make.right.mas_equalTo(lineView0.mas_left).offset(-1);
            }];
            
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lineView.mas_right).offset(5);
                make.right.mas_equalTo(gifBtn.mas_left).offset(5);
                make.top.mas_equalTo(inputBgView.mas_top).offset(5);
                make.bottom.mas_equalTo(inputBgView.mas_bottom).offset(-5);
            }];
            
            [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(inputBgView.mas_centerY);
                make.right.mas_equalTo(inputBgView.mas_right).offset(0);
                make.size.mas_equalTo(CGSizeMake(WKScreenW * 0.15, 40));
            }];
            
            [gifBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(inputBgView.mas_bottom).offset(0);
                make.left.and.right.mas_equalTo(0);
                make.bottom.mas_equalTo(containView.mas_bottom).offset(0);
            }];
            
            
            if (inputView.screenType == WKGoodsLayoutTypeVertical) {
                // 竖屏
                
                CGFloat spacing    = 10;
                CGFloat itemHeight = (WKScreenH * 0.4 - 50 -spacing *3)/2;
                CGFloat itemWidth  = (WKScreenW - spacing *5)/4;
                
                containView.frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenH * 0.4);
                gifBackView.frame = CGRectMake(0, 50, WKScreenW, WKScreenH * 0.4 - 50);
                scrollView.frame = gifBackView.bounds;
                scrollView.contentSize = CGSizeMake(WKScreenW * 3, WKScreenW * 0.4 - 50);

                pageControl.frame = CGRectMake(0, 0, 60, 20);
                pageControl.center = CGPointMake(WKScreenW/2, (WKScreenH * 0.4 - 50) - 15);
                
                pageControl.numberOfPages = 3;

                NSInteger pageNumber = 8;
                NSInteger rowNumber  = 4;
                
                for (int i=0; i<itemArr.count; i++) {
                    
                    WKInputGifView *item = itemArr[i];
                    // 页
                    NSInteger multiple = i/8;
                    // 行
                    NSInteger cloumn = (i - multiple * pageNumber)/rowNumber;
                    // 列
                    NSInteger index = (i - multiple * pageNumber)%rowNumber;
                    
                    CGRect rect = CGRectMake(multiple * WKScreenW + index * itemWidth + (index+1) * spacing, cloumn * itemHeight + (cloumn + 1) * spacing, itemWidth, itemHeight);
                    item.frame = rect;
                    
                }

                [textField becomeFirstResponder];

                [UIView animateWithDuration:0.3 animations:^{
                } completion:^(BOOL finished) {
                }];
                
            }else{
                // 横屏
                CGFloat sizeScale = 0.7;
                
                NSInteger pageNumber = 12;
                NSInteger rowNumber  = 6;
                
                CGFloat spacing    = 10;
                CGFloat itemHeight = (WKScreenH * sizeScale - 50 -spacing *2)/2;
                CGFloat itemWidth  = (WKScreenW - spacing *7)/rowNumber;
                
                containView.frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenH * sizeScale);

                gifBackView.frame = CGRectMake(0, 50, WKScreenW, WKScreenH * sizeScale - 50);
                scrollView.frame = gifBackView.bounds;
                scrollView.contentSize = CGSizeMake(WKScreenW * 2, scrollView.frame.size.height);

                pageControl.frame = CGRectMake(0, 0, 60, 20);
                pageControl.center = CGPointMake(WKScreenW/2, (WKScreenH * sizeScale - 50) - 15);

                
                pageControl.numberOfPages = 2;
    
                for (int i=0; i<itemArr.count; i++) {
                    
                    WKInputGifView *item = itemArr[i];
                    // 页
                    NSInteger multiple = i/pageNumber;
                    // 行
                    NSInteger cloumn = (i - multiple * pageNumber)/rowNumber;
                    // 列
                    NSInteger index = (i - multiple * pageNumber)%rowNumber;
                    
                    CGRect rect = CGRectMake(multiple * WKScreenW + index * itemWidth + (index+1) * spacing, cloumn * itemHeight + (cloumn + 1) * spacing, itemWidth, itemHeight);
                    item.frame = rect;
                    
                }
                
                [textField becomeFirstResponder];
                
                [UIView animateWithDuration:0.3 animations:^{
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
}

// 键盘的监听方法
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        if (inputView.screenType == WKGoodsLayoutTypeHoriztal) {
            inputView.containView.frame = CGRectMake(0,WKScreenH - (kbHeight + 50), WKScreenW, WKScreenH * 0.7);

        }else{
            inputView.containView.frame = CGRectMake(0,WKScreenH - (kbHeight + 50), WKScreenW, WKScreenH * 0.4);
        }
    }];
    
    NSDictionary *dict = @{@"kbheight":@(kbHeight)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWINPUT" object:nil userInfo:dict];
}

- (void)keyboardWillHide:(NSNotification *)notify{
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat kbh;

    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        if (inputView.screenType == WKGoodsLayoutTypeHoriztal) {
            inputView.containView.frame = CGRectMake(0, WKScreenH * 0.3, WKScreenW, WKScreenH * 0.7);
        }else{
            inputView.containView.frame = CGRectMake(0, WKScreenH * 0.6, WKScreenW, WKScreenH * 0.4);
        }
    }];
    
    if (inputView.screenType == WKGoodsLayoutTypeHoriztal) {
        kbh = 0.7* WKScreenH - 50;
    }else{
        kbh = 0.4* WKScreenH - 50;
    }
    
    NSDictionary *dict = @{@"kbheight":@(kbh)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWINPUT" object:nil userInfo:dict];
}

- (void)textChanged:(UITextField *)textField{
    if (textField.text.length == 0) {
        [inputView.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [inputView.sendBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/WKScreenW;
    [inputView.pageControl setCurrentPage:page];
    
}

- (void)hanleTap:(UITapGestureRecognizer *)tap{
    
    if (inputView.currentItem != nil) {
        inputView.currentItem.gifModel.isSelected = NO;
    }
    
    WKInputGifView *tempGif = (WKInputGifView *)tap.view;
    tempGif.gifModel.isSelected = YES;
    
    inputView.currentItem = tempGif;
    
    WKMessage *msg = [[WKMessage alloc] init];
    msg.name = User.MemberName;
    msg.isGif = YES;
    msg.gif = inputView.currentItem.gifModel.gifName;
    
    if (inputView.sendBlock) {
        inputView.sendBlock(msg);
    }
    
//    [inputView dismissView:inputView.maskBtn];
}

// 隐藏view
- (void)dismissView:(UIButton *)btn{
    
    [UIView animateWithDuration:0.3 animations:^{
        if (inputView.textField.becomeFirstResponder) {
            [inputView.textField resignFirstResponder];
        }else{
            inputView.containView.frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenH * 0.4);
        }
        
    } completion:^(BOOL finished) {
        
        if (_textField.text.length != 0) {
            objc_setAssociatedObject(self.class, kInputContent, _textField.text, OBJC_ASSOCIATION_COPY);
        }
        
        [inputView.maskBtn removeFromSuperview];
        [inputView.containView removeFromSuperview];
        [inputView removeFromSuperview];
        inputView.sendBlock = nil;
        inputView = nil;
        
        IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
        keyBoard.enable = YES;
        keyBoard.enableAutoToolbar = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISSINPUT" object:nil];
        
    }];
}

// 切换输入方式
- (void)switchInputType:(UIButton *)btn{
    inputView.gifBtn.hidden = NO;
    
    if (inputView.type == WKInputTypeGif) {
        inputView.type = WKInputTypText;
        inputView.textField.placeholder = @"输入聊天内容";
        [btn setImage:[UIImage imageNamed:@"barrage_off"] forState:UIControlStateNormal];
        [inputView.textField becomeFirstResponder];
        
        if (inputView.preType == WKInputTypeBarrage) {
            
            inputView.type = WKInputTypeBarrage;
            btn.selected = !btn.selected;
            inputView.textField.placeholder = @"开启弹幕,0.1元/条";
            if (self.saleStatus == 100) {
                inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
            }
            
            inputView.preType = inputView.type;

        }else if (inputView.preType == WKInputTypText){
            
            inputView.type = WKInputTypText;
//            btn.selected = !btn.selected;
            inputView.textField.placeholder = @"和主播说点什么";
            if (self.saleStatus == 1 || self.saleStatus == 100) {
                inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
            }
            
            inputView.preType = inputView.type;

        }
        
    }else if(inputView.type == WKInputTypText){
        inputView.type = WKInputTypeBarrage;
        btn.selected = !btn.selected;
        inputView.textField.placeholder = @"开启弹幕,0.1元/条";
        if (self.saleStatus == 100 || self.saleStatus == 101) {
            inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
        }
        
        inputView.preType = inputView.type;

    }else if (inputView.type == WKInputTypeBarrage){
        inputView.type = WKInputTypText;
        btn.selected = !btn.selected;
        inputView.textField.placeholder = @"和主播说点什么";
        if (self.saleStatus == 1 || self.saleStatus == 100 || self.saleStatus == 101) {
            inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
        }
        
        inputView.preType = inputView.type;

    }
    
    inputView.superView.inputType = inputView.type;
    

}

- (void)sendGif:(UIButton *)btn{
    // 选择就是键盘
    
    inputView.preType = inputView.type;
    
    [inputView.textField resignFirstResponder];
    btn.hidden = YES;
    inputView.type = WKInputTypeGif;
    
    [inputView.switchBtn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
    inputView.switchBtn.selected = NO;
}

// 发送输入内容
- (void)sendMsg:(UIButton *)btn{
    
    if (inputView.textField.text.length != 0) {
        WKMessage *msg = [[WKMessage alloc] init];
        msg.name = User.MemberName;
        msg.isGif = NO;
        msg.sendType = inputView.type;
        
        msg.content = inputView.textField.text;
        inputView.textField.text = @"";
        
//        [inputView.textField resignFirstResponder];
//        [inputView dismissView:inputView.maskBtn];
        if (msg.sendType == WKInputTypeBarrage && msg.content.length>20) {
            inputView.textField.text = msg.content;
        }
        if (inputView.sendBlock) {
            inputView.sendBlock(msg);
        }
    }else{
        [WKPromptView showPromptView:@"聊天内容不能为空"];
    }
}
//status 1.拍卖中 100.参与拍卖 0,未拍卖
+ (void)settingPlaceholderContentWithType:(NSInteger )status{
    inputView.saleStatus = status;
    if (status == 1) {
        if (inputView.switchBtn.isSelected) {
            inputView.textField.placeholder = @"开启弹幕,0.1元/条";
        }else{//未开启
            inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
        }
    }else if (status == 100){
        inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
    }else if (status == 101){
        inputView.textField.placeholder = @"参与拍卖可免费发送弹幕哦";
        inputView.switchBtn.selected = YES;
        inputView.type = WKInputTypeBarrage;
    }else if (status == 0){
        if (inputView.switchBtn.isSelected) {
            inputView.textField.placeholder = @"开启弹幕,0.1元/条";
        }else{//未开启
            inputView.textField.placeholder = @"和主播说点什么";
        }
    }
}

@end
