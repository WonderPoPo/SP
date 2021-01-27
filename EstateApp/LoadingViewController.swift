//
//  LoadingViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/12.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit



extension UIViewController {
    
    func present_loading_VC(){
        let storyboard = UIStoryboard( name: "PresentViewController", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "LoadingViewController" ) as! LoadingViewController
        
        present(VC, animated: false, completion: nil)
        
    }
    
    
    
    func dismiss_loading_VC(){
        DispatchQueue.main.async{
            
            self.dismiss(animated: false, completion: nil)
        }
    }
}

class LoadingViewController : UIViewController{
    
    
    
}
