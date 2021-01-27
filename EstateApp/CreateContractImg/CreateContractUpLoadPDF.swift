//
//  CreateContractUpLoadPDF.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateContractUpLoadPDF :UIViewController, UIDocumentPickerDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button_style2(sel_button: sel_pdfBtn)
        button_style1(sel_button: sendBtn)
        
    }
    
    
    
    @IBOutlet weak var sel_pdfBtn: UIButton!
    @IBAction func sel_pdfAction(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        send_pdf_api()
        
    }
    var parepare_send_data :Data?
    
    func send_pdf_api( ){
        var  filestr = parepare_send_data!.base64EncodedString()

        print(glo_account_id)
        print(CreateContract_sel_contract_id)
        print("FFFFFF")
        
          let json: [String: Any] = ["landlord_id": glo_account_id ,
         "contract_id": CreateContract_sel_contract_id,
         "type": "PDF",
         "document": filestr ]
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/contractmanagement/uploadcontractdocument")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let downloadedData = data{
                do{
                    let data_JSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                    
                    if let data_JSON = data_JSON {
                        
                        print(data_JSON )
                        if (data_JSON == nil){
                            print("YA")
                            return
                        }
                        
                        
                        let d_message:String = data_JSON["Message"] as Any as! String
                        if (d_message == "No Error"){
                            DispatchQueue.main.sync {
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        }
                        
                    }
                    
                    print("OK get_user_info_api")
                    
                    
                }
                catch{
                    
                    print(error)
                    print("something wrong after downloaded")
                }
            }
            else {
                print("no data")
                
            }
            
            
            
        }
        
        task.resume()
    }
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        print("WWWW")
        guard let selectedFileURL = urls.first else {
            print("selectedFileURL!!")
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        //print(dir)
        //print(sandboxFileURL)
        //print(selectedFileURL.lastPathComponent)
        
        sel_pdfBtn.setTitle(selectedFileURL.lastPathComponent, for: .normal)
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
            //send_contract_api(FileData: try! Data(contentsOf: sandboxFileURL))
            parepare_send_data = try! Data(contentsOf: sandboxFileURL)
        }
        else {
            
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                //send_contract_api(FileData: try! Data(contentsOf: sandboxFileURL))
                parepare_send_data = try! Data(contentsOf: sandboxFileURL)
                print("Copied file!")
            }
            catch {
                print("Error: (error)")
            }
        }
    }
    
    func send_contract_api( FileData : Data){
        
        
        var  filestr = FileData.base64EncodedString()
        //filestr = filestr.data(using: .utf8)
        
        print(filestr)
        let json: [String: Any] = ["pdf": filestr]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/test")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            
            if let downloadedData = data{
                do{
                    let data_JSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                    
                    if let data_JSON = data_JSON {
                        
                        print(data_JSON )
                        if (data_JSON == nil){
                            print("YA")
                            return
                        }
                        
                        
                        //let d_message:String = data_JSON["Message"] as Any as! String
                        //if (d_message == "No Error"){
                        
                        
                        //}
                        
                        
                    }
                    
                    print("OK send_contract_api")
                    
                    
                }
                catch{
                    
                    print(error)
                    print("something wrong after downloaded")
                }
            }
            else {
                print("no data")
                
            }
            
            
            
        }
        
        task.resume()
        
    }
    
}
