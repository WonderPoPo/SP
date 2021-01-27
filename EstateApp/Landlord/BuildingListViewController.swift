//
//  BuildingListViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/12.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


struct BuildingData{
    let name : String
    
    var image_url : String
    var image :UIImage?
    
    var total_area :Double
    var rent_persent :Double
    
    var property_items : [propertyDetailData]
    
    
    init(from name_D:String,_ image_D : String ){
        self.name = name_D
        self.image_url = image_D
        self.property_items = []
        self.total_area = -1
        self.rent_persent = -1
        //self.image = nil
    }
    
    
    
    
}

struct property_grouptag_data : Decodable{
    let Items : Items
    let Message :String
    
    struct Items : Decodable{
        let group : [Group]
        
        struct Group : Decodable{
            let name : String
            
            let image : String
        }
    }
}


var glo_BuildingList = [BuildingData]()
var glo_BuildingImgList = [BuildingImgData]()

struct BuildingImgData {
    var group_img :UIImage
    
    struct propertyItem {
        var item_img : [UIImage]
    }
}




class BuildingCell : UITableViewCell{
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var rentpercent: UILabel!
    
    override func awakeFromNib() {
        
        
        
    }
    
}



class BuildingListViewController :UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    
    
    
    
    
    
    @IBOutlet weak var BuildingTable: UITableView!
    
    
    @IBAction func createBuildingAction(_ sender: Any) {
        
        let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "CreateBuildingListViewController" ) as! CreateBuildingListViewController
        
        VC.delegate = self
        present(VC, animated: true, completion: nil)
    }
    
    
    
    //var EquipList = [Equip_itemdata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        
        BuildingTable.delegate = self
        BuildingTable.dataSource = self
        
        
        //glo_BuildingList.append(BuildingData(from: "Test","nil"))
        
        //getgrouptag_api()
        download_image()
        
        refresher = UIRefreshControl()
        refresher.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        refresher.addTarget(self, action: #selector(self.refreshtable), for: UIControl.Event.valueChanged)
        BuildingTable.addSubview(refresher)
    }
    var refresher: UIRefreshControl!
    @objc func refreshtable( ){
        //landlordgeteventinformation_api(sel_id: glo_account_id)
        BuildingTable.reloadData()
        refresher.endRefreshing()
    }
    
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
    let group : DispatchGroup = DispatchGroup()
    
    
    func download_image(){
        

        if ( glo_BuildingList.count == 0){
            return
        }
        for i in 0 ... glo_BuildingList.count - 1{
            
            
            self.group.enter()
            myDataQueue.async (group: group){
                var loading_img = url_to_image(url: (URL(string:glo_BuildingList[i].image_url)!))
                DispatchQueue.main.sync{
                    glo_BuildingList[i].image = loading_img
                }
                self.group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.BuildingTable.reloadData()
                
                
                
            }
            
            
        }
        
        
        
    }
    
       func get_user_info_api(sel_id:String){
           
           
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
                               
                               print(d_Items["auth"] as! String)
                       
                               
                               let d_information = d_Items["information"] as! Dictionary<String,Any>
                               let d_name = d_information["name"] as! String

                               

                               
                               DispatchQueue.main.sync {
                                
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
    
    func getgrouptag_api_createandupdate(){
        
        
        
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
                    let eventdata = try decoder.decode(property_group_data.self, from: downloadedData)
                    print(eventdata.Items.group)
                    
                    //User_Login += eventdata
                    
                    if (eventdata.Message == "No Error"){
                        
                            var i = glo_BuildingList.count
                            while ( i < eventdata.Items.group.count ){
                                glo_BuildingList.append(BuildingData(from: eventdata.Items.group[i].name ,eventdata.Items.group[i].image))
                                i += 1
                            }
                            
                            print( self.sel_update_index )
                            print("self.sel_update_index")
                            if (self.sel_update_index != -1 && self.sel_update_index < glo_BuildingList.count ){
                                
                                //self.group.enter()
                               
                                    
                                    
                                    glo_BuildingList[self.sel_update_index].image_url = eventdata.Items.group[self.sel_update_index].image
                                    let loading_img = url_to_image(url: (URL(string:glo_BuildingList[self.sel_update_index].image_url)!))
                                    glo_BuildingList[self.sel_update_index].image = loading_img
                                    DispatchQueue.main.sync {
                                        self.BuildingTable.reloadData()
                                        self.sel_update_index = -1
                                    }
                                        //self.group.leave()
                           
                                
                                //self.group.notify(queue: DispatchQueue.main ){
                                  
                                    //DispatchQueue.main.async {
                                       
                                    //    self.BuildingTable.reloadData()
                                    //}
                                
                                //}
                            }
                            
                            DispatchQueue.main.sync {
                            self.BuildingTable.reloadData()
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
   
    var sel_update_index = -1
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let edit_auth_button = UITableViewRowAction(style: .normal, title: "編輯照片"){ (rowAction , indexPath) in
            let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
            
            let VC = storyboard.instantiateViewController( withIdentifier: "CreateBuildingListViewController" ) as! CreateBuildingListViewController
            
            VC.update_name = glo_BuildingList[indexPath.row].name
            VC.sel_index = indexPath.row
            VC.delegate = self
            self.sel_update_index = indexPath.row
            self.present(VC, animated: true, completion: nil)
           
            
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    
            
            
        }
        edit_auth_button.backgroundColor = color1
        
        return [edit_auth_button]
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        
        return glo_BuildingList.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        
        
        cell.name.text = glo_BuildingList[indexPath.row].name
        //cell.address.text = "台北大安街"
        
        if (glo_BuildingList[indexPath.row].rent_persent == -1 ){
            
            
            var rent_num = 0
            
            for item in glo_BuildingList[indexPath.row].property_items {
                print(item.current_contract_id)
                print(item.tenant_id)
                if (item.current_contract_id != "nil" && item.tenant_id != "nil" ){
                    rent_num += 1
                }
           
            }
            print(NSNumber(value: 2 * 100 / 7))
            print(glo_BuildingList[indexPath.row].property_items.count)
           
            print("FFFFFK")
            if (glo_BuildingList[indexPath.row].property_items.count > 0 ){
                glo_BuildingList[indexPath.row].rent_persent = Double(rent_num * 100 / glo_BuildingList[indexPath.row].property_items.count)
                
               
            }
            else{
                glo_BuildingList[indexPath.row].rent_persent = 0
            }
        }
        
        cell.rentpercent.text = "出租率 " + String(glo_BuildingList[indexPath.row].rent_persent) + "%"
        
        if (glo_BuildingList[indexPath.row].total_area == -1 ){
            
            
            var total_area = 0
            
            for item in glo_BuildingList[indexPath.row].property_items {
                total_area += Int(item.area)
            }
            
            glo_BuildingList[indexPath.row].total_area = Double(total_area)
        }
        
        cell.area.text =  String(glo_BuildingList[indexPath.row].total_area) + "坪  " + String(glo_BuildingList[indexPath.row].property_items.count) + "戶"//"130坪/5户"
        if (glo_BuildingList[indexPath.row].image != nil){
            cell.photo.image = glo_BuildingList[indexPath.row].image
        }
        else{
            cell.photo.image = #imageLiteral(resourceName: "emptyImg")
        }
       
        
        
        
        
        
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return PlaceList[section].name
     }
     */
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        performSegue(withIdentifier: "selpropertysegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selpropertysegue" ){
            
            if let indexPath = BuildingTable.indexPathForSelectedRow {
                let vc = segue.destination as! PropertyListViewController
                vc.title = glo_BuildingList[indexPath.row].name
                vc.sel_group_index = indexPath.row
            }
            
        }
    }
    
}



var scrollView:UIScrollView?
var lastImageView:UIImageView?
var originalFrame:CGRect!
var isDoubleTap:ObjCBool!

extension UITableViewCell{
 
    @objc func showZoomImageView( tap : UITapGestureRecognizer) {
            let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
            bgView.backgroundColor = UIColor.black
            let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
            bgView.addGestureRecognizer(tapBg)
            let picView = tap.view as! UIImageView//view 强制转换uiimageView
            let imageView = UIImageView.init()
            imageView.image = picView.image;
            //imageView.frame = bgView.convert(picView.frame, from: self.view)
            imageView.frame = bgView.frame
            bgView.addSubview(imageView)
        UIApplication.shared.keyWindow!.addSubview(bgView)
            lastImageView = imageView
            originalFrame = imageView.frame
            scrollView = bgView
            scrollView?.maximumZoomScale = 1.5
            //self.?.delegate = self

            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: UIView.AnimationOptions.beginFromCurrentState,
                animations: {
                    var frame = imageView.frame
                    frame.size.width = bgView.frame.size.width
                    frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                    frame.origin.x = 0
                    frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                    imageView.frame = frame
            }, completion: nil
            )

        }
    @objc func tapBgView(tapBgRecognizer:UITapGestureRecognizer)
        {
            scrollView?.contentOffset = CGPoint.zero
            UIView.animate(withDuration: 0.5, animations: {
                lastImageView?.frame = originalFrame
                tapBgRecognizer.view?.backgroundColor = UIColor.clear
            }) { (finished:Bool) in
                tapBgRecognizer.view?.removeFromSuperview()
                scrollView = nil
                lastImageView = nil
            }
        }
}


extension BuildingListViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        print(sendData as! String)
        DispatchQueue.main.async {
            self.BuildingTable.reloadData()
        }
        
        //getgrouptag_api_createandupdate()
        //BuildingTable.reloadData()
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
    }
}




