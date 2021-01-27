//
//  PropertyListViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/12.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

struct PropertyData{
    var name : String
    
    init(from name_D:String ){
        self.name = name_D
        
    }
    
}


struct property_data : Decodable{
    let Items : [property_Items_data]
    let Message :String
    
    
}

struct property_Items_data : Decodable{
    let information : Information
    let current_contract_id :String
    let tenant_id: String
    let contract_history: [String]
    let landlord_id: String
    let object_id: String
    let group_name: String
    
    struct Information : Decodable {
        
        let area: String
        let image: [String]
        let address: String
        let road: String
        let street: String
        let object_name: String
        let district: String
        let purchase_price: Int
        let parking_space: String
        let description: String
        let floor: Int
        let type: String
        
    }
    
}




class PropertyCell : UITableViewCell{
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var Tenant: UILabel!
    @IBOutlet weak var rentfee: UILabel!
    @IBOutlet weak var area: UILabel!
}

class PropertyListViewController :UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var PropertyTable: UITableView!
    
    @IBAction func CreateAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "CreatePropertyViewController" ) as! CreatePropertyViewController
        
        VC.delegate = self
        VC.sel_group_index = sel_group_index
        present(VC, animated: true, completion: nil)
        
    }
    
    //var EquipList = [Equip_itemdata]()
    
    var SegueType = ""
    var sel_group_index = 0
    
    var sel_object_id_list = [String]()
    var sel_PropertyList = [propertyDetailData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        PropertyTable.delegate = self
        PropertyTable.dataSource = self
        
     
        
        //PropertyList.append(PropertyData(from: "2樓215"))
        
        if ( SegueType == "preparedata"  ){
            get_sel_object_list_api()
        }
        else{
            sel_PropertyList = glo_BuildingList[sel_group_index].property_items
            download_image()
        }
        
        
        
        
        refresher = UIRefreshControl()
        refresher.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        refresher.addTarget(self, action: #selector(self.refreshtable), for: UIControl.Event.valueChanged)
        PropertyTable.addSubview(refresher)
    }
    var refresher: UIRefreshControl!
    @objc func refreshtable( ){
        //landlordgeteventinformation_api(sel_id: glo_account_id)
        if ( SegueType == "preparedata"  ){
            get_sel_object_list_api()
        }
        else{
            sel_PropertyList = glo_BuildingList[sel_group_index].property_items
            download_image()
        }
        PropertyTable.reloadData()
        refresher.endRefreshing()
    }
    
    func get_sel_object_list_api(){
        

        if ( sel_object_id_list.count == 0){
            return
        }
        for i in 0 ... sel_object_id_list.count - 1{
            
            
            self.group.enter()
            myDataQueue.async (group: group){
                self.getpropertybygrouptag_api(sel_object_id: self.sel_object_id_list[i])
                
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.PropertyTable.reloadData()
                self.download_image()
                
                
            }
            
            
        }
        
        
        
    }
    
    func getpropertybygrouptag_api( sel_object_id : String){
        
    

        let json: [String: Any] = ["object_id" : sel_object_id]
                
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
                            
                            //glo_root_id = glo_account_id
                            
                            let d_Item = data_JSON["Items"] as! Dictionary<String,Any>
                            
                            
                            //for d_Item in d_Items{
                                do{
                                let d_current_contract_id = d_Item["current_contract_id"] as! String
                                let d_event_history = d_Item["event_history"] as! [String]
                                let d_landlord_id = d_Item["landlord_id"] as! String
                                let d_tenant_id = d_Item["tenant_id"] as! String
                                //let d_system_id = d_Item["system_id"] as! String
                                let d_system_id = ""
                                let d_group_name = d_Item["group_name"] as! String
                                let d_object_id = d_Item["object_id"] as! String
                                    
                                
                                    
                                let d_information = d_Item["information"] as! Dictionary<String,Any>
                                    var d_purchase_price = d_information["purchase_price"] as! Any
                                    if (d_purchase_price is Int){
                                        
                                    }
                                    else{
                                        d_purchase_price = 0
                                    }
                                let d_road = d_information["road"] as! String
                                let d_object_name = d_information["object_name"] as! String
                                let d_rules = d_information["rules"] as! String
                                var d_floor = d_information["floor"] as! String
                            
                                    var d_area = d_information["area"] as! Any
                                    if (d_area is NSString){
                                        d_area = (d_information["area"] as! NSString).doubleValue
                                    }
                                    else if (d_area is Int){
                                        d_area = d_area as! Double
                                        //d_area = Double(d_area)

                                    }
                                    else{
                                        d_area = 0
                                    }
                                let d_image = d_information["image"] as! [String]
                                let d_full_address = d_information["full_address"] as! String
                                var d_rent = d_information["rent"] as! Any
                                    if (d_rent is Int){
                                        
                                    }
                                    else{
                                        d_rent = 0
                                    }
                                let d_parking_space = d_information["parking_space"] as! String
                                let d_region = d_information["region"] as! String
                                let d_description = d_information["description"] as! String
                                let d_street = d_information["street"] as! String
                                let d_type = d_information["type"] as! String
                                
                                
                                    self.sel_PropertyList.append(propertyDetailData(ImgList: [], current_contract_id: d_current_contract_id, event_history: d_event_history, purchase_price: d_purchase_price as! Int, road: d_road, object_name: d_object_name, rules: d_rules, landlord_id: d_landlord_id, floor: d_floor , area: d_area as! Double, image_url: d_image, tenant_id: d_tenant_id, full_address: d_full_address, rent: d_rent as! Int, parking_space: d_parking_space, object_id: d_object_id, region: d_region, description: d_description, system_id: d_system_id, group_name: d_group_name, street: d_street, type: d_type))
                                
                                }catch {
                                    
                                    print("error_propertyDetailList")
                                }
                                 
                                
                            //}
                            
                           
                 
                            
                        }
                        DispatchQueue.main.sync {
                            self.group.leave()
                            //self.PropertyTable.reloadData()
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
        

        if ( sel_PropertyList.count == 0){
            return
        }
        for i in 0 ... sel_PropertyList.count - 1{
            
            
            self.group.enter()
            myDataQueue.async (group: group){
                if (self.sel_PropertyList[i].image_url.count > 0){
                    
                
                    var loading_img = url_to_image(url: (URL(string:self.sel_PropertyList[i].image_url[0])!))
                DispatchQueue.main.sync{
                    self.sel_PropertyList[i].ImgList = [loading_img]
                }
                }
                self.group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.PropertyTable.reloadData()
                
                
                
            }
            
            
        }
        
        
        
    }
    
    /*
     func getpropertybygrouptag_api(){
     
     
     
     let json: [String: Any] = ["landlord_id": glo_account_id,"group_name":self.title!]
     
     let jsonData = try? JSONSerialization.data(withJSONObject: json)
     
     // create post request
     let url = URL(string: api_host + api_basePath + "/propertymanagement/getpropertybygrouptag")!
     var request = URLRequest(url: url)
     request.httpMethod = "POST"
     
     // insert json data to the request
     request.httpBody = jsonData
     
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
     
     
     
     
     if let downloadedData = data{
     do{
     let decoder = JSONDecoder()
     let eventdata = try decoder.decode(property_data.self, from: downloadedData)
     print(eventdata.Message)
     
     //User_Login += eventdata
     
     if (eventdata.Message == "No Error"){
     DispatchQueue.main.sync {
     self.PropertyList = eventdata.Items
     //var i = 0
     //while ( i < eventdata.Items.count ){
     //self.PropertyList = eventdata.Items
     //    i += 1
     //}
     
     self.PropertyTable.reloadData()
     }
     
     }
     
     
     print("OK")
     
     
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
     
     
     */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        
        return sel_PropertyList.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
        
        print()
        if (sel_PropertyList[indexPath.row].tenant_id == "" || sel_PropertyList[indexPath.row].tenant_id == "nil"){
            cell.Tenant.text = "沒有房客"
        }
        else{
            cell.Tenant.text = sel_PropertyList[indexPath.row].tenant_id
        }

        cell.name.text = sel_PropertyList[indexPath.row].object_name
        cell.address.text = sel_PropertyList[indexPath.row].full_address
       
        cell.rentfee.text = "$" + String(sel_PropertyList[indexPath.row].purchase_price)
        cell.area.text = String(sel_PropertyList[indexPath.row].area) + "坪"
        
        if (sel_PropertyList[indexPath.row].ImgList.count > 0){
            cell.photo.image = sel_PropertyList[indexPath.row].ImgList[0]
        }
        else{
            cell.photo.image = #imageLiteral(resourceName: "emptyImg")
        }
    
        cell.photo.cornerRadius = 5
        
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return PlaceList[section].name
     }
     */
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        performSegue(withIdentifier: "propertydetailsegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "propertydetailsegue" ){
        
             if let indexPath = PropertyTable.indexPathForSelectedRow {
             let vc = segue.destination as! PropertyDetailViewController
                vc.title = sel_PropertyList[indexPath.row].object_name
                vc.sel_property = sel_PropertyList[indexPath.row]
    
             
             }
             
        }
    }
    
    
    
}


extension PropertyListViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        PropertyTable.reloadData()
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
    }
}




