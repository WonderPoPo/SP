//
//  ShowImageViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/7.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

var glo_show_Img : UIImage?

class ShowImageViewController :UIViewController{
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var Img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Img.image = glo_show_Img
        
    }
    
    
    
    
    
    
}
/*
glo_show_Img = 
@objc func showImageAction (_ gesture: UITapGestureRecognizer){
    
    let storyboard = UIStoryboard( name: "PresentViewController", bundle: .main )
    
    let VC = storyboard.instantiateViewController( withIdentifier: "ShowImageViewController" ) as! ShowImageViewController
    
    
    present(VC, animated: true, completion: nil)
    
    
    
}

*/


