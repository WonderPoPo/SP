//
//  StaffViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/14.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

protocol SelCellIndexDelegate{
    func SelCellIndex(_ sender: Any)
}

struct staffsectiondata{
    
    let name : String
    var staff_item:[staffitemdata]

    init(from name_D:String ,_ staff_item_D:[staffitemdata] ){
        self.name = name_D
        self.staff_item = staff_item_D

    }
        
}



struct staffitemdata{
    var icon_img : UIImage?
    var name : String
    let id : String
    var icon_url: String
    var staffprofilelist : [staffProfileData]
    
    struct staffProfileData {
        let title : String
        var content:String

        init(from title_D:String ,_ content_D:String ){
            self.title = title_D
            self.content = content_D

        }
                
    }

    init(from id_D:String ,_ icon_url_D:String ){
        self.name = ""
        self.id = id_D
  
        
        self.icon_url = icon_url_D

        self.staffprofilelist = []
    }
        
}

class StaffTableHeader : UITableViewCell{
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Header_Btn: UIButton!
}

class StaffTableCell : UITableViewCell{
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var more_Btn: UIButton!

    
    @IBAction func moreAction(_ sender: Any) {
        delegate?.SelCellIndex(self)
    }
    
    var delegate : SelCellIndexDelegate?
}
class StaffViewController :UIViewController,UITableViewDelegate , UITableViewDataSource, SelCellIndexDelegate{

    @IBOutlet weak var staffTable: UITableView!
    
    
    @IBAction func CreateAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
                  
        let VC = storyboard.instantiateViewController( withIdentifier: "CreateStaffViewController" ) as! CreateStaffViewController
                  
        VC.delegate = self
               
        present(VC, animated: true, completion: nil)
                  
        
    }
    
    var staffsectionList = [staffsectiondata]()
    var staffList = [staffitemdata]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        staffTable.delegate = self
        staffTable.dataSource = self
        
        for item in glo_staff_tenant_id_list {
            staffList.append(staffitemdata(from: item,"nil"))
        }
        staffsectionList.append(staffsectiondata(from: "租客", staffList))
        isExpand.append(false)
        staffList.removeAll()
        
        //staffList.append(staffitemdata(from: "小明","nil"))
        //staffList.append(staffitemdata(from: "小光","nil"))
        //staffList.append(staffitemdata(from: "小心","nil"))
        for item in glo_staff_agent_id_list {
            staffList.append(staffitemdata(from: item,"nil"))
        }
        
        staffsectionList.append(staffsectiondata(from: "管理", staffList))
        isExpand.append(false)
        
        staffList.removeAll()
        
        //staffList.append(staffitemdata(from: "小英","nil"))
        //staffList.append(staffitemdata(from: "小美","nil"))
        for item in glo_staff_accountant_id_list {
            staffList.append(staffitemdata(from: item,"nil"))
        }
  
        
        staffsectionList.append(staffsectiondata(from: "會計", staffList))
        isExpand.append(false)
        
        staffList.removeAll()
        
        //staffList.append(staffitemdata(from: "小偉","nil"))
        for item in glo_staff_technician_id_list {
            staffList.append(staffitemdata(from: item,"nil"))
        }
       
        
        staffsectionList.append(staffsectiondata(from: "維修", staffList))
        isExpand.append(false)
        staffList.removeAll()
        
        get_staff_userinfo()
    }
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
    let group : DispatchGroup = DispatchGroup()
    
    
    func get_staff_userinfo(){
        
        
        if ( staffsectionList.count == 0){
            return
        }
        for i in 0 ... staffsectionList.count - 1{
            //staffsectionList[i].staff_item[indexPath.row].id
            
            
            if ( self.staffsectionList[i].staff_item.count == 0){
                return
            }
            for j in 0 ... self.staffsectionList[i].staff_item.count - 1{
                self.group.enter()
                myDataQueue.async (group: group){
                    //var loading_img = url_to_image(url: (URL(string:glo_BuildingList[i].image_url)!))
                    //DispatchQueue.main.async{
                        self.get_sel_user_info_api(sel_id: self.staffsectionList[i].staff_item[j].id,staff_group_index: i ,staff_index: j )
                    //}
                    self.group.leave()
                    
                    
                }
                
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.staffTable.reloadData()
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    func get_sel_user_info_api(sel_id:String ,staff_group_index : Int, staff_index:Int){
     
        
        let json: [String: Any] = ["id": sel_id]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/accountmanagement/getuserinformation")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            
            if let downloadedData = data{
                do{
                    let data_JSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                    
                    if let data_JSON = data_JSON {
                        
                        print(data_JSON )
                        if (data_JSON == nil){
                            print("YA")
                            return
                        }
                        
                        
                        let d_message:String = data_JSON["Message"] as Any as! String
                        if (d_message == "No Error"){
                            
                            let d_Items = data_JSON["Items"] as! Dictionary<String,Any>
                            
             
                            let d_auth = d_Items["auth"] as! String
                            
                     
                            
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            let d_name = d_information["name"] as! String
                            let d_sex = d_information["sex"] as! String
                            let d_mail = d_information["mail"] as! String
                            let d_phone = d_information["phone"] as! String
                            let d_annual_income = d_information["annual_income"] as! String
                            let d_industry = d_information["industry"] as! String
                            let d_profession = d_information["profession"] as! String
                  
                            let d_icon = d_information["icon"] as! String
                            
                            self.staffsectionList[staff_group_index].staff_item[staff_index].name = d_name
                            self.staffsectionList[staff_group_index].staff_item[staff_index].icon_url = d_icon
                            self.staffsectionList[staff_group_index].staff_item[staff_index].icon_img = url_to_image(url: URL(string: d_icon)!)
                            self.staffsectionList[staff_group_index].staff_item[staff_index].staffprofilelist.append(staffitemdata.staffProfileData(from: "姓名", d_name))
                            self.staffsectionList[staff_group_index].staff_item[staff_index].staffprofilelist.append(staffitemdata.staffProfileData(from: "性別", d_sex))
                            self.staffsectionList[staff_group_index].staff_item[staff_index].staffprofilelist.append(staffitemdata.staffProfileData(from: "電郵信箱", d_mail))
                            self.staffsectionList[staff_group_index].staff_item[staff_index].staffprofilelist.append(staffitemdata.staffProfileData(from: "電話號碼", d_phone))
                 

                          

                            
                            DispatchQueue.main.sync {
                                self.staffTable.reloadData()
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    print("OK get_user_info_api")
                    
                    
                }
                catch{
                    
                    print(error)
                    print("something wrong after downloaded")
                }
            }
            else {
                print("no data")
                
            }
            
            
            
        }
        
        task.resume()
        
    }
    
    
    /*
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        let delete_button = UITableViewRowAction(style: .normal, title: "解僱"){ (rowAction , indexPath) in
            
           
            self.staffList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print("delete comment")
            
            
        }
        delete_button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        let edit_auth_button = UITableViewRowAction(style: .normal, title: "編輯權限"){ (rowAction , indexPath) in
            
           
            self.staffList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print("delete comment")
            
            
        }
        edit_auth_button.backgroundColor = color1
        
        return [delete_button,edit_auth_button]
        
    }
    
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return staffsectionList.count
    }
    
    func total_cell_count () -> Int{
        var total_count = 0
        var n = 0
        while ( n < staffsectionList.count){
            total_count += staffsectionList[n].staff_item.count
            
            n += 1
        }
        
        print(total_count)
        return total_count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        if (isExpand[section] == false){
           return 0
        }
        else{
           return staffsectionList[section].staff_item.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffTableCell", for: indexPath) as! StaffTableCell
               
        cell.Icon.image = staffsectionList[indexPath.section].staff_item[indexPath.row].icon_img
        cell.Name.text = staffsectionList[indexPath.section].staff_item[indexPath.row].name
        //cell.Equipment_amount.text = "X " + staffsectionList[indexPath.section].equip_item[indexPath.row].amount
    
        sel_Index = indexPath

        cell.delegate = self
        cell.more_Btn.addTarget(self, action: #selector(staffMoreFunc), for: UIControl.Event.touchUpInside)
               
        return cell
    }

    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PlaceList[section].name
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "StaffTableHeader") as! StaffTableHeader
                   
            
        header.Title.text = "\(staffsectionList[section].name)(\(staffsectionList[section].staff_item.count))"
        
        header.Header_Btn.tag = section
        header.Header_Btn.addTarget(self, action: #selector(TapHeader), for: UIControl.Event.touchUpInside)
        

                   
        return header.contentView
    }
    
    var isExpand:[Bool] = []
    
    var sel_Index : IndexPath?
    
    @objc func staffMoreFunc(sender:UIButton){
        
   
            let alertController = UIAlertController(
                title: staffsectionList[sel_Index!.section].staff_item[sel_Index!.row].id,
                         message: "",
                         preferredStyle: .actionSheet)

         
                     let cancelAction = UIAlertAction(
                         title: "取消",
                         style: .cancel,
                         handler: nil)

                     alertController.addAction(cancelAction)


             let okAction1 = UIAlertAction(title: "編輯權限",style: .default ){ (_) in
                
             }
        
             alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "刪除",style: .destructive){ (_) in
            self.staffsectionList[self.sel_Index!.section].staff_item.remove(at: self.sel_Index!.row)
            self.staffTable!.reloadSections(IndexSet(integer: self.sel_Index!.section), with: .automatic)
            
             }
             alertController.addAction(okAction2)
        

                     // 顯示提示框
            self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func TapHeader(sender:UIButton){
        print("\(sender.tag) tap")
        let section = sender.tag
        if (isExpand[section] == false){
            isExpand[section] = true
        }
        else{
            isExpand[section] = false
        }
        
        self.staffTable!.reloadSections(IndexSet(integer: section), with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        performSegue(withIdentifier: "profilesegue", sender: self)
        
    
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    
    func SelCellIndex(_ sender: Any){
        guard let tappedIndex = staffTable.indexPath(for: sender as! StaffTableCell) else {return}
        sel_Index = tappedIndex

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profilesegue"){
            if let indexPath = staffTable.indexPathForSelectedRow{
                let vc = segue.destination as! UserProfileViewController

                vc.sel_staff_id = staffsectionList[indexPath.section].staff_item[indexPath.row].name
            }
            
            
            
        }
    }
    
}


extension StaffViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        let property_data = sendData as! staff_info_data
        

        if (property_data.staff_type == "tenant"){
            glo_staff_tenant_id_list.append(property_data.id)
        }
        else if (property_data.staff_type == "technician"){
            glo_staff_technician_id_list.append(property_data.id)
        }
        else if (property_data.staff_type == "accountant"){
            glo_staff_accountant_id_list.append(property_data.id)
        }
        else if (property_data.staff_type == "agent"){
            glo_staff_agent_id_list.append(property_data.id)
        }

        staffsectionList.removeAll()
        
        for item in glo_staff_tenant_id_list {
                  staffList.append(staffitemdata(from: item,"nil"))
              }
              staffsectionList.append(staffsectiondata(from: "租客", staffList))
              isExpand.append(false)
              staffList.removeAll()
              
              //staffList.append(staffitemdata(from: "小明","nil"))
              //staffList.append(staffitemdata(from: "小光","nil"))
              //staffList.append(staffitemdata(from: "小心","nil"))
              for item in glo_staff_agent_id_list {
                  staffList.append(staffitemdata(from: item,"nil"))
              }
              
              staffsectionList.append(staffsectiondata(from: "管理", staffList))
              isExpand.append(false)
              
              staffList.removeAll()
              
              //staffList.append(staffitemdata(from: "小英","nil"))
              //staffList.append(staffitemdata(from: "小美","nil"))
              for item in glo_staff_accountant_id_list {
                  staffList.append(staffitemdata(from: item,"nil"))
              }
        
              
              staffsectionList.append(staffsectiondata(from: "會計", staffList))
              isExpand.append(false)
              
              staffList.removeAll()
              
              //staffList.append(staffitemdata(from: "小偉","nil"))
              for item in glo_staff_technician_id_list {
                  staffList.append(staffitemdata(from: item,"nil"))
              }
             
              
              staffsectionList.append(staffsectiondata(from: "維修", staffList))
              isExpand.append(false)
              staffList.removeAll()
        
        staffTable.reloadData()
        ///sel_property_id = property_data.object_id
        //sel_propertyBtn.setTitle(property_data.full_address, for: .normal)
       // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!

    }
    

}


struct staff_info_data {

    var staff_type :String
    var icon_url:String
    var id:String
    var name:String
    
}
