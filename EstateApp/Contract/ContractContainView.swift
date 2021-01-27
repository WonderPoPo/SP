//
//  ContractContainView.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class ContractContainView: UIViewController{
    var checkbox_status = false
    
    @IBOutlet weak var checkbox: UIButton!
    
    @IBOutlet weak var SignImg: UIImageView!
    
    @IBOutlet weak var contract_Content: UITextView!
    var Signdata : UIImage?
    
    @IBAction func SignaAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "PresentViewController", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "SignDrawViewController" ) as! SignDrawViewController
        
        VC.delegate = self
        present(VC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func checkbox_Action(_ sender: Any) {
        if ( checkbox_status == false ) {
            checkbox_status = true
            checkbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            
        }
        else{
            checkbox_status = false
            checkbox.setImage(UIImage(systemName: "square"), for: .normal)
            
        }
        
    }
}


protocol  DismissBackDelegate {
    func dismissBack(sendData :Any)
}

extension ContractContainView : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        SignImg.image = sendData as? UIImage
       // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!

    }
}
