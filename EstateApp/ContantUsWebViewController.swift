//
//  ContantUsWebViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/7.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import WebKit

class ContantUsWebViewController : UIViewController{

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = "https://www.google.com.tw/"
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        
    }
    
    
}
