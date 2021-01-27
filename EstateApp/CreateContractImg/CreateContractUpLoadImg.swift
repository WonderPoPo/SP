//
//  CreateContractUpLoadImg.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class CreateImgCollectionCell :UICollectionViewCell{
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBAction func removeAction(_ sender: Any) {
        delegate?.SelCellIndex(self)
    }
        
    var delegate : SelCellIndexDelegate?
}

class CreateContractUpLoadImg : UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBAction func uploadImgAction(_ sender: Any) {
        photoButtonAction()
        
    }
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        send_imglist_api()
    }
    
    
    
    @IBOutlet weak var imgCollection: UICollectionView!
    
    var img_url_List = [String]()
    var imgList = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgCollection.delegate = self
        imgCollection.dataSource = self
        print(img_url_List.count)
        print("!!!!")
        if (img_url_List.count > 0){
            uploadImgBtn.isHidden = true
            sendBtn.isHidden = true
            
            download_image()
            return
        }
        
        
        button_style2(sel_button: uploadImgBtn)
        button_style1(sel_button: sendBtn)
    }
    
    
    func send_imglist_api( ){
        
        var imgbase64List = [String]()
        if ( imgList.count > 0 ){
            for i in 0 ... imgList.count - 1{
                imgbase64List.append(image_to_base64(select_Image: imgList[i]))
                
            }
        }
        else{
            return
        }
        print(imgbase64List)
        
          let json: [String: Any] = ["landlord_id": glo_account_id ,
         "contract_id": CreateContract_sel_contract_id,
         "type": "JPG",
         "document": imgbase64List ]
        
        
        
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
    
    
    
    let myDataQueue = DispatchQueue(label: "DataQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)  // thread
      let group : DispatchGroup = DispatchGroup()
      
    func download_image(){
        print(img_url_List.count)
        print("download_image")

        if ( img_url_List.count == 0){
            return
        }
        for i in 0 ... img_url_List.count - 1{
            
            self.imgList.append(#imageLiteral(resourceName: "ironman"))
            self.group.enter()
            myDataQueue.async (group: group){
               
                    
                
                var loading_img = url_to_image(url: (URL(string:self.img_url_List[i])!))
                DispatchQueue.main.async{
                    self.imgList[i] = loading_img
                    //self.imgList.append(loading_img)
                    self.group.leave()
                    
                
                }
                
            }
            
        }
        
        group.notify(queue: DispatchQueue.main ){
            
            print("fin")
            
            DispatchQueue.main.async {
                
               
                self.imgCollection.reloadData()
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func photoButtonAction() {
        
        print("photoBtn.....")
        //do something ...
        
        let imageSelect = UIImagePickerController()
        imageSelect.sourceType = .photoLibrary
        imageSelect.delegate = self
        present(imageSelect,animated: true,completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[.originalImage] as? UIImage
        //var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //insert_photo_to_scroll(sel_image: image!)
        
        //sel_img.image = image!
        imgList.append(image!)
        imgCollection.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateImgCollectionCell", for: indexPath) as! CreateImgCollectionCell
        
        cell.img.image = imgList[indexPath.row]
   
        
        sel_Index = indexPath
        cell.removeBtn.isHidden = true
        cell.removeBtn.addTarget(self, action: #selector(removeImg), for: UIControl.Event.touchUpInside)
        //cell.Icon.cornerRadius = ( cell.frame.width - 20 ) * 0.5
        
        
        
        return cell
        
        
    }
    
    @objc func removeImg(sender:UIButton){
        imgList.remove(at: sel_Index!.row)
        imgCollection.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (  collectionView.frame.size.width ) , height: collectionView.frame.size.width )
      
        
    }
    
    var sel_Index : IndexPath?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        
        
    }
    
    func SelCellIndex(_ sender: Any){
        guard let tappedIndex = imgCollection.indexPath(for: sender as! RepairerReportImgCell) else {return}
        sel_Index = tappedIndex
        
    }
    
    
    
    
    
    
    
    
    
    
}



