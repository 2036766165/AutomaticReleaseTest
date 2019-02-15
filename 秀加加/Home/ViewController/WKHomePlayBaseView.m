//
//  WKHomePlayBaseView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomePlayBaseView.h"
#import "WKHomePlayCell.h"
#import "SDCycleScrollView.h"
#import "WKAllWebViewController.h"

@interface WKHomePlayBaseView ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) NSArray * dataArr;

@property (assign, nonatomic) CGFloat lastScrollOffset;

@property (assign, nonatomic) CGFloat countOffSet;

@property (assign, nonatomic) BOOL cycleViewHidden;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView3;

@end

@implementation WKHomePlayBaseView

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dataArr cycle:(BOOL)cycleViewHidden block:(homePlayBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        self.cycleViewHidden = cycleViewHidden;
        self.tableView.showsVerticalScrollIndicator = NO;
        if (self.cycleViewHidden) {
            self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }else{
            [self.tableView initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        }
        self.dataArr = dataArr;
        self.countOffSet = 0;
        self.isOpenFooterRefresh = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
-(void)reloadDataWithArray:(NSArray *)array{
    [super reloadDataWithArray:array];
    NSMutableArray *ScrollImageArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i< self.imageScrollList.count; i ++) {
        WKScrollImageModel *temp = self.imageScrollList[i];
        [ScrollImageArray addObject:temp.ImageURL];
    }
    if (!self.cycleScrollView3 && ScrollImageArray.count>0) {
        self.cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        self.cycleScrollView3.autoScrollTimeInterval = 4;
        self.cycleScrollView3.pageControlBottomOffset = -7;
        self.cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        self.cycleScrollView3.imageURLStringsGroup = ScrollImageArray;
        self.tableView.tableHeaderView =self.cycleScrollView3;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //点击轮播图进行跳转
    WKScrollImageModel *imageModel =  self.imageScrollList[index];
    NSLog(@"点击了第%ld张图片，链接地址：%@",(long)index,imageModel.LinkURL);
    
    if(self.JumpBlock)
    {
        self.JumpBlock(imageModel.LinkURL);
    }
}

#pragma mark tableView Dategate
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //获得轮播图集合
//    NSMutableArray *ScrollImageArray = [[NSMutableArray alloc]init];
//    for (int i = 0 ; i< self.imageScrollList.count; i ++) {
//        WKScrollImageModel *temp = self.imageScrollList[i];
//        [ScrollImageArray addObject:temp.ImageURL];
//    }
//    if (ScrollImageArray.count>0 && !self.cycleScrollView3) {
//        self.cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
//        self.cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
//        self.cycleScrollView3.autoScrollTimeInterval = 4;
//        self.cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
//        self.cycleScrollView3.imageURLStringsGroup = ScrollImageArray;
//    }
//    
//    if (self.cycleViewHidden) {
//        return [[UIView alloc]init];
//    }else{
//        return self.cycleScrollView3;
//    }
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.cycleViewHidden) {
//        return 0.001;
//    }else{
//        return 130;
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKHomePlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKHomePlayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WKHomePlayModel *model = self.dataArr[indexPath.row];
    cell.isSearch = self.isSearch;
    cell.model = model;
    cell.block = ^(NSString *memberId){
        self.block(-1,memberId);
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 434*WKScaleW;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.block(indexPath.row,@"1");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat y = scrollView.contentOffset.y;
        if (y<0 || y+WKScreenH > 434*WKScaleW*self.dataArr.count) {
            if (self.scrollBlock) {
                self.scrollBlock(0);
            }
            return;
        }
        if (self.scrollBlock) {
            self.scrollBlock(y-self.lastScrollOffset);
        }
        self.lastScrollOffset = y;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tableView) {
        if (self.endBlock) {
            self.endBlock();
        }
    }
}
-(void)setTabeViewFrame:(CGRect)frame{
    self.tableView.frame = frame;
}
-(void)headerRequestWithData{
    if (self.requestBlock) {
        self.requestBlock();
    }
}

@end
