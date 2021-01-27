//
//  CreateBuildingListViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/18.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit



class CreateBuildingListViewController : UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
   
    @IBOutlet weak var name_field: UITextField!
    
 
    
    @IBOutlet weak var sel_imgBtn: UIButton!
    
    @IBOutlet weak var sel_img: UIImageView!
    @IBAction func sel_img_Action(_ sender: Any) {
        photoButtonAction()
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if (update_name != ""){
            updatepropertygrouptag_api()  //只更新照片
        }
        else {
            createpropertygrouptag_api()
        }
        //dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextStepAction(_ sender: Any) {
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var sendbtn: UIButton!
    
    var update_name = ""
    var sel_index = 0
    
    var delegate : DismissBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        button_style2(sel_button: sel_imgBtn)
        button_style1(sel_button: sendbtn)
        
        
        if (update_name != ""){
            name_field.isUserInteractionEnabled = false
            name_field.text = update_name
            name_field.borderStyle = .none
        }
        
        
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
    
    func createpropertygrouptag_api(){
        
        var Imgbase64 = "nil"
        if (sel_img.image != nil){
            Imgbase64 = image_to_base64(select_Image: sel_img.image!)
        }
       
        
        let Group: [String: Any] = ["name": name_field.text! ,"image": Imgbase64]

        let json: [String: Any] = ["group": Group ,
                                     "id":glo_account_id,
                                     "system_id":glo_account_system_id]
                  
               let jsonData = try? JSONSerialization.data(withJSONObject: json)

               // create post request
               let url = URL(string: api_host + api_basePath + "/grouptagmanagement/creategrouptag")!
               var request = URLRequest(url: url)
               request.httpMethod = "POST"

                  // insert json data to the request
               request.httpBody = jsonData

               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   
                   

          
                   if let downloadedData = data{
                       do{
                           let decoder = JSONDecoder()
                           let eventdata = try decoder.decode(landlordopenpermission_data.self, from: downloadedData)
                          print(eventdata.Message)
                       
                          //User_Login += eventdata
                           
                           if (eventdata.Message == "No Error"){
                             
                              DispatchQueue.main.sync {
                                
                                glo_BuildingList.append(BuildingData(from: self.name_field.text! ,"nil"))
                                if (self.sel_img.image != nil){
                                    glo_BuildingList[glo_BuildingList.count - 1].image = self.sel_img.image!
                                }
                                
                                self.delegate?.dismissBack(sendData: "create")
                                self.dismiss(animated: true, completion: nil)
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
      
    
    func updatepropertygrouptag_api(){
      
      let Imgbase64 = image_to_base64(select_Image: sel_img.image!)
      
      let Group: [String: Any] = ["name": name_field.text! ,"image": Imgbase64]

      let json: [String: Any] = ["group": Group ,
                                   "id":glo_account_id,
                                   "group_index": sel_index,"system_id":glo_account_system_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/grouptagmanagement/updategrouptaginformation")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(landlordopenpermission_data.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        //User_Login += eventdata
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                            
                                glo_BuildingList[self.sel_index].image = self.sel_img.image!
                                
                                self.delegate?.dismissBack(sendData: "update1")
                              self.dismiss(animated: true, completion: nil)
                            }
                             
                         }
                   
               
                        self.delegate?.dismissBack(sendData: "update2")
                        
                         print("OK updatepropertygrouptag_api")

                     
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
    
    
}
