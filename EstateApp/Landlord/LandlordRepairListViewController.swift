//
//  LandlordRepairListViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/14.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


struct eventlistData : Decodable{
    let Message: String
    let Items: [Items]               // 如果有Event 記錄 就會以下的東西 可以是空 也可以有一堆
    
    struct Items : Decodable{
        let timestmp : Int
        let information : Information
        
        struct Information : Decodable{
            let date : String
            let dynamic_status : [Dynamic_status]
            let description : String
            
            struct Dynamic_status : Decodable{
                let date : String
                let description : String
                let image : [String]
            }
            
        }
        var status : String
        let event_id : String
        let object_id : String
        let initiate_id : String
        let participant : [Participant]
        let type : String
        
        struct Participant : Decodable{
            let auth : String
            let id : String
            
        }
        
    }
}

struct RepairInfoData {
    var name : String
    var Img : UIImage?
    
}

var RepairList = [eventlistData.Items]()

var RepairInfoList = [RepairInfoData]()

struct LandlordRepairData{
    var address : String
    var status : String
    var lastupdatetime : String
    
    
    init(from address_D:String ,_ status_D:String, _ lastupdatetime_D:String){
        self.address = address_D
        self.status = status_D
        self.lastupdatetime = lastupdatetime_D
        
    }
    
}


class LandlordRepairListCell : UITableViewCell{
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var intro: UILabel!
    @IBOutlet weak var lastupdatetime: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
}


class LandlordRepairListViewController : UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var RepairTable: UITableView!
    
    
    @IBAction func CreateAction(_ sender: Any) {
        //performSegue(withIdentifier: "MaintainViewController", sender: <#T##Any?#>)
        
        
        let storyboard = UIStoryboard( name: "Main", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "MaintainViewController" ) as! MaintainViewController
        
        //VC.delegate = self
        //VC.modalPresentationStyle = .overFullScreen
        
        //present(VC, animated: true, completion: nil)
        
        
    }
    
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        
        RepairTable.delegate = self
        RepairTable.dataSource = self
        
        
        //RepairList.append(LandlordRepairData(from: "桃園中壢大仁五街6樓6號","水管爆裂","2020/11/12 08:20"))
        //RepairList.append(LandlordRepairData(from: "桃園中壢實踐路1樓7號","已完成","2020/11/11 18:34"))
        //RepairList.append(LandlordRepairData(from: "桃園中壢幸福2樓1號","已完成","2020/11/10 20:26"))
        //RepairList.append(LandlordRepairData(from: "桃園中壢大埔3樓1號","已完成","2020/11/10 12:11"))
        if (glo_account_auth == "landlord"){  // 房東
            landlordgeteventinformation_api(sel_id: glo_account_id)
        }
        else{
            
        }
        
        
        
        refresher = UIRefreshControl()
        refresher.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        refresher.addTarget(self, action: #selector(self.refreshtable), for: UIControl.Event.valueChanged)
        RepairTable.addSubview(refresher)
    }
    
    @objc func refreshtable( ){
        landlordgeteventinformation_api(sel_id: glo_account_id)
        refresher.endRefreshing()
    }
    
    func landlordgeteventinformation_api(sel_id:String){
        
        
        let json: [String: Any] = ["landlord_id": sel_id]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/eventmanagement/landlordgeteventinformation")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            
            if let downloadedData = data{
                do{
                    let decoder = JSONDecoder()
                    let eventdata = try decoder.decode(eventlistData.self, from: downloadedData)
                    
                    
                    print(eventdata)
                    
                    DispatchQueue.main.sync {
                        if (eventdata.Message == "No Error"){
                            RepairList = eventdata.Items
                            var i = 0
                            while ( i < RepairList.count) {
                                if (RepairList[i].status == "Received"){
                                    RepairList[i].status = "已接案"
                                }
                                else if (RepairList[i].status == "Assigned"){
                                    RepairList[i].status = "已指派"
                                }
                                else if (RepairList[i].status == "Processing"){
                                    RepairList[i].status = "處理中"
                                }
                                else if (RepairList[i].status == "Closed"){
                                    RepairList[i].status = "已結案"
                                }
                                else {
                                    RepairList[i].status = ""
                                }
                                
                                
                                RepairInfoList.append(RepairInfoData(name: ""))
                                self.search_objectid_api(sel_index: i)
                                i += 1
                            }
                           
                            self.RepairTable.reloadData()
                        }
                        
                        
                    }
                    
                    print("OK get_user_info_api")
                    
                    //if (self.Total_Event_List[self.maintype].this_EventData.count == 0){
                    //self.dismiss_loading_VC()
                    // return
                    //}
                    
                    
                    //self.myDataQueue.async {
                    self.download_image()
                    
                    //}
                    
                    
                    
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
        
        //let t_img :UIImage? = #imageLiteral(resourceName: "ironman")
        
        //var loading_img_count = glo_BuildingList.count
        
        
        /*print(loading_img_count)
        print(self.Total_Event_List[sel_maintype].this_EventData.count)
        for i in loading_img_count ... self.Total_Event_List[sel_maintype].this_EventData.count - 1{
            
            self.Total_Event_List[sel_maintype].this_EventImage.append(t_img!)
            
            
        }
        
        
        */
        if ( RepairList.count == 0){
            return
        }
        for i in 0 ... RepairList.count - 1{
            
            
            self.group.enter()
            myDataQueue.async (group: group){
                
                if (RepairList[i].information.dynamic_status.count > 0 && RepairList[i].information.dynamic_status[0].image.count > 0){
                    var loading_img = url_to_image(url: (URL(string:RepairList[i].information.dynamic_status[0].image[0])!))
                    DispatchQueue.main.sync{
                        RepairInfoList[i].Img = loading_img
                    }
                }
                else{
                    RepairInfoList[i].Img = #imageLiteral(resourceName: "emptyImg")
                }

                self.group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.RepairTable.reloadData()
                
                
                
            }
            
            
        }
        
        
        
    }
    
    func search_objectid_api(sel_index:Int){
        
        
        let json: [String: Any] = ["object_id": RepairList[sel_index].object_id]
        
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
                            
                            print(d_information["name"])
                            
                            //self.RepairDetailList[3].repairitem[0].content = d_information["name"] as! String
                            RepairInfoList[sel_index].name = d_information["full_address"] as! String
                            
                            DispatchQueue.main.async {
                                self.RepairTable.reloadData()
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        
        return RepairList.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordRepairListCell", for: indexPath) as! LandlordRepairListCell
        
        
        cell.address.text = RepairInfoList[indexPath.row].name
        cell.intro.text = RepairList[indexPath.row].information.description
        cell.status.text = RepairList[indexPath.row].status
        if ( RepairList[indexPath.row].information.dynamic_status.count > 0){
            cell.lastupdatetime.text = RepairList[indexPath.row].information.dynamic_status[0].date
        }
        else{
            cell.lastupdatetime.text = "nil"
        }
        cell.photo.image = RepairInfoList[indexPath.row].Img
        
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return PlaceList[section].name
     }
     */
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        performSegue(withIdentifier: "repairdetailsegue", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "repairdetailsegue" ){
            if let indexPath = RepairTable.indexPathForSelectedRow {
                let vc = segue.destination as! RepairDetailViewController
                vc.sel_object_id = RepairList[indexPath.row].event_id
                
                
                EventListDetail = RepairList[indexPath.row]
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
    
}
