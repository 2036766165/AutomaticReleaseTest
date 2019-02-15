//
//  WKSelectedDistrictView.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSelectedDistrictView.h"
#import "WKAddressItemTableViewCell.h"
#import "WKAddressItem.h"
#import "WKSelectedDistrictView.h"
#import "UIView+YYAdd.h"
#import "NSObject+XWAdd.h"

const char *kCompletionBlock = "kBlock";
const char *kShowView        = "view";
typedef enum : NSUInteger {
    WKCurrentSelectedTypeProvince,
    WKCurrentSelectedTypeCity,
    WKCurrentSelectedTypeCountry,
    WKCurrentSelectedTypeDone
} WKCurrentSelectedType;


@interface WKSelectedDistrictView () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *provinceBtn;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UIButton *countryBtn;

@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UITableView *provinceTable;
@property (nonatomic,strong) UITableView *cityTable;
@property (nonatomic,strong) UITableView *countryTable;

@property (nonatomic,strong) UITableView *currentTable;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSArray *addressList;

@property (nonatomic,strong) UIView *addressBgView;
@property (nonatomic,copy) NSString *countryName;

@property (nonatomic,strong) NSMutableArray *selectedArr;

@property (nonatomic,strong) WKAddressItem *provinceItem;
@property (nonatomic,strong) WKAddressItem *countryItem;
@property (nonatomic,strong) WKAddressItem *cityItem;

@end

static NSString *cellId = @"cellId";

static WKSelectedDistrictView *selectDistrictict = nil;

@implementation WKSelectedDistrictView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
        NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSError *error;
        if (error) {
            _LOGD(@"error : %@",error.description);
        }
        //取出数据源
        self.selectedArr = @[].mutableCopy;
        
        self.addressList = [NSArray yy_modelArrayWithClass:[WKAddressItem class] json:jsonStr];
        [self setupViews];
    }
    return self;
}

+ (void)showWithDefaultProvince:(NSString *)province city:(NSString *)city country:(NSString *)country completion:(CompletionBlock)block{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    WKSelectedDistrictView *view = [[WKSelectedDistrictView alloc] initWithFrame:CGRectMake(0, WKScreenH , WKScreenW,0)];
//    view.backgroundColor = [UIColor blueColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    btn.frame = keyWindow.bounds;
    [btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview:btn];
    
    
    selectDistrictict = view;
    
    NSString *provinceStr = province.length == 0?@"请选择":province;
    NSString *cityStr = city.length == 0?@"":city;
    NSString *countryStr = country.length == 0?@"":country;
    
    for (int i=0; i<selectDistrictict.addressList.count; i++) {
        
        WKAddressItem *item = selectDistrictict.addressList[i];
        NSLog(@"item name : %@",item.name);
        
        if ([item.name isEqualToString:provinceStr]) {
            selectDistrictict.provinceItem = item;
            
            for (int j=0; j<selectDistrictict.provinceItem.sub.count; j++) {
                
                WKAddressItem *cityItem = selectDistrictict.provinceItem.sub[j];
                
                if ([cityStr isEqualToString:cityItem.name]) {
                    selectDistrictict.cityItem = cityItem;
                    
                    for (int n=0; n<selectDistrictict.cityItem.sub.count; n++) {
                        WKAddressItem *countryItem = selectDistrictict.cityItem.sub[n];
                        if ([countryItem.name isEqualToString:countryStr]) {
                            selectDistrictict.countryItem = countryItem;
                        }
                        
                    }
                }
            }
        }
    }
    
    [selectDistrictict.selectedArr addObject:province];
    [selectDistrictict.selectedArr addObject:city];
    [selectDistrictict.selectedArr addObject:country];
    
    
    [view.provinceBtn setTitle:provinceStr forState:UIControlStateNormal];
    [view.cityBtn setTitle:cityStr forState:UIControlStateNormal];
    [view.countryBtn setTitle:countryStr forState:UIControlStateNormal];
    [btn addSubview:view];
  
    [selectDistrictict.provinceTable reloadData];
    [selectDistrictict.cityTable reloadData];
    [selectDistrictict.countryTable reloadData];

    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(0, WKScreenH * 0.3, WKScreenW, WKScreenH * 0.7);
    } completion:^(BOOL finished) {
        
    }];
    
    if (![countryStr isEqualToString:@""]) {
         [view updateLineViewWithLab:view.countryBtn];
              // 滑动到最后一页
        [view.scrollView setContentOffset:CGPointMake(WKScreenW * 2, 0) animated:YES];
           }
    
    if (block) {
        objc_setAssociatedObject(self, kCompletionBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    objc_setAssociatedObject(self, kShowView, view, OBJC_ASSOCIATION_RETAIN);
     
}

- (void)setupViews{

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"所在地区";
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = btn;
    
    [self.titleLabel addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.titleLabel.mas_right).offset(-5);
    }];

    UIView *addressBgView = [UIView new];
    addressBgView.layer.borderColor = [UIColor colorWithHexString:@"#E0E3E5"].CGColor;
    addressBgView.layer.borderWidth = 0.8;
    addressBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:addressBgView];
    self.addressBgView = addressBgView;
    
    [addressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_offset(44);
    }];
    
    // 省
    UIButton *lastLab;
    for (int i=0; i<3; i++) {
        UIButton *lab = [UIButton new];
        lab.titleLabel.textAlignment = NSTextAlignmentCenter;
        [lab setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
        lab.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [addressBgView addSubview:lab];
        if (i == 0) {
            self.provinceBtn=lab;
            [self.provinceBtn setTitle:@"请选择" forState:UIControlStateNormal];
            //给按钮添加事件，用于点击后联动
            [self.provinceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i == 1){
            self.cityBtn=lab;
             [self.cityBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            self.countryBtn=lab;
            [self.countryBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        if (lastLab == nil) {
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(10);
                make.top.and.bottom.mas_equalTo(addressBgView);
                make.width.mas_greaterThanOrEqualTo(60);
            }];
        }else{
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastLab.mas_right).offset(5);
                make.top.and.bottom.mas_equalTo(addressBgView);
                make.width.mas_greaterThanOrEqualTo(60);
            }];
        }
        
        lastLab = lab;
    }
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
    [addressBgView addSubview:lineView];
    
    self.lineView = lineView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(addressBgView.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.provinceBtn.mas_centerX).offset(0);
        make.width.mas_equalTo(self.provinceBtn.mas_width);
        make.height.mas_equalTo(@2);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 88, WKScreenW, WKScreenH * 0.7 - 88)];
    scrollView.contentSize = CGSizeMake(WKScreenW * 3, scrollView.frame.size.height);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    for (int i=0; i<3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(WKScreenW * i, 0, WKScreenW, scrollView.frame.size.height) style:UITableViewStyleGrouped];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [scrollView addSubview:tableView];
        
        if (i==0) {
            self.provinceTable = tableView;
            self.currentTable = self.provinceTable;
        }else if(i==1){
            self.cityTable = tableView;
        }else
            self.countryTable = tableView;
    }
    
}
//点击按钮,滚动到对应位置
-(void)btnClick:(UIButton *) btn{
    if(btn==self.provinceBtn){
        [self updateLineViewWithLab:self.provinceBtn];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(btn==self.cityBtn){
        [self updateLineViewWithLab:self.cityBtn];
        [self.scrollView setContentOffset:CGPointMake(WKScreenW, 0) animated:YES];
    }else if(btn==self.countryBtn){
        [self updateLineViewWithLab:self.countryBtn];
        [self.scrollView setContentOffset:CGPointMake(WKScreenW*2, 0) animated:YES];
    }
}
//- (void)dealloc{
//    [self removeObserver:self.scrollView forKeyPath:@"contentOffset.x"];
//}
//
#pragma mark - UITabelView delegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.provinceTable]) {
        return self.addressList.count;
    }else if ([tableView isEqual:self.cityTable]){
        return _provinceItem.sub.count;
    }else{
        return _cityItem.sub.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKAddressItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
        cell = [[WKAddressItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    WKAddressItem *item;
    
    
    if ([tableView isEqual:self.provinceTable]) {
        item = self.addressList[indexPath.row];
    }else if ([tableView isEqual:self.cityTable]){
        item = _provinceItem.sub[indexPath.row];
    }else{
        item = _cityItem.sub[indexPath.row];
    }

    if ([selectDistrictict.selectedArr containsObject:item.name]) {
        item.isSelected = YES;
    }
    
    [cell setItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKAddressItemTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    WKAddressItem *item;
    if ([tableView isEqual:self.provinceTable]) {
        item = self.addressList[indexPath.row];
    }else if ([tableView isEqual:self.cityTable]){
        item = _provinceItem.sub[indexPath.row];
    }else{
        item = _cityItem.sub[indexPath.row];
    }

    item.isSelected = NO;
    [cell setItem:item];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKAddressItemTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    WKAddressItem *item;
    if ([tableView isEqual:self.provinceTable]) {
        item = self.addressList[indexPath.row];
    }else if ([tableView isEqual:self.cityTable]){
        item = _provinceItem.sub[indexPath.row];
    }else{
        item = _cityItem.sub[indexPath.row];
    }

    item.isSelected = YES;
    [cell setItem:item];

    /*
    if ([tableView isEqual:self.provinceTable]) {
        _provinceItem = self.addressList[indexPath.row];
        
        [self.provinceBtn setTitle:_provinceItem.name forState:UIControlStateNormal];
        [self.cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [self updateLineViewWithLab:self.cityBtn];

        self.currentTable = self.cityTable;
        [self.cityTable reloadData];
        
        if (self.scrollView.contentSize.width == WKScreenW) {
            self.scrollView.contentSize = CGSizeMake(WKScreenW * 2, self.scrollView.frame.size.height);
        }
        
        [self.scrollView setContentOffset:CGPointMake(WKScreenW, 0) animated:YES];


    }else if ([tableView isEqual:self.cityTable]){
        _cityItem = _provinceItem.sub[indexPath.row];
      
        [self.cityBtn setTitle:_cityItem.name forState:UIControlStateNormal];
        [self updateLineViewWithLab:self.countryBtn];
        [self.countryBtn setTitle:@"请选择" forState:UIControlStateNormal];
        if (self.scrollView.contentSize.width == WKScreenW * 2) {
            self.scrollView.contentSize = CGSizeMake(WKScreenW * 3, self.scrollView.frame.size.height);
        }
        [self.scrollView setContentOffset:CGPointMake(WKScreenW * 2, 0) animated:YES];
        [self.countryTable reloadData];

    }else{
        _countryItem = _cityItem.sub[indexPath.row];
        [self.countryBtn setTitle:_countryItem.name forState:UIControlStateNormal];
        self.countryTable = self.countryTable;
        [self updateLineViewWithLab:self.countryBtn];
        CompletionBlock block = objc_getAssociatedObject(self.class, kCompletionBlock);
        if (block) {
            [self.class dismissView];        
            block(@[self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.countryBtn.titleLabel.text]);

        }
    }
    [self layoutIfNeeded];
     */
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.provinceTable]) {
        _provinceItem = self.addressList[indexPath.row];
        
        [self.provinceBtn setTitle:_provinceItem.name forState:UIControlStateNormal];
        [self.cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [self updateLineViewWithLab:self.cityBtn];
        
        self.currentTable = self.cityTable;
        [self.cityTable reloadData];
        
        if (self.scrollView.contentSize.width == WKScreenW) {
            self.scrollView.contentSize = CGSizeMake(WKScreenW * 2, self.scrollView.frame.size.height);
        }
        
        [self.scrollView setContentOffset:CGPointMake(WKScreenW, 0) animated:YES];
        
        
    }else if ([tableView isEqual:self.cityTable]){
        _cityItem = _provinceItem.sub[indexPath.row];
        
        [self.cityBtn setTitle:_cityItem.name forState:UIControlStateNormal];
        [self updateLineViewWithLab:self.countryBtn];
        [self.countryBtn setTitle:@"请选择" forState:UIControlStateNormal];
        if (self.scrollView.contentSize.width == WKScreenW * 2) {
            self.scrollView.contentSize = CGSizeMake(WKScreenW * 3, self.scrollView.frame.size.height);
        }
        [self.scrollView setContentOffset:CGPointMake(WKScreenW * 2, 0) animated:YES];
        [self.countryTable reloadData];
        
    }else{
        _countryItem = _cityItem.sub[indexPath.row];
        [self.countryBtn setTitle:_countryItem.name forState:UIControlStateNormal];
        self.countryTable = self.countryTable;
        [self updateLineViewWithLab:self.countryBtn];
        CompletionBlock block = objc_getAssociatedObject(self.class, kCompletionBlock);
        if (block) {
            [self.class dismissView];
            block(@[self.provinceBtn.titleLabel.text,self.cityBtn.titleLabel.text,self.countryBtn.titleLabel.text]);
            
        }
    }
    [self layoutIfNeeded];
    return indexPath;
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
      if (scrollView.contentOffset.x == 0) {
        [self updateLineViewWithLab:self.provinceBtn];
    }else if (scrollView.contentOffset.x == WKScreenW){
        [self updateLineViewWithLab:self.cityBtn];
    }else{
        [self updateLineViewWithLab:self.countryBtn];
    }

}


- (void)updateLineViewWithLab:(UIButton *)lab{
    UIView *view = objc_getAssociatedObject(self.class, kShowView);
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.addressBgView.mas_bottom).offset(0);
        //make.right.and.left.mas_equalTo(self.provinceLabel).offset(0);
        make.centerX.mas_equalTo(lab.mas_centerX).offset(0);
        make.width.mas_equalTo(lab.mas_width);
        make.height.mas_equalTo(@2);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [view layoutIfNeeded];
    }];
    [lab setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    
    
}
//完成添加后
+ (void)dismissView{
    UIView *view = objc_getAssociatedObject(self, kShowView);
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, WKScreenH, WKScreenW, 0);
    } completion:^(BOOL finished) {
//          view.hidden = YES;
//        view.superview.hidden=YES;
        [view removeAllSubviews];
        [view.superview removeFromSuperview];
    }];
}


@end

