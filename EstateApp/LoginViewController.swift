//
//  LoginViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import SwiftCSV






struct login_data : Decodable{
    let Message :String
}

struct user_info_data : Decodable{
    let Items : Items
    let Message :String
    
    struct Items : Decodable{

        let auth:String
        let information : Information
        let permissions : String
        let pw: String
        let id: String
        let system_id : String
        let lists:Lists

        struct Information : Decodable{
            let name: String
            let mail: String
            let icon: String
        }
        
        struct Lists : Decodable{
            let accountant: [String]
            let agent: [String]
            let contract: [String]
            let event : [String]
            let group : [Group]
            let technician : [String]
            let tenant : [String]
            
            struct Group : Decodable{
                let name: String
                let image: String
          
            }
        }
        
    }
}


var glo_accountinfo : user_info_data?


struct property_group_item : Decodable{
    let title:String
    

    init(from  title_D : String){
        self.title = title_D

    }

}


class LoginViewController:UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var account_id: UITextField!
    
    @IBOutlet weak var account_pw: UITextField!
    
    @IBOutlet weak var pw_display_Btn: UIButton!
    
    @IBAction func pw_displayAction(_ sender: Any) {
   
        if (account_pw.isSecureTextEntry == true){
            account_pw.isSecureTextEntry = false
            pw_display_Btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            pw_display_Btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        else{
            account_pw.isSecureTextEntry = true
            pw_display_Btn.setImage(UIImage(systemName: "eye"), for: .normal)
            pw_display_Btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    
        
    }
    
    @IBAction func login_Action(_ sender: Any) {
        
        present_loading_VC()
        send_login_api()
        
        
        
    }
    
    
    
    @IBAction func landlordAction(_ sender: Any) {
        glo_account_auth = "landlord"
        landlord_auth_present()
        
    }
    
    
    @IBAction func tenantAction(_ sender: Any) {
        glo_account_auth = "tenant"
        tenant_auth_present()
        
    }
    
 
    
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var contantusLabel: UILabel!
    
    
    func landlord_auth_present(){
        glo_account_auth = "landlord"
        let storyboard = UIStoryboard( name: "LandlordMain", bundle: .main )
                      
        let VC = storyboard.instantiateViewController( withIdentifier: "LandlordTabBarController" ) as! LandlordTabBarController
              
        present(VC, animated: true, completion: nil)
                      
    }
    
    func tenant_auth_present(){
        glo_account_auth = "tenant"
        let storyboard = UIStoryboard( name: "Main", bundle: .main )
           
        let VC = storyboard.instantiateViewController( withIdentifier: "TenantTabBarController" ) as! TenantTabBarController
           
        
        present(VC, animated: true, completion: nil)
           
        
    }
    
    func technician_auth_present(){
        glo_account_auth = "technician"
        
        let storyboard = UIStoryboard( name: "Main", bundle: .main )
           
        let VC = storyboard.instantiateViewController( withIdentifier: "TenantTabBarController" ) as! TenantTabBarController
        
        
        present(VC, animated: true, completion: nil)
           
        
    }
 

    var currentTextField: UITextField?
    
      var rect: CGRect?

      func textFieldDidBeginEditing(_ textField: UITextField) {
      
          currentTextField = textField
      }
    
    var contantustextArray = [String]()
    var contantusfonttextArray = [UIFont]()
    var contantuscolortextArray = [UIColor]()
    
    var policytextArray = [String]()
    var policyfonttextArray = [UIFont]()
    var policycolortextArray = [UIColor]()
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
        pw_display_Btn.setImage(UIImage(systemName: "eye"), for: .normal)
        pw_display_Btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        account_id.delegate = self
        account_pw.delegate = self
        
        
        account_id.text = "jason9071"
        account_pw.text = "123456"
          
          hideKeyboardWhenTappedAround()
          
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
          
          
          rect = view.bounds
        
        
        /// policy label setting
        
       
        
        contantustextArray.append("還不是會員？請")
        contantustextArray.append("聯繫我們")
        
        contantusfonttextArray.append(UIFont.systemFont(ofSize: 12))
        contantusfonttextArray.append(UIFont.systemFont(ofSize: 13))
        
        contantuscolortextArray.append(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        contantuscolortextArray.append(maincolor2)
        
      
        
        self.contantusLabel.attributedText = getAttributedString(arrayText: contantustextArray, arrayColors: contantuscolortextArray, arrayFonts: contantusfonttextArray)
        self.contantusLabel.isUserInteractionEnabled = true
        let contantustapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnContantUsLabel(_ :)))
        contantustapgesture.numberOfTapsRequired = 1
        self.contantusLabel.addGestureRecognizer(contantustapgesture)
        
        //////////////////////////////////////////
        
        
        
        
        policytextArray.append("繼續使用Smart Perty，既表示\n您已同意")
        policytextArray.append("使用條款")
        policytextArray.append("和")
        policytextArray.append("隱私條款")
        
        policyfonttextArray.append(UIFont.systemFont(ofSize: 12))
        policyfonttextArray.append(UIFont.systemFont(ofSize: 13))
        policyfonttextArray.append(UIFont.systemFont(ofSize: 12))
        policyfonttextArray.append(UIFont.systemFont(ofSize: 13))
        
        policycolortextArray.append(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        policycolortextArray.append(maincolor2)
        policycolortextArray.append(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        policycolortextArray.append(maincolor2)
        
        
        self.policyLabel.attributedText = getAttributedString(arrayText: policytextArray, arrayColors: policycolortextArray, arrayFonts: policyfonttextArray)
        self.policyLabel.isUserInteractionEnabled = true
        let policytapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        policytapgesture.numberOfTapsRequired = 1
        self.policyLabel.addGestureRecognizer(policytapgesture)
        
      }
    
    func getAttributedString(arrayText:[String]?, arrayColors:[UIColor]?, arrayFonts:[UIFont]?) -> NSMutableAttributedString {

        let finalAttributedString = NSMutableAttributedString()

        for i in 0 ..< (arrayText?.count)! {

            let attributes = [NSAttributedString.Key.foregroundColor: arrayColors?[i], NSAttributedString.Key.font: arrayFonts?[i]]
            let attributedStr = (NSAttributedString.init(string: arrayText?[i] ?? "", attributes: attributes as [NSAttributedString.Key : Any]))

            if i != 0 {

                finalAttributedString.append(NSAttributedString.init(string: " "))
            }

            finalAttributedString.append(attributedStr)
        }

        return finalAttributedString
    }
    
    @objc func tappedOnContantUsLabel(_ gesture: UITapGestureRecognizer){
        if let text = self.contantusLabel.text {
            let tapRange1 = (text as NSString).range(of: contantustextArray[1])
            print(tapRange1)
            if gesture.didTapAttributedTextInLabel(label: self.contantusLabel, inRange: tapRange1) {
                performSegue(withIdentifier: "websegue", sender: self)
                
            }
        }
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer){
        
     
        if let text = self.policyLabel.text {
            let tapRange1 = (text as NSString).range(of: policytextArray[1])
            let tapRange2 = (text as NSString).range(of: policytextArray[3])
            
            print(tapRange1)
            print(tapRange2)
            if gesture.didTapAttributedTextInLabel(label: self.policyLabel, inRange: tapRange1) {
                performSegue(withIdentifier: "userpolicysegue", sender: self)
                
            } else if gesture.didTapAttributedTextInLabel(label: self.policyLabel, inRange: tapRange2){
                performSegue(withIdentifier: "privacypolicysegue", sender: self)
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    func send_login_api(){
        
        if (account_id.text! == "re"){
            glo_account_auth = "technician"
            self.technician_auth_present()
            return
        }
        
        if (account_id.text! == "" || account_pw.text! == "" ){
            return
        }

        let json: [String: Any] = ["id": account_id.text!,"pw":account_pw.text!,"platform" : "IOS"]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/accountmanagement/userlogin")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(login_data.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        //User_Login += eventdata
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                                self.get_user_info_api(sel_id: self.account_id.text!)
                            }
                             
                         }
                        else if (eventdata.Message == "Login Failed"){
                            self.dismiss_loading_VC()
                             
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
                            glo_account_id = sel_id
                            glo_account_system_id = d_system_id
                            
                            let d_auth = d_Items["auth"] as! String
                            
                            print(d_Items["auth"] as! String)
                            glo_account_auth = d_auth
                            
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            let d_sex = d_information["sex"] as! String
                            glo_account_sex = d_sex
                            let d_name = d_information["name"] as! String
                            glo_account_name = d_name
                            
                
                            
                            let d_icon = d_information["icon"] as! String
                            glo_account_icon_url = d_icon
                            let d_mail = d_information["mail"] as! String
                            glo_account_mail = d_mail
                            let d_phone = d_information["phone"] as! String
                            glo_account_phone = d_phone
                            let d_annual_income = d_information["annual_income"] as! String
                            glo_account_annual_income = d_annual_income
                            let d_industry = d_information["industry"] as! String
                            glo_account_industry = d_industry
                            let d_profession = d_information["profession"] as! String
                            glo_account_profession = d_profession
                            
                            if (glo_account_auth == "landlord") {
                                let d_lists = d_Items["lists"] as! Dictionary<String,Any>
                                
                                let d_tenant = d_lists["tenant"] as! [String]
                                let d_technician = d_lists["technician"] as! [String]
                                let d_agent = d_lists["agent"] as! [String]
                                let d_accountant = d_lists["accountant"] as! [String]
                                
                                glo_staff_tenant_id_list = d_tenant
                                glo_staff_technician_id_list = d_technician
                                glo_staff_agent_id_list = d_agent
                                glo_staff_accountant_id_list = d_accountant
                            }
                            

                            
                            DispatchQueue.main.sync {
                                self.dismiss_loading_VC()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    if (d_auth == "landlord"){
                                        
                                        self.landlord_auth_present()
                                        
                                        
                                    }
                                    else if (d_auth == "tenant"){
                                        glo_tenant_object_id = d_Items["object_id"] as! String
                                        self.tenant_auth_present()
                                    }
                                    else if (d_auth == "technician"){
                                        self.technician_auth_present()
                                    }
                                    else if (d_auth == "accountant"){
                                        //self.tenant_auth_present()
                                    }
                                    else if (d_auth == "agent"){
                                        //self.tenant_auth_present()
                                    }
                                    else if (d_auth == "admin"){
                                        //self.tenant_auth_present()
                                    }
                                }
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
      
      
    @objc func keyboardWillShow(note: NSNotification) {
      if (currentTextField == nil){
          return
      }

          let userInfo = note.userInfo!
    
          let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
          let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
          
          let origin = (currentTextField?.frame.origin)!
      
          let height = (currentTextField?.frame.size.height)!
       
          let targetY = origin.y + height
        
          let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height

    
          if targetY >= visibleRectWithoutKeyboard {
              var rect = self.rect!
          
              rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + 80

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
}


extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        //indexOfCharacter = indexOfCharacter + 4

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
