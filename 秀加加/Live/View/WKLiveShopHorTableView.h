//
//  WKLiveShopHorTableView.h
//  秀加加
//
//  Created by lin on 2016/10/18.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKLiveShopListModel.h"
#import "WKLiveShopCommentModel.h"

@interface WKLiveShopHorTableView : WKBaseTableView

@property (strong, nonatomic) WKLiveShopListModel *liveshopListModel;

//@property (strong, nonatomic) WKLiveShopCommentModel *shopCommentModel;
@property (nonatomic,strong) NSMutableArray *commentArray;

@property (strong, nonatomic) NSArray *picarray;

@end
