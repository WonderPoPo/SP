//
//  MaintainViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit



struct CreateEventDetailData :Codable {
    
    let initiate_id : String
    let system_id: String
    let timestmp: Int
    let type: String
    let status: String
    let object_id : String
    let participant: [Participant]
    let information: Information
    struct Participant :Codable {
        let id: String
        let auth: String
    }
    
    struct Information :Codable {
        let description: String
        let date: String
        let dynamic_status: [Dynamic_status]
        struct Dynamic_status :Codable {
            let description: String
            let date: String
            let image: [String?]
            
        }
    }
    
}


class MaintainViewImgCell :UICollectionViewCell{
    
    
    @IBOutlet weak var Img: UIImageView!
    
}

class MaintainViewController:UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    var currentTextView : UITextView?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phonenumber: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var repairtypebtn: UIButton!
    
    
    @IBOutlet weak var sel_property_label: UILabel!
    @IBOutlet weak var sel_property_Btn: UIButton!
    @IBAction func sel_propertyAction(_ sender: Any) {
        
        let storyboard = UIStoryboard( name: "PresentViewController", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "SelPropertyViewController" ) as! SelPropertyViewController
        
        VC.delegate = self
        present(VC, animated: true, completion: nil)

        
    }
    
  
    @IBAction func repairtypeAction(_ sender: Any) {
        let alertController = UIAlertController(
                           title: "列表可選擇",
                           message: "",
                           preferredStyle: .actionSheet)

           
        let cancelAction = UIAlertAction(
                           title: "取消",
                           style: .cancel,
                           handler: nil)

        alertController.addAction(cancelAction)


        let okAction1 = UIAlertAction(title: "維修",style: .default ){ (_) in
            self.repairtypebtn.setTitle("維修", for: .normal)
        }
        
        alertController.addAction(okAction1)
        /*
        let okAction2 = UIAlertAction(title: "租約",style: .default){ (_) in
            self.repairtypebtn.setTitle("租約", for: .normal)
        }
        alertController.addAction(okAction2)
        let okAction3 = UIAlertAction(title: "使用",style: .default){ (_) in
            self.repairtypebtn.setTitle("使用", for: .normal)
        }
               
        alertController.addAction(okAction3)
               
        let okAction4 = UIAlertAction(title: "其他",style: .default){ (_) in
            self.repairtypebtn.setTitle("其他", for: .normal)
        }
        alertController.addAction(okAction4)
        */
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var formtitle: UITextView!
    
    @IBOutlet weak var formcontent: UITextView!
    
    @IBAction func sel_imgAction(_ sender: Any) {
        
        photoButtonAction()
        
    }
    
   
    @IBOutlet weak var ImgCollection: UICollectionView!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        
        createevent_api()
        
    }
    
    func createevent_api(){
        print(gettimestmp())
     
        var event_type = "nil"
        if ( (repairtypebtn.titleLabel?.text!)! == "維修"){
            event_type = "maintain"
        }
        
        
        let eventjson = CreateEventDetailData(initiate_id: glo_account_id, system_id: glo_account_system_id, timestmp: Int(gettimestmp()), type: event_type, status: "nil", object_id: sel_property_id, participant: [], information: CreateEventDetailData.Information(description: formtitle.text, date: getdate(Date()), dynamic_status: []))
    
        print(eventjson)

        //let json: [EventDetailData] = [ eventjson]
                
  
        let encoder = JSONEncoder()
        let data = try? encoder.encode(eventjson)
        
        

             // create post request
             let url = URL(string: api_host + api_basePath + "/eventmanagement/createevent")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = data
        
        
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
                            
                            let d_event_id = d_Items["event_id"] as! String
                            DispatchQueue.main.sync {
                                self.updateeventinformation_api(event_id: d_event_id)
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
    
    func updateeventinformation_api(event_id:String){
        
  
          var imgbase64List = [String]()
          if ( ImgList.count > 0 ){
              for i in 0 ... ImgList.count - 1{
                  imgbase64List.append(image_to_base64(select_Image: ImgList[i]))
                  
              }
          }
    
          
          
        let updataevent = UpdateEventData(event_id: event_id,description: formtitle.text!, landlord_id : glo_root_id, dynamic_status: UpdateEventData.Dynamic_status(sender_id: glo_account_id , description: formcontent.text!, date: getdate(Date()), image: imgbase64List))
          
          print(updataevent)
          let encoder = JSONEncoder()
          let jsonData = try? encoder.encode(updataevent)
          
          //let jsonData = try? JSONSerialization.data(withJSONObject: json)
          
          // create post request
          let url = URL(string: api_host + api_basePath + "/eventmanagement/updateeventinformation")!
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
                         
                                    self.navigationController?.popViewController(animated: true)
                                
                                  //self.dismiss(animated: true, completion: nil)
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
    
    
    func getpropertybygrouptag_api(){
        
    

        let json: [String: Any] = ["landlord_id": glo_account_id,"group_name":self.title!]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/eventmanagement/createevent")!
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentTextView = textView
    }
    
    var ImgList = [UIImage]()
    
    var rect : CGRect?
    var sel_property_id = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        if (glo_account_auth != "landlord"){
            
            sel_property_Btn.isHidden = true
            sel_property_label.isHidden = true
            sel_property_id = glo_tenant_object_id // tenant只有一個object
        }
        
        
        
        ImgCollection.delegate = self
        ImgCollection.dataSource = self
        
        button_style2(sel_button: repairtypebtn)
        button_style2(sel_button: sel_property_Btn)
        
        rect = view.bounds
        
        name.text = "jason"
        phonenumber.text = "0987766654"
        email.text = "jason@gmail.com"
        
       // button_style2(sel_button: sel_property_Btn)
        //button_style2(sel_button: repairtypebtn)
        button_style1(sel_button: sendBtn)
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
        ImgList.append(image!)
        
        ImgCollection.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
  @objc func keyboardWillShow(note: NSNotification) {
    if (currentTextView == nil){
        return
    }

        let userInfo = note.userInfo!
  
        let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let origin = (currentTextView?.frame.origin)!
    
        let height = (currentTextView?.frame.size.height)!
     
        let targetY = origin.y + height
      
        let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height

  
        if targetY >= visibleRectWithoutKeyboard {
            var rect = self.rect!
        
            rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + 5

            UIView.animate(
                withDuration: duration,
                animations: { () -> Void in
                    self.view.frame = rect
                }
            )
        }
    }

    
    @objc func keyboardWillHide(note: NSNotification) {
    
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)

        UIView.animate(
            withDuration: duration,
            animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
            }
        )
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
                  return 1
                    
              }
                
              func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

                return ImgList.count
              }
                
                
                
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaintainViewImgCell", for: indexPath) as! MaintainViewImgCell

               
                cell.Img.image = ImgList[indexPath.row]
                
                       
                return cell
                
               
            }
        
        
       
         
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             
            return CGSize(width: 140 , height:  140 )
                
        
                 
        }
    
    
    
}

extension MaintainViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        print(sendData)
        let property_data = sendData as! propertyDetailData
        sel_property_id = property_data.object_id
        sel_property_Btn.setTitle(property_data.full_address, for: .normal)
       // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!

    }
    

}
