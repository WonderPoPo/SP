//
//  LandlordTabBarController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/2.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit



class LandlordTabBarController:UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 2
        
        self.delegate = self
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.tintColor = tabbartint
       
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if ( item == (tabBar.items)![0]){
          
            
            let storyboard = UIStoryboard( name: "LandlordMain", bundle: .main )
            
            let VC = storyboard.instantiateViewController( withIdentifier: "NavConsoleViewController" )
            
       
        
            //present(VC, animated: true, completion: nil )
            
            
            
            
        }
        
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("FK")
        return true
    }
    
    
    
    
}
