//
//  CreateStaffViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/23.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit



struct  landlordopenpermission_data : Decodable{
    let Message : String
}

struct createstaffData : Codable{
    let name : String
  
}

class CreateStaffViewController : UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    
    @IBOutlet weak var auth_btn: UIButton!
    
    @IBAction func authAction(_ sender: Any) {
        if (selected_object == true){
            return
        }
        let alertController = UIAlertController(
            title: "身份類別可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        
        
        let okAction1 = UIAlertAction(title: "租客",style: .default ){ (_) in
            self.auth_btn.setTitle("租客", for: .normal)
        }
        alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "維修人員",style: .default){ (_) in
            self.auth_btn.setTitle("維修人員", for: .normal)
        }
        alertController.addAction(okAction2)
        let okAction3 = UIAlertAction(title: "會計師",style: .default){ (_) in
            self.auth_btn.setTitle("會計師", for: .normal)
        }
        
        alertController.addAction(okAction3)
        
        let okAction4 = UIAlertAction(title: "管理",style: .default){ (_) in
            self.auth_btn.setTitle("管理", for: .normal)
        }
        alertController.addAction(okAction4)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var permission_btn: UIButton!
    
    @IBAction func permissionAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "目前權限可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        let okAction1 = UIAlertAction(title: "所有權限",style: .default ){ (_) in
            self.permission_btn.setTitle("所有權限", for: .normal)
        }
        alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "只可編輯",style: .default){ (_) in
            self.permission_btn.setTitle("只可編輯", for: .normal)
        }
        alertController.addAction(okAction2)
        let okAction3 = UIAlertAction(title: "只可觀看",style: .default){ (_) in
            self.permission_btn.setTitle("只可觀看", for: .normal)
        }
        
        alertController.addAction(okAction3)
        
        let okAction4 = UIAlertAction(title: "沒有權限",style: .default){ (_) in
            self.permission_btn.setTitle("沒有權限", for: .normal)
        }
        alertController.addAction(okAction4)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var comfirmBtn: UIButton!
    @IBAction func comfirmAction(_ sender: Any) {
        createaccount_api()
        
        //landlordopenpermission_api()
        
        
    }
    
    @IBOutlet weak var sel_propertyBtn: UIButton!
    @IBAction func sel_propertyAction(_ sender: Any) {
        if (selected_object == true){
            return
        }
        let storyboard = UIStoryboard( name: "PresentViewController", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "SelPropertyViewController" ) as! SelPropertyViewController
        
        VC.delegate = self
        present(VC, animated: true, completion: nil)
        
    }
    
    var selected_object = false
    
    var sel_property_id = ""
    
    var create_type = ""

    var sel_object_full_address = ""
    
    var delegate : DismissBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        hideKeyboardWhenTappedAround()
        
        button_style1(sel_button: comfirmBtn)
        button_style2(sel_button: auth_btn)
        button_style2(sel_button: permission_btn)
        button_style2(sel_button: sel_propertyBtn)
        
        if (create_type == "tenant"){
            self.auth_btn.setTitle("租客", for: .normal)
            self.sel_propertyBtn.setTitle(sel_object_full_address, for: .normal)
        }
        
        
        
        
    }
    
    
    
    func createaccount_api( ){
        
        let sel_auth = auth_chinese_to_eng(sel_auth: (auth_btn.titleLabel?.text!)!)
        print(sel_property_id)
        print(sel_auth)
        
        var informationdata: [String: Any] = ["name": name.text!, "sex":"nil", "mail":"nil","phone":phonenumber.text, "annual_income":"nil", "industry":"nil","icon":"nil","profession":"nil"]
       
        var json: [String: Any] = [:]
        if ( sel_auth == "tenant"){
            json = ["auth": sel_auth, "root_id": glo_account_id, "object_id":sel_property_id ,"information":informationdata]
        }
        else{
            json = ["auth": sel_auth,  "root_id":glo_account_id ,"information":informationdata]
        }
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/accountmanagement/createaccountbylandlord")!
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
                            let d_user_id = d_Items["user_id"] as! String
                            DispatchQueue.main.async {
                                self.delegate?.dismissBack(sendData: passdata1(type: "tenant_id", any_data: d_user_id))
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
    
    func landlordopenpermission_api(){
        
        let temp_auth = auth_chinese_to_eng(sel_auth: (auth_btn.titleLabel?.text!)!)
        
        var temp_permission = ""
        if ( temp_permission == "所有權限"){
            temp_permission = "A"
        }
        else if ( temp_permission == "只可編輯"){
            temp_permission = "W"
        }
        else if ( temp_permission == "只可觀看"){
            temp_permission = "R"
        }
        else if ( temp_permission == "沒有權限"){
            temp_permission = "N"
        }
        
    }
    
    
    
}



extension CreateStaffViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        let property_data = sendData as! propertyDetailData
        sel_property_id = property_data.object_id
        sel_propertyBtn.setTitle(property_data.full_address, for: .normal)
        
        //sel_propertyBtn.setTitle(sel_property_id, for: .normal)
        print(sel_propertyBtn.titleLabel?.text)
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
        
    }
    
    
}
