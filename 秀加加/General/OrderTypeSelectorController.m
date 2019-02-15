//
//  OrderTypeSelectorController.m
//  秀加加
//
//  Created by liuliang on 2017/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "OrderTypeSelectorController.h"
#import "OrderTypeCell.h"

@interface OrderTypeSelectorController ()


@end

@implementation OrderTypeSelectorController

@synthesize selectedIndex;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
        
        if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
            self.preferredContentSize = CGSizeMake(100, 4 * 40 - 1);
        } else {
            self.contentSizeForViewInPopover = CGSizeMake(100, 4 * 40 - 1);
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40.0;
    self.view.backgroundColor = [UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    OrderTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OrderTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    NSString* labelname = @"";
    NSString* imname = @"";
    if(indexPath.row == 0){
        imname = @"ordertypeall";
        labelname = @"全部";
    }
    if(indexPath.row == 1){
        imname = @"ordertypeputong";
        labelname = @"普通订单";
    }
    if(indexPath.row == 2){
        imname = @"ordertypepaimai";
        labelname = @"拍卖订单";
    }
    if(indexPath.row == 3){
        imname = @"ordertypexingyun";
        labelname = @"幸运订单";
    }
    if(indexPath.row == self.selectedIndex){
        imname = [imname stringByAppendingString:@"2"];
        cell.selected = true;
    }
    [cell setData:labelname img:imname];
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row];
    //cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //remove keyboard if table row is clicked
    NSDictionary *dict = [NSDictionary dictionaryWithObject:indexPath forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ordertypeselect" object:nil userInfo:dict];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
