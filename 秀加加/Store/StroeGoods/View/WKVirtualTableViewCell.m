//
//  WKVirtualTableViewCell.m
//  秀加加
//  标题：维护虚拟商品
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKVirtualTableViewCell.h"
#import "WKPickerImageView.h"
#import "UITextView+Placeholder.h"
#import "WKCellOperationProtocol.h"
#import "WKGoodsModel.h"

@interface WKVirtualTableViewCell () <WKCellOperationProtocol,UITextViewDelegate>

@property (nonatomic,strong) UITextView *memoTextView;

@property (nonatomic,weak) WKPickerImageView *pickImageV;

@property (nonatomic , strong) UILabel *lblTip;

@end

@implementation WKVirtualTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFB64F"];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFB64F"];
        CGFloat cellHeight = 240;

        UIBezierPath *topPath = [UIBezierPath bezierPath];
        topPath.lineWidth = 1.0;
        [topPath moveToPoint:CGPointMake(-1, 16)];
        [topPath addLineToPoint:CGPointMake(WKScreenW*3/4, 16)];
        [topPath addLineToPoint:CGPointMake(WKScreenW *3/4 + 8, 4)];
        [topPath addLineToPoint:CGPointMake(WKScreenW *3/4 + 16, 16)];
        [topPath addLineToPoint:CGPointMake(WKScreenW, 16)];
//        [topPath closePath];
        [topPath addLineToPoint:CGPointMake(WKScreenW + 1, cellHeight - 1)];
        [topPath addLineToPoint:CGPointMake(-1, cellHeight - 1)];
        [topPath closePath];
        
        CAShapeLayer *topLine = [CAShapeLayer layer];
        topLine.path = topPath.CGPath;
        topPath.lineWidth = 1.0;
        
        topLine.fillColor = [UIColor whiteColor].CGColor;
        topLine.strokeColor = [UIColor colorWithHexString:@"#FFB64F"].CGColor;
        [self.contentView.layer addSublayer:topLine];
        
        //选择图片
        CGFloat itemWidth = (WKScreenW - 50)/4;

        WKPickerImageView *pickerImageV = [[WKPickerImageView alloc] initWithFrame:CGRectZero type:WKPickerImageTypeVirtual];
        
        __weak typeof(self) weakSelf = self;
        self.pickImageV = pickerImageV;
        
        pickerImageV.refreshImage = ^(){
            if ([_delegate respondsToSelector:@selector(getImageArr:memo:)]) {
                [_delegate getImageArr:[weakSelf.pickImageV getImageArr] memo:self.memoTextView.text];
            }
        };
        
        pickerImageV.refreshCount = ^(NSInteger lineCount) {
            [topPath removeAllPoints];
            [topLine removeFromSuperlayer];
            
            [topPath moveToPoint:CGPointMake(-1, 10)];
            [topPath addLineToPoint:CGPointMake(WKScreenW*3/4, 10)];
            [topPath addLineToPoint:CGPointMake(WKScreenW *3/4 + 5, 0)];
            [topPath addLineToPoint:CGPointMake(WKScreenW *3/4 + 10, 10)];
            [topPath addLineToPoint:CGPointMake(WKScreenW, 10)];
            //        [topPath closePath];
            [topPath addLineToPoint:CGPointMake(WKScreenW + 1, 219 + (lineCount - 1) * (itemWidth + 10))];
            [topPath addLineToPoint:CGPointMake(-1, 219 + (lineCount - 1) * (itemWidth + 10))];
            [topPath closePath];
            
            topLine.path = topPath.CGPath;

            [weakSelf.pickImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(WKScreenW, itemWidth + 10 + (lineCount - 1) * (itemWidth + 10)));
            }];
//            [self.contentView.layer addSublayer:topLine];
            [self.contentView.layer insertSublayer:topLine atIndex:0];

            if ([_delegate respondsToSelector:@selector(refreshHeight:)]) {
                [_delegate refreshHeight:220 + (lineCount - 1) * (itemWidth + 10)];
            }
            
        };
        
        pickerImageV.maxCount = 9;
        [self.contentView addSubview:pickerImageV];
        
        [pickerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(20);
            make.left.mas_offset(0);
            make.size.mas_offset(CGSizeMake(WKScreenW, itemWidth + 20));
        }];
        
        UITextView *textView = [UITextView new];
        textView.placeholder = @"备注";
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:14.0f];
        textView.layer.borderColor = [UIColor colorWithHexString:@"#FFB64F"].CGColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 3.0;
        
        textView.placeholderColor = [UIColor colorWithHexString:@"#FFB64F"];
        textView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:textView];
        self.memoTextView = textView;
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pickerImageV.mas_bottom).offset(10);
            make.left.mas_offset(10);
            make.bottom.mas_offset(-40);
            make.width.mas_offset(WKScreenW - 20);
        }];
        
        self.lblTip = [[UILabel alloc]init];
        self.lblTip.text = @"无限制";
        self.lblTip.textColor = [UIColor colorWithHexString:@"#FFB64F"];
        self.lblTip.textAlignment = NSTextAlignmentCenter;
        self.lblTip.font = [UIFont systemFontOfSize:14];
        self.lblTip.backgroundColor = [UIColor clearColor];
        CGSize tipSize = [self.lblTip.text sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 15)];
        [self.contentView addSubview:self.lblTip];
        [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-44);
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.size.sizeOffset(CGSizeMake(tipSize.width, 15));
        }];
        
        UILabel *lab = [UILabel new];
        lab.text = @"温馨提示: 虚拟商品购买成功后自动发货";
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textColor = [UIColor colorWithHexString:@"#FFB64F"];
        [self.contentView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.size.mas_offset(CGSizeMake(300, 20));
        }];

        
//        UIBezierPath *bottomPath = [UIBezierPath bezierPath];
//        [bottomPath moveToPoint:CGPointMake(0, self.contentView.frame.size.height - 1)];
//        [bottomPath addLineToPoint:CGPointMake(WKScreenW, self.contentView.frame.size.height - 1)];
//        
//        CAShapeLayer *bottomLine = [CAShapeLayer layer];
//        bottomLine.path = bottomPath.CGPath;
//        bottomLine.fillColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor;
//        [self.contentView.layer addSublayer:bottomLine];
        
    }
    return self;
}

- (void)setDataModel:(WKGoodsModel *)dataModel{
    self.memoTextView.text = dataModel.Memo;
    [self.pickImageV setImageArr:dataModel.GoodsVirtualInfoList];
    if(dataModel.Memo.length > 0)
    {
        self.lblTip.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length == 0)
    {
        self.lblTip.hidden = NO;
    }
    
    if ([_delegate respondsToSelector:@selector(getImageArr:memo:)]) {
        [_delegate getImageArr:[self.pickImageV getImageArr] memo:textView.text];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.lblTip.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
