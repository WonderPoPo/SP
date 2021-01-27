//
//  CreateHouseRuleViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/22.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


class CreateHouseRuleViewController : UIViewController  {

    @IBOutlet weak var ruletext: UITextView!
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func sendAction(_ sender: Any) {
        delegate?.dismissBack(sendData: ruletext.text)
        dismiss(animated: true, completion: nil)
    }
    
    var pass_text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
  
        ruletext.text = pass_text
        hideKeyboardWhenTappedAround()
        
        button_style1(sel_button: sendBtn)
        
        
        if ( glo_account_auth == "tenant"  ){
            glo_tenant_object_id = sel_object_id
        }
        
    }
    
  
    
    
      struct updateequipmentData : Codable{
          let landlord_id : String
          let object_id : String
          let equipment : equipmentData
          struct  equipmentData : Codable{
              let title : String
              let information : informationData
              struct  informationData : Codable{
                  let name : String
                  let count : Int
                  let image : [String]
              }
          }
          
          
      }
          
    var delegate : DismissBackDelegate?
     var sel_object_id = ""
    
    
 
}


