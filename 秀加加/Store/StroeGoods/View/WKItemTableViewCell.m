//
//  WKItemTableViewCell.m
//  wdbo
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKItemTableViewCell.h"
#import "WKMarkModel.h"

@interface WKItemTableViewCell () <UITextFieldDelegate>{
    UIView *_lineView;
    WKMarkModel *_tempModel;
    UITextField *_text_price;
    UITextField *_text_stock;
    UITextField *_text_model;
}

@end

@implementation WKItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.right.mas_offset(-55 * WKScaleW);
            make.width.mas_offset(0.8);
        }];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"pro_del"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.left.mas_equalTo(lineView.mas_right).offset(0);
            make.width.mas_offset(25);
        }];
        
        UILabel *priceTitle = [UILabel new];
        priceTitle.textColor = [UIColor darkGrayColor];
        priceTitle.text = @"价格:";
        priceTitle.textAlignment = NSTextAlignmentLeft;
        priceTitle.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:priceTitle];
        
        [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5 + 10);
            make.top.mas_offset(20);
            make.size.mas_offset(CGSizeMake(50, 22));
        }];

        UIView *lineView0 = [UIView new];
        lineView0.tag = 1001;
        lineView0.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        [self.contentView addSubview:lineView0];
        
        [lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(44 + 10);
            make.right.mas_equalTo(lineView.mas_left).offset(-10);
            make.left.mas_offset(10);
            make.height.mas_offset(0.8);
        }];

        UITextField *textField_price = [UITextField new];
        textField_price.font = [UIFont systemFontOfSize:14.0f];
        textField_price.textColor = [UIColor lightGrayColor];
        textField_price.placeholder = @"请输入价格";
        textField_price.keyboardType = UIKeyboardTypeDecimalPad;
        textField_price.textAlignment = NSTextAlignmentLeft;
        textField_price.delegate = self;
        textField_price.tag = 11;
        [self.contentView addSubview:textField_price];
        
        _text_price = textField_price;
        
        [textField_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceTitle.mas_right).offset(10);
            make.centerY.mas_equalTo(priceTitle.mas_centerY);
            make.right.mas_equalTo(lineView.mas_left).offset(5);
            make.height.mas_offset(30);
        }];
//
        UILabel *stockNumber = [UILabel new];
        stockNumber.textColor = [UIColor darkGrayColor];
        stockNumber.text = @"库存:";
        stockNumber.textAlignment = NSTextAlignmentCenter;
        stockNumber.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:stockNumber];
        
        [stockNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5);
            make.top.mas_offset(10 + 44 + 10);
            make.size.mas_offset(CGSizeMake(50, 22));
        }];
        
        UIView *lineView1 = [UIView new];
        lineView1.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        lineView1.tag = 1002;
        [self.contentView addSubview:lineView1];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(44 * 2 + 10);
            make.right.mas_equalTo(lineView.mas_left).offset(-10);
            make.left.mas_offset(10);
            make.height.mas_offset(0.8);
        }];

        UITextField *textField_stock = [UITextField new];

        textField_stock.keyboardType = UIKeyboardTypeNumberPad;
        textField_stock.font = [UIFont systemFontOfSize:14.0f];
        textField_stock.textColor = [UIColor lightGrayColor];
        textField_stock.placeholder = @"请输入库存";
        textField_stock.tag = 12;
        textField_stock.textAlignment = NSTextAlignmentLeft;
        textField_stock.delegate = self;
        [self.contentView addSubview:textField_stock];
        
        _text_stock = textField_stock;
        
        [textField_stock mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceTitle.mas_right).offset(10);
            make.centerY.mas_equalTo(stockNumber.mas_centerY);
            make.right.mas_equalTo(lineView.mas_left).offset(5);
            make.height.mas_offset(30);
        }];
//
        UILabel *modelNo = [UILabel new];
        modelNo.textColor = [UIColor darkGrayColor];
        modelNo.text = @"型号:";
        modelNo.textAlignment = NSTextAlignmentCenter;
        modelNo.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:modelNo];
        
        [modelNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5);
            make.top.mas_offset(10 + 44 * 2 + 10);
            make.size.mas_offset(CGSizeMake(50, 22));
        }];
        
        UITextField *textField_model = [UITextField new];
        
        textField_model.font = [UIFont systemFontOfSize:14.0f];
        textField_model.textColor = [UIColor lightGrayColor];
        textField_model.placeholder = @"请输入型号";
        textField_model.tag = 13;
        textField_model.textAlignment = NSTextAlignmentLeft;
        textField_model.delegate = self;
        [self.contentView addSubview:textField_model];

        _text_model = textField_model;
        
        [textField_model mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceTitle.mas_right).offset(10);
            make.centerY.mas_equalTo(modelNo.mas_centerY);
            make.right.mas_equalTo(lineView.mas_left).offset(5);
            make.height.mas_offset(30);
        }];
    }
    
    return self;
}

- (void)setItemModel:(WKMarkModel *)model{
    CGFloat rightSpace = 0;
    
    _text_model.userInteractionEnabled = NO;
    _tempModel = model;
    [self updateLineWith:10];

    if (model.ModelName) {
        rightSpace = -35;
        _text_model.userInteractionEnabled = YES;
        [self updateLineWith:0];
    }
    
    _text_price.text = model.Price != nil?model.Price:@"";
    _text_stock.text = model.Stock != nil?[NSString stringWithFormat:@"%@",model.Stock]:@"";
    _text_model.text = model.ModelName != nil ? model.ModelName : @"";
    
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(rightSpace);
    }];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)updateLineWith:(CGFloat)padding{
    UIView *lineView0 = [self.contentView viewWithTag:1001];
    UIView *lineView1 = [self.contentView viewWithTag:1002];
    
    [lineView0 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_lineView.mas_left).offset(-padding);
    }];
    
    [lineView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_lineView.mas_left).offset(-padding);
    }];
    
}
- (void)deleteClick:(UIButton *)btn{
    
    if ([_delegate respondsToSelector:@selector(deleteWith:)]) {
        [_delegate deleteWith:_tempModel];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 11) {
        // 价格
        _tempModel.Price = textField.text;
    }else if (textField.tag == 12){
        // 库存
        _tempModel.Stock = @(textField.text.integerValue);
    }else{
        // 型号
        _tempModel.ModelName = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 12) {
        
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (toBeString.length > 4 && range.length!=1){
            textField.text = [toBeString substringToIndex:4];
            [WKProgressHUD showTopMessage:@"库存不能大于4位数"];
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}

- (void)drawRect:(CGRect)rect{
    
    // 划线
    [[UIColor colorWithHexString:@"#E9EAEF"] set];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 10, self.contentView.frame.size.width - 20, self.contentView.frame.size.height - 20)];
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapSquare;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
    
}

@end
