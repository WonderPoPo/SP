//
//  ShowContractViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/13.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import PDFKit
import WebKit
import MobileCoreServices


class ContractImgCell : UITableViewCell{
    
    
    @IBOutlet weak var Img: UIImageView!
    
}

class ShowContractViewController :UIViewController, UIDocumentPickerDelegate,UITableViewDelegate , UITableViewDataSource{
    let webView = WKWebView()
    var sel_contract_document = ""
    var sel_contract_document_imglist = [String]()
    var sel_contract_imglist = [UIImage?]()
    @IBOutlet weak var ImgTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "合約"
        ImgTable.delegate = self
        ImgTable.dataSource = self
        
        if (sel_contract_document_imglist.count != 0){   // JPG
            webView.isHidden = true
            download_image()
            
        }
        else{
            let urlStr = sel_contract_document
           
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
            
            
            self.view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 0).isActive = true
            webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: 0).isActive = true
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        }
        
        
        
        
        
        
        //contractBtnAction()
        
    }
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
      let group : DispatchGroup = DispatchGroup()
      
    func download_image(){
         

         if ( sel_contract_document_imglist.count == 0){
             return
         }
         for i in 0 ... sel_contract_document_imglist.count - 1{
             sel_contract_imglist.append(nil)
             
             self.group.enter()
             myDataQueue.async (group: group){
                var loading_img = url_to_image(url: (URL(string:self.sel_contract_document_imglist[i])!))
                 DispatchQueue.main.sync{
                    
                    self.sel_contract_imglist[i] = loading_img
                    self.ImgTable.reloadData()
                 }
                 self.group.leave()
             }
             
         }
         
         group.notify(queue: DispatchQueue.main ){
             
             print("fin")
             
             DispatchQueue.main.async {
                 
                
                 self.ImgTable.reloadData()
                 
                 
                 
             }
             
             
         }
         
         
         
     }

     
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //return total_cell_count()
         
         
         return sel_contract_imglist.count
         
         
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ContractImgCell", for: indexPath) as! ContractImgCell
         
         
         
        cell.Img.image = sel_contract_imglist[indexPath.row]
         
         
         return cell
     }
     
}
