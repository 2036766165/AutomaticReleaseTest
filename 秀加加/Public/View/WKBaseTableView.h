//
//  WKBaseTableView.h
//  wdbo
//
//  Created by lin on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKRefreshTypeHeader,
    WKRefreshTypeFooter
} WKRefreshType;

@interface WKBaseTableView : UIView <UITableViewDataSource,UITableViewDelegate>

/**
 *  页数索引
 */
@property (nonatomic, assign)   NSInteger pageNO;
/**
 *  每页显示多少条
 */
@property (nonatomic, assign)   NSInteger pageSize;
/**
 *  是否还有显示的数据
 */
@property (nonatomic, assign, readonly)   BOOL isEndForLoadmore;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  列表
 */
@property (nonatomic, strong, readonly) UITableView *tableView;

/**
 *  是否开启头部刷新
 */
@property (nonatomic, assign)   BOOL isOpenHeaderRefresh;
/**
 *  是否开启尾部刷新
 */
@property (nonatomic, assign)   BOOL isOpenFooterRefresh;

@property (nonatomic, copy)    void (^requestBlock)();

@property (nonatomic,assign) BOOL isEmpty;
//
//@property (nonatomic, copy)    void (^refreshBlock)(WKRefreshType);

/**
 *  根据tableview样式创建tableview
 *
 *  @param tableViewStyle 样式
 *      
 *  @return UITableView实例
 */
//- (instancetype)initWithTableViewStyle:(UITableViewStyle)tableViewStyle;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

/**
 *  刷新
 *
 *  @param array 数据
 */
- (void)reloadDataWithArray:(NSArray *)array;

-(void)reloadData;

- (void)endRefreshing;
/**
 *  头部刷新请求（子类需要重新）
 */
- (void)headerRequestWithData;
/**
 *  脚部刷新请求（子类需要重新）
 */
- (void)footerRequestWithData;

/*
 * 加载完没有数据或网络失败的提示
 */
- (void)setRemindreImageName:(NSString *)imageName text:(NSString *)text completion:(void(^)())completionBlock;

/*
 * 没有更多数据
 */
- (void)noMoreData;

/*
 * 重置底部刷新
 */
- (void)resetFooterView;


- (void)setRemindreImageName:(NSString *)imageName text:(NSString *)text offsetY:(CGFloat)offsetY completion:(void(^)())completionBlock;

@end
