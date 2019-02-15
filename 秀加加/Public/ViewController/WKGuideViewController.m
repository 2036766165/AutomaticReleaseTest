//
//  WKGuideViewController.m
//  show++
//
//  Created by lin on 16/7/25.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKGuideViewController.h"
#import "AppDelegate.h"
#import "WKGuideViewCell.h"

@implementation WKGuideViewController
{
    NSString *ID;
    AppDelegate *appDelegate;
}

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //行距
    layout.minimumLineSpacing = 0;
    // 间距
    layout.minimumInteritemSpacing = 0;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ID = @"引导";
    // 初始化
    [self setUp];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"7e879d"];
    [self.collectionView registerClass:[WKGuideViewCell class] forCellWithReuseIdentifier:ID];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.pageControl = [[WKPageControl alloc]initWithFrame:CGRectMake(0, WKScreenH-40, WKScreenW, 20)];
    self.pageControl.numberOfPages = 5;
    [self.view addSubview:self.pageControl];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[WKGuideViewCell alloc]initWithFrame:CGRectMake(0, 0,WKScreenW, WKScreenH)];
    }
    NSString *imageName = [NSString stringWithFormat:@"firstPage%ld",indexPath.item+1];
    cell.image = [UIImage imageNamed:imageName];
    [cell.startBtn addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row == 4)
    {
        cell.startBtn.hidden = YES;
    }
    else
    {
        cell.startBtn.hidden = YES;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        [self button1Action:nil];
    }
}
- (void)button1Action:(UIButton *)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    appDelegate = application.delegate;
    [appDelegate customTabBar];
}

-(void)setUp
{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    [self.pageControl setCurrentPage:scrollView.contentOffset.x/WKScreenW];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.contentOffset.x>WKScreenW*4) {
        [self button1Action:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
