//
//  FinanceViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/7.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class FinanceCell :UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    
}

class FinanceViewController : UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    struct total_Financedata {
        let type : String
        let financeitem : [Financeitemdata]
        
    }
    
    struct Financeitemdata{
        
        let title : String
        let date : String
        let amount : Int
        
    }
    
    
    
    @IBOutlet weak var FinanceTable: UITableView!
    
    
    @IBOutlet weak var total_amountLabel: UILabel!
    
    @IBOutlet weak var selgroupBtn: UIButton!
    
    @IBAction func selgroupAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        
        var n = 0
        
        print(glo_BuildingList)
        while ( n < glo_BuildingList.count){
            let okAction1 = UIAlertAction(title: glo_BuildingList[n].name,style: .default   ){ (action:UIAlertAction!) in
                
                
                print(action.title)
                let cur_n = glo_BuildingList.firstIndex(where: {$0.name == action.title})
                print(cur_n)
                //self.this_PropertyList = []
                //self.propertyTable.reloadData()
                
                
                self.selgroupBtn.setTitle(glo_BuildingList[cur_n!].name, for: .normal)
                
                //self.getpropertybygrouptag_api(sel_title: glo_BuildingList[cur_n!].name)
                //self.Unfold_group(sel_index: cur_n!)
                
                
            }
            
            alertController.addAction(okAction1)
            
            
            
            n += 1
        }
        
        
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    @IBOutlet weak var selpropertyBtn: UIButton!
    @IBAction func selpropertyAction(_ sender: Any) {
        
        
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        
        let building_n = glo_BuildingList.firstIndex(where: {$0.name == selgroupBtn.titleLabel?.text})
        
        if (building_n == nil){
            return
        }
        var n = 0
        
        print(glo_BuildingList)
        while ( n < glo_BuildingList[building_n!].property_items.count){
            let okAction1 = UIAlertAction(title: glo_BuildingList[building_n!].property_items[n].full_address,style: .default   ){ (action:UIAlertAction!) in
                
                
                print(action.title)
                let cur_n = glo_BuildingList[building_n!].property_items.firstIndex(where: {$0.full_address == action.title})
                //print(cur_n)
                //self.this_PropertyList = []
                //self.propertyTable.reloadData()
                
                
                self.selpropertyBtn.setTitle(glo_BuildingList[building_n!].property_items[cur_n!].full_address, for: .normal)
                
                //self.getpropertybygrouptag_api(sel_title: glo_BuildingList[cur_n!].name)
                //self.Unfold_group(sel_index: cur_n!)
                
                
            }
            
            alertController.addAction(okAction1)
            
            
            
            n += 1
        }
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var seltimeBtn: UIButton!
    @IBAction func seltimeAction(_ sender: Any) {
        
    }
    
    
    var FinanceList = [total_Financedata]()
    var FinanceItemList = [Financeitemdata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FinanceTable.delegate = self
        FinanceTable.dataSource = self
        
        button_style2(sel_button: selgroupBtn)
        button_style2(sel_button: selpropertyBtn)
        button_style2(sel_button: seltimeBtn)
        
        
        FinanceItemList.append(Financeitemdata(title: "租金", date: "", amount: 30000))
        FinanceItemList.append(Financeitemdata(title: "合計", date: "", amount: 30000))
        FinanceList.append(total_Financedata(type: "收入", financeitem: FinanceItemList))
        
        FinanceItemList.removeAll()
        
        FinanceItemList.append(Financeitemdata(title: "修繕 漏水", date: "2020/03/20", amount: 8000))
        FinanceItemList.append(Financeitemdata(title: "修繕 冷氣", date: "2020/01/20", amount: 10000))
        FinanceItemList.append(Financeitemdata(title: "地價", date: " ", amount: 7500))
        FinanceItemList.append(Financeitemdata(title: "房屋稅", date: " ", amount: 1500))
        FinanceItemList.append(Financeitemdata(title: "營業稅", date: " ", amount: 1600))
        FinanceItemList.append(Financeitemdata(title: "廣告519.com", date: " ", amount: 796))
        FinanceItemList.append(Financeitemdata(title: "水電", date: " ", amount: 800))
        FinanceItemList.append(Financeitemdata(title: "利息 2%", date: " ", amount: 24500))
        
        FinanceItemList.append(Financeitemdata(title: "合計", date: "", amount: 50000))
        FinanceList.append(total_Financedata(type: "支出", financeitem: FinanceItemList))
        
        
        total_amountLabel.text = "-30000"
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FinanceList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        return FinanceList[section].financeitem.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCell", for: indexPath) as! FinanceCell
        
        
        cell.title.text = FinanceList[indexPath.section].financeitem[indexPath.row].title
        cell.date.text = FinanceList[indexPath.section].financeitem[indexPath.row].date
        cell.amount.text = String(FinanceList[indexPath.section].financeitem[indexPath.row].amount )
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "收入"
        }
        else {
            return "支出"
        }
    }
    
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let header = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableHeader") as! EquipmentTableHeader
     
     
     header.PlaceTitle.text = "\(PlaceList[section].name)(\(PlaceList[section].equip_item.count))"
     
     header.HeaderBtn.tag = section
     header.HeaderBtn.addTarget(self, action: #selector(TapHeader), for: UIControl.Event.touchUpInside)
     
     
     
     return header.contentView
     }
     
     */
    /*
     var isExpand:[Bool] = []
     
     @objc func TapHeader(sender:UIButton){
     print("\(sender.tag) tap")
     let section = sender.tag
     if (isExpand[section] == false){
     isExpand[section] = true
     }
     else{
     isExpand[section] = false
     }
     
     self.EquipTable!.reloadSections(IndexSet(integer: section), with: .automatic)
     
     }
     
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        
    }
    
    //func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //   return 59
    //}
    
}
