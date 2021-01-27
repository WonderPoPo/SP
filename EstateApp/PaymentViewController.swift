//
//  PaymentViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class PaymentViewController:UIViewController{
    
    @IBOutlet weak var lastpaiddate: UILabel!
    @IBOutlet weak var paydate: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    @IBAction func payAction(_ sender: Any) {
        payrent_api()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        button_style1(sel_button: payBtn)
        
        
        lastpaiddate.text = "2020/10/01"
        paydate.text = "2020/11/01"
        amount.text = "3000"
    }
    
    struct Transaction_informationData {
        let test = "test"
    }
    //var Transaction_information : Transaction_informationData?
    
    func payrent_api(){
        print(glo_tenant_object_id)
    
        let Transaction_information: [String: Any] = [:]
    
        let json: [String: Any] = ["user_id": glo_account_id , "system_id" : glo_account_system_id , "transaction_information": Transaction_information,"type": "rent","object_id": glo_tenant_object_id,"amount": Int(amount.text!)]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/paymentmanagement/createpayment")!
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
    
}
