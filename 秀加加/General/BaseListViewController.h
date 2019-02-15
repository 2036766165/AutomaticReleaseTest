//
//  BaseListView.h
//  秀加加
//
//  Created by liuliang on 2016/10/24.
//  Copyright © 2016年 walkingtec. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <BaseListVM.h>
@interface BaseListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

- (SEL) getAPI;

@end

