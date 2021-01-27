//
//  EquipmentViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

struct placedata{
    let name : String
    var equip_item:[Equip_itemdata]
    
    init(from name_D:String ,_ equip_item_D:[Equip_itemdata] ){
        self.name = name_D
        self.equip_item = equip_item_D
        
    }
    
}



struct Equip_itemdata{
    let name : String
    let amount: Int
    let img_url:String
    var img :UIImage?
    
    init(from name_D:String ,_ amount_D:Int ,_ img_url_D:String ){
        self.name = name_D
        self.amount = amount_D
        self.img_url = img_url_D
        
    }
    
}

class EquipmentTableHeader : UITableViewCell{
    
    
    @IBOutlet weak var PlaceTitle: UILabel!
    
    @IBOutlet weak var HeaderBtn: UIButton!
    
    
    @IBAction func Tap_Action(_ sender: Any) {
        
        print("tap_header")
    }
    
    
    
    
}

class EquipmentTableCell : UITableViewCell{
    
    
    @IBOutlet weak var Equipment_title: UILabel!
    
    @IBOutlet weak var Equipment_amount: UILabel!
    
    @IBOutlet weak var Equipment_Img: UIImageView!
    
}

class EquipmentViewController :UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var EquipTable: UITableView!
    
    @IBAction func createAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "CreateEquipmentViewController" ) as! CreateEquipmentViewController
        VC.sel_object_id = sel_object_id
        VC.delegate = self
        present(VC, animated: true, completion: nil)
    }
    
    var PlaceList = [placedata]()
    var EquipList = [Equip_itemdata]()
    
    //var equipmentList = [equipmentData.equipmentData]()
    
    var sel_object_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        EquipTable.delegate = self
        EquipTable.dataSource = self
        /*
         
         EquipList.append(Equip_itemdata(from: "桌子",1,"nil"))
         EquipList.append(Equip_itemdata(from: "椅子",1,"nil"))
         EquipList.append(Equip_itemdata(from: "衣櫃",1,"nil"))
         EquipList.append(Equip_itemdata(from: "雙人床",1,"nil"))
         EquipList.append(Equip_itemdata(from: "全身鏡",1,"nil"))
         
         PlaceList.append(placedata(from: "房間", EquipList))
         isExpand.append(false)
         
         EquipList.removeAll()
         
         EquipList.append(Equip_itemdata(from: "桌子",2,"nil"))
         EquipList.append(Equip_itemdata(from: "椅子",4,"nil"))
         EquipList.append(Equip_itemdata(from: "冰箱",1,"nil"))
         EquipList.append(Equip_itemdata(from: "沙發",1,"nil"))
         EquipList.append(Equip_itemdata(from: "鞋櫃",1,"nil"))
         EquipList.append(Equip_itemdata(from: "電視",1,"nil"))
         EquipList.append(Equip_itemdata(from: "洗衣機",1,"nil"))
         
         PlaceList.append(placedata(from: "客廳", EquipList))
         isExpand.append(false)
         
         EquipList.removeAll()
         
         EquipList.append(Equip_itemdata(from: "晾衣桿",1,"nil"))
         EquipList.append(Equip_itemdata(from: "椅子",1,"nil"))
         EquipList.append(Equip_itemdata(from: "玻璃小桌",1,"nil"))
         
         
         PlaceList.append(placedata(from: "陽台", EquipList))
         isExpand.append(false)
         EquipList.removeAll()
         
         */
        
        if ( glo_account_auth == "tenant"){
            sel_object_id = glo_tenant_object_id
        }
        get_equipment_api()
    }
    
    func get_equipment_api(){
        self.PlaceList.removeAll()
        
        let json: [String: Any] = ["object_id": sel_object_id]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: api_host + api_basePath + "/propertymanagement/getpropertybyobjectid")!
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
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            let d_equipments = d_information["equipment"] as! [Dictionary<String,Any>]
                            
                            for d_equipment in d_equipments{
                                
                                let d_equipment_title = d_equipment["title"] as! String
                                let d_equipment_informations = d_equipment["information"] as! [Dictionary<String,Any>]
                                
                                for d_eq_information in d_equipment_informations{
                                    let d_count = d_eq_information["count"] as! Int
                                    let d_name = d_eq_information["name"] as! String
                                    let d_image = d_eq_information["image"] as! [String]
                                    
                                    if (d_image.count > 0){
                                        self.EquipList.append(Equip_itemdata(from: d_name,d_count,d_image[0]))
                                    }
                                    else{
                                        self.EquipList.append(Equip_itemdata(from: d_name,d_count,"nil"))
                                    }
                                }
                                
                                self.PlaceList.append(placedata(from: d_equipment_title, self.EquipList))
                                self.isExpand.append(false)
                                self.EquipList.removeAll()
                                self.download_image()
                            }
                            
                            DispatchQueue.main.sync {
                                
                                self.EquipTable.reloadData()
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
    
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
    let group : DispatchGroup = DispatchGroup()
    
    
    
    func download_image(){
        
        
        if ( PlaceList.count == 0 ){
            return
        }
        
        for i in 0 ... PlaceList.count - 1{
            
            if ( PlaceList[i].equip_item.count == 0 ){
                return
            }
            
            for j in 0 ... PlaceList[i].equip_item.count - 1{
                
                self.group.enter()
                myDataQueue.async (group: group){
                    //print(self.PlaceList[i].equip_item[j].img_url)
                    var newURL = self.PlaceList[i].equip_item[j].img_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    var loading_img = url_to_image(url: URL(string: newURL)!)
                    DispatchQueue.main.sync{
                        self.PlaceList[i].equip_item[j].img = loading_img
                    }
                    self.group.leave()
                }
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                self.EquipTable.reloadData()
                
            }
            
            
        }
        
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PlaceList.count
    }
    
    func total_cell_count () -> Int{
        var total_count = 0
        var n = 0
        while ( n < PlaceList.count){
            total_count += PlaceList[n].equip_item.count
            
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
            return PlaceList[section].equip_item.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableCell", for: indexPath) as! EquipmentTableCell
        
        
        cell.Equipment_title.text = PlaceList[indexPath.section].equip_item[indexPath.row].name
        cell.Equipment_amount.text = "X " + String(PlaceList[indexPath.section].equip_item[indexPath.row].amount)
        
        if (PlaceList[indexPath.section].equip_item[indexPath.row].img == nil){
            cell.Equipment_Img.image = #imageLiteral(resourceName: "emptyImg")
        }
        else{
            cell.Equipment_Img.image = PlaceList[indexPath.section].equip_item[indexPath.row].img
        }
       
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return PlaceList[section].name
     }
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableHeader") as! EquipmentTableHeader
        
        
        header.PlaceTitle.text = "\(PlaceList[section].name)(\(PlaceList[section].equip_item.count))"
        
        header.HeaderBtn.tag = section
        header.HeaderBtn.addTarget(self, action: #selector(TapHeader), for: UIControl.Event.touchUpInside)
        
        
        
        return header.contentView
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    
}


extension EquipmentViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        let property_data = sendData as! equipmentData
        get_equipment_api()
        
        //
        //var PlaceList = [placedata]()
        //var EquipList = [Equip_itemdata]()
        
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
        
    }
    
    
}
