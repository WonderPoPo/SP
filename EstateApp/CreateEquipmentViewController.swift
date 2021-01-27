//
//  CreateEquipmentViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/19.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


struct equipmentData : Codable{
    let landlord_id : String
    let object_id : String
    let equipment : [equipmentData]
    struct  equipmentData : Codable{
        let title : String
        let information : [informationData]
        struct  informationData : Codable{
            let name : String
            let count : Int
            let image : [String]
        }
    }
    
    
}


class CreateEquipmentViewController : UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

   

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var placetextField: UITextField!
    @IBOutlet weak var selplaceBtn: UIButton!
    
    var equipmentList = ["房間","客廳","陽台"]
    @IBAction func selplaceAction(_ sender: Any) {
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
               while ( n < equipmentList.count){
                   let okAction1 = UIAlertAction(title: equipmentList[n],style: .default   ){ (action:UIAlertAction!) in
                       
                   
                       print(action.title)
                    let cur_n = self.equipmentList.firstIndex(where: {$0 == action.title})
                       print(cur_n)
                
                  
                    self.placetextField.text = self.equipmentList[cur_n!]
                       
                  
                       
                   }
                   
                   alertController.addAction(okAction1)
                   
                   
                   
                   n += 1
               }

                   
                   

                   // 顯示提示框
               self.present(alertController, animated: true, completion: nil)
               
    }
    
    @IBOutlet weak var place_objecttextField: UITextField!
    @IBOutlet weak var place_objectnumtextField: UITextField!
    
    @IBOutlet weak var sel_imgBtn: UIButton!
    @IBAction func sel_imgAction(_ sender: Any) {
        photoButtonAction()
    }
    
    @IBOutlet weak var sel_img: UIImageView!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        updatepropertyqeuipment_api()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
  
        hideKeyboardWhenTappedAround()
        
        button_style1(sel_button: sendBtn)
        button_style3(sel_button: selplaceBtn)
        button_style2(sel_button: sel_imgBtn)
        
        if ( glo_account_auth == "tenant"  ){
            glo_tenant_object_id = sel_object_id
        }
        
    }
    
  
    
    
      
          
    var delegate : DismissBackDelegate?
     var sel_object_id = ""
    
    
    func updatepropertyqeuipment_api(){
        
        var Imgbase64 = "nil"
        if (sel_img.image != nil){
            Imgbase64 = image_to_base64(select_Image: sel_img.image!)
        }
        else{
            Imgbase64 = "nil"
        }
      
        print(glo_root_id)
        print(sel_object_id)
        
        
        let equipjson = equipmentData(landlord_id: glo_root_id, object_id: sel_object_id, equipment: [equipmentData.equipmentData(title: placetextField.text!, information: [equipmentData.equipmentData.informationData(name: place_objecttextField.text!, count: Int(place_objectnumtextField.text!)!, image: [Imgbase64])])])
        print(equipjson)
        
        print("OKOK")
 
            let encoder = JSONEncoder()
            let jsonData = try? encoder.encode(equipjson)

             // create post request
             let url = URL(string: api_host + api_basePath + "/propertymanagement/uploadpropertyequipment")!
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
                                 
                                //self.delegate?.dismissBack(sendData: <#T##Any#>)
                                DispatchQueue.main.sync {
                                    
                                    self.delegate?.dismissBack(sendData: equipjson)
                                    self.dismiss(animated: true, completion: nil)
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
    
        sel_img.image = image!
           
        dismiss(animated: true, completion: nil)
    }

}


