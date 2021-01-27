//
//  ContractViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class ContractViewController :UIViewController{
    
    
    @IBOutlet weak var CertificateView: UIView!
    @IBOutlet weak var ContractView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        CertificateView.isHidden = true
        ContractView.isHidden = false
        
        
    }
    
    
    @IBOutlet weak var segController: UISegmentedControl!
    
    @IBAction func segAction(_ sender: Any) {
        if ( ContractView.isHidden == false){
            ContractView.isHidden = true
            CertificateView.isHidden = false
        }
        else{
            ContractView.isHidden = false
            CertificateView.isHidden = true
            
        }
        
        
    }
    
    
    @IBAction func LeftSwipeAction(_ sender: Any) {
        segController.selectedSegmentIndex = 1
        
        ContractView.isHidden = true
        CertificateView.isHidden = false
        
    }
    
    @IBAction func RightSwipeAction(_ sender: Any) {
        segController.selectedSegmentIndex = 0
        ContractView.isHidden = false
        CertificateView.isHidden = true
        
    }
    
}
