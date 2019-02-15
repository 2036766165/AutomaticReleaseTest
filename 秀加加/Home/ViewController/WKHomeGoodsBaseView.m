//
//  WKHomeGoodsView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHomeGoodsBaseView.h"
#import "WKHomeGoodsBaseCell.h"
@interface WKHomeGoodsBaseView ()

@property (assign, nonatomic) CGFloat lastScrollOffset;

@property (assign, nonatomic) CGFloat countOffSet;

@property (strong, nonatomic) NSTimer * timer;

@property (assign, nonatomic) NSInteger timeCount;

@end

@implementation WKHomeGoodsBaseView

-(instancetype)initWithFrame:(CGRect)frame block:(homeGoodsBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
#pragma mark tableView Dategate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKHomeGoodsBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKHomeGoodsBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.block(indexPath.row,@"1");
    WKHomeGoodsModel *goodsMd = self.dataArray[indexPath.row];
    if ([_delegate respondsToSelector:@selector(selectGoodsWith:)]) {
        [_delegate selectGoodsWith:goodsMd];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat y = scrollView.contentOffset.y;
        if (y<0 || y+WKScreenH > 140*self.dataArray.count) {
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
