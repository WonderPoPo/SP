//
//  TenantTabBarController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/2.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class TenantTabBarController:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
       selectedIndex = 1
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.tintColor = tabbartint
    }
    
  
}
