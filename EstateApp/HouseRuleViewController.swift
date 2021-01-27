//
//  HouseRuleViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class HouseRuleViewController:UIViewController{
    
    @IBAction func createHouseRule(_ sender: Any) {
        
        let storyboard = UIStoryboard( name: "CreatePage", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "CreateHouseRuleViewController" ) as! CreateHouseRuleViewController
        
        VC.pass_text = rulecontent.text!
        VC.delegate = self
        present(VC, animated: true, completion: nil)
    }
    @IBOutlet weak var rulecontent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        rulecontent.text = "-不能抽煙\n-$5/度\n\n\n\n\n\n\n\n\n-WiFi:smartperty506\n  密碼:8888"
    }
    
    
}

extension HouseRuleViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        rulecontent.text = sendData as! String
        
        
    }
    
    
}
