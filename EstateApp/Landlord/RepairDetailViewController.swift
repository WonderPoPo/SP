//
//  RepairDetailViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/17.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


var EventListDetail : eventlistData.Items?

var RepairDetailList = [RepairGroup]()
struct RepairGroup {
    let title : String
    var repairitem:[RepairDetailData]
    
    init(from title_D:String ,_ repairitem_D:[RepairDetailData] ){
        self.title = title_D
        self.repairitem = repairitem_D
        
    }
    
}

struct RepairDetailData {
    let title : String
    var content:String
    var img : [UIImage?]
    
    init(from title_D:String ,_ content_D:String ){
        self.title = title_D
        self.content = content_D
        
        self.img = []
    }
    
}

class LandlordEventCell : UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    
    
}



class LandlordSelRepairEventCell : UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var EventCollection: UICollectionView!
    
  
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
    let group : DispatchGroup = DispatchGroup()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        EventCollection.delegate = self
        EventCollection.dataSource = self
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 3){
        print("awakeFromNib")
            self.EventCollection.reloadData()
        //}
        
   
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("\(RepairDetailList[1].repairitem[EventCollection.tag].img.count) img counttttt")
        return RepairDetailList[1].repairitem[EventCollection.tag].img.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandlordEventCell", for: indexPath) as! LandlordEventCell
        
        print("\(EventCollection.tag) EventCollection.tag")
        print("\(indexPath.row) indexPath.row")
        print(RepairDetailList[1].repairitem[EventCollection.tag ].img.count)
        
        if (RepairDetailList[1].repairitem[EventCollection.tag ].img.count > 0 ){
            cell.img.image = RepairDetailList[1].repairitem[EventCollection.tag ].img[indexPath.row]
        }
        else {
            cell.img.image = #imageLiteral(resourceName: "logo")
        }
        
        
        
        cell.img.cornerRadius =  10
        cell.img.zoomImage()
        //cell.intro.text = "今天修好了水管漏水快修完了"
        //cell.date.text = "2020/10/11 20:20"
        
        return cell
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80  , height: 80 )
        
        
        
    }
    
}

class RepairDetailCell :UITableViewCell{
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var Content: UILabel!
    
    @IBOutlet weak var selrepairer_btn: UIButton!
}


class RepairDetailStatusCell :UITableViewCell{
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var StatusBtn: UIButton!
    
    @IBOutlet weak var CreateEventBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button_style2(sel_button: StatusBtn)
        StatusBtn.setTitle("選擇狀態", for: .normal)
        CreateEventBtn.setTitle("新增動態", for: .normal)
        
    }
    
}

class RepairDetailViewController : UIViewController,UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var segController: UISegmentedControl!

    @IBAction func segAction(_ sender: Any) {
        if (segController.selectedSegmentIndex == 0){
            forumView.isHidden = true
        }
        else{
            forumView.isHidden = false
        }
        
    }
    
    @IBOutlet weak var forumView: UIView!
    
    @IBOutlet weak var RepairTable: UITableView!
    
    @IBOutlet weak var navrightbtn: UIButton!
    
    
    @IBAction func selrepairerAction(_ sender: Any) {
        
        
        let storyboard = UIStoryboard( name: "LandlordMain", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "LandlordSelRepairerViewController" ) as! LandlordSelRepairerViewController
        
        VC.delegate = self
        
        present(VC, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var CreateEventBtn: UIButton!
    @IBAction func CreateEventAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "LandlordMain", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "RepairerReportViewController" ) as! RepairerReportViewController
        
        //VC.delegate = self
        
        present(VC, animated: true, completion: nil)
        
    }
    
    
    
    
    var RepairDetailItem = [RepairDetailData]()
    
    var sel_object_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forumView.isHidden = true
        
        CreateEventBtn.cornerRadius = 5
        //cell.ViewCard.clipsToBounds = true
        CreateEventBtn.layer.masksToBounds = false
        CreateEventBtn.layer.shadowColor = UIColor.lightGray.cgColor
        CreateEventBtn.layer.shadowOpacity = 0.8
        CreateEventBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        CreateEventBtn.layer.shadowRadius = 5
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        if (glo_account_auth == "technician"){
            //navrightbtn.setTitle("", for: .normal)
            //navrightbtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        }
  
        
        RepairTable.delegate = self
        RepairTable.dataSource = self
        
        
        RepairDetailList.removeAll()
        RepairDetailItem.removeAll()
        
        
        
        
        RepairDetailItem.append(RepairDetailData(from: "維修項目",""))
        RepairDetailItem.append(RepairDetailData(from: "報修日期時間",""))
        
        
        RepairDetailList.append(RepairGroup(from: "項目資訊", RepairDetailItem))
        isExpand.append(false)
        
        RepairDetailItem.removeAll()
        
        RepairDetailItem.append(RepairDetailData(from: "狀態",""))
        RepairDetailItem.append(RepairDetailData(from: "",""))
        RepairDetailItem.append(RepairDetailData(from: "",""))
        
        RepairDetailList.append(RepairGroup(from: "維修動態", RepairDetailItem))
        
        isExpand.append(false)
        
        RepairDetailItem.removeAll()
        
        //RepairDetailItem.append(RepairDetailData(from: "公司",""))
        RepairDetailItem.append(RepairDetailData(from: "維修人員",""))
        RepairDetailItem.append(RepairDetailData(from: "電話",""))
        
        RepairDetailList.append(RepairGroup(from: "維修資訊", RepairDetailItem))
        
        
        isExpand.append(false)
        
        RepairDetailItem.removeAll()
        
        RepairDetailItem.append(RepairDetailData(from: "地址",""))
        RepairDetailItem.append(RepairDetailData(from: "聯絡人",""))
        RepairDetailItem.append(RepairDetailData(from: "電話",""))
        
        
        RepairDetailList.append(RepairGroup(from: "填表人資訊", RepairDetailItem))
        isExpand.append(false)
        
        
        
        print( RepairDetailList.count)
        print(RepairDetailList)
        
        if (glo_account_auth == "landlord"){
            fillindetail(sel_eventdata: EventListDetail!)
            search_objectid_api(sel_id: EventListDetail!.object_id)
        }
        else{
            landlordgeteventinformation_api(sel_id: glo_account_id)
        }
        
        self.download_image()
  
        
    }
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
    let group : DispatchGroup = DispatchGroup()
    
    func download_image(){
        
         
        if ( (EventListDetail?.information.dynamic_status.count)! == 0 ){
            return
        }
        
        for i in 0 ... (EventListDetail?.information.dynamic_status.count)! - 1{
    
            RepairDetailList[1].repairitem.append(RepairDetailData(from: "",""))
            if ( (EventListDetail?.information.dynamic_status[i].image.count)! > 0 ){
                // return
                //}
              
                RepairDetailList[1].repairitem[i].img = []
                for j in 0 ... (EventListDetail?.information.dynamic_status[i].image.count)! - 1{
                    RepairDetailList[1].repairitem[i].img.append(#imageLiteral(resourceName: "emptyImg"))
                    //EventListDetail
                    
                    self.group.enter()
                    myDataQueue.async (group: group){
                        
                        
                        var loading_img = url_to_image(url: (URL(string:(EventListDetail?.information.dynamic_status[i].image[j])!)!))
                        DispatchQueue.main.sync{
                            RepairDetailList[1].repairitem[i].img[j] = loading_img
                        }
                    }
                    
                    
                    self.group.leave()
                }
            }
            
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
                
               
                self.RepairTable.reloadData()
           
                
                
                
            }
            
            
        }
        
        
        
    }
    
    func fillindetail( sel_eventdata : eventlistData.Items){
        RepairDetailList[0].repairitem[0].content = sel_eventdata.information.description
        RepairDetailList[0].repairitem[1].content = sel_eventdata.information.date
        
        RepairDetailList[1].repairitem[0].content = sel_eventdata.status
        
        print(sel_eventdata)
        print("sel_eventdata")
        let applicant_n = sel_eventdata.participant.firstIndex(where: {$0.auth == "tenant"})
        if (applicant_n != nil){   // 建表人是tenant
            set_applicant_info_api(sel_id: sel_eventdata.participant[applicant_n!].id)
        }
        else{ // 建表人是tenant
            set_applicant_info_api(sel_id: sel_eventdata.initiate_id)
        }
        let technician_n = sel_eventdata.participant.firstIndex(where: {$0.auth == "technician"})
        if (technician_n != nil){
            set_technician_n_info_api(sel_id: sel_eventdata.participant[technician_n!].id)
        }
        
        
    }
    
    func search_objectid_api(sel_id:String){
        
        
        let json: [String: Any] = ["object_id": sel_id]
        
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
                        print("data_JSON")
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
                            RepairDetailList[3].repairitem[0].content = d_information["full_address"] as! String
                            
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
    
    func set_applicant_info_api(sel_id:String){
        print("\(sel_id)sel_idididid")
        
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
                            
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            
                            print(d_information["name"])
                            
                            //self.RepairDetailList[3].repairitem[0].content = d_information["name"] as! String
                            RepairDetailList[3].repairitem[1].content = d_information["name"] as! String
                            RepairDetailList[3].repairitem[2].content = d_information["name"] as! String
                            
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
    
    func set_technician_n_info_api(sel_id:String){
        
        
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
                            
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            
                            print(d_information["name"])
                            
                            RepairDetailList[2].repairitem[0].content = d_information["name"] as! String
                            RepairDetailList[2].repairitem[1].content = d_information["name"] as! String
                            //RepairDetailList[2].repairitem[2].content = d_information["name"] as! String
                            
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
    
    
    func landlordgeteventinformation_api(sel_id:String){
        
        
        let json: [String: Any] = ["initiate_id": sel_id]
        
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
                    
                    
                    if (eventdata.Items.count > 0 ){
                        self.search_objectid_api(sel_id: eventdata.Items[0].object_id)
                        
                    }
                    
                    print(eventdata)
                    
                    DispatchQueue.main.sync {
                        if (eventdata.Message == "No Error"){
                            RepairList = eventdata.Items
                            self.RepairTable.reloadData()
                        }
                        
                        
                    }
                    
                    print("OK get_user_info_api")
                    
                    //if (self.Total_Event_List[self.maintype].this_EventData.count == 0){
                    //self.dismiss_loading_VC()
                    // return
                    //}
                    
                    
                    //self.myDataQueue.async {
                    
                    
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RepairDetailList.count
    }
    
    func total_cell_count () -> Int{
        var total_count = 0
        var n = 0
        while ( n < RepairDetailList.count){
            total_count += RepairDetailList[n].repairitem.count
            
            n += 1
        }
        
        print(total_count)
        return total_count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ( section == 1 ){
            return (EventListDetail?.information.dynamic_status.count)! + 1
        }
        else{
            return RepairDetailList[section].repairitem.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 1 && indexPath.row != 0 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordSelRepairEventCell", for: indexPath) as! LandlordSelRepairEventCell
            
            cell.EventCollection.tag = indexPath.row - 1
            
            cell.name.text = ""
            cell.content.text = EventListDetail?.information.dynamic_status[indexPath.row - 1].description
            
            cell.date.text = EventListDetail?.information.dynamic_status[indexPath.row - 1].date
            
            cell.EventCollection.reloadData()
            
            return cell
        }
        else if ( indexPath.section == 1 && indexPath.row == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepairDetailStatusCell", for: indexPath) as! RepairDetailStatusCell
            
            cell.Title.text = RepairDetailList[indexPath.section].repairitem[indexPath.row].title
            
            cell.StatusBtn.setTitle(RepairDetailList[indexPath.section].repairitem[indexPath.row].content, for: .normal)
            
            if (RepairDetailList[indexPath.section].repairitem[indexPath.row].content == "" || RepairDetailList[indexPath.section].repairitem[indexPath.row].content == "nil"){
                cell.StatusBtn.setTitle("選擇狀態", for: .normal)
            }
            else {
                cell.StatusBtn.setTitle(RepairDetailList[indexPath.section].repairitem[indexPath.row].content, for: .normal)
            }
            
            if (RepairDetailList[indexPath.section].repairitem[indexPath.row].content == "" || RepairDetailList[indexPath.section].repairitem[indexPath.row].content == "nil"){
                cell.StatusBtn.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
                cell.StatusBtn.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            }
            else if ( RepairDetailList[indexPath.section].repairitem[indexPath.row].content == "已結案"){
                cell.StatusBtn.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
                cell.StatusBtn.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }
            else {
                cell.StatusBtn.setTitleColor(maincolor3, for: .normal)
                cell.StatusBtn.layer.borderColor = maincolor3.cgColor
            }
            
            cell.CreateEventBtn.addTarget(self, action: #selector(createeventfunction), for: UIControl.Event.touchUpInside)
            cell.StatusBtn.addTarget(self, action: #selector(selstatusfunction), for: UIControl.Event.touchUpInside)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairDetailCell", for: indexPath) as! RepairDetailCell
        
        
        cell.Title.text = RepairDetailList[indexPath.section].repairitem[indexPath.row].title
        cell.Content.text =   RepairDetailList[indexPath.section].repairitem[indexPath.row].content
        
        
        if (cell.Title.text == "維修人員"){
            cell.selrepairer_btn.isHidden = false
            cell.selrepairer_btn.addTarget(self, action: #selector(selrepairerAction), for: UIControl.Event.touchUpInside)
        }
        else{
            cell.selrepairer_btn.isHidden = true
        }
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return PlaceList[section].name
     }
     */
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let header = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableHeader") as! EquipmentTableHeader
     
     
     header.PlaceTitle.text = "\(RepairDetailList[section].title)(\(RepairDetailList[section].repairitem.count))"
     
     header.HeaderBtn.tag = section
     header.HeaderBtn.addTarget(self, action: #selector(TapHeader), for: UIControl.Event.touchUpInside)
     
     
     
     return header.contentView
     }
     */
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
        
        self.RepairTable!.reloadSections(IndexSet(integer: section), with: .automatic)
        
    }
    @objc func createeventfunction(sender:UIButton){
        let storyboard = UIStoryboard( name: "LandlordMain", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "RepairerReportViewController" ) as! RepairerReportViewController
        
        //VC.delegate = self
        
        present(VC, animated: true, completion: nil)
    }
    @objc func selrepairerfunction(sender:UIButton){
        if (glo_account_auth != "landlord"){
            return
        }
        print("\(sender.tag) tap")
        let storyboard = UIStoryboard( name: "LandlordMain", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "LandlordSelRepairerViewController" ) as! LandlordSelRepairerViewController
        
        VC.delegate = self
        
        present(VC, animated: true, completion: nil)
        
    }
    
    @objc func selstatusfunction(sender:UIButton){
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        let sel_section = 1
        let sel_row = 0
        
        let okAction1 = UIAlertAction(title: "已接案",style: .default ){ (_) in
            RepairDetailList[sel_section].repairitem[sel_row].content = "已接案"
            self.RepairTable.reloadData()
            self.set_repair_status_api(sel_status: "Received")
        }
        alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "已指派",style: .default){ (_) in
            RepairDetailList[sel_section].repairitem[sel_row].content = "已指派"
            self.RepairTable.reloadData()
            self.set_repair_status_api(sel_status: "Assigned")
        }
        alertController.addAction(okAction2)
        let okAction3 = UIAlertAction(title: "處理中",style: .default){ (_) in
            RepairDetailList[sel_section].repairitem[sel_row].content = "處理中"
            self.RepairTable.reloadData()
            self.set_repair_status_api(sel_status: "Processing")
        }
        
        alertController.addAction(okAction3)
        
        let okAction4 = UIAlertAction(title: "已結案",style: .default){ (_) in
            RepairDetailList[sel_section].repairitem[sel_row].content = "已結案"
            self.RepairTable.reloadData()
            self.set_repair_status_api(sel_status: "Closed")
        }
        alertController.addAction(okAction4)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func set_repair_status_api(sel_status:String){
        
        let json: [String: Any] = ["landlord_id": glo_account_id,"event_id": EventListDetail!.event_id,"status_to_changed": sel_status]

           
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: api_host + api_basePath + "/eventmanagement/changeeventstatus")!
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
                                 
                                
                               
                                
                             }
                             
                             
                         }
                         
                         print("OK set_repair_status_api")
                         
                         
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
    /*
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     //return 59
     }
     
     */
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return RepairDetailList[section].title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LandlordSelRepairerViewController"){
            let vc = segue.destination as! LandlordSelRepairerViewController
            vc.delegate = self
        }
    }
    
}



extension RepairDetailViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        let backdata = sendData as! repairerdata
        //RepairDetailList[2].repairitem[0].content = backdata.company
        RepairDetailList[2].repairitem[0].content = backdata.name
        RepairDetailList[2].repairitem[1].content = backdata.phonenum
        //RepairDetailList[2].repairitem[3].content = backdata.repairdate
        RepairTable.reloadData()
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
        
    }
}
