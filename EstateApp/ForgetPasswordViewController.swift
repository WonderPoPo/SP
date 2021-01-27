//
//  ForgetPasswordViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/7.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class ForgetPasswordViewController : UIViewController {
    
    
    @IBOutlet weak var account_id: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var getcodeBtn: UIButton!
    @IBAction func getcodeAction(_ sender: Any) {
        forget_pw_api()
        
    }
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        //forget_pw_api()
        
    }
    
    @IBOutlet weak var contantusLabel: UILabel!
    
    var contantustextArray = [String]()
    var contantusfonttextArray = [UIFont]()
    var contantuscolortextArray = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button_style2(sel_button: getcodeBtn)
        button_style1(sel_button: sendBtn)
        
        
        contantustextArray.append("如持續遇到問題，請")
          contantustextArray.append("聯繫我們")
          
          contantusfonttextArray.append(UIFont.systemFont(ofSize: 12))
          contantusfonttextArray.append(UIFont.systemFont(ofSize: 13))
          
          contantuscolortextArray.append(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
          contantuscolortextArray.append(maincolor2)
          
        
          
          self.contantusLabel.attributedText = getAttributedString(arrayText: contantustextArray, arrayColors: contantuscolortextArray, arrayFonts: contantusfonttextArray)
          self.contantusLabel.isUserInteractionEnabled = true
          let contantustapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
          contantustapgesture.numberOfTapsRequired = 1
          self.contantusLabel.addGestureRecognizer(contantustapgesture)
    }
    
    
    func forget_pw_api(){
              
    
        let json: [String: Any] = ["id": account_id.text,
                                   "phone": phoneTextField.text ]
                      
                   let jsonData = try? JSONSerialization.data(withJSONObject: json)

                   // create post request
                   let url = URL(string: api_host + api_basePath + "/accountmanagement/forgotpassword")!
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
    
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer){
        if let text = self.contantusLabel.text {
            let tapRange1 = (text as NSString).range(of: contantustextArray[1])
            print(tapRange1)
            if gesture.didTapAttributedTextInLabel(label: self.contantusLabel, inRange: tapRange1) {
                performSegue(withIdentifier: "websegue", sender: self)
                
            }
        }

    }
    
    
}
