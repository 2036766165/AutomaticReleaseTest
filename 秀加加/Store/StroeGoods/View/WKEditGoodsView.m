//
//  WKEditGoodsView.m
//  秀加加
//  添加商品
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKEditGoodsView.h"
#import "UITextView+Placeholder.h"
#import "WKImageCollectionViewCell.h"
#import "WKImageModel.h"
#import "NSObject+WKImagePicker.h"
#import "WKPickerImageView.h"
#import "WKMarkModel.h"
#import "WKItemTableViewCell.h"
#import "WKVirtualTableViewCell.h"
#import "WKCellOperationProtocol.h"
#import "WKGoodsModel.h"

static NSString *cellId = @"cellId";

@interface WKEditGoodsView () <UITableViewDelegate,UITableViewDataSource,WKItemDelegete,WKCellOperationProtocol> {
    WKGoodsType _type;
    CGFloat _cellHeight;
    WKGoodsModel *_dataModel;
}

@property (nonatomic,strong) WKGoodsModel *dataModel;
@property (nonatomic,strong) UITextView *nameText;
@property (nonatomic,strong) UITextView *descText;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *priceText;
@property (nonatomic,strong) UIButton *freeShippingBtn;
@property (nonatomic,strong) UIButton *onlyAuctionBtn;
@property (nonatomic,strong) UIButton *goodsBtn;
@property (nonatomic,strong) UIButton *virtualBtn;
@property (nonatomic,strong) WKPickerImageView *pickImageView;
@property (nonatomic,strong) NSMutableArray *modeArr;  // 型号数组
@property (nonatomic,copy)   NSString *price;     // 虚拟商品备注
@end

@implementation WKEditGoodsView

- (NSMutableArray *)modeArr{
    if (!_modeArr) {
        WKMarkModel *item = [WKMarkModel new];
        _modeArr = @[item].mutableCopy;
    }
    return _modeArr;
}

- (WKGoodsModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[WKGoodsModel alloc] init];
        _dataModel.IsFreeShipping = YES;
    }
    return _dataModel;
}

- (instancetype)initWithFrame:(CGRect)frame type:(WKGoodsType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setupViews];
    }
    return self;
}

- (void)setDataModel:(WKGoodsModel *)dataModel{
    _dataModel = dataModel;
    
    self.nameText.text = dataModel.GoodsName;
    self.descText.text = dataModel.Description;
    [self.pickImageView setImageArr:dataModel.GoodsPicList];

    UIButton *btn;
    if (!dataModel.IsVirtual) {
        btn = self.goodsBtn;
        self.goodsBtn.selected = YES;
        self.virtualBtn.userInteractionEnabled = NO;
        self.modeArr = dataModel.GoodsModelList.mutableCopy;
        [self.tableView reloadData];
    }else{
        self.goodsBtn.userInteractionEnabled = NO;
        btn = self.virtualBtn;
    }
    [self selectedGoodsType:btn];

    WKMarkModel *md = [dataModel.GoodsModelList firstObject];
    self.priceText.text = md.Price;
}

#pragma mark - 获取要上传的信息
- (NSDictionary *)getEditInfo{
    
    [self endEditing:YES];
    
    if ([self checkInput]) {
        [WKPromptView showPromptView:[self checkInput]];
        return nil;
    }
    
    //专有参数
    NSDictionary *dict;
    if (_type == WKPickerImageTypeNormal) {
        dict = @{
                @"IsFreeShipping":self.dataModel.IsFreeShipping == YES?@"true":@"false"
                };
    }else{
        
        WKMarkModel *md = [[WKMarkModel alloc] init];
        md.ModelName = @"";
        md.Stock = @1;
        md.Price = self.priceText.text;
        self.modeArr = @[md].mutableCopy;
        
        dict = @{
                 @"Memo":self.dataModel.Memo,
                 @"GoodsVirtualInfoList":[self getVirtualImageWith:self.dataModel.GoodsVirtualInfoList]
                };
    }
    
    // 公共参数
    NSMutableDictionary *parameters = @{
                                        @"GoodsName":self.nameText.text,
                                        @"Description":self.descText.text,
                                        @"GoodsPicList":[self getJsonImageWith:[self.pickImageView getImageArr]],
                                        @"IsVirtual":_type == WKPickerImageTypeNormal?@"false":@"true",
                                        @"IsHidden": self.dataModel.IsHidden ? @"true" : @"false",
                                        @"GoodsModelList":[self getModeInfo],
                                        
                                        }.mutableCopy;
    
    [parameters addEntriesFromDictionary:dict];
    
    if (_dataModel.GoodsCode != nil) {
        // 编辑商品
        [parameters addEntriesFromDictionary:@{
                                               @"IsDelete":@"false",
                                               @"IsMarketable":_dataModel.IsMarketable==YES?@"true":@"false",
                                               @"ID":_dataModel.ID,
                                               @"GoodsCode":_dataModel.GoodsCode
                                               }];
    }
    
    return parameters;
}

#pragma mark - 提交商品验证
- (NSString *)checkInput{
    if ([self.pickImageView getImageArr].count <= 0)
    {
        return @"请上传商品图片！";
    }
    
    if (self.nameText.text.length == 0)
    {
        return @"请填写商品名称！";
    }
    else
    {
        if(self.nameText.text.length > 50)
        {
            return @"商品名称限制50个字符！";
        }
    }
    
    if(self.descText.text.length == 0)
    {
        return @"请输入商品描述！";
    }
    else
    {
        if(self.descText.text.length > 150)
        {
            return @"商品描述限制150个字符！";
        }
    }
    
    if (_type == WKPickerImageTypeNormal) {
        
        NSMutableSet *models_set = [NSMutableSet setWithCapacity:self.modeArr.count];

        for (WKMarkModel *markModel in self.modeArr) {
            if(markModel.Price.length == 0 || markModel.Stock == nil)
            {
                return @"请输入价格和库存！";
            }
            
            if(![self isPureFloat:markModel.Price] || markModel.Price.floatValue <= 0)
            {
                return @"商品价格必须大于0！";
            }
            
            if(markModel.Stock.integerValue < 0)
            {
                return @"商品库存必须大于等于0！";
            }
            
            //判断如果ItemsArray有多个，证明有多个型号
            if(self.modeArr.count > 1 && markModel.ModelName.length == 0)
            {
                return @"请填写型号！";
            }
            else
            {
                if(markModel.ModelName.length > 10)
                {
                    return @"商品型号限制10个字符！";
                }
            }
        }
        
        if (models_set.count != self.modeArr.count && models_set.count != 0) {
            return @"型号名称不能重复！";
        }
        
    }else{
        if (self.dataModel.GoodsVirtualInfoList.count <= 0 && self.dataModel.Memo.length == 0)
        {
            return @"虚拟商品需要维护一组图片或文章！";
        }
        
        if(![self isPureFloat:self.priceText.text] || self.priceText.text.floatValue <= 0 )
        {
            return @"请输入价格！";
        }
    }
    return nil;
}

//MARK: 获取型号详情
- (NSString *)getModeInfo{
    //定义返回集合
    NSMutableArray *arr = @[].mutableCopy;
    //循环集合
    for (WKMarkModel *markModel in self.modeArr) {
        //库存不维护，默认为0
        markModel.ModelName = markModel.ModelName == nil ? @"" : markModel.ModelName;
        NSString *price = [NSString stringWithFormat:@"%.2f",markModel.Price.floatValue];
        NSDictionary *dict = @{@"Price":price,
                                      @"Stock":markModel.Stock,
                                      @"ID":markModel.ID == nil?@"":markModel.ID,
//                                      @"CreateTime":markModel.CreateTime == nil?@"":markModel.CreateTime,
                                      @"ModelCode":markModel.ModelCode == nil?@"":markModel.ModelCode,
                                      @"ModelName":markModel.ModelName == nil?@"":markModel.ModelName
                                      };
        
        //添加到返回集合中
        [arr addObject:dict];
    }
    return [arr yy_modelToJSONString];
}

- (NSString *)getJsonImageWith:(NSArray *)arr{
    
    NSMutableArray *picArr = @[].mutableCopy;
    for (NSUInteger i=0; i<arr.count; i++) {
        WKImageModel *md = arr[i];
        NSDictionary *imageDict = @{
                                    @"ID":md.ID==nil?@"":md.ID,
                                    @"PicUrl":md.PicUrl,
                                    @"Sort":@(i+1),
                                    @"CreateTime":md.CreateTime==nil?@"":md.CreateTime
                                    };
        [picArr addObject:imageDict];
    }
    return [picArr yy_modelToJSONString];
}

- (NSString *)getVirtualImageWith:(NSArray *)arr{
    NSMutableArray *picArr = @[].mutableCopy;
    for (NSUInteger i=0; i<arr.count; i++) {
        WKImageModel *md = arr[i];
        NSDictionary *imageDict = @{
//                                    @"ID":md.ID==nil?@"":md.ID,
                                    @"FileUrl":md.FileUrl,
                                    @"FileType":md.FileType,
                                    @"Sort":@(i)
                                    };
        [picArr addObject:imageDict];
    }
    return [picArr yy_modelToJSONString];
}

- (void)setupViews{
    
    _cellHeight = 240;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    
    tableView.tableHeaderView = [self getHeaderView];
    tableView.tableFooterView = [self getFooterView];
    self.tableView = tableView;
}

- (UIView *)getHeaderView{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 420)];

    UILabel *picLabel = [self getLabelWith:@"商品图片"];
    [tableHeaderView addSubview:picLabel];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    [picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tableHeaderView.mas_left).offset(10);
        make.top.mas_equalTo(tableHeaderView.mas_top).offset(5);
        make.size.mas_offset(CGSizeMake(100, 30));
    }];
    
    CGFloat itemWidth = (WKScreenW - 50)/4;
    WKPickerImageView *imagePicker = [[WKPickerImageView alloc] initWithFrame:CGRectZero];
    imagePicker.maxCount = 4;
    self.pickImageView = imagePicker;
    [tableHeaderView addSubview:imagePicker];
    
    [imagePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(picLabel.mas_bottom).offset(5);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(WKScreenW, itemWidth + 20));
    }];
    
    // 商品名称
    UILabel *lab1 = [self getLabelWith:@"商品名称"];
    [tableHeaderView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(100, 35));
        make.left.mas_offset(10);
        make.top.mas_equalTo(imagePicker.mas_bottom).offset(10);
    }];
    
    UITextView *textField = [UITextView new];
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = @"请输入商品名称";
    textField.layer.borderColor = [UIColor colorWithHexString:@"E9EAEF"].CGColor;
    textField.layer.borderWidth = 1.5;
    [tableHeaderView addSubview:textField];
    self.nameText = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab1.mas_bottom).offset(5);
        make.left.mas_equalTo(tableHeaderView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW-20, 44));
    }];
    
    // 商品描述
    UILabel *lab2 = [self getLabelWith:@"商品描述"];
    [tableHeaderView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(100, 35));
        make.left.mas_offset(10);
        make.top.mas_equalTo(textField.mas_bottom).offset(10);
    }];
    
    UITextView *textView = [UITextView new];
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"请输入商品描述";
    textView.layer.borderColor = [UIColor colorWithHexString:@"E9EAEF"].CGColor;
    textView.layer.borderWidth = 1.5;
    [tableHeaderView addSubview:textView];
    self.descText = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab2.mas_bottom).offset(10);
        make.left.mas_equalTo(tableHeaderView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW-20, 120));
    }];
    
    UIView *segBackView = [UIView new];
    segBackView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:1.00 alpha:1.00];
    [tableHeaderView addSubview:segBackView];
    
    [segBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(10);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(WKScreenW, 55));
    }];
    
    UIView *segmentView = [UIView new];
    segmentView.layer.borderWidth = 1.0;
    segmentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [segBackView addSubview:segmentView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [segmentView addSubview:lineView];
    
    if (User.isReviewID) {
        
        UIButton *goodsBtn = [UIButton buttonWithType:0];
        goodsBtn.tag = 10;
        [goodsBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [goodsBtn setTitle:@"商品规格" forState:0];
        [goodsBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        [goodsBtn setTitleColor:[UIColor colorWithHexString:@"#FC6601"] forState:UIControlStateSelected];
        [goodsBtn addTarget:self action:@selector(selectedGoodsType:) forControlEvents:UIControlEventTouchUpInside];
        goodsBtn.userInteractionEnabled = NO;
        [segmentView addSubview:goodsBtn];
        self.goodsBtn = goodsBtn;
        
        [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(-1);
            make.size.mas_offset(CGSizeMake(WKScreenW + 2, 45));
        }];
        
        [goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(1);
            make.left.mas_offset(0);
            make.size.mas_offset(CGSizeMake(WKScreenW, 43));
        }];
        
        tableHeaderView.frame = CGRectMake(0, 0, WKScreenW, 420 + 60);
        
        return tableHeaderView;
    }else{
        UIButton *goodsBtn = [UIButton buttonWithType:0];
        goodsBtn.tag = 10;
        [goodsBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [goodsBtn setTitle:@"实物商品" forState:0];
        [goodsBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        [goodsBtn setTitleColor:[UIColor colorWithHexString:@"#FC6601"] forState:UIControlStateSelected];
        [goodsBtn addTarget:self action:@selector(selectedGoodsType:) forControlEvents:UIControlEventTouchUpInside];
        [segmentView addSubview:goodsBtn];
        self.goodsBtn = goodsBtn;
        
        UIButton *virtualBtn = [UIButton buttonWithType:0];
        virtualBtn.tag = 11;
        virtualBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [virtualBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#FFB64F"]] forState:UIControlStateSelected];
        [virtualBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [virtualBtn setTitle:@"虚拟商品" forState:0];
        [virtualBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        [virtualBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [virtualBtn addTarget:self action:@selector(selectedGoodsType:) forControlEvents:UIControlEventTouchUpInside];
        [segmentView addSubview:virtualBtn];
        self.virtualBtn = virtualBtn;
        
        if (_type == WKGoodsTypeSale) {
            [self selectedGoodsType:goodsBtn];
        }else{
            [self selectedGoodsType:virtualBtn];
        }
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(WKScreenW/2);
            make.size.mas_offset(CGSizeMake(1, 45));
        }];
        
        [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(-1);
            make.size.mas_offset(CGSizeMake(WKScreenW + 2, 45));
        }];
        
        [goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(1);
            make.left.mas_offset(0);
            make.size.mas_offset(CGSizeMake(WKScreenW/2 - 1, 43));
        }];
        
        [virtualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(1);
            make.left.mas_offset(WKScreenW/2);
            make.size.mas_offset(CGSizeMake(WKScreenW/2, 43));
        }];
        
        tableHeaderView.frame = CGRectMake(0, 0, WKScreenW, 420 + 60);
        
        return tableHeaderView;
    }
    
    
    
}

- (UIView *)getFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WKScreenW, 120)];
    footerView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:1.00 alpha:1.00];
    UIView *AuctionView;

    if (_type == WKGoodsTypeSale) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WKScreenW, 45)];
        backView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:backView];
        
        UILabel *lblTitle = [self getLabelWith:@"包邮"];
        lblTitle.font = [UIFont systemFontOfSize:14.0f];
        [backView addSubview:lblTitle];
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView.mas_centerY);
            make.left.equalTo(backView.mas_left).offset(10);
            make.size.sizeOffset(CGSizeMake(40, 15));
        }];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"order_cancel"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-10);
            make.centerY.equalTo(lblTitle.mas_centerY);
            make.size.sizeOffset(CGSizeMake(50, 30));
        }];
        btn.selected = self.dataModel.IsFreeShipping;
        self.freeShippingBtn = btn;
    
        //定义只用于拍卖按钮的位置
        AuctionView = [[UIView alloc]initWithFrame:CGRectMake(0, 62, WKScreenW, 45)];
    }else{
        //需要重新定义高度
        footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WKScreenW, 155)];
        footerView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:1.00 alpha:1.00];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WKScreenW, 65)];
        backView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:backView];
        
        UIView *borderView = [[UIView alloc] init];
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = [UIColor colorWithHexString:@"E9EAEF"].CGColor;
        borderView.layer.cornerRadius = 5.0f ;
        borderView.layer.masksToBounds = YES;
        [backView addSubview:borderView];
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(10);
            make.left.equalTo(backView.mas_left).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.mas_equalTo(45);
        }];
        
        UILabel *lblTitle = [[UILabel alloc]init];
        lblTitle.text = @"价格：";
        lblTitle.textColor = [UIColor darkGrayColor];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = [UIFont systemFontOfSize:14];
        [borderView addSubview:lblTitle];
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(borderView.mas_left).offset(10);
            make.centerY.equalTo(borderView.mas_centerY);
            make.size.sizeOffset(CGSizeMake(50, 15));
        }];
        
        UITextField *textField = [UITextField new];
        textField.font = [UIFont systemFontOfSize:14];
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = @"请输入价格";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [borderView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblTitle.mas_right).offset(5);
            make.right.equalTo(borderView.mas_right).offset(-5);
            make.centerY.equalTo(lblTitle.mas_centerY);
            make.height.mas_equalTo(45);
        }];
        
        self.priceText = textField;
        self.priceText.text = self.price;
        
        //定义只用于拍卖按钮的位置
        AuctionView = [[UIView alloc]initWithFrame:CGRectMake(0, 95, WKScreenW, 45)];
    }
    
    AuctionView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:AuctionView];
    UILabel *lblTitle2 = [self getLabelWith:@"只限于活动（拍卖、幸运购）"];
    lblTitle2.font = [UIFont systemFontOfSize:14.0f];
    [AuctionView addSubview:lblTitle2];
    [lblTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(AuctionView.mas_centerY);
        make.left.equalTo(AuctionView.mas_left).offset(10);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.7, 15));
    }];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"order_cancel"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(btnAuctionClick:) forControlEvents:UIControlEventTouchUpInside];
    [AuctionView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(AuctionView.mas_right).offset(-10);
        make.centerY.equalTo(lblTitle2.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 30));
    }];
    btn2.selected = self.dataModel.IsHidden;
    self.onlyAuctionBtn = btn2;

    if (User.isReviewID) {
        AuctionView.hidden = YES;
    }
    
    return footerView;
}

- (UILabel *)getLabelWith:(NSString *)text{
    UILabel *lab = [[UILabel alloc] init];
    lab.text = text;
    lab.textColor = [UIColor darkGrayColor];
    lab.font = [UIFont systemFontOfSize:16.0f];
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentLeft;
    return lab;
}

// 包邮
- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.dataModel.IsFreeShipping = btn.selected;
}

//只用于拍卖
- (void)btnAuctionClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.dataModel.IsHidden = btn.selected;
}

#pragma mark - 实物商品与虚拟商品按钮切换操作
- (void)selectedGoodsType:(UIButton *)btn{
    
    //如果按钮之前是选中的，不做任何操作
    if (!btn.isSelected) {
        btn.selected = !btn.selected;
    }
    
    if (btn.tag == 10) {
        // 实物商品
        btn.superview.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        UIButton *otherBtn = [btn.superview viewWithTag:11];
        otherBtn.selected = NO;
        _type = WKGoodsTypeSale;
        
    }else{
        // 虚拟商品
        btn.superview.layer.borderColor = [UIColor colorWithHexString:@"#FFB64F"].CGColor;
        
        UIButton *otherBtn = [btn.superview viewWithTag:10];
        otherBtn.selected = NO;
        _type = WKGoodsTypeAuction;
    }
    
    self.price = self.priceText.text;
    self.tableView.tableFooterView = [self getFooterView];
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_type == WKGoodsTypeSale) {
        return self.modeArr.count;
    }else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_type == WKGoodsTypeSale) {
        if (section == self.modeArr.count - 1) {
            return 70.0f;
        }else{
            return 0.01f;
        }
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == WKGoodsTypeSale) {
        WKMarkModel *md = self.modeArr[indexPath.section];
        if (md.ModelName) {
            return 44 * 3 + 20;
        }else{
            return 44 * 2 + 20;
        }
    }else{
        return _cellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_type == WKGoodsTypeSale) {
        if (section == self.modeArr.count-1) {
            UIView *footerView = [UIView new];
            footerView.frame = CGRectMake(0, 0, WKScreenW, 70);
            footerView.backgroundColor = [UIColor whiteColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@" 添加商品型号" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pro_smalladd04"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(addModel:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderWidth = 1.5;
            btn.layer.borderColor = [UIColor colorWithHexString:@"E9EAEF"].CGColor;
            btn.frame = CGRectMake(10, 20, WKScreenW - 20, 40);
            [footerView addSubview:btn];
            return footerView;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == WKGoodsTypeSale) {
        
        WKItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WKItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setItemModel:self.modeArr[indexPath.section]];
        return cell;
        
    }else{
        
        WKVirtualTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
        if (!cell) {
            cell = [[WKVirtualTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = _dataModel;

        return cell;
    }
    
    return nil;
}

- (void)getImageArr:(NSArray *)imageArr memo:(NSString *)memo{
    self.dataModel.GoodsVirtualInfoList = imageArr;
//    self.virtualArr = imageArr;
    self.dataModel.Memo = memo;
}

- (void)refreshHeight:(CGFloat)height{
    _cellHeight = height;
    [self.tableView reloadData];
}

#pragma mark - 删减型号
- (void)addModel:(UIButton *)btn{
    // 添加型号
    if (self.modeArr.count == 1) {
        
        WKMarkModel *item = self.modeArr[0];
        if (!item.ModelName) {
            item.ModelName = @"";
            NSDate *time = [NSDate date];
            item.CreateTime = [NSString stringWithFormat:@"%@",time];
        }else{
            WKMarkModel *newItem = [WKMarkModel new];
            newItem.ModelName = @"";
            NSDate *time = [NSDate date];
            newItem.CreateTime = [NSString stringWithFormat:@"%@",time];
            [self.modeArr addObject:newItem];
        }
        
    }else{
        WKMarkModel *newItem = [WKMarkModel new];
        newItem.ModelName = @"";
        NSDate *time = [NSDate date];
        newItem.CreateTime = [NSString stringWithFormat:@"%@",time];
        [self.modeArr addObject:newItem];
    }
    
    [self.tableView reloadData];
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.modeArr.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)deleteWith:(id)obj{
    WKMarkModel *md = (WKMarkModel *)obj;
    
    if (self.modeArr.count == 1) {
        WKMarkModel *item = self.modeArr[0];
        item.ModelName = nil;
    }else{
        [self.modeArr removeObject:md];
    }
    [_tableView reloadData];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


@end
