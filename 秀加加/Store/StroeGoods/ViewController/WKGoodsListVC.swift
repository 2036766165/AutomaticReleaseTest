//
//  WKGoodsListVC.swift
//  秀加加
//
//  Created by sks on 2016/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

import UIKit

class WKGoodsListVC: ViewController {

    var tableView: WKGoodsListView? = nil
    var dataArr:Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = WKGoodsListView(tableViewStyle: .Grouped)
        
        self.view.addSubview(self.tableView!)
        
        tableView?.mas_makeConstraints({ (make:MASConstraintMaker!) in
//            make!.edges.equalTo().(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        
        self.loadData()
    }
    
    func loadData() {
        let http = WKNetWorkManager.shareNetWork()
        
        let parameters:[String:AnyObject] = ["ShopOwnerNo":"",
                          "CustomerNo":"",
                          "PageIndex":self.tableView!.pageSize,
                          "PageSize":self.tableView!.pageNO
                          ]
        
        http.getGoodsList(HttpRequestMethod.Post, url: "ShopGoods/GetGoodsList", param: parameters as [NSObject : AnyObject], success: { (response:WKBaseResponse!) in
            
            }) { (response:WKBaseResponse!) in
                
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
