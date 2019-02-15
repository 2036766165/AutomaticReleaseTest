//
//  WKShowInputView.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/20.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^inputBlock)(NSString *);
typedef void (^buttonBlock)();

typedef enum {
    TEXTFIELDTYPE,   // input
    TEXTVIEWTYPE,    // textFild
    LABELTYPE        // select
}ChooseInputBox;

@interface WKShowInputView : UIView

+(void)showInputWithPlaceString:(NSString *)placeString type:(ChooseInputBox)inputBox andBlock:(inputBlock)block;
/**
 *  block
 */
@property (copy, nonatomic) inputBlock block;

@property (copy, nonatomic) buttonBlock butBlock;

+(void)textField:(NSString *)textFieldStr;

+(void)textView:(NSString *)textViewStr;

+(void)addImage:(UIImage *)image and:(buttonBlock)block;

+(void)setKeyBoard:(UIKeyboardType)keyboardType and:(ChooseInputBox)type;

@end
