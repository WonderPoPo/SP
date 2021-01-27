//
//  CreatePropertyViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/21.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

struct RegionData{
    let name : String
    let street_item:[StreetData]
    
}

struct StreetData {
    let name : String
    let road_item:RoadData
    struct RoadData {
        let name : [String]
    }
}

var regionList = [RegionData]()
var streetList = [StreetData]()
func insertregionList(){
    
    streetList.append(StreetData(name: "金城鎮", road_item: StreetData.RoadData(name:["中興市場","伯玉路","光前路"] )))
    streetList.append(StreetData(name: "金沙鎮", road_item: StreetData.RoadData(name:["建東農場","復興街","德明路"] )))
    streetList.append(StreetData(name: "金湖鎮", road_item: StreetData.RoadData(name:["下莊光武路","前港路","南機路"] )))
    regionList.append(RegionData(name: "金門縣", street_item: streetList))
    
    streetList.removeAll()
    streetList.append(StreetData(name: "竹東鎮", road_item: StreetData.RoadData(name:["三重一路","上坪","中豐路"] )))
    streetList.append(StreetData(name: "香山區", road_item: StreetData.RoadData(name:["香村路","五福路","遠義路"] )))
    streetList.append(StreetData(name: "東區", road_item: StreetData.RoadData(name:["安和街","光復路","安康路"] )))
    regionList.append(RegionData(name: "新竹縣", street_item: streetList))
    
    streetList.removeAll()
    streetList.append(StreetData(name: "頭城鎮", road_item: StreetData.RoadData(name:["中庸街","二城路","仙公路"] )))
    streetList.append(StreetData(name: "礁溪鄉", road_item: StreetData.RoadData(name:["化龍街","十六結路","和平路"] )))
    streetList.append(StreetData(name: "員山鄉", road_item: StreetData.RoadData(name:["尚深路","山前路","德湖一路"] )))
    regionList.append(RegionData(name: "宜蘭縣", street_item: streetList))
    streetList.removeAll()
    
    
}

class CreatePropertyCell: UICollectionViewCell{
    
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var delegate : SelCellIndexDelegate?
    
}




class CreatePropertyViewController : UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, SelCellIndexDelegate {
    
    @IBOutlet weak var imagecollection: UICollectionView!
    @IBOutlet weak var sendbtn: UIButton!
    
    
    
    @IBOutlet weak var region_label: UILabel!
    
    
    
    @IBOutlet weak var object_name: UITextField!
    @IBOutlet weak var region_btn: UIButton!
    @IBOutlet weak var street_btn: UIButton!
    @IBOutlet weak var road_btn: UIButton!
    @IBOutlet weak var full_address: UITextField!
    @IBOutlet weak var floor: UITextField!
    @IBOutlet weak var area: UITextField!
    @IBOutlet weak var parking_space: UITextField!
    @IBOutlet weak var type_btn: UIButton!
    @IBOutlet weak var intro: UITextField!
    @IBOutlet weak var expect_rent: UITextField!
    @IBOutlet weak var purchase_price: UITextField!
    
    var region_n = -1
    var street_n = -1
    var road_n = -1
    
    @IBAction func regionAction(_ sender: Any) {
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
        while ( n < regionList.count){
            let okAction1 = UIAlertAction(title: regionList[n].name,style: .default   ){ (action:UIAlertAction!) in
                
                print(action.title)
                self.region_n = regionList.firstIndex(where: {$0.name == action.title})!
                
                self.region_btn.setTitle(regionList[self.region_n].name, for: .normal)
                
                
                if (self.street_n != -1){
                    self.street_n = -1
                    self.street_btn.setTitle("請重新選擇", for: .normal)
                }
                if (self.road_n != -1){
                    self.road_n = -1
                    self.road_btn.setTitle("請重新選擇", for: .normal)
                }

                
            }
            alertController.addAction(okAction1)
            
            n += 1
        }
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func streetAction(_ sender: Any) {
        
        if (region_n == -1){
            return
        }
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
        while ( n < regionList[region_n].street_item.count){
            let okAction1 = UIAlertAction(title: regionList[region_n].street_item[n].name,style: .default   ){ (action:UIAlertAction!) in
                
                print(action.title)
                self.street_n = regionList[self.region_n].street_item.firstIndex(where: {$0.name == action.title})!
                
                self.street_btn.setTitle(regionList[self.region_n].street_item[self.street_n].name, for: .normal)
                
                
          
                if (self.road_n != -1){
                    self.road_n = -1
                    self.road_btn.setTitle("請重新選擇", for: .normal)
                }
            }
            alertController.addAction(okAction1)
            
            n += 1
        }
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func roadAction(_ sender: Any) {
        if (street_n == -1){
            return
        }
        
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
        while ( n < regionList[region_n].street_item[street_n].road_item.name.count){
            let okAction1 = UIAlertAction(title: regionList[region_n].street_item[street_n].road_item.name[n],style: .default   ){ (action:UIAlertAction!) in
                
                print(action.title)
                self.road_n = regionList[self.region_n].street_item[self.street_n].road_item.name.firstIndex(where: {$0 == action.title})!
                
                self.road_btn.setTitle(regionList[self.region_n].street_item[self.street_n].road_item.name[self.road_n], for: .normal)
                
            }
            alertController.addAction(okAction1)
            
            n += 1
        }
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
     
    }
    

    var propertytypeList = ["住宅","套房","店面","辦公" ,"住辦","廠房" ,"車位" ,"土地" ,"其他"]
    
    func propertytype_to_eng(sel_type:String)->String{
        
        if (sel_type == "住宅"){
            return "Dwelling"
        }
        else if (sel_type == "套房"){
            return "Suite"
        }
        else if (sel_type == "店面"){
            return "Storefront"
        }
        else if (sel_type == "辦公"){
            return "Office"
        }
        else if (sel_type == "住辦"){
            return "DwellingOffice"
        }
        else if (sel_type == "廠房"){
            return "Factory"
        }
        else if (sel_type == "車位"){
            return "ParkingSpace"
        }
        else if (sel_type == "土地"){
            return "LandPlace"
        }
        else if (sel_type == "其他"){
            return "Other"
        }
        else{
            return sel_type
        }
        
    }
    
    
    
    var propertytypeList_n = -1
    @IBAction func typeAction(_ sender: Any) {
        
        
        
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
        while ( n < propertytypeList.count){
            let okAction1 = UIAlertAction(title: propertytypeList[n],style: .default   ){ (action:UIAlertAction!) in
                
                print(action.title)
                self.propertytypeList_n = self.propertytypeList.firstIndex(where: {$0 == action.title})!
                
                self.type_btn.setTitle(self.propertytypeList[self.propertytypeList_n], for: .normal)
                
                

                
            }
            alertController.addAction(okAction1)
            
            n += 1
        }
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        create_property_api()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
       let group : DispatchGroup = DispatchGroup()
       
       
       
    func create_property_api(){
  
        if (propertytypeList_n == -1){
            return
        }
        
        let json: [String: Any] = [
            "landlord_id": glo_account_id,
            "system_id" : glo_account_system_id,
            "group_name": glo_BuildingList[sel_group_index].name,
            "object_name": object_name.text,
            "region" : region_btn.titleLabel?.text,
            "street": street_btn.titleLabel?.text,
            "road": road_btn.titleLabel?.text,
            "full_address": full_address.text,
            "floor" : floor.text!,
            "area": area.text,
            "rent": expect_rent.text!,
            "parking_space": parking_space.text,
            "type": propertytype_to_eng(sel_type: (type_btn.titleLabel?.text)!),
            "purchase_price": Int(purchase_price.text!),
            "description" : intro.text
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/propertymanagement/createproperty")!
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
                            let d_object_id:String = d_Items["object_id"] as Any as! String
                            
                            
                            
   
                            DispatchQueue.main.sync {
                                glo_BuildingList[self.sel_group_index].property_items.append(propertyDetailData(ImgList: [], current_contract_id: "nil", event_history: [], purchase_price: Int(self.purchase_price.text!)!, road: (self.road_btn.titleLabel?.text)!, object_name: (self.street_btn.titleLabel!.text)!, rules: "nil", landlord_id: glo_account_id, floor: self.floor.text!, area: 40.5, image_url: [], tenant_id: "nil", full_address: self.full_address.text!, rent: Int(4000), parking_space: self.parking_space.text!, object_id: d_object_id, region: (self.region_btn.titleLabel!.text)!, description: self.intro.text!, system_id: glo_account_system_id, group_name: glo_BuildingList[self.sel_group_index].name, street: self.street_btn.titleLabel!.text!, type: self.propertytype_to_eng(sel_type: (self.type_btn.titleLabel!.text)!)))

                                
                            
                              
                                if ( self.imgList.count > 1){
                                for i in 1 ... self.imgList.count - 1{
                                    self.group.enter()
                                    self.myDataQueue.async (group: self.group){
                                        glo_BuildingList[self.sel_group_index].property_items[glo_BuildingList[self.sel_group_index].property_items.count - 1].ImgList.append(self.imgList[i])
                                        self.insert_property_img_api(select_Image: self.imgList[i])
                                        
                                    }
                                        
                                }
                                }
                                
                                self.group.notify(queue: DispatchQueue.main ){
                                    //DispatchQueue.main.sync {
                                    self.delegate?.dismissBack(sendData: "create")
                                                   
                                    self.dismiss(animated: true, completion: nil)
                                    //}
                                }
                                
                            }
                                //self.delegate?.dismissBack(sendData: "create")
              
                                //self.dismiss(animated: true, completion: nil)
                            
                            
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
    
    func insert_property_img_api(select_Image:UIImage){
    
        let base64img = image_to_base64(select_Image: select_Image)

        print(glo_BuildingList[self.sel_group_index].property_items.last!.object_id)
        print("glo_BuildingList[self.sel_group_index].property_items.last!.object_id")
          let json: [String: Any] = [
              "landlord_id": glo_account_id,
              "object_id" : glo_BuildingList[self.sel_group_index].property_items.last!.object_id,
              "image": [base64img]
              
          ]
          
          let jsonData = try? JSONSerialization.data(withJSONObject: json)
          
          // create post request
          let url = URL(string: api_host + api_basePath + "/propertymanagement/uploadpropertyimage")!
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
                        
                              DispatchQueue.main.async {
                        
                                self.group.leave()
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
    
    var imgList = [UIImage]()
    

    var sel_group_index = 0
    
    var delegate:DismissBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        button_style1(sel_button: sendbtn)
        imagecollection.delegate = self
        imagecollection.dataSource = self
        
        imgList.append(#imageLiteral(resourceName: "AddBlock"))
        
        button_style2(sel_button: region_btn)
        button_style2(sel_button: street_btn)
        button_style2(sel_button: road_btn)
        button_style2(sel_button: type_btn)
        
        
        insertregionList()
        
        
       
        
    }
    
    
    func photoButtonAction() {
        
        print("photoBtn.....")
        //do something ...
        
        let imageSelect = UIImagePickerController()
        imageSelect.sourceType = .photoLibrary
        imageSelect.delegate = self
        present(imageSelect,animated: true,completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[.originalImage] as? UIImage
        //var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //insert_photo_to_scroll(sel_image: image!)
        
        //sel_img.image = image!
        imgList.append(image!)
        imagecollection.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePropertyCell", for: indexPath) as! CreatePropertyCell
        
        
        cell.Img.image = imgList[indexPath.row]
        
        if (indexPath.row == 0 ){
            cell.removeBtn.isHidden = true
        }
        else{
            cell.removeBtn.isHidden = false
        }
        
        sel_Index = indexPath
        
        cell.delegate = self
        cell.removeBtn.addTarget(self, action: #selector(removeImg), for: UIControl.Event.touchUpInside)
        //cell.Icon.cornerRadius = ( cell.frame.width - 20 ) * 0.5
        
        
        
        return cell
        
        
    }
    
    @objc func removeImg(sender:UIButton){
        imgList.remove(at: sel_Index!.row)
        imagecollection.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ( ( collectionView.frame.size.width - 60 ) / 3 ) , height: ( ( collectionView.frame.size.width - 60 ) / 3 ) )
        
        
        
    }
    
    var sel_Index : IndexPath?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            photoButtonAction()
        }
        
        
        
        
        
    }
    
    func SelCellIndex(_ sender: Any){
        guard let tappedIndex = imagecollection.indexPath(for: sender as! RepairerReportImgCell) else {return}
        sel_Index = tappedIndex
        
    }
    
    
    
    
    
    
    
    
    
    
}

extension CreatePropertyViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        
        
        imgList.append((sendData as? UIImage)!)
        imagecollection.reloadData()
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
        
    }
}
