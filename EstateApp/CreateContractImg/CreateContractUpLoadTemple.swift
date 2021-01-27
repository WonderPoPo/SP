//
//  CreateContractUpLoadTemple.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class CreateContractUpLoadTemple :UIViewController, UITextViewDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button_style1(sel_button: sendBtn)
        
        hideKeyboardWhenTappedAround()
  
        doc_temple.delegate = self
    }
    
    
    @IBOutlet weak var doc_temple: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        send_temple_api()
        
    }
    func send_temple_api( ){
        

        
          let json: [String: Any] = ["landlord_id": glo_account_id ,
         "contract_id": CreateContract_sel_contract_id,
         "type": "TXT",
         "document": doc_temple.text ]
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/contractmanagement/uploadcontractdocument")!
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
                            DispatchQueue.main.sync {
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
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         
  
         view.endEditing(true)
     }
    
}
