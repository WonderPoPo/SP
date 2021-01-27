//
//  LandlordMainPageViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/23.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import Charts



struct propertyDetailData {
    var ImgList : [UIImage?]
    var current_contract_id: String
    let event_history: [String]
    let purchase_price: Int
    let road: String
    let object_name: String
    let rules: String
    let landlord_id: String
    let floor: String
    //let attraction: [],
    let area: Double
    //let contract_history: [],
    let image_url: [String]
    var tenant_id: String
    let full_address: String
    let rent: Int
    let parking_space: String
    let object_id: String
    let region: String
    let description: String

    let system_id: String
    let group_name: String
    let street: String
    let type: String


}

var propertyDetailList = [propertyDetailData]()


class LandlordMainPageHeader : UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    
}

class LandlordMainPageCell :UITableViewCell  , ChartViewDelegate{
    
    @IBOutlet weak var HelloTitle: UILabel!

    @IBOutlet weak var newsBtn: UIButton!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var news: UILabel!
    
    @IBOutlet weak var weather_icon: UIImageView!
    @IBOutlet weak var weather_value: UILabel!
    
    @IBOutlet weak var Chart: LineChartView!
    
    
    @IBOutlet weak var Rent_button: UIButton!
    @IBOutlet weak var NotRent_button: UIButton!
    
    @IBAction func RentListAction(_ sender: Any) {
        
        
    }
    
    @IBAction func NotRentListAction(_ sender: Any) {
        
        
    }
    
    let list = ["11/26","12/26","1/26","2/26"]
    let amount = [81.0 , 5.0 ]
    
    var income = ["上個月","這個月"]
    var income_value  = [10000.0,13000.0,15000.0,20000.0]
    var pay_value  = [0.0,200.0,2000.0,500.0]
    override func awakeFromNib() {
        super.awakeFromNib()
        Chart.delegate = self
        
        
        
        
        button_style3(sel_button: Rent_button)
        button_style3(sel_button: NotRent_button)
        
        newsBtn.cornerRadius = 5
        //newsBtn.clipsToBounds = true
        newsBtn.layer.masksToBounds = false
        newsBtn.layer.shadowColor = UIColor.lightGray.cgColor
        newsBtn.layer.shadowOpacity = 0.8
        newsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        newsBtn.layer.shadowRadius = 4
        newsBtn.layer.borderWidth = 1
        newsBtn.layer.borderColor = UIColor.lightGray.cgColor

        //button_style3(sel_button: newsBtn)
        
        setLineChart(sel_list: list, sel_amount: amount)
        
        //set_property_rent_api(sel_id: glo_account_id)
    }
    
    
    
    func setLineChart(sel_list :[String], sel_amount:[Double]){
        var dataSet = LineChartData()
        var dataEntry = [ChartDataEntry]()
        for i in 0..<4{
            dataEntry.append(ChartDataEntry(x: Double(i), y: Double(income_value[i]), data: income))
           
        }
        
       
        let line1 = LineChartDataSet(entries:dataEntry , label: "收入")
        line1.colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]

        line1.lineWidth = 3
        dataSet.addDataSet(line1 )
        
        var dataEntry2 = [ChartDataEntry]()
        for i in 0..<4{
            dataEntry2.append(ChartDataEntry(x: Double(i), y: Double(pay_value[i]), data: income))
           
        }
        let line2 = LineChartDataSet(entries:dataEntry2 , label: "支出")
        line2.colors = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        line2.lineWidth = 3
    
        dataSet.addDataSet(line2)
        Chart.data = dataSet
        
       
        
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
        Chart.xAxis.labelPosition = .bottom
        Chart.xAxis.drawGridLinesEnabled = false
        
        Chart.animate(xAxisDuration: 1,yAxisDuration: 1)
        
        
        
    }
    

    
}

class LandlordMainPageRentDelayCell :UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var tenant_name: UILabel!
    @IBOutlet weak var delay_time: UILabel!
    
    @IBOutlet weak var rent_fee: UILabel!
}

class LandlordMainPageContractExpireCell :UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var expire_time: UILabel!
}



class LandlordMainPageViewController :UIViewController ,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var MainPageTable: UITableView!
    
    
    struct PageRentDelayData{
        var name : String
        var tenant_name : String
        var delay_time : String
        var rent_fee : String
        
        init(from name_D:String,_ tenant_name_D:String ,_ delay_time_D:String,_ rent_fee_D:String ){
            self.name = name_D
            self.tenant_name = tenant_name_D
            self.delay_time = delay_time_D
            self.rent_fee = rent_fee_D

        }
        
    }
    
    struct ContractExpireData{
        var name : String
        var address : String
        var expire_time : String
        
        init(from name_D:String,_ address_D:String ,_ expire_time_D:String ){
            self.name = name_D
            self.address = address_D
            self.expire_time = expire_time_D
           

        }
        
    }
    
    var PageRentDelayList = [PageRentDelayData]()
    var ContractExpireList = [ContractExpireData]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
             
        
        MainPageTable.delegate = self
        MainPageTable.dataSource = self
        
        
        
        
        PageRentDelayList.append(PageRentDelayData(from: "大樓A", "Jason", "3個月", "$30000"))
        PageRentDelayList.append(PageRentDelayData(from: "大樓B", "Aiden", "20個月", "$200000"))
        PageRentDelayList.append(PageRentDelayData(from: "大樓C", "Hugo", "4個月", "$40000"))
        
        ContractExpireList.append(ContractExpireData(from: "大樓C", "幸福大樓3樓15室", "2個月後到期"))
        ContractExpireList.append(ContractExpireData(from: "大樓D", "大仁大樓3樓17室", "2個月後到期"))
        
        getgrouptag_api()
        
        hello_api()
        set_property_rent_api(sel_id: glo_account_id)
        
    }
    
    var welcome_message = ""
    
    func hello_api(){
              
    
           let json: [String: Any] = [: ]
                      
                   let jsonData = try? JSONSerialization.data(withJSONObject: json)

                   // create post request
                   let url = URL(string: api_host + api_basePath + "/accountmanagement/welcomemessage")!
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
                                let d_welcome = d_Items["welcome_message"] as! String
                                self.welcome_message = d_welcome
                                   DispatchQueue.main.sync {
                                    self.MainPageTable.reloadData()
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

    
    func set_property_rent_api(sel_id:String){
              
    
           let json: [String: Any] = ["landlord_id": sel_id]
                      
                   let jsonData = try? JSONSerialization.data(withJSONObject: json)

                   // create post request
                   let url = URL(string: api_host + api_basePath + "/propertymanagement/getpropertyrentalstatus")!
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
                                   
                                   let d_renting = d_Items["renting"] as! Dictionary<String,Any>
                                   let d_counter = d_renting["counter"] as! Int
                                   let d_object_id = d_renting["object_id_list"] as! [String]
                              self.rent_object_id_list = d_object_id
                                
                                let d_not_on_rent = d_Items["not_on_rent"] as! Dictionary<String,Any>
                                let d_norent_counter = d_not_on_rent["counter"] as! Int
                                let d_norent_object_id = d_not_on_rent["object_id_list"] as! [String]
                                   
                                self.not_rent_object_id_list = d_norent_object_id
                                //self.RepairDetailList[3].repairitem[0].content = d_information["name"] as! String
                                
                                   DispatchQueue.main.sync {
                                    self.MainPageTable.reloadData()
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
    

    func getgrouptag_api(){
        
      let json: [String: Any] = ["id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/grouptagmanagement/getgrouptag")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(property_grouptag_data.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        //User_Login += eventdata
                         
                         if (eventdata.Message == "No Error"){
                      
                                var i = 0
                                if (eventdata.Items.group.count == 0){
                                    return
                                }
                                for i in 0 ... eventdata.Items.group.count - 1{
                                    glo_BuildingList.append(BuildingData(from: eventdata.Items.group[i].name ,eventdata.Items.group[i].image))
                                    
                                    self.group.enter()
                                    self.myDataQueue.async (group: self.group){
                                        
                                        self.getpropertybygrouptag_api(sel_index: i)
                                        self.group.leave()
                                    }
                                    
                                }
                                
                                self.group.notify(queue: DispatchQueue.main ){
                                    print("fin")
                            
                                    DispatchQueue.main.async {
                                           
                                    }
                           
                                }
               
                         }
                  
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
    
    
    
    func getpropertybygrouptag_api( sel_index : Int){

        let json: [String: Any] = ["landlord_id": glo_account_id,"group_name":glo_BuildingList[sel_index].name]
                
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
                    let data_JSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                    
                    if let data_JSON = data_JSON {
                        
                        print(data_JSON )
                        if (data_JSON == nil){
                            print("YA")
                            return
                        }
                        
                        
                        let d_message:String = data_JSON["Message"] as Any as! String
                        if (d_message == "No Error"){
                            
                            glo_root_id = glo_account_id
                            
                            let d_Items = data_JSON["Items"] as! [Dictionary<String,Any>]
                            
                            
                            for d_Item in d_Items{
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
                              
                                    print(d_information["area"] )
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
                                //let d_area = (d_information["area"] as! NSString).doubleValue
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
                                
                                print(d_area)
                                    propertyDetailList.append(propertyDetailData(ImgList: [], current_contract_id: d_current_contract_id, event_history: d_event_history, purchase_price: d_purchase_price as! Int, road: d_road, object_name: d_object_name, rules: d_rules, landlord_id: d_landlord_id, floor: d_floor as! String , area: (d_area) as! Double, image_url: d_image, tenant_id: d_tenant_id, full_address: d_full_address, rent: d_rent as! Int, parking_space: d_parking_space, object_id: d_object_id, region: d_region, description: d_description, system_id: d_system_id, group_name: d_group_name, street: d_street, type: d_type))
                                
                                }catch {
                                    
                                    print("error_propertyDetailList")
                                }
                                 
                                
                            }
                            
                            glo_BuildingList[sel_index].property_items = propertyDetailList
                 
                            propertyDetailList.removeAll()
                     
                            
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           self.navigationController?.setNavigationBarHidden(true, animated: animated)
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        if (section == 0){
           return 1
        }
        else if (section == 1){
            return PageRentDelayList.count
        }
        else if (section == 2){
            return ContractExpireList.count
        }
        
        return 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
             let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordMainPageCell", for: indexPath) as! LandlordMainPageCell
                        
            if (glo_account_sex == "男"){
                cell.HelloTitle.text = "Hello~" + glo_account_name + "君"
            }
            else if (glo_account_sex == "女"){
                cell.HelloTitle.text = "Hello~" + glo_account_name + "醬"
            }
            else{
                cell.HelloTitle.text = "Hello~" + glo_account_name
            }
                
                cell.message.text = welcome_message
                cell.news.text = "2020年12月5日房租到期\n冷氣機維修\n萬聖節快樂~~"
                //cell.weather_icon.image =
                //cell.weather_value.text
                
             
           
            cell.newsBtn.addTarget(self, action: #selector(NewsBtnAction), for: UIControl.Event.touchUpInside)
            cell.Rent_button.addTarget(self, action: #selector(RentBtnAction), for: UIControl.Event.touchUpInside)
          
            cell.NotRent_button.addTarget(self, action: #selector(NotRentBtnAction), for: UIControl.Event.touchUpInside)
            
            
            
            cell.Rent_button.setTitle(String(rent_object_id_list.count) + "已出租" , for: .normal)
            cell.NotRent_button.setTitle(String(not_rent_object_id_list.count) + "未出租" , for: .normal)
            

                        
                return cell
            
        }
        else if ( indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordMainPageRentDelayCell", for: indexPath) as! LandlordMainPageRentDelayCell
                       
                
            cell.name.text = PageRentDelayList[indexPath.row].name
            cell.tenant_name.text = PageRentDelayList[indexPath.row].tenant_name
            cell.delay_time.text = PageRentDelayList[indexPath.row].delay_time
            cell.rent_fee.text = PageRentDelayList[indexPath.row].rent_fee

            

                       
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordMainPageContractExpireCell", for: indexPath) as! LandlordMainPageContractExpireCell
                       
                
               cell.name.text = ContractExpireList[indexPath.row].name
               cell.address.text = ContractExpireList[indexPath.row].address
               cell.expire_time.text = ContractExpireList[indexPath.row].expire_time

            

                       
               return cell
        }
        
    }
    
    var rent_object_id_list = [String]()
    var not_rent_object_id_list = [String]()
    @objc func RentBtnAction(sender:UIButton){
        print("\(sender.tag) tap")
        
        sel_object_id_list = rent_object_id_list
        performSegue(withIdentifier: "selpropertysegue", sender: sender)
        
    }
    
    @objc func NotRentBtnAction(sender:UIButton){
        print("\(sender.tag) tap")
        
        sel_object_id_list = not_rent_object_id_list
        performSegue(withIdentifier: "selpropertysegue", sender: sender)
        
    }
    
    @objc func NewsBtnAction(sender:UIButton){
        print("\(sender.tag) tap")
        self.tabBarController?.selectedIndex = 1
        
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
           return nil
        }
        else if (section == 1){
            return "即將到期房租"
        }
        else if (section == 2){
            return "即將到期合約"
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "LandlordMainPageHeader") as! LandlordMainPageHeader
                   
            
        
        if (section == 0){
           header.title.text = ""
        }
        else if (section == 1){
            header.title.text = "即將到期房租"
        }
        else if (section == 2){
            header.title.text = "即將到期合約"
        }
  

                   
        return header.contentView
    }
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        if (indexPath.section != 0){
            performSegue(withIdentifier: "propertydetailsegue", sender: nil)
            
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     if (section == 0){
        return 0
     }
     else {
        return tableView.sectionHeaderHeight
     }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "selpropertysegue" ){
             
             
             let vc = segue.destination as! PropertyListViewController

            vc.title = ((sender as! UIButton).titleLabel?.text)!
             vc.SegueType = "preparedata"
             vc.sel_object_id_list = self.sel_object_id_list
    
             
         }
     }
    

     
     var sel_object_id_list = [String]()
     
  
    
}
