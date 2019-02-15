//
//  WKPagesView.m
//  wdbo
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKPagesView.h"
#import "YCSegmentViewUnit.h"
#import "WKItemBtn.h"
#import "UIImage+Extension.h"
#import "WKCollectionView.h"
#import "UIViewController+WKTrack.h"
#import "WMScrollView.h"

@interface WKPagesView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    NSArray *_viewControllers;
    NSArray *_titles;
    NSArray *_imageNames;
    NSArray *_selectedImageNames;
    NSMutableArray *_btnArr;
    UIButton *_selectedBtn;
    UIView *_animationView;
    WKPageType _type;
    NSInteger _index;
}

@property (nonatomic,strong)  WKCollectionView *collectionView;

@end;

@implementation WKPagesView

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)initWithFrame:(CGRect)frame toolBarType:(WKPageType)type BtnTitles:(NSArray *)titles images:(NSArray *)imageNames selectedImages:(NSArray *)selectedImages  viewController:(NSArray <UIViewController *>*)viewControllers{
    if (self = [super initWithFrame:frame]) {
        
        _type = type;
        
        _btnArr = @[].mutableCopy;
        
        _viewControllers = viewControllers;
        _titles = titles;
        _imageNames = imageNames;
        _selectedImageNames = selectedImages;
        
        NSAssert(_titles.count != _imageNames.count != _selectedImageNames.count != _viewControllers.count, @"必须一一对应");
        
        UIView *toolbar = [UIView new];
        toolbar.backgroundColor = [UIColor whiteColor];
        [self addSubview:toolbar];
        
        CGFloat toolbarHeight = 60.0f;

        if (type == WKPageTypeShare) {
            
            toolbarHeight = 40.0f;
        }
        
        [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.top.mas_offset(0);
            make.height.mas_offset(toolbarHeight);
        }];
        
        if (type == WKPageTypeShare) {

            UIView *lineView = [UIView new];
            lineView.backgroundColor = [UIColor whiteColor];
            [toolbar addSubview:lineView];
            lineView.frame = CGRectMake(0, toolbarHeight - 2, WKScreenW, 2);
            NSString *title = _titles[0];
            CGFloat width = [title boundingRectWithSize:CGSizeMake(10000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:NULL].size.width;

            _animationView = [UIView new];
            _animationView.backgroundColor = MAIN_COLOR;
            _animationView.frame = CGRectMake((WKScreenW/_titles.count)/2, 0, width + 10, 2);
            _animationView.center = CGPointMake(WKScreenW/_titles.count, 0.5);
            
            [lineView addSubview:_animationView];
        }
        
        for (int i=0; i<_titles.count; i++) {
            
            WKItemBtn *btn = [WKItemBtn buttonWithType:UIButtonTypeCustom];
            
            [btn setImage:[UIImage imageNamed:_imageNames[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_selectedImageNames[i]] forState:UIControlStateSelected];
            
            btn.tag = 10 + i;
            
            [self setupBtn:btn With:type Index:i];
            [toolbar addSubview:btn];
            [_btnArr addObject:btn];
            
            CGFloat singleWidth = WKScreenW/_viewControllers.count;
            
            if (type == WKPageTypeShare) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(0);
                    make.left.mas_offset(singleWidth * i + 1);
                    make.width.mas_offset(singleWidth);
                    make.height.mas_offset(toolbarHeight-1);
                }];
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(0);
                    make.left.mas_offset(singleWidth * i + 1);
                    make.width.mas_offset(singleWidth);
                    make.height.mas_equalTo(toolbar.mas_height);
                }];
            }
            
            if (i == 0) {
                
                if (type == WKPageTypeShare) {
                }
                
                [self pageSelectedIndex:btn];
            }
            
            UIViewController *controller = _viewControllers[i];
            controller.itemBtn = btn;
        }
        
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[WKCollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[YCSegmentViewUnit class] forCellWithReuseIdentifier:@"YCSegmentViewUnit"];
        [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
        self.collectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(toolbar.mas_bottom).offset(1);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.bottom.mas_offset(0);
        }];

    }
    
    return self;
}

- (void)setupBtn:(WKItemBtn *)btn With:(WKPageType)type Index:(NSInteger)i{
    
    btn.btnType = type;
    
    if (type == WKPageTypeOrder) {
        
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(pageSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *attriTitle_normal = [[NSMutableAttributedString alloc] initWithString:_titles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x8f8f8f]
                                                                                                                                 }];
        
        NSMutableAttributedString *attriTitle_selected = [[NSMutableAttributedString alloc] initWithString:_titles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:MAIN_COLOR
                                                                                                                                   }];

        [btn setAttributedTitle:attriTitle_normal forState:UIControlStateNormal];
        [btn setAttributedTitle:attriTitle_selected forState:UIControlStateSelected];
        
    }
    else if (type == WKPageTypeShare){
        // 分享
        [btn addTarget:self action:@selector(pageSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *attriTitle_normal = [[NSMutableAttributedString alloc] initWithString:_titles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x8f8f8f]
                                                                                                                                 }];
        
        NSMutableAttributedString *attriTitle_selected = [[NSMutableAttributedString alloc] initWithString:_titles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:MAIN_COLOR
                                                                                                                                   }];
        
        [btn setAttributedTitle:attriTitle_normal forState:UIControlStateNormal];
        [btn setAttributedTitle:attriTitle_selected forState:UIControlStateSelected];
        
    }
    else{
        [btn addTarget:self action:@selector(pageSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *attriTitle_normal = [[NSMutableAttributedString alloc] initWithString:_titles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x8f8f8f]
                                                                                                                                 }];
        
        NSMutableAttributedString *attriTitle_selected = [[NSMutableAttributedString alloc] initWithString:_titles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                                                                                                                   NSForegroundColorAttributeName:MAIN_COLOR
                                                                                                                                   }];

        [btn setAttributedTitle:attriTitle_normal forState:UIControlStateNormal];
        [btn setAttributedTitle:attriTitle_selected forState:UIControlStateSelected];
    }

}

- (void)pageSelectedIndex:(UIButton *)btn{
    [self animationViewWith:btn];
    self.collectionView.scrollEnabled = YES;
    NSInteger index = btn.tag - 10;
    [self.collectionView setContentOffset:CGPointMake(index * WKScreenW, 0) animated:YES];
}

- (void)animationViewWith:(UIButton *)btn{
    NSInteger index = btn.tag - 10;
    _index = index;

    if (_type == WKPageTypeShare) {

        NSString *title = _titles[index];
        CGFloat width = [title boundingRectWithSize:CGSizeMake(10000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:NULL].size.width;
        
        [UIView animateWithDuration:0.3 animations:^{

            _animationView.frame = CGRectMake(((WKScreenW/_titles.count)/2 - width/2) + index * WKScreenW/3, 0, width+12, 2);

        }];
    }
}

- (void)changeBtn:(UIButton *)btn{
    if (btn.tag == _selectedBtn.tag) {
        return;
    }
    btn.selected = !btn.selected;
    [_selectedBtn setSelected:NO];
    _selectedBtn = btn;
}

#pragma makr - 设置未读消息
- (void)setBadges:(NSArray *)array{
    NSAssert(array.count == _btnArr.count, @"要设置的总数和已有的不相等");
    NSLog(@"array is %@",array);
    for (int i=0; i<_btnArr.count; i++) {
        NSNumber *badgeNum = array[i];
        WKItemBtn *item = _btnArr[i];
        item.badgeText = badgeNum;
    }
}

#pragma mark - 设置选中的页面
- (void)selectedIndex:(NSInteger)index{
    NSAssert(index < _btnArr.count, @"超出界限了");
    WKItemBtn *btn = _btnArr[index];

    [self performSelector:@selector(selected:) withObject:btn afterDelay:0.5];
}

- (void)selected:(UIButton *)btn{
    [self pageSelectedIndex:btn];
    self.collectionView.scrollEnabled = YES;
}

#pragma mark - UICollectionView delegate and dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _viewControllers.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCSegmentViewUnit * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCSegmentViewUnit" forIndexPath:indexPath];
    UIViewController *vc = _viewControllers[indexPath.section];
    cell.view = vc.view;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    CGPoint offset = self.collectionView.contentOffset;
    CGFloat pageFloat = offset.x / self.collectionView.bounds.size.width + 0.5;
    if (pageFloat < 0) {
        pageFloat = 0;
    }
    if (pageFloat > _viewControllers.count) {
        pageFloat = _viewControllers.count - 1;
    }
    NSInteger page = (NSInteger)pageFloat;
    UIButton *btn = _btnArr[page];
    [self changeBtn:btn];
    [self animationViewWith:btn];
}

// MARK: UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setScrollEnabled];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setScrollEnabled];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self setScrollEnabled];
}

- (void)setScrollEnabled{
    for (UIView* next = [self.collectionView superview]; next; next = next.superview) {
        
        const char *className = object_getClassName(next.classForCoder);
        
//        printf("class name : %s\n",className);
        
        if (strcmp(className, "WMScrollView") == 0) {
            WMScrollView *nextScroll = (WMScrollView *)next;
            if (_index < _viewControllers.count -1) {
                nextScroll.scrollEnabled = NO;
            }else{
                nextScroll.scrollEnabled = YES;
            }
            
            if (_index == 0) {
                self.collectionView.bounces = NO;
            }else{
                self.collectionView.bounces = YES;
            }
            return;
        }
//        else if ((strcmp(className, "WKStoreViewController") == 0)){
//            UIViewController *controller = (UIViewController *)next;
//            controller.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
    }
}

#pragma mark - UIGestureRecongnizerDelegate

- (void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
