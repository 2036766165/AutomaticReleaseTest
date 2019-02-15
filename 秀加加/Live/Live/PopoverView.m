//
//  PopoverView.m
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//

#import "PopoverView.h"
#import "WKPopverCell.h"
#import "NSString+WJ.h"

@implementation WKPopverItem


@end

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 44.f
#define TITLE_FONT [UIFont systemFontOfSize:16]
//#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface PopoverView ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *_superView;
    UIView *_fromView;
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *itemArray;

//@property (nonatomic, strong) NSArray *titleArray;
//@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic) CGPoint showPoint;

//@property (nonatomic, strong) UIButton *handerView;

@end

@implementation PopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.borderColor = RGB(200, 199, 204);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    }
    
    return self;
}

- (instancetype)initFrom:(UIView *)view On:(UIView *)superView titles:(NSArray *)titles images:(NSArray *)images selectedImages:(NSArray *)selectedImages type:(WKPopverType)type{
    if (self = [super init]) {
        
        if (type == WKPopverTypeCamera) {
            self.image = [UIImage imageNamed:@"kuang"];
        }else{
            self.image = [UIImage imageNamed:@"shareBg"];
        }
        
        self.backgroundColor = [UIColor clearColor];
        
        self.itemArray = @[].mutableCopy;
        
        for (int i=0; i<titles.count; i++) {
            WKPopverItem *item = [WKPopverItem new];
            item.itemName = titles[i];
            item.itemImage = images[i];
            item.itemSelctedImage = selectedImages[i];
            [self.itemArray addObject:item];
        }
        
        _superView = superView;
        _fromView = view;
        
        for (int i=0; i<_superView.subviews.count; i++) {
            
            UIView *v = _superView.subviews[i];
            if ([v isKindOfClass:self.class]) {
                [v removeFromSuperview];
            }
        }

        [superView addSubview:self];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view.mas_top).offset(-5);
            make.right.mas_equalTo(view.mas_right).offset(15);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        [self addSubview:self.tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

-(void)show{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_superView addGestureRecognizer:tap];
    
    NSString *str = [self getLengthestStr];
    
    CGFloat width = [str sizeOfStringWithFont:[UIFont systemFontOfSize:14.0f] withMaxSize:CGSizeMake(10000, 40)].width;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_fromView.mas_top).offset(-5);
            make.right.mas_equalTo(_fromView.mas_right).offset(5);
            make.size.mas_offset(CGSizeMake(width + 60, ROW_HEIGHT * self.itemArray.count + 10));
        }];
    }];
    
    [self layoutIfNeeded];
}

- (NSString *)getLengthestStr{
    NSString *str = @"";
    
    for (int i=0; i<self.itemArray.count; i++) {
        WKPopverItem *item = self.itemArray[i];
        if (item.itemName.length > str.length) {
            str = item.itemName;
        }
    }
    
    return str;
}


-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    
    if (self.dismissCompletion) {
        
        UIButton *btn = (UIButton *)_fromView;
        btn.selected = NO;
        self.dismissCompletion();
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        NSArray *arr = [_superView gestureRecognizers];
        for (int i=0; i<arr.count; i++) {
            
            UIGestureRecognizer *ges = arr[i];
            if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
                [_superView removeGestureRecognizer:ges];
            }
        }
    }];
}


#pragma mark - UITableView
-(UITableView *)tableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.frame;
    rect.origin.x = SPACE;
    rect.origin.y = kArrowHeight + SPACE;
    rect.size.width -= SPACE * 2;
    rect.size.height -= (SPACE - kArrowHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.layer.borderColor = [UIColor clearColor].CGColor;
    self.tableView.layer.borderWidth = 1.0f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    
    return _tableView;
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString *str = [self getLengthestStr];
    
    CGFloat width = [str sizeOfStringWithFont:[UIFont systemFontOfSize:14.0f] withMaxSize:CGSizeMake(10000, 40)].width;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 80, 2.0)];
    lineView.backgroundColor = [UIColor clearColor];
    return lineView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    WKPopverCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WKPopverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedInex = ^(id obj){
        WKPopverCell *cell = (WKPopverCell *)obj;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];

        _selectedIndex = indexPath.row;
        
        for (int i=0; i<self.itemArray.count; i++) {
            WKPopverItem *preItem = self.itemArray[i];
            
            if (_selectedIndex == i && preItem.isSelected == YES) {
                _selectedIndex = -1;
            }
            
            preItem.isSelected = NO;
        }
        
        if (_selectedIndex != -1) {
            WKPopverItem *item = self.itemArray[indexPath.row];
            item.isSelected = YES;
            [cell setItem:item];
        }
        
        if (self.selectRowAtIndex) {
            self.selectRowAtIndex(_selectedIndex);
        }
        
        [tableView reloadData];
    };
    
    [cell setItem:self.itemArray[indexPath.row]];
    return cell;
}

- (void)setSelectedIndex:(NSInteger)index{
    _selectedIndex = index;
    if (_selectedIndex != -1) {
        WKPopverItem *item = self.itemArray[index];
        item.isSelected = YES;
        [_tableView reloadData];
    }
}

//- (void)itemSelectedWith:(id)obj{
//    WKPopverCell *cell = (WKPopverCell *)obj;
//    
//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//    
//    WKPopverItem *item = self.itemArray[indexPath.row];
//    item.isSelected = YES;
//    
//    [cell setItem:item];
//    
//    if (self.selectRowAtIndex) {
//        self.selectRowAtIndex(indexPath.row);
//    }
//
//}

#pragma mark - UITableView Delegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    WKPopverItem *item = self.itemArray[indexPath.row];
//    item.isSelected = YES;
//    
//    WKPopverCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    [cell setItem:item];
//    
//    if (self.selectRowAtIndex) {
//        self.selectRowAtIndex(indexPath.row);
//    }
////    [self dismiss:YES];
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    WKPopverItem *item = self.itemArray[indexPath.row];
//    item.isSelected = NO;
//    WKPopverCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setItem:item];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [self.borderColor set]; //设置线条颜色
//    
//    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
//    
//    float xMin = CGRectGetMinX(frame);
//    float yMin = CGRectGetMinY(frame);
//    
//    float xMax = CGRectGetMaxX(frame);
//    float yMax = CGRectGetMaxY(frame);
//    
//    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
//    
//    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
//    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
//    
//    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
//    [popoverPath addCurveToPoint:arrowPoint
//                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
//                   controlPoint2:arrowPoint];//actual arrow point
//    
//    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
//                   controlPoint1:arrowPoint
//                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
//    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
//    
//    //填充颜色
//    [RGB(245, 245, 245) setFill];
//    [popoverPath fill];
//    
//    [popoverPath closePath];
//    [popoverPath stroke];
//}


@end
