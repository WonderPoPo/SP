//
//  PropertyDetailViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/12.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PropertyToolCellDelegate {
    func segue_tool_page(sel_index:Int)
}

struct PropertyDetailGroupData{
    var title : String
    var items : [PropertyDetailData]
    
    
    init(from title_D:String,_ items_D:[PropertyDetailData] ){
        self.title = title_D
        self.items = items_D
        
        
    }
    
}

struct PropertyDetailData{
    var title : String
    var intro : String
    var date : String
    var fee : String
    
    init(from title_D:String,_ intro_D:String ,_ date_D:String,_ fee_D:String ){
        self.title = title_D
        self.intro = intro_D
        self.date = date_D
        self.fee = fee_D
        
    }
    
}



var PhotoList = [UIImage]()
class PropertyDetailCell : UITableViewCell , UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var parkingspace: UILabel!
    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var rentfee: UILabel!
    @IBOutlet weak var rentdeadline: UILabel!
    @IBOutlet weak var intro: UILabel!
    
    @IBOutlet weak var tenantBtn: UIButton!
    
    @IBOutlet weak var PhotoCollection: UICollectionView!
    
    @IBOutlet weak var ToolsCollection: UICollectionView!
    
    
    var delegate : PropertyToolCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoCollection.delegate = self
        PhotoCollection.dataSource = self
        
        ToolsCollection.delegate = self
        ToolsCollection.dataSource = self
        
       
        //PhotoCollection.reloadData()
        
        
        
    }
    var ToolsList = ["住戶守則","設備手冊","周邊景點"]
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == PhotoCollection){
            return PhotoList.count
        }
        else{
            return ToolsList.count
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == PhotoCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyPhotoCell", for: indexPath) as! PropertyPhotoCell
            
            
            cell.Photo.image = PhotoList[indexPath.row]
            cell.Photo.cornerRadius =  10
            cell.Photo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showZoomImageView(tap:))))
            
            cell.Photo.zoomImage()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyDetailToolsCell", for: indexPath) as! PropertyDetailToolsCell
            
            
            cell.tool_title.text = ToolsList[indexPath.row]
            label_style3(sel_label: cell.tool_title)
            
            cell.layer.cornerRadius =  10
            
            return cell
        }
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == PhotoCollection){
            return CGSize(width: ( collectionView.frame.size.width / 2 ) - 40  , height: ( collectionView.frame.size.width / 2 ) - 40 )
        }
        else{
            return CGSize(width: 80  , height: 30)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate!.segue_tool_page(sel_index:indexPath.row)
    }
    
    
    
    
}

class PropertyDetailHeaderCell : UITableViewCell{
    
    @IBOutlet weak var More_Button: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBAction func MoreAction(_ sender: Any) {
        if ( title.text == "" ){
            
            
        }
        
        
    }
}

class PropertyRepairCell : UITableViewCell{
    
    @IBOutlet weak var repair_title: UILabel!
    @IBOutlet weak var repair_intro: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fee: UILabel!
    
    
}

class PropertyPhotoCell : UICollectionViewCell{
    
    @IBOutlet weak var Photo: UIImageView!
    
}

class PropertyDetailToolsCell :UICollectionViewCell{
    
    @IBOutlet weak var tool_title: UILabel!
    
}

class PropertyRentCell : UITableViewCell{
    
    
    @IBOutlet weak var rent_price: UILabel!
    
    @IBOutlet weak var rent_paydate: UILabel!
    @IBOutlet weak var rent_term: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var paymethod: UILabel!
    @IBOutlet weak var paycycle: UILabel!
    
    @IBOutlet weak var contractBtn: UIButton!
    
    
    
}


class PropertyDetailViewController : UIViewController,UITableViewDelegate , UITableViewDataSource,UITextFieldDelegate, UIDocumentPickerDelegate, PropertyToolCellDelegate{
    
    @IBOutlet weak var repairTable: UITableView!
    
    
    var DetailList = [PropertyDetailGroupData]()
    var DetailItemList = [PropertyDetailData]()
    
    var address = "桃園中壢大仁五街6號"
    var floor = "6樓"
    var area = "30坪"
    var parkingspace = "樓下B1平面式"
    var phonenumber = "0958888888"
    var rentfee = "25000元/月"
    var rentdeadline = "2020年12月11日"
    var intro = "冬暖夏涼\n四季沒蚊子\n每個都說好。周邊景點多，步行3分鐘到捷運站，夜市商圈通通都有"
    
    
    
    var sel_property : propertyDetailData?
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoList.removeAll()
        
        
        //PhotoList.append(#imageLiteral(resourceName: "ironman"))
        print(sel_property?.floor)
        print("sel_property?.floor")
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        

        
        repairTable.delegate = self
        repairTable.dataSource = self
        
        
        DetailItemList.append(PropertyDetailData(from: "","","",""))
        
        
        DetailList.append(PropertyDetailGroupData(from: "客戶資訊", DetailItemList))
        
        DetailItemList.removeAll()
        
        DetailItemList.append(PropertyDetailData(from: "租金","未付款","到期日:2020/11/30","$10000"))
        
        
        DetailList.append(PropertyDetailGroupData(from: "租金明細", DetailItemList))
        
        DetailItemList.removeAll()
        
        DetailItemList.append(PropertyDetailData(from: "水管","已結案","2020/11/30","$10000"))
        DetailItemList.append(PropertyDetailData(from: "水管塞住","已結案","2020/11/30","$10000"))
        DetailItemList.append(PropertyDetailData(from: "廁所漏水","已結案","2020/11/29","$15000"))
        DetailItemList.append(PropertyDetailData(from: "牆壁破洞","已結案","2020/11/28","$22000"))
        
        
        DetailList.append(PropertyDetailGroupData(from: "維修紀錄", DetailItemList))
        
        
        download_image()
        print(sel_property!.image_url.count)
        
        if (sel_property!.image_url.count == 0){
            
            
            var cur_img_num = sel_property!.ImgList.count
            var cur_imgurl_num = sel_property!.image_url.count
                   
            var n = 0
                   
            while ( n < cur_img_num){
                PhotoList.append(sel_property!.ImgList[n]!)
                
                n += 1
                       
                //self.imgList.append()
            }

            //glo_BuildingList[self.sel_group_index].property_items[glo_BuildingList[self.sel_group_index].property_items.count - 1].ImgList = self.imgList
        }
        
        getcontract_api()
        get_user_info_phonenum_api(sel_id: glo_root_id)
        
    }
    
    
    
    
    var show_contract_img = false
    
       func getcontract_api(){
         
        if (sel_property?.current_contract_id == "nil"){
            return
        }
        
        print(sel_property!.current_contract_id)
           
        let json: [String: Any] = ["landlord_id": glo_root_id, "contract_id": sel_property!.current_contract_id ]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: json)
           
           print("OKOK")
           
           // create post request
           let url = URL(string: api_host + api_basePath + "/contractmanagement/getcontractbycontractid")!
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
                            
                            let d_date = d_Items["date"] as Any as! Dictionary<String,Any>
                            let d_end_date = d_date["end_date"] as Any as! Int
                            //let d_time_left = d_date["time_left"] as Any as! Int
                            let d_start_date = d_date["start_date"] as Any as! Int
                            //let d_next_date = d_date["next_date"] as Any as! Int
                            
                            let d_tenant_id = d_Items["tenant_id"] as Any as! String
                            //let d_backup = d_Items["backup"] as! Dictionary<String,Any>
                            let d_backup = d_Items["backup"] as! Any
                            var d_type = ""
                            if let d_backup = d_backup as? Dictionary<String,Any>{
                                d_type = d_backup["type"] as Any as! String
                                if (d_type == "JPG"){
                                    let d_document = d_backup["document"] as Any as! [String]
                                    self.contract_document_imglist = d_document
                                }
                                else{
                                    let d_document = d_backup["document"] as Any as! String
                                    self.contract_document = d_document
                                }
                                
                            }
                            
                            //for d_backup in d_backups{
                            
                                
                            //}
                            
                            let d_payment = d_Items["payment"] as Any as! Dictionary<String,Any>
                            let d_deposit = d_payment["deposit"] as Any as! Int
                            let d_currency = d_payment["currency"] as Any as! String
                            let d_rent = d_payment["rent"] as Any as! Int
                            let d_payment_method = d_payment["payment_method"] as Any as! String
                            
                            
                            
                            self.contract_end_date = getdate(Date(timeIntervalSince1970: TimeInterval(d_end_date) ),dateFormat: "yyyy/MM/dd")
                      
                            //self.contract_time_left = String(d_time_left)
                            self.contract_start_date = getdate(Date(timeIntervalSince1970: TimeInterval(d_start_date) ),dateFormat: "yyyy/MM/dd")
                            //self.contract_next_date = String(d_next_date)
                            
                            self.contract_deposit = String(d_deposit)
                            self.contract_currency = String(d_currency)
                            self.contract_rent = String(d_rent)
                            
                            if(d_payment_method == "Permonth"){
                                self.contract_payment_method = "月繳"
                            }
                            else if (d_payment_method == "Perseason"){
                                self.contract_payment_method = "季繳"
                            }
                            else if (d_payment_method == "Perhalfyear"){
                                self.contract_payment_method = "半年繳"
                            }
                            else if (d_payment_method == "Peryear"){
                                self.contract_payment_method = "年繳"
                            }
                            else {
                                self.contract_payment_method = d_payment_method
                            }
                            
                            self.contract_type = d_type
                            
                         
                           self.show_contract_img = true
                           
                   
                               //self.delegate?.dismissBack(sendData: <#T##Any#>)
                               DispatchQueue.main.sync {
                            
                                   
                                   //self.delegate?.dismissBack(sendData: equipjson)
                                self.repairTable.reloadData()
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
    
    func get_user_info_phonenum_api(sel_id:String){
        
        
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
                            
                            let d_system_id = d_Items["system_id"] as! String
                    
                            let d_auth = d_Items["auth"] as! String
                            
            
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            let d_sex = d_information["sex"] as! String
            
                            let d_name = d_information["name"] as! String
                    let d_icon = d_information["icon"] as! String
                          
                            let d_mail = d_information["mail"] as! String
                         
                            let d_phone = d_information["phone"] as! String
                         
                            let d_annual_income = d_information["annual_income"] as! String
                           
                            let d_industry = d_information["industry"] as! String
                            
                            let d_profession = d_information["profession"] as! String
                          
      
                            self.landlord_phonenum = d_phone
                            
                            DispatchQueue.main.sync {
                               self.repairTable.reloadData()
                                
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
    
    var landlord_phonenum = ""
    
    var contract_end_date = ""
    var contract_time_left = ""
    var contract_start_date = ""
    var contract_next_date = ""

    var contract_deposit = ""
    var contract_currency = ""
    var contract_rent = ""
    var contract_payment_method = ""
    
    var contract_type = ""
    var contract_document = ""
    var contract_document_imglist = [String]()
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
      let group : DispatchGroup = DispatchGroup()
      
    func download_image(){
        

        if ( sel_property!.image_url.count == 0){
            return
        }
        for i in 0 ... sel_property!.image_url.count - 1{
            
            
            self.group.enter()
            myDataQueue.async (group: group){
                if (self.sel_property!.image_url.count > 0){
                    
                
                var loading_img = url_to_image(url: (URL(string:self.sel_property!.image_url[i])!))
                DispatchQueue.main.async{
                    self.sel_property!.ImgList.append(loading_img)
                    PhotoList.append(loading_img)
                    self.group.leave()
                    
                }
                }
                
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.repairTable.reloadData()
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        
        return DetailList[section].items.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0 && indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyDetailCell", for: indexPath) as! PropertyDetailCell
            
            var titleRange = NSRange(location: 0, length: 2)
            
            
            let myAttrString = NSMutableAttributedString(string: "地址  " + address)
            myAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: titleRange)
            
            button_style2(sel_button: cell.tenantBtn)
            cell.tenantBtn.setTitleColor(maincolor3, for: .normal)
            if (sel_property!.tenant_id == "nil" || sel_property!.tenant_id == "" ){
                cell.tenantBtn.setTitle("新增房客", for: .normal)
            }
            else{
                cell.tenantBtn.setTitle(sel_property!.tenant_id, for: .normal)
            }
            
            cell.address.text = sel_property?.full_address
            cell.floor.text = String(sel_property!.floor)
            cell.area.text =  String(sel_property!.area) + "坪"
            cell.parkingspace.text =  sel_property?.parking_space
            cell.phonenumber.text =  landlord_phonenum
            //cell.rentfee.text =  rentfee
            //cell.rentdeadline.text =  rentdeadline
            cell.intro.text = sel_property?.description
            
            cell.PhotoCollection.reloadData()
            
            cell.delegate = self
            
            
            cell.tenantBtn.addTarget(self, action: #selector(tenantBtnAction), for: UIControl.Event.touchUpInside)
            
            return cell
            
        }
        else if (indexPath.section == 1 && indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyRentCell", for: indexPath) as! PropertyRentCell
            cell.rent_price.text = contract_rent
            cell.rent_term.text = contract_end_date
            cell.rent_paydate.text = "2021/2/13"
            cell.paycycle.text = contract_payment_method
            if (String(contract_deposit) == "" || String(contract_deposit) == "nil"){
                cell.deposit.text = ""
            }
            else{
                cell.deposit.text = String(contract_deposit) + "台幣"
            }
            cell.status.text = "未繳付"
            cell.paymethod.text = contract_start_date
            
           
            
            button_style3(sel_button: cell.contractBtn)
       
            cell.contractBtn.addTarget(self, action: #selector(contractBtnAction), for: UIControl.Event.touchUpInside)
            
            if (show_contract_img == true){
                cell.contractBtn.isHidden = false
            }
            else{
                cell.contractBtn.isHidden = true
            }
            
            if (self.contract_type == "TXT" || contract_type == "JPG" || contract_type == "PDF"){
                
                cell.contractBtn.backgroundColor = maincolor3
                
                cell.contractBtn.setTitle("瀏覽合約", for: .normal)
            }
            //else if (self.contract_type == ""){
                //cell.contractBtn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
                //cell.contractBtn.setTitle("上傳合約", for: .normal)
            //}
            else {
                cell.contractBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                cell.contractBtn.setTitle("上傳合約", for: .normal)
            }
            
            return cell
            
        }
            
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyRepairCell", for: indexPath) as! PropertyRepairCell
            
            
            cell.repair_title.text = DetailList[indexPath.section].items[indexPath.row].title
            cell.repair_intro.text = DetailList[indexPath.section].items[indexPath.row].intro
            cell.date.text = DetailList[indexPath.section].items[indexPath.row].date
            cell.fee.text = DetailList[indexPath.section].items[indexPath.row].fee
            cell.fee.isHidden = true
            
            
            
            return cell
        }
        
    }
    
    @objc func tenantBtnAction(sender:UIButton){
        print(sel_property!.tenant_id)
        if (sel_property!.tenant_id == "" || sel_property!.tenant_id == "nil"){
            let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
                             
            let VC = storyboard.instantiateViewController( withIdentifier: "CreateStaffViewController" ) as! CreateStaffViewController
                             
            VC.selected_object = true
            VC.create_type = "tenant"
            VC.sel_property_id = sel_property!.object_id
            VC.sel_object_full_address = sel_property!.full_address
            VC.delegate = self
           
                          
            present(VC, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "profilesegue", sender: self)
            
                             
        }
        //let file_path = getDocumentsDirectory()
        //print(file_path)
    }
    
    @objc func contractBtnAction(sender:UIButton){
        
        if (self.contract_type == "TXT" || contract_type == "JPG" || contract_type == "PDF"){
            
            performSegue(withIdentifier: "showcontractsegue", sender: self)
            return
        }
        else {
            let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
            
            let VC = storyboard.instantiateViewController( withIdentifier: "CreateContractImgViewController" ) as! CreateContractImgViewController
            CreateContract_sel_contract_id = sel_property!.current_contract_id
            CreateContract_sel_landlord_id = sel_property!.landlord_id
            VC.delegate = self
           
            
            
            present(VC, animated: true, completion: nil)
            
            //performSegue(withIdentifier: "showcontractsegue", sender: self)  ****
            return
        }
        
        
        //let file_path = getDocumentsDirectory()
        //print(file_path)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        print("WWWW")
        guard let selectedFileURL = urls.first else {
            print("selectedFileURL!!")
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
            send_contract_api(FileData: try! Data(contentsOf: sandboxFileURL))
        }
        else {
            
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                send_contract_api(FileData: try! Data(contentsOf: sandboxFileURL))
                print("Copied file!")
            }
            catch {
                print("Error: (error)")
            }
        }
    }
    
    func send_contract_api( FileData : Data){
        
        
        var  filestr = FileData.base64EncodedString()
        //filestr = filestr.data(using: .utf8)
        
        print(filestr)
        let json: [String: Any] = ["pdf": filestr]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/test")!
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
                        
                        
                        //let d_message:String = data_JSON["Message"] as Any as! String
                        //if (d_message == "No Error"){
                        
                        
                        //}
                        
                        
                    }
                    
                    print("OK send_contract_api")
                    
                    
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
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if ( section == 0  ){
            return nil
        }
        else {
            let header = tableView.dequeueReusableCell(withIdentifier: "PropertyDetailHeaderCell") as! PropertyDetailHeaderCell
            
            
            header.title.text = DetailList[section].title
            
            //if ( section == 0 ){
            //    header.More_Button.isHidden = true
            //}
            //else{
            //    header.More_Button.isHidden = false
            //}
            
            header.More_Button.isHidden = true
            
            if ( section == 1 ){
                if ( sel_property!.tenant_id == "nil" || sel_property!.tenant_id == ""){
                    header.More_Button.isHidden = true
                }
                else if (sel_property?.current_contract_id == "nil" || sel_property?.current_contract_id == "" ){
                    header.More_Button.isHidden = false
                }
                else{
                    header.More_Button.isHidden = true
                }
                header.More_Button.setTitle("新增", for: .normal)
                header.More_Button.addTarget(self, action: #selector(editcontract), for: UIControl.Event.touchUpInside)
            }
            
            
            return header.contentView
        }
        
    }
    
  
    @objc func editcontract(sender:UIButton){
        let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "CreateContractInfoViewController" ) as! CreateContractInfoViewController
        
        VC.sel_object_id = sel_property!.object_id
        VC.tenant_id = sel_property!.tenant_id
        VC.delegate = self
        present(VC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ( section == 0  ){
            return 0
        }
        else{
            return tableView.sectionHeaderHeight
        }
    }
    
    var isExpand:[Bool] = []
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
    
    
    
    
    
    
    //////////////
    
    
    func segue_tool_page(sel_index:Int) {
        if (sel_index == 0){
            performSegue(withIdentifier: "houserulesegue", sender: self)
        }
        else if (sel_index == 1){
            performSegue(withIdentifier: "equipmentsegue", sender: self)
        }
        else if (sel_index == 2){
            performSegue(withIdentifier: "houseviewpointegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "equipmentsegue" ){
        
             //if let indexPath = PropertyTable.indexPathForSelectedRow {
             let vc = segue.destination as! EquipmentViewController
                
            vc.sel_object_id = self.sel_property!.object_id
                //sel_property = glo_BuildingList[sel_group_index].property_items[indexPath.row]
                
             
            // }
             
        }
        else if (segue.identifier == "showcontractsegue" ){
        
             //if let indexPath = PropertyTable.indexPathForSelectedRow {
             let vc = segue.destination as! ShowContractViewController
                
            vc.sel_contract_document = self.contract_document
            vc.sel_contract_document_imglist = self.contract_document_imglist
             CreateContract_sel_contract_id = sel_property!.current_contract_id
             CreateContract_sel_landlord_id = sel_property!.landlord_id
   
            // }
             
        }
        else if (segue.identifier == "showcontractimglistsegue"){
            let vc = segue.destination as! CreateContractUpLoadImg
                         
            vc.img_url_List = self.contract_document_imglist
            CreateContract_sel_contract_id = sel_property!.current_contract_id
            CreateContract_sel_landlord_id = sel_property!.landlord_id
            
                     // }
        }
        
        if (segue.identifier == "profilesegue"){
                
            let vc = segue.destination as! UserProfileViewController

            
            vc.sel_staff_id = sel_property!.tenant_id
                 
                 
                 
                 
        }
        
        
    }
    
    
    
}
extension ViewController: UIDocumentPickerDelegate {
    
    
}
extension PropertyDetailViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        if (sendData is String){
            if ((sendData as! String) != "createcontract"){
                sel_property!.current_contract_id = sendData as! String
                getcontract_api()
            }
            else {
                getcontract_api()
            }
        }
        else if ( sendData is passdata1){
            if ((sendData as! passdata1 ).type == "tenant_id"){
                sel_property!.tenant_id = (sendData as! passdata1 ).any_data as! String
                self.repairTable.reloadData()
            }

            
        }
        
     
        
    }
    

}
