//
//  WKStoreAuthTable.swift
//  秀加加
//
//  Created by sks on 2016/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

import UIKit

class WKStoreAuthTable: WKBaseTableView {
    
    // @[@"实体店名:",@"责任人:",@"手机号码:",@"验证码:",@"所在地区:",@"详细地址:"]
    let dataModel:WKAuthStoreModel? = nil
    let titles:Array = [["实体店名:","手机号码:","验证码:","所在地区","详细地址"],["营业执照或资格证书"],["责任人身份证"]]

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.isOpenHeaderRefresh = false
//        self.isOpenFooterRefresh = false
//        self.tableView.showsVerticalScrollIndicator = false
////        self.tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: UITableView delegate
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (titles[section]).count
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return titles.count
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            return 160
//        }else if indexPath.section == 2{
//            return 180
//        }else{
//            return 44.0
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellId = "\(indexPath.section)\(indexPath.row)"
//        
////        let cellId = String.init(format: "\(%zd) + \(%zd)", indexPath.section,indexPath.row)
//        var cell:WKStoreItemTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! WKStoreItemTableViewCell?
//        
//        if cell == nil {
//            cell = WKStoreItemTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
//        }
//        cell?.titleLabel?.text = self.titles[indexPath.section][indexPath.row]
//        
//        if cell?.titleLabel?.text == "营业执照或资格证书" {
//            
//            let btn = self.getBtn(tag: 10)
//            cell?.contentView.addSubview(btn)
//            let addImage = UIImage.init(named: "add")
//            
//            btn.mas_makeConstraints({ (make) in
//                make?.top.equalTo()(cell?.titleLabel?.mas_bottom)?.setOffset(10);
//                make!.size.equalTo()(addImage?.size)
//                make!.left.equalTo()(20)
//            })
//            
//        }else if cell?.titleLabel?.text ==  "责任人身份证"{
//            // 正面
//            let frontBtn = self.getBtn(tag: 11)
//            cell?.contentView.addSubview(frontBtn)
//            let addImage = UIImage.init(named: "add")
//            
//            frontBtn.mas_makeConstraints({ (make) in
//                make?.top.equalTo()(cell?.titleLabel?.mas_bottom)?.setOffset(10);
//                make!.size.equalTo()(addImage?.size)
//                make!.left.equalTo()(20)
//            })
//            
//            let frontLab = UILabel()
//            frontLab.text = "身份证正面"
//            frontLab.font = UIFont.systemFont(ofSize: 12.0)
//            frontLab.textAlignment = NSTextAlignment.center
//            cell?.contentView.addSubview(frontLab)
//            
//            frontLab.mas_makeConstraints({ (make) in
//                make?.top.equalTo()(frontBtn.mas_bottom)?.setOffset(10)
//                make!.left.equalTo()(20)
//                make!.size.equalTo()(CGSize(width: 100, height: 20))
//            })
//            
//            // 反面
//            let backBtn = self.getBtn(tag: 11)
//            cell?.contentView.addSubview(backBtn)
//            
//            frontBtn.mas_makeConstraints({ (make) in
//                make?.top.equalTo()(cell?.titleLabel?.mas_bottom)?.setOffset(10);
//                make!.size.equalTo()(addImage?.size)
//                make?.left.equalTo()(frontBtn.mas_right)?.setOffset(20)
//            })
//            
//            let backLab = UILabel()
//            backLab.text = "身份证反面"
//            backLab.font = UIFont.systemFont(ofSize: 12.0)
//            backLab.textAlignment = NSTextAlignment.center
//            cell?.contentView.addSubview(backLab)
//            
//            frontLab.mas_makeConstraints({ (make) in
//                make?.top.equalTo()(backBtn.mas_bottom)?.setOffset(10)
//                make!.left.equalTo()(20)
//                make!.size.equalTo()(CGSize(width: 100, height: 20))
//            })
//            
//        }else{
//            
//        }
//        
//        return cell!
//    }
//    
//    private func getBtn(tag : Int) -> UIButton{
//        let addImage = UIImage.init(named: "add")
//        let btn = UIButton(type: UIButtonType.custom)
//        btn.tag = tag
//        btn.setImage(addImage, for: UIControlState.normal)
//        btn.addTarget(self, action: #selector(self.selectedImage(btn:)), for: UIControlEvents.touchUpInside)
//        return btn
//    }
//    
//    @objc private func selectedImage(btn: UIButton){
//        if btn.tag == 10 {
//            // 营业执照
//            
//        }else if btn.tag == 11{
//            // 身份证正面
//            
//        }else{
//            // 身份证反面
//            
//        }
//    }
    
        /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
