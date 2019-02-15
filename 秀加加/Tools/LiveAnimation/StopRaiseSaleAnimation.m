//
//  RaiseSaleAnimation.m
//  Animation
//
//  Created by Chang_Mac on 17/2/24.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import "StopRaiseSaleAnimation.h"

@interface StopRaiseSaleAnimation ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray * proTimeList;

@end

static StopRaiseSaleAnimation *raiseSale;

@implementation StopRaiseSaleAnimation

+(void)StopAcutionAnimation:(StartAuctionModel *)auctionModel andMessageView:(UIView *)messageView superView:(UIView *)superView{
    
    if (raiseSale) {
        raiseSale = nil;
        [raiseSale removeFromSuperview];
    }
    
    raiseSale = [[StopRaiseSaleAnimation alloc]init];
    
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [superView addSubview:maskView];
    
    UIView *view = [superView viewWithTag:123213];
    [superView insertSubview:maskView aboveSubview:view];
    
    [maskView addSubview:messageView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]init];
    [maskView addGestureRecognizer:tapGR];
    
    UIImageView *pickIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.1, WKScreenW*0.38, WKScreenW*0.8, WKScreenW*0.75)];
    pickIM.image = [UIImage imageNamed:@"chenggong-1"];
    [maskView addSubview:pickIM];
    
    raiseSale.proTimeList = auctionModel.memberArr.mutableCopy;;
        
    // 选择框
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    // 显示选中框
    pickerView.delegate = raiseSale;
    pickerView.dataSource = raiseSale;
    pickerView.showsSelectionIndicator=YES;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    pickerView.frame = CGRectMake(WKScreenW*0.09, WKScreenW*0.21, WKScreenW*0.6, WKScreenW*0.27);
    pickerView.showsSelectionIndicator = YES;
    [pickIM addSubview:pickerView];
    
    [pickerView selectRow:raiseSale.proTimeList.count-3 inComponent:0 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAKeyframeAnimation *pickViewAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        pickViewAnim.duration = 0.2;
        pickViewAnim.beginTime = 1+CACurrentMediaTime();
        pickViewAnim.values = @[@(1),@(0)];
        pickViewAnim.removedOnCompletion = NO;
        pickViewAnim.fillMode = kCAFillModeForwards;
        [pickIM.layer addAnimation:pickViewAnim forKey:nil];
        
        UILabel *memberName = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.18, WKScreenW*0.675, WKScreenW*0.64, WKScreenW*0.1)];
        memberName.text = auctionModel.memberName;
        memberName.layer.opacity = 0;
        memberName.textColor = [UIColor whiteColor];
        memberName.textAlignment = NSTextAlignmentCenter;
        memberName.font = [UIFont systemFontOfSize:WKScreenW*0.06];
        [maskView addSubview:memberName];
        
        CAKeyframeAnimation *memberNameAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        memberNameAnim.duration = 0.2;
        memberNameAnim.beginTime = 1.0f;
        memberNameAnim.values = @[@(0),@(1)];
        memberNameAnim.removedOnCompletion = NO;
        memberNameAnim.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *memberNamePersitionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        memberNamePersitionAnim.duration = 0.2;
        memberNamePersitionAnim.beginTime = 1.0f;
        memberNamePersitionAnim.values = @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenW*0.775)],[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenH*0.5+WKScreenW*0.13)]];
        memberNamePersitionAnim.removedOnCompletion = NO;
        memberNamePersitionAnim.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *memberNameTransAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        memberNameTransAnim.duration = 0.5;
        memberNameTransAnim.beginTime = 1;
        memberNameTransAnim.values = @[@(1),@(1.5),@(1.5),@(1)];
        memberNameTransAnim.removedOnCompletion = NO;
        memberNameTransAnim.fillMode = kCAFillModeForwards;
        
        CAAnimationGroup *memberNameGroup = [CAAnimationGroup animation];
        memberNameGroup.duration = 5;
        memberNameGroup.removedOnCompletion = NO;
        memberNameGroup.fillMode = kCAFillModeForwards;
        memberNameGroup.animations = @[memberNameAnim,memberNamePersitionAnim,memberNameTransAnim];
        [memberName.layer addAnimation:memberNameGroup forKey:nil];
        
        UIImageView *memberIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.4, WKScreenW*0.1, WKScreenW*0.2, WKScreenW*0.2)];
        memberIM.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:auctionModel.memberPic]]];
        memberIM.layer.cornerRadius = WKScreenW*0.1;
        memberIM.layer.masksToBounds = YES;
        memberIM.alpha = 0;
        memberIM.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [maskView addSubview:memberIM];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            memberIM.alpha = 1;
        });
        
        CAKeyframeAnimation *memberIMTransAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        memberIMTransAnim.duration = 0.325;
        memberIMTransAnim.removedOnCompletion = NO;
        memberIMTransAnim.fillMode = kCAFillModeForwards;
        memberIMTransAnim.values = @[@(0.1),@(1)];
        
        CAKeyframeAnimation *memberIMPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        memberIMPositionAnim.duration = 0.325;
        memberIMPositionAnim.removedOnCompletion = NO;
        memberIMPositionAnim.fillMode = kCAFillModeForwards;
        memberIMPositionAnim.values = @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenW*0.2)],[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.5, WKScreenH*0.5-WKScreenW*0.05)]];
        
        CAAnimationGroup *memberIMGroup = [CAAnimationGroup animation];
        memberIMGroup.animations = @[memberIMPositionAnim,memberIMTransAnim];
        memberIMGroup.duration = 0.325;
        memberIMGroup.beginTime = 1.15+CACurrentMediaTime();
        memberIMGroup.removedOnCompletion = NO;
        memberIMGroup.fillMode = kCAFillModeForwards;
        [memberIM.layer addAnimation:memberIMGroup forKey:nil];
        
        UIImageView *animationIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
        NSMutableArray *images = [NSMutableArray new];
        for (int i = 1 ; i < 18; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"lucky%d-1",i]]];
        }
        animationIM.animationImages = images;
        animationIM.animationRepeatCount = 1;
        animationIM.animationDuration = 1;
        animationIM.alpha = 0;
        animationIM.image = [UIImage imageNamed:@"lucky17-1"];
        [maskView addSubview:animationIM];
        [maskView sendSubviewToBack:animationIM];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            animationIM.alpha = 0.5;
            [animationIM startAnimating];
        });
        
        CGSize textSize = [auctionModel.memberName sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW*0.06] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW*0.06)];
        UIImageView *memberNameBackIM = [[UIImageView alloc]initWithFrame:CGRectMake((WKScreenW*0.96-textSize.width)/2, WKScreenH*0.5+WKScreenW*0.097, textSize.width+WKScreenW*0.05, WKScreenW*0.07)];
        memberNameBackIM.image = [UIImage imageNamed:@"name1"];
        memberNameBackIM.alpha = 0;
        [maskView addSubview:memberNameBackIM];
        [maskView bringSubviewToFront:memberName];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            memberNameBackIM.alpha = 1;
        });
        
        
        UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.2, WKScreenH*0.5+WKScreenW*0.22, WKScreenW*0.6, WKScreenW*0.13)];
        goodsView.layer.cornerRadius = 8;
        goodsView.layer.borderColor = [UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1].CGColor;
        goodsView.backgroundColor = [[UIColor colorWithRed:253/255.0 green:200/255.0 blue:80/255.0 alpha:1] colorWithAlphaComponent:0.1];
        goodsView.layer.borderWidth = 1;
        goodsView.layer.masksToBounds = YES;
        goodsView.layer.opacity = 0;
        [maskView addSubview:goodsView];
        
        UIImageView *goodsIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.02, WKScreenW*0.09, WKScreenW*0.09)];
        goodsIM.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:auctionModel.goodsPic]]];
        goodsIM.layer.cornerRadius = WKScreenW*0.045;
        goodsIM.layer.masksToBounds = YES;
        [goodsView addSubview:goodsIM];
        
        UILabel *goodsName = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.18, WKScreenW*0.02, WKScreenW*0.7, WKScreenW*0.09)];
        goodsName.textColor = [UIColor whiteColor];
        goodsName.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        goodsName.text = auctionModel.goodsName.length<1?@"语音商品":auctionModel.goodsName;
//        goodsName.adjustsFontSizeToFitWidth = YES;
        [goodsView addSubview:goodsName];
        if ([goodsName.text isEqualToString:@"语音商品"]) {
            goodsIM.image = [UIImage imageNamed:@"yuyin"];
        }
        
        CAKeyframeAnimation *priceAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        priceAnim.duration = 2;
        priceAnim.beginTime = CACurrentMediaTime()+2.5;
        priceAnim.values = @[@(0.5),@(1)];
        priceAnim.keyTimes = @[@(0.03),@(0.06)];
        priceAnim.removedOnCompletion = NO;
        priceAnim.fillMode = kCAFillModeForwards;
        [goodsView.layer addAnimation:priceAnim forKey:nil];
        
        [UIView animateWithDuration:0.5 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            raiseSale = nil;
        }];
    });
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return self.proTimeList.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *contentStr = self.proTimeList[row];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: contentStr];
    //颜色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, contentStr.length)];
    //字号
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: WKScreenW*0.025] range: NSMakeRange(0, contentStr.length)];
    
    return attributedStr;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return WKScreenW*0.08;
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    // 使用一个UIAlertView来显示用户选中的列表项
    NSLog(@"%@",self.proTimeList[row]);
}
@end
