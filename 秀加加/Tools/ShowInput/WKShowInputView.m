//
//  WKShowInputView.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/20.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKShowInputView.h"
#import "NSObject+XWAdd.h"
@interface WKShowInputView ()<UITextViewDelegate>

/**
 *  textfield
 */
@property (strong, nonatomic) UITextField * textField;

/**
 *  textView
 */
@property (strong, nonatomic) UITextView * textView;
/**
 *  textView提示文字
 */
@property (strong, nonatomic) UILabel *contentLabel;
/**
 *  type
 */
@property (assign, nonatomic) ChooseInputBox inputBoxType;
/**
 *  label
 */
@property (strong, nonatomic) UILabel * label;
/**
 *  imageBut
 */
@property (strong, nonatomic) UIButton * imageBut;
/**
 *  蒙版
 */
@property (strong, nonatomic) UIButton *maskButton;
/**
 *  提示框view
 */
@property (strong, nonatomic) UIView *promptView;
/**
 *  控件高度
 */
@property (assign, nonatomic) CGFloat promptHeight;
/**
 *  控件宽度
 */
@property (assign, nonatomic) CGFloat promptWidth;

@end
@implementation WKShowInputView

static WKShowInputView *showInput = nil;

+(void)showInputWithPlaceString:(NSString *)placeString type:(ChooseInputBox)inputBox andBlock:(inputBlock)block{
    if (showInput == nil) {
        @synchronized (self){
            UIWindow *currenWindow = [UIApplication sharedApplication].keyWindow;
            
            showInput = [[WKShowInputView alloc]init];
            showInput.backgroundColor = [UIColor clearColor];
            showInput.inputBoxType = inputBox;
            //设置控件的宽高
            if (showInput.inputBoxType == TEXTFIELDTYPE || inputBox == LABELTYPE) {
                showInput.promptHeight = WKScreenW*0.35;
            }else{
                showInput.promptHeight = WKScreenW;
            }
            showInput.promptWidth = WKScreenW-40;
            //蒙版
            showInput.maskButton = [[UIButton alloc]init];
            showInput.maskButton.backgroundColor = [UIColor blackColor];
            showInput.maskButton.alpha = 0.4;
            [showInput.maskButton addTarget:showInput action:@selector(maskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [showInput addSubview:showInput.maskButton];
            [showInput.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(WKScreenW, WKScreenH));
            }];
            //提示View
            showInput.promptView = [[UIView alloc] init];
            showInput.promptView.backgroundColor = [UIColor whiteColor];
            showInput.promptView.layer.cornerRadius = showInput.promptWidth*0.03;
            showInput.promptView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            showInput.promptView.layer.borderWidth = showInput.promptWidth*0.01;
            showInput.promptView.layer.masksToBounds = YES;
            [showInput addSubview:showInput.promptView];
            [showInput.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.top.mas_equalTo((WKScreenH - showInput.promptHeight-20)/2);
                make.size.mas_equalTo(CGSizeMake(showInput.promptWidth, showInput.promptHeight));
            }];
            showInput.promptView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            
            [UIView animateWithDuration:0.3 animations:^{
                showInput.maskButton.backgroundColor = [UIColor blackColor];
                
                showInput.promptView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
                showInput.promptView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            }];
            //判断是textField还是textView
            if (inputBox == TEXTFIELDTYPE || inputBox == LABELTYPE) {
                //textField
                showInput.textField  = [[UITextField alloc]init];
                showInput.textField.placeholder = placeString;
                [showInput.textField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
                [showInput.promptView addSubview:showInput.textField];
                [showInput.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(20);
                    make.top.equalTo(showInput.promptView.mas_top).offset(25);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth-40-50, showInput.promptWidth*0.1));
                }];
                //如果是提示,关闭textField的用户交互
                if (inputBox == LABELTYPE) {
                    showInput.textField.text = placeString;
                    showInput.textField.autocorrectionType=NO;
                    showInput.textField.textColor = [UIColor darkGrayColor];
                    showInput.textField.userInteractionEnabled = NO;
                    [showInput.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(showInput.promptView.mas_left).offset(20);
                        make.top.equalTo(showInput.promptView.mas_top).offset(25);
                        make.size.mas_equalTo(CGSizeMake(showInput.promptWidth-40, showInput.promptWidth*0.1));
                    }];
                }
                //输入框后的button
                showInput.imageBut = [[UIButton alloc]init];
                [showInput.imageBut addTarget:showInput action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [showInput.promptView addSubview:showInput.imageBut];
                [showInput.imageBut mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.textField.mas_right).offset(5);
                    make.centerY.equalTo(showInput.textField.mas_centerY).offset(-5);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth*0.08, showInput.promptWidth*0.08));
                }];
            }else{
                //textView
                showInput.textView = [[UITextView alloc]init];
                showInput.textView.font = [UIFont systemFontOfSize:16];
                showInput.textView.delegate = showInput;
                showInput.textField.autocorrectionType=NO;
                
                showInput.label = [[UILabel alloc]init];
                showInput.label.font = [UIFont systemFontOfSize:16];
                showInput.label.textColor = [UIColor grayColor];
                showInput.label.text = placeString;
                showInput.label.numberOfLines = 0;
                [showInput.textView addSubview:showInput.label];
                [showInput.label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.textView.mas_left).offset(10);
                    make.top.equalTo(showInput.textView.mas_top).offset(10);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth-30, 17));
                }];
                
                [showInput.promptView addSubview:showInput.textView];
                [showInput.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(10);
                    make.top.equalTo(showInput.promptView.mas_top).offset(20);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth-20, WKScreenW*0.75));
                }];
            }
            //横线
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.8];
            [showInput.promptView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.left.equalTo(showInput.promptView.mas_left).offset(20);
                make.left.equalTo(showInput.promptView.mas_left).offset(0);
                make.bottom.equalTo(showInput.promptView.mas_bottom).offset(-WKScreenW*0.175);
              //  make.right.mas_equalTo(-20);
                make.right.mas_equalTo(0);
                make.height.offset(1);
            }];
            //竖线
            UIView *lineView2 = [[UIView alloc]init];
            lineView2.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.8];
            [showInput.promptView addSubview:lineView2];
            [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(showInput.promptView.mas_left).offset(showInput.promptWidth/2);
                make.centerY.equalTo(showInput.promptView.mas_bottom).offset(-WKScreenW*0.35/4);
                make.height.mas_equalTo(20);
                make.width.offset(1);
            }];
            //取消
            UIButton *cancelButton = [[UIButton alloc]init];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            cancelButton.tag = 1;
            [cancelButton addTarget:showInput action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [showInput.promptView addSubview:cancelButton];
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(showInput.promptView.mas_left).offset(0);
                make.top.equalTo(lineView.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(showInput.promptWidth/2, WKScreenW*0.35/2));
            }];
            //确认
            UIButton *confirmButton = [[UIButton alloc]init];
            [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
            confirmButton.tag = 2;
            confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[confirmButton setTintColor: [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00]];
            [confirmButton setBackgroundColor: [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00]];
            [confirmButton addTarget:showInput action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [showInput.promptView addSubview:confirmButton];
            [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(showInput.promptView.mas_left).offset(showInput.promptWidth/2);
                make.top.equalTo(lineView.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(showInput.promptWidth/2, WKScreenW*0.35/2));
            }];
            //判断横屏状态
            if (WKScreenH > WKScreenW) {
                [showInput.promptView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(20);
                    make.top.mas_equalTo((WKScreenH - showInput.promptHeight-20)/2);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth, showInput.promptHeight));
                }];
            }else{
                //重写控件位置
                showInput.promptHeight = WKScreenH * 0.35;
                showInput.promptWidth = WKScreenW*0.5;
                
                [showInput.promptView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(showInput.promptWidth/2);
                    make.top.mas_equalTo((WKScreenH - showInput.promptHeight)/2);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth, showInput.promptHeight));
                }];
                [showInput.promptView layoutIfNeeded];
                
                [confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(showInput.promptWidth/2);
                    make.top.equalTo(showInput.promptView.mas_top).offset(showInput.promptHeight/2);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth/2, showInput.promptHeight/2));
                }];
                [confirmButton layoutIfNeeded];
                
                [cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(0);
                    make.top.equalTo(showInput.promptView.mas_top).offset(showInput.promptHeight/2);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth/2, showInput.promptHeight/2));
                }];
                [cancelButton layoutIfNeeded];
                [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(0);
                    make.top.equalTo(cancelButton.mas_top).offset(-1);
                    make.height.mas_equalTo(1);
                    make.width.offset(showInput.promptWidth);
                }];
                [lineView layoutIfNeeded];
                [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(showInput.promptWidth/2);
                    make.centerY.equalTo(cancelButton.mas_top).offset(showInput.promptHeight/4);
                    make.height.mas_equalTo(20);
                    make.width.offset(1);
                }];
                [showInput.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(showInput.promptView.mas_left).offset(0);
                    make.top.equalTo(showInput.promptView.mas_top).offset(15);
                    make.size.mas_equalTo(CGSizeMake(showInput.promptWidth, showInput.promptHeight/3));
                }];
            }
            
            if (inputBox == LABELTYPE) {
                showInput.textField.textAlignment = NSTextAlignmentCenter;
            }
            
            [currenWindow addSubview:showInput];
            [showInput mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(WKScreenW, WKScreenH));
            }];
        }
    }
    showInput.block = block;
}

-(void)maskButtonClick:(UIButton *)button{
    [showInput.textField resignFirstResponder];
    [showInput.textView resignFirstResponder];
    if (WKScreenH>WKScreenW) {
        [UIView animateWithDuration:0.2 animations:^{
            showInput.maskButton.backgroundColor = [UIColor clearColor];
            showInput.promptView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [showInput removeFromSuperview];
            self.frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenH);
            showInput = nil;
        }];
    }else{
        self.frame = CGRectMake(0, WKScreenW, WKScreenW, WKScreenH);
        [self removeFromSuperview];
        [showInput removeFromSuperview];
        
        showInput = nil;
    }
}

-(void)buttonClick:(UIButton *)button{
    [showInput.textField resignFirstResponder];
    [showInput.textView resignFirstResponder];
    
    if (WKScreenH>WKScreenW) {
        [UIView animateWithDuration:0.2 animations:^{
            showInput.maskButton.backgroundColor = [UIColor clearColor];
            showInput.promptView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [showInput removeFromSuperview];
            self.frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenH);
            showInput = nil;
        }];
    }else{
        self.frame = CGRectMake(0, WKScreenW, WKScreenW, WKScreenH);
        [self removeFromSuperview];
        [showInput removeFromSuperview];
        
        showInput = nil;
    }
    if (button.tag == 2) {
        if (self.inputBoxType == TEXTFIELDTYPE) {
            
            if (self.block) {
                self.block(self.textField.text);
                self.block = nil;
                [showInput removeFromSuperview];
                [self removeFromSuperview];
            }
        }else{
            if (self.textView.text.length>200) {
                [WKProgressHUD showTopMessage:@"请输入200字以内的公告"];
            }else{
                if (self.block) {
//                    [self xw_postNotificationWithName:@"SHOWINPUTTWO" userInfo:nil];
                    self.block(self.textView.text);
                    self.block = nil;
                    [showInput removeFromSuperview];
                    [self removeFromSuperview];
                }
            }
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView;{
    NSLog(@"%lu",(unsigned long)textView.text.length);
    if (textView.text.length>0) {
        self.label.hidden = YES;
    }else{
        self.label.hidden = NO;
    }
}

+(void)textField:(NSString *)textFieldStr{
    if (textFieldStr.length>0) {
        showInput.textField.text = textFieldStr;
    }
}

+(void)textView:(NSString *)textViewStr{
    if (textViewStr.length>0) {
        showInput.textView.text = textViewStr;
        showInput.label.hidden = YES;
    }
}

+(void)addImage:(UIImage *)image and:(buttonBlock)block{
    showInput.butBlock = block;
    [showInput.imageBut setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)imageButtonClick{
    [UIView animateWithDuration:0.2 animations:^{
        showInput.maskButton.backgroundColor = [UIColor clearColor];
        showInput.promptView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [showInput removeFromSuperview];
        self.frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenH);
        showInput = nil;
    }];
    if (self.butBlock) {
        self.butBlock();
        self.butBlock = nil;
    }
}

+(void)setKeyBoard:(UIKeyboardType)keyboardType and:(ChooseInputBox)type{
    if (type == TEXTFIELDTYPE) {
        showInput.textField.keyboardType = keyboardType;
    }else if(type == TEXTVIEWTYPE){
        showInput.textView.keyboardType = keyboardType;
    }
}
@end
