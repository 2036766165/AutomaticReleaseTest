//
//  WKPickerImageView.m
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKPickerImageView.h"
#import "WKImageCollectionViewCell.h"
#import "WKImageModel.h"
#import "NSObject+WKImagePicker.h"
#import "WKCellOperationProtocol.h"
#import "WKButton.h"

@interface WKPickerImageView () <UICollectionViewDelegate,UICollectionViewDataSource,WKCellOperationProtocol,UICollectionViewDelegateFlowLayout>

//@property (nonatomic,strong) UIView *addBtn;
//@property (nonatomic,strong) UIView *addImageV;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) NSIndexPath *originIndexPath;     // 开始的位置
@property (nonatomic,strong) NSIndexPath *moveIndexPath;       // 移动的位置
@property (nonatomic,strong) UIView *snapMoveCell;                 // 截图
@property (nonatomic,assign) CGPoint lastPoint;                // 手势结束的点

//@property (nonatomic,strong) UIButton *addVideoBtn;
@property (nonatomic,assign) WKPickerImageType type;
@property (nonatomic,assign) NSUInteger lineCount;   // 显示几行图片

@end

@implementation WKPickerImageView

- (instancetype)initWithFrame:(CGRect)frame type:(WKPickerImageType)type{
    if (self = [super initWithFrame:frame]) {
        [self commonInitType:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInitType:WKPickerImageTypeNormal];
    }
    return self;
}

- (void)commonInitType:(WKPickerImageType)type{
    self.type = type;
    self.lineCount = 1;
    
    CGFloat itemWidth = (WKScreenW - 50)/4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerNib:[UINib nibWithNibName:@"WKImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WKImageCollectionViewCell"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [collectionView addGestureRecognizer:longPress];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setPlaceholder];
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[].mutableCopy;
    }
    return _imageArray;
}

- (void)setPlaceholder{
    if (self.type == WKPickerImageTypeNormal) {
        // 添加图片的按钮
        WKImageModel *addImage = [[WKImageModel alloc] init];
        addImage.image = [UIImage imageNamed:@"addImage"];
        addImage.isNormal = YES;
        [self.imageArray addObject:addImage];
        
    }else{
        WKImageModel *addImage = [[WKImageModel alloc] init];
        addImage.image = [UIImage imageNamed:@"addImage_virtual"];
        addImage.isNormal = YES;
        [self.imageArray addObject:addImage];
        
        WKImageModel *addVideo = [[WKImageModel alloc] init];
        addVideo.isNormal = YES;
        addVideo.image = [UIImage imageNamed:@"addVideo"];
        [self.imageArray addObject:addVideo];
    }
}

- (void)setImageArr:(NSArray *)arr{
    self.imageArray = arr.mutableCopy;
    [self setPlaceholder];
    [self adaptHeight];
}

- (NSArray *)getImageArr{
    NSInteger length = self.type == WKPickerImageTypeNormal?1:2;
    return [self.imageArray subarrayWithRange:NSMakeRange(0, self.imageArray.count - length)];
}

- (void)longPress:(UILongPressGestureRecognizer *)press{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[press locationOfTouch:0 inView:press.view]];
    
    if (self.type == WKPickerImageTypeNormal) {
        if (indexPath.item == self.imageArray.count - 1) {
            return;
        }
    }else{
        if (indexPath.item == self.imageArray.count - 1 || indexPath.item == self.imageArray.count - 2) {
            return;
        }
    }
    
    switch (press.state) {
        case UIGestureRecognizerStateBegan:
            // 开始
            [self setupBeginGesture:press];
            break;
        case UIGestureRecognizerStateChanged:
            [self setupGestureChanged:press];
            break;
            
        default:
            [self setupGestureEndOrCancel:press];
            break;
    }
}

- (void)setupBeginGesture:(UILongPressGestureRecognizer *)gesture{
    // 判断手指所在的cell
    self.lastPoint = [gesture locationOfTouch:0 inView:self.collectionView];
    self.originIndexPath = [self.collectionView indexPathForItemAtPoint:self.lastPoint];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.originIndexPath];
    UIView *snapMoveCell = [cell snapshotViewAfterScreenUpdates:NO];  // 截图
    snapMoveCell.frame = cell.frame;
    [self.collectionView addSubview:snapMoveCell];
    cell.hidden = YES;
    self.snapMoveCell = snapMoveCell;
    [UIView animateWithDuration:0.2 animations:^{
        self.snapMoveCell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
}

- (void)setupGestureChanged:(UILongPressGestureRecognizer *)gesture{
    CGFloat transX = [gesture locationOfTouch:0 inView:self.collectionView].x - self.lastPoint.x;
    CGFloat transY = [gesture locationOfTouch:0 inView:self.collectionView].y - self.lastPoint.y;
    
    self.snapMoveCell.center = CGPointApplyAffineTransform(self.snapMoveCell.center, CGAffineTransformMakeTranslation(transX, transY));
    self.lastPoint = [gesture locationOfTouch:0 inView:gesture.view];  // 记录移动的最好一点
    
    // 交换cell
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if (self.originIndexPath == [self.collectionView indexPathForCell:cell]) {
            continue;
        }
        // 计算移动的snapMoveCell和相交cell的距离
        CGFloat spaceX = fabs(self.snapMoveCell.center.x - cell.center.x);
        CGFloat spaceY = fabs(self.snapMoveCell.center.y - cell.center.y);
        
        if (spaceX <= self.snapMoveCell.frame.size.width/2 && spaceY <= self.snapMoveCell.frame.size.height/2) {
            
            self.moveIndexPath = [self.collectionView indexPathForCell:cell];
            
            if (self.type == WKPickerImageTypeNormal) {
                
                if (self.moveIndexPath.item == self.imageArray.count - 1) {
                    [self setupGestureEndOrCancel:gesture];
                    break;
                }
            }else{
                if (self.moveIndexPath.item == self.imageArray.count - 1 || self.moveIndexPath.item == self.imageArray.count - 2) {
                    [self setupGestureEndOrCancel:gesture];
                    break;
                }
            }

            [self.collectionView moveItemAtIndexPath:self.originIndexPath toIndexPath:self.moveIndexPath];
            // 更新数据源
            [self updateDataSource];
            self.originIndexPath = self.moveIndexPath;
            break;
        }
    }
}

- (void)updateDataSource{
    
    if (self.moveIndexPath.item > self.originIndexPath.item) {
        for (NSUInteger index = self.originIndexPath.item; index < self.moveIndexPath.item; index++) {
            [self.imageArray exchangeObjectAtIndex:index withObjectAtIndex:index+1];
        }
    }else{
        for (NSUInteger index=self.originIndexPath.item; index > self.moveIndexPath.item; index--) {
            [self.imageArray exchangeObjectAtIndex:index withObjectAtIndex:index-1];
        }
    }
    
    //[self.imageArray exchangeObjectAtIndex:self.moveIndexPath.item withObjectAtIndex:self.originIndexPath.item];
}

- (void)setupGestureEndOrCancel:(UILongPressGestureRecognizer *)gesture{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.originIndexPath];
    [UIView animateWithDuration:0.25 animations:^{
        self.snapMoveCell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.snapMoveCell.center = cell.center;
        
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [self.snapMoveCell removeFromSuperview];
    }];
}

- (void)adaptHeight{
    if (self.refreshImage) {
        self.refreshImage();
    }
    
    if (self.type == WKPickerImageTypeNormal) {
        
        //                 if (self.imageArray.count >= 4) {
        //                     self.addImageV.hidden = YES;
        //                 }else{
        //                     self.addImageV.hidden = NO;
        //
        //                     [self.addImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        //                         make.left.mas_offset(10 + self.imageArray.count * (itemWidth + 10));
        //                     }];
        //                 }
        
    }else{
        
        NSInteger lineCount = (self.imageArray.count)%4 == 0 ? (self.imageArray.count)/4 : (self.imageArray.count)/4 + 1;
        if (self.lineCount != lineCount) {
            if (self.refreshCount) {
                self.refreshCount(lineCount);
            }
            self.lineCount = lineCount;
        }
        
        //                 self.collectionView.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, (itemWidth + 10) * lineCount);
        //                 self.collectionView.frame = CGSizeMake(WKScreenW, self.collectionView.contentSize.height);
        
        //                 if (self.imageArray.count >= 9) {
        //                     self.addImageV.hidden = YES;
        //
        //                     [self.addVideoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        //                         make.left.mas_offset(10 + self.imageArray.count%4 * (itemWidth + 10));
        //                     }];
        //
        //                 }else{
        //                     self.addImageV.hidden = NO;
        //
        //                     [self.addImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        //                         make.left.mas_offset(10 + (self.imageArray.count)%4 * (itemWidth + 10));
        //                     }];
        //
        //                     [self.addVideoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        //                         make.left.mas_offset(10 + (self.imageArray.count + 1)%4 * (itemWidth + 10));
        //                     }];
        //                 }
    }
    
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.collectionView layoutIfNeeded];
//    }];
    [self.collectionView reloadData];
    
}

#pragma mark - Action
- (void)addImageTap{
    
    NSInteger exceptCount = 0;
    if (self.type == WKPickerImageTypeNormal) {
        exceptCount = 1;
    }else{
        exceptCount = 2;
    }
    
    [self captureImageWithCaptureType:WKCaptureImageTypeMutiple maxCount:self.maxCount - self.imageArray.count + exceptCount :^(NSArray *arr) {
        
        [WKProgressHUD showLoadingGifText:@""];
        //选择图片后，进行上传
        [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:arr success:^(WKBaseResponse *response)
         {
             //上传成功后，返回图片路径
             NSArray *picurls = (NSArray *)response.Data;

             //添加到图片集合中
             for (int i=0; i<arr.count; i++)
             {
                 WKImageModel *imageItem =  [[WKImageModel alloc] init];
                 imageItem.image = arr[i];
                 imageItem.FileType = @1;
                 imageItem.FileUrl = picurls[i];
                 imageItem.PicUrl = picurls[i];
                 [self.imageArray insertObject:imageItem atIndex:0];
//                 [self.imageArray addObject:imageItem];
             }
             [self adaptHeight];
             //关闭遮罩
             [WKProgressHUD dismiss];
         }
                            failure:^(WKBaseResponse *response)
         {
             [WKProgressHUD dismiss];
             [WKProgressHUD showTopMessage:@"图片上传失败，请重试！"];
         }];
    }];
}

#pragma mark - UICollectionView Delegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WKImageCollectionViewCell class]) forIndexPath:indexPath];
    [cell setImageMd:self.imageArray[indexPath.item]];
    cell.delegate = self;
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 20, 10);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == WKPickerImageTypeVirtual) {
        
        if (indexPath.item == self.imageArray.count - 1) {
            // 添加视频
            
        }else if(indexPath.item == self.imageArray.count - 2){
            // 图片
            [self addImageTap];
        }else{
            // 查看图片
            [self showImageIndex:indexPath.item];
        }
        
    }else{
        
        if (indexPath.item == self.imageArray.count - 1) {
            [self addImageTap];
        }else{
            [self showImageIndex:indexPath.item];
        }
    }
}

- (void)showImageIndex:(NSInteger)index{
    NSMutableArray *arr = @[].mutableCopy;

    NSArray *subArr;
    if (self.type == WKPickerImageTypeNormal) {
       subArr = [self.imageArray subarrayWithRange:NSMakeRange(0, self.imageArray.count - 1)];
    }else{
       subArr = [self.imageArray subarrayWithRange:NSMakeRange(0, self.imageArray.count-2)];
    }
    
    for (int i=0; i < subArr.count; i++)
    {
        WKImageModel *imageModel = self.imageArray[i];
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        if (imageModel.image == nil) {
            
            if (imageModel.PicUrl) {
                photo.photoURL = [NSURL URLWithString:imageModel.PicUrl];
            }else{
                photo.photoURL = [NSURL URLWithString:imageModel.FileUrl];
            }
        }else{
            photo.photoImage = imageModel.image;
        }
        [arr addObject:photo];
    }
    [self showImageWith:arr index:index];
}

- (void)opeartionCell:(id)cell type:(WKOpeartionType)type{
    // 删除cell
    NSIndexPath *idx = [self.collectionView indexPathForCell:cell];
    [self.imageArray removeObjectAtIndex:idx.item];
    [self.collectionView reloadData];
    
//    CGFloat itemWidth = (WKScreenW - 50)/4;
    
    NSInteger lineCount = (self.imageArray.count)%4 == 0 ? (self.imageArray.count)/4 : (self.imageArray.count)/4 + 1;
    if (self.lineCount != lineCount) {
        if (self.refreshCount) {
            self.refreshCount(lineCount);
        }
        self.lineCount = lineCount;
    }
    
    if (self.refreshImage) {
        self.refreshImage();
    }

    [UIView animateWithDuration:0.1 animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
