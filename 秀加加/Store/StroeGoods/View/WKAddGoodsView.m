//
//  WKAddGoodsView.m
//  秀加加
//  添加，修改 商品/拍卖品
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddGoodsView.h"
#import "WKItemTableViewCell.h"
#import "WKMarkModel.h"
#import "UITextView+Placeholder.h"
#import "WKGoodsModel.h"
#import "WKImageModel.h"
#import "UIView+YYAdd.h"
#import "NSObject+WKImagePicker.h"
#import "WKImageItemView.h"
#import "WKShowInputView.h"

static NSString *cellId = @"cellId";

@interface WKAddGoodsView () <UITableViewDelegate,UITableViewDataSource,WKItemDelegete,WKDeleteImageDelegate>{
    CGFloat _headerHeight;
    WKGoodsType _type;
    BOOL _isShiping;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextView *textField;    // 商品名称
@property (nonatomic,strong) UITextView *textView;      // 商品描述
@property (nonatomic,strong) UITextField *auctionPriceText; // 起拍价格

@property (nonatomic,strong) NSMutableArray *picArr;
@property (nonatomic,strong) NSMutableArray *itemsArray;

@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) UIButton *shippingBtn;

@property (nonatomic,strong) UIButton *btnDelete; //删除按钮
@end

@implementation WKAddGoodsView

@synthesize dataModel = _dataModel;

- (NSMutableArray *)itemsArray{
    if (_itemsArray == nil) {
        WKMarkModel *item = [WKMarkModel new];
        _itemsArray = @[item].mutableCopy;
    }
    return _itemsArray;
}

- (NSMutableArray *)picArr{
    if (!_picArr) {
        _picArr = @[].mutableCopy;
    }
    return _picArr;
}

- (WKGoodsModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[WKGoodsModel alloc] init];
        _dataModel.GoodsCode = @0;
    }
    return _dataModel;
}

//修改商品功能
- (void)setDataModel:(WKGoodsModel *)dataModel{
    _dataModel = dataModel;
    
    //加载数据
    [self showGoodsInfo];
}

- (instancetype)initWithFrame:(CGRect)frame type:(WKGoodsType)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self setupSubViews];
    }
        return self;
}

- (void)setupSubViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [self getHeaderView];

    // 商品
    if (_type == WKGoodsTypeSale) {
        self.tableView = [self getTableView];
        UIView *footerView = [self getFooterView];
        
        self.tableView.tableHeaderView = headerView;
        self.tableView.tableFooterView = footerView;
    }else{
        // 拍卖品
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        [self addSubview:scrollView];
        UIView *auctionView = [self getAuctionFooter];
        headerView.frame = CGRectMake(0, 0, WKScreenW, _headerHeight);
        auctionView.frame = CGRectMake(0, _headerHeight, WKScreenW, 160);
    
        [scrollView addSubview: headerView];
        [scrollView addSubview: auctionView];
        scrollView.contentSize = CGSizeMake(WKScreenW, 600);
    }
}

// MARK: 编辑商品 展示商品信息
- (void)showGoodsInfo{

    self.textField.text = self.dataModel.GoodsName;
    self.textView.text = self.dataModel.Description;
    self.itemsArray = self.dataModel.GoodsModelList.mutableCopy;
    
    for (int i=0; i<self.dataModel.GoodsPicList.count; i++) {
        [self.picArr insertObject:self.dataModel.GoodsPicList[i] atIndex:0];
    }
    
    self.shippingBtn.selected = self.dataModel.IsFreeShipping;
    _isShiping = self.shippingBtn.selected;
    
    if (_type == WKGoodsTypeAuction) {
        WKMarkModel *md = self.itemsArray[0];
        self.auctionPriceText.text = md.Price;
        
        [self.btnDelete setHidden:NO];
        [self.btnDelete layoutIfNeeded];
    }
    else
    {
        UIView *footerView = [self getEditFooterView];
        self.tableView.tableFooterView = footerView;
        [self.tableView.tableFooterView layoutIfNeeded];
    }
    
    [self layoutImages];
    [self.tableView reloadData];
}

- (UITableView *)getTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    [tableView registerClass:[WKItemTableViewCell class] forCellReuseIdentifier:cellId];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    return tableView;
}

- (UIView *)getHeaderView{
    
    _headerHeight = 420;

    // 头视图
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, _headerHeight)];
    // 商品图片
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableHeaderView = tableHeaderView;
    
    UILabel *lab = [self getLabelWith:@"商品图片"];
    [tableHeaderView addSubview:lab];
    
    WKImageModel *imageMd = [[WKImageModel alloc] init];
    imageMd.image = [UIImage imageNamed:@"addImage"];
    imageMd.PicUrl = @"add";
    [self.picArr addObject:imageMd];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tableHeaderView.mas_left).offset(10);
        make.top.mas_equalTo(tableHeaderView.mas_top).offset(5);
        make.size.mas_offset(CGSizeMake(100, 30));
    }];
    
    CGFloat itemWidth = (WKScreenW - 10 * 5)/4;
    
    UIView *imageBgView = [UIView new];
    
    imageBgView.tag = 1009;
    [tableHeaderView addSubview:imageBgView];
    
    [self layoutImages];
    
    [imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW-20, itemWidth + 10));
    }];
    
    // 商品名称
    UILabel *lab1 = [self getLabelWith:@"商品名称"];
    [tableHeaderView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(100, 35));
        make.left.mas_offset(10);
        make.top.mas_equalTo(imageBgView.mas_bottom).offset(10);
    }];
    
    UITextView *textField = [UITextView new];
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = @"请输入商品名";
    textField.layer.borderColor = [UIColor colorWithHexString:@"E9EAEF"].CGColor;
    textField.layer.borderWidth = 1.5;
    [tableHeaderView addSubview:textField];
    self.textField = textField;
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
    self.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab2.mas_bottom).offset(10);
        make.left.mas_equalTo(tableHeaderView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW-20, 120));
    }];

    return tableHeaderView;
}

- (UIView *)getFooterView{
    _isShiping = YES;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 80)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW, 44));
        make.left.mas_offset(0);
    }];
    
    UILabel *lab4 = [self getLabelWith:@"包邮"];
    [lineView addSubview:lab4];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(100, 40));
        make.centerY.mas_equalTo(lineView.mas_centerY).offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"order_cancel"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lineView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lineView.mas_right).offset(-20);
        make.centerY.mas_equalTo(lineView.mas_centerY).offset(0);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    self.shippingBtn = btn;
    self.shippingBtn.selected= _isShiping ? YES : NO;
    
    return footerView;
}

- (UIView *)getAuctionFooter{
    UIView *auctionView = [UIView new];
    auctionView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:16];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"请输入起拍价格";
    textField.layer.borderWidth = 1.5;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.borderColor = [UIColor colorWithHexString:@"E9EAEF"].CGColor;
    [auctionView addSubview:textField];
    self.auctionPriceText = textField;
    
    UILabel *lab = [UILabel new];
    lab.text = @"价  格:";
    lab.frame = CGRectMake(0, 0, 60, 50);
    lab.textColor = [UIColor darkTextColor];
    lab.font = [UIFont systemFontOfSize:16.0f];
    lab.textAlignment = NSTextAlignmentCenter;
    self.auctionPriceText.leftViewMode = UITextFieldViewModeAlways;
    self.auctionPriceText.leftView = lab;
    
    [self.auctionPriceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW - 20, 50));
    }];
    
    UILabel *reminderLab = [UILabel new];
    reminderLab.text = @"*拍卖品必须包邮";
    reminderLab.frame = CGRectMake(0, 0, 100, 40);
    reminderLab.textColor = [UIColor lightGrayColor];
    reminderLab.font = [UIFont systemFontOfSize:16.0f];
    reminderLab.textAlignment = NSTextAlignmentLeft;
    [auctionView addSubview:reminderLab];
    
    [reminderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.auctionPriceText.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW - 20, 30));
    }];
    
    //修改商品操作，添加删除按钮
    self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDelete setTitle:@"删除拍卖品" forState:UIControlStateNormal];
    self.btnDelete.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
    [self.btnDelete setHidden:YES];
    [self.btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [auctionView addSubview:self.btnDelete];
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reminderLab.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 50));
    }];
    
    return auctionView;
}

-(UIView *)getEditFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 120)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.size.mas_offset(CGSizeMake(WKScreenW, 44));
        make.left.mas_offset(0);
    }];
    
    UILabel *lab4 = [self getLabelWith:@"包邮"];
    [lineView addSubview:lab4];
    
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(100, 40));
        make.centerY.mas_equalTo(lineView.mas_centerY).offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"order_cancel"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lineView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lineView.mas_right).offset(-20);
        make.centerY.mas_equalTo(lineView.mas_centerY).offset(0);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    self.shippingBtn = btn;
    self.shippingBtn.selected= _isShiping ? YES : NO;
    
    //修改商品操作，添加删除按钮
    self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDelete setTitle:@"删除商品" forState:UIControlStateNormal];
    self.btnDelete.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
    [self.btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.btnDelete];
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 50));
    }];
    
    return footerView;
}

-(void)btnDeleteClick
{
    [WKShowInputView showInputWithPlaceString:@"是否确认删除此商品？" type:LABELTYPE andBlock:^(NSString * Count) {
        if (self.delegateBlock) {
            self.delegateBlock(self.dataModel.ID);
        }
    }];
}

#pragma mark - 图片布局
- (void)layoutImages{

    UIView *imageBgView = [self.tableHeaderView viewWithTag:1009];
    
    [imageBgView removeAllSubviews];
    
    CGFloat width = (WKScreenW - 10 * 5)/4;
    
    NSInteger rowCapacity = 4;
    NSInteger rows = _picArr.count%rowCapacity == 0? _picArr.count/rowCapacity:_picArr.count/rowCapacity + 1; //行index
    [imageBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(WKScreenW-20, rows * (width + 10)));
    }];
    _headerHeight += (width + 10) * (rows-1);
        
    __block UIView *lastView;

    [self.picArr enumerateObjectsUsingBlock:^(WKImageModel   *image, NSUInteger idx, BOOL *  stop) {
        
        WKImageItemView *view = [[WKImageItemView alloc] init];
        view.delegate = self;
        if (image.image != nil) {
            view.imageView.image = image.image;
            if ([image.PicUrl isEqualToString:@"add"]) {
                view.hiddenClose = YES;
                
                if (self.picArr.count >= 5) {
                    view.hidden = YES;
                }else{
                    view.hidden = NO;
                }
            }
            
        }else{
            [view.imageView sd_setImageWithURL:[NSURL URLWithString:image.PicUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        }
        view.userInteractionEnabled = YES;
        [imageBgView addSubview:view];
        NSInteger rowIndex = idx / rowCapacity; //行index
        NSInteger columnIndex = idx % rowCapacity;//列index
        
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置 各个item 大小相等
                make.size.equalTo(lastView);
            }];
        }
        
        if (columnIndex == 0) {//每行第一列
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置左边界
                make.left.offset(10);
                if (rowIndex == 0) {//第一行 第一个
                    make.width.equalTo(view.mas_height);//长宽相等
                    if (_picArr.count < rowCapacity) {//不满一行时 需要 计算item宽
                        //比如 每行容量是6,则公式为:(superviewWidth/6) - (leftMargin + rightMargin + SumOf_selectedImagespacing)/6
                        make.width.mas_offset(width);
                    }
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {//设置上边界
                        make.top.offset(10);
                    }];
                }else {//其它行 第一个
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        //和上一行的距离
                        make.top.equalTo(lastView.mas_bottom).offset(10);
                    }];
                }
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置item水平间距
                make.left.equalTo(lastView.mas_right).offset(10);
                //设置item水平对齐
                make.centerY.equalTo(lastView);
                
                //设置右边界距离
                if (columnIndex == rowCapacity - 1 && rowIndex == 0) {//只有第一行最后一个有必要设置与父视图右边的距离，因为结合这条约束和之前的约束可以得出item的宽，前提是必须满一行，不满一行 需要计算item的宽
                    make.right.offset(- 10);
                }
            }];
        }
        lastView = view;
        
        lastView.tag = idx + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
        [lastView addGestureRecognizer:tap];
        
    }];
}

- (void)layoutViewWithRows:(NSInteger)rows{
    
    if (_type == WKGoodsTypeSale) {
        self.tableHeaderView.frame = CGRectMake(0, 0, WKScreenW, _headerHeight);
        self.tableView.tableHeaderView = self.tableHeaderView;
        
        [self.tableHeaderView layoutIfNeeded];
    }else{
        [self.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(WKScreenW, _headerHeight));
        }];
        
        [self.tableHeaderView layoutIfNeeded];
        [self layoutIfNeeded];
    }
}

// MARK: 选择图片
- (void)selectImage:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag - 100 == _picArr.count-1 || _picArr.count == 0) {
        // 选择图片
        [self captureImageWithCaptureType:WKCaptureImageTypeMutiple maxCount:5 - _picArr.count :^(NSArray *arr) {
            
            [WKProgressHUD showLoadingGifText:@""];
            //选择图片后，进行上传
            [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:arr success:^(WKBaseResponse *response)
            {
                //上传成功后，返回图片路径
                NSArray *picurls = (NSArray *)response.Data;

                //添加到图片集合中
                for (int i=0; i<arr.count; i++)
                {
                    if(self.picArr.count > 5)
                    {
                        break;
                    }
                    WKImageModel *imageItem =  [[WKImageModel alloc] init];
                    imageItem.image = arr[i];
                    imageItem.PicUrl = picurls[i];
                    [self.picArr insertObject:imageItem atIndex:0];
                }
                
                //排版图片
                [self layoutImages];
                
                //关闭遮罩
                [WKProgressHUD dismiss];
            }
            failure:^(WKBaseResponse *response)
            {
                [WKProgressHUD dismiss];
                [WKProgressHUD showTopMessage:@"图片上传失败，请重试！"];
            }];
        }];
        
    }else{
        // 查看图片
        if (self.picArr.count != 0) {
            NSMutableArray *arr = @[].mutableCopy;
            
            for (int i=0; i < self.picArr.count-1; i++)
            {
                WKImageModel *imageModel = self.picArr[i];
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                if (imageModel.image == nil) {
                    photo.photoURL = [NSURL URLWithString:imageModel.PicUrl];
                }else{
                    photo.photoImage = imageModel.image;
                }
                [arr addObject:photo];
            }

            [self showImageWith:arr index:tap.view.tag-100];
        }
        
    }
}

// MARK: Action
- (void)btnClick:(UIButton *)btn{
    // 包邮
    _isShiping = !_isShiping;
    btn.selected = !btn.selected;
}

// MARK: 获取要上传的信息
- (NSDictionary *)getGoodsInfo{
    self.dataModel.GoodsName = self.textField.text;
    self.dataModel.Description = self.textView.text ;
    self.dataModel.IsFreeShipping = _isShiping ;
    
    //获取的图片中，包含添加按钮的图片
    self.dataModel.GoodsPicList = [self getPicArr];
    if (self.dataModel.GoodsPicList.count == 0) {
        [self promptViewShow:@"至少传一张图片！"];
        return nil;
    }

    if (self.dataModel.GoodsName.length == 0) {
        [self promptViewShow:@"请填写商品名称！"];
        return nil;
    }
    else
    {
        if(self.dataModel.GoodsName.length > 12)
        {
            [self promptViewShow:@"商品名称限制12个字符！"];
            return nil;
        }
    }
    
    if(self.dataModel.Description.length == 0)
    {
        [self promptViewShow:@"请输入商品描述！"];
        return nil;
    }
    else
    {
        if(self.dataModel.Description.length > 150)
        {
            [self promptViewShow:@"商品描述限制150个字符！"];
            return nil;
        }
    }
    
    // 获取型号
    self.dataModel.GoodsModelList = [self getModeArr];
    if(self.dataModel.GoodsModelList == nil)
    {
        return  nil;
    }

    // 获取图片
    NSString *isShopping = _isShiping?@"true":@"false";
    
    NSMutableDictionary *para = @{
                           @"GoodsName": self.dataModel.GoodsName,
                           @"Description": self.dataModel.Description,
                           @"GoodsPicList": [self.dataModel.GoodsPicList yy_modelToJSONString],
                           @"GoodsModelList": [self.dataModel.GoodsModelList yy_modelToJSONString],
                           @"IsFreeShipping": _type == WKGoodsTypeSale?isShopping:@"true",
                           @"IsAuction": _type == WKGoodsTypeSale?@"false":@"true"
                           }.mutableCopy;
    
    if (self.dataModel.GoodsCode.integerValue != 0) {
//        NSLog(@"boolvalue : %@",@(self.dataModel.IsMarketable));
        
        NSDictionary *dict = @{
                               @"ID":self.dataModel.ID,
                               @"GoodsCode":self.dataModel.GoodsCode,
                               @"IsDelete":self.dataModel.IsDelete?@"true":@"false",
                               @"IsMarketable":self.dataModel.IsMarketable?@"true":@"false",
                               @"CreateTime":self.dataModel.CreateTime
                               };
        [para addEntriesFromDictionary:dict];
    }
    
    NSLog(@"para : %@",para);
    return para;
}

- (NSArray *)getModeArr{
    //定义返回集合
    NSMutableArray *arr = @[].mutableCopy;
    
    //如果是维护拍卖品
    if (_type == WKGoodsTypeAuction) {
        [self.itemsArray removeAllObjects];
        if(self.auctionPriceText.text.length == 0)
        {
            [self promptViewShow:@"请输入商品价格！"];
            return nil;
        }
        else if(![self isPureFloat:self.auctionPriceText.text] || self.auctionPriceText.text.floatValue <= 0)
        {
            [self promptViewShow:@"商品价格必须大于0！"];
            return nil;
        }
      
        WKMarkModel *md = [[WKMarkModel alloc] init];
        md.Price = [NSString stringWithFormat:@"%.2f",self.auctionPriceText.text.floatValue];
        md.Stock = @1;
        md.ModelName = @"";
        [self.itemsArray addObject:md];
    }
    
    //把ItemArray中的数据，放入Models_Set中
    NSMutableSet *models_set = [NSMutableSet setWithCapacity:self.itemsArray.count];
    
    //循环集合
    for (WKMarkModel *markModel in self.itemsArray) {
        if(markModel.Price.length == 0 || markModel.Stock == nil)
        {
            [self promptViewShow:@"请输入价格和库存！"];
            return nil;
        }
        
        if(![self isPureFloat:markModel.Price] || markModel.Price.floatValue <= 0)
        {
            [self promptViewShow:@"商品价格必须大于0！"];
            return nil;
        }
        
        if(markModel.Stock.integerValue < 0)
        {
            [self promptViewShow:@"商品库存必须大于等于0！"];
            return nil;
        }

        //判断如果ItemsArray有多个，证明有多个型号
        if(self.itemsArray.count > 1 && markModel.ModelName.length == 0)
        {
            [self promptViewShow:@"请请填写型号！"];
            return nil;
        }
        else
        {
            if(markModel.ModelName.length > 10)
            {
                [self promptViewShow:@"商品型号限制10个字符！"];
                return nil;
            }
        }
        
        //库存不维护，默认为0
        markModel.ModelName = markModel.ModelName == nil ? @"" : markModel.ModelName;
        NSString *price = [NSString stringWithFormat:@"%.2f",markModel.Price.floatValue];
        NSMutableDictionary *dict = @{@"Price":price,@"Stock":markModel.Stock}.mutableCopy;
        [dict addEntriesFromDictionary:@{@"ModelName":markModel.ModelName}];
        [models_set addObject:markModel.ModelName];
        if (markModel.ID != nil) {
            if (self.dataModel.GoodsCode.integerValue != 0) {
                [dict addEntriesFromDictionary:@{@"ID":markModel.ID}];
                [dict addEntriesFromDictionary:@{@"CreateTime":markModel.CreateTime}];
                [dict addEntriesFromDictionary:@{@"ModelCode":markModel.ModelCode}];
            }
        }
        
        //添加到返回集合中
        [arr addObject:dict];
    }

    if (models_set.count != self.itemsArray.count && models_set.count != 0) {
        [self promptViewShow:@"型号名称不能重复！"];
        return nil;
    }
    
    return arr;
}

// MARK: 删减图片
- (void)deleteImageWith:(id)obj{
    WKImageItemView *view = (WKImageItemView *)obj;
    [_picArr removeObjectAtIndex:view.tag-100];
    [self layoutImages];
}

//获取图片集合
- (NSArray *)getPicArr{
    //图片集合最后一张是添加按钮图片，不返回
    NSMutableArray *tempArr =[[NSMutableArray alloc]init];
    for (int i = 0; i < self.picArr.count - 1; i++) {
        WKImageModel *imgModel =  self.picArr[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"PicUrl"] = imgModel.PicUrl == nil ? @"" : imgModel.PicUrl;
        dic[@"ID"] = imgModel.ID == nil ? @"" : imgModel.ID;
        dic[@"CreateTime"] = imgModel.CreateTime == nil ? @"" : imgModel.CreateTime;
        //dic[@"Sort"] = @(i + 1);
        dic[@"Sort"] = @(self.picArr.count - 1 - i);
        [tempArr addObject:dic];
    }
    
    
    
    return tempArr;
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

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemsArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.itemsArray.count-1) {
        UIView *footerView = [UIView new];
        footerView.frame = CGRectMake(0, 0, WKScreenW, 70);
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"添加商品型号" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pro_smalladd01"] forState:UIControlStateNormal];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.itemsArray.count - 1) {
        return 70.0f;
    }else{
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKMarkModel *md = _itemsArray[indexPath.section];
    if (md.ModelName) {
        return 44 * 3 + 20;
    }else{
        return 44 * 2 + 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setItemModel:self.itemsArray[indexPath.section]];
    return cell;
}

#pragma mark - 删减型号
- (void)addModel:(UIButton *)btn{
    // 添加型号
    if (_itemsArray.count == 1) {
        
        WKMarkModel *item = _itemsArray[0];
        if (!item.ModelName) {
            item.ModelName = @"";
            NSDate *time = [NSDate date];
            item.CreateTime = [NSString stringWithFormat:@"%@",time];
        }else{
            WKMarkModel *newItem = [WKMarkModel new];
            newItem.ModelName = @"";
            NSDate *time = [NSDate date];
            newItem.CreateTime = [NSString stringWithFormat:@"%@",time];
            [_itemsArray addObject:newItem];
        }
        
    }else{
        WKMarkModel *newItem = [WKMarkModel new];
        newItem.ModelName = @"";
        NSDate *time = [NSDate date];
        newItem.CreateTime = [NSString stringWithFormat:@"%@",time];
        [_itemsArray addObject:newItem];
    }
    
    [_tableView reloadData];
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_itemsArray.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)deleteWith:(id)obj{
    WKMarkModel *md = (WKMarkModel *)obj;
    
    if (_itemsArray.count == 1) {
        WKMarkModel *item = _itemsArray[0];
        item.ModelName = nil;
    }else{
        [_itemsArray removeObject:md];
    }
    [_tableView reloadData];
}

- (void)layoutImageViewsWith:(CGFloat)height{
    _headerHeight += height;
    self.tableHeaderView.frame = CGRectMake(0, 0, WKScreenW, _headerHeight);
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableHeaderView layoutIfNeeded];
}
-(void)promptViewShow:(NSString *)message{
    [WKPromptView showPromptView:message];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
