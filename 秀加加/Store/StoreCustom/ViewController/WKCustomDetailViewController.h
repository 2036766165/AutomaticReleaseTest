//
//  WKCustomDetailViewController.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKCustomInformationModel.h"
#import "WKCustomTableModel.h"

@interface WKCustomDetailViewController : ViewController

@property (nonatomic, strong) NSString *customCode;

@property (nonatomic, strong) CustomInnerList *customModel;

@property (nonatomic , strong) NSMutableArray *InnerList ;

@end
