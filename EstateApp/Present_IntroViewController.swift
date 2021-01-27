//
//  Present_IntroViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


class Present_IntroViewController :UIViewController{
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        textView.clipsToBounds = true
        textView.layer.masksToBounds = false
        textView.layer.cornerRadius = 20
        textView.layer.shadowColor = UIColor.lightGray.cgColor
        textView.layer.shadowOpacity = 0.8
        textView.layer.shadowOffset = CGSize(width: 0.8, height: 2.0)
        textView.layer.shadowRadius = 2
        
    }
    
    @IBAction func Tap_Action(_ sender: Any) {
        print("Tap")
        if ( self.view.isHidden == false ){
            DispatchQueue.main.async{
                       
                UIView.animate(withDuration: 0.3) {
                    self.view.alpha = 0
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
        
    }
    
    
    
    
    func present_message_VC() -> Present_IntroViewController {
        print("present_VC")
        let storyboard = UIStoryboard( name: "Main", bundle: .main )
    
        let VC = storyboard.instantiateViewController( withIdentifier: "Present_IntroViewController" ) as! Present_IntroViewController
        return VC
    }
}
