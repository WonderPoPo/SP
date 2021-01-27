//
//  RepairerReportViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/24.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


struct UpdateEventData :Codable {
    
    let event_id : String
    let description: String
    let landlord_id :String
    let dynamic_status: Dynamic_status
    
    
    struct Dynamic_status :Codable {
        let sender_id: String
        let description: String
        let date: String
        let image: [String]
        
    }
    
}

class RepairerReportImgCell : UICollectionViewCell{
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var remove_btn: UIButton!
    @IBAction func removeAction(_ sender: Any) {
        delegate?.SelCellIndex(self)
    }
    
    var delegate : SelCellIndexDelegate?
}

class RepairerReportViewController :UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate ,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , SelCellIndexDelegate{
    
    
    
    @IBOutlet weak var imgCollection: UICollectionView!
    
    @IBOutlet weak var sel_statusBtn: UIButton!
    @IBAction func sel_statusAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        let okAction1 = UIAlertAction(title: "處理中",style: .default ){ (_) in
            self.sel_statusBtn.setTitle("處理中", for: .normal)
        }
        alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "已結案",style: .default){ (_) in
            self.sel_statusBtn.setTitle("已結案", for: .normal)
        }
        alertController.addAction(okAction2)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var intro: UITextField!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var Signbtn: UIButton!
    @IBAction func SignAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "PresentViewController", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "SignDrawViewController" ) as! SignDrawViewController
        
        VC.delegate = self
        present(VC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var Sendbtn: UIButton!
    
    @IBAction func sendAction(_ sender: Any) {
        updateeventinformation_api()
        
    }
    
    var imgList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        
        
        button_style2(sel_button: Signbtn)
        button_style1(sel_button: Sendbtn)
        
        date.text = getdate(Date())
        
        
        hideKeyboardWhenTappedAround()
        
        imgCollection.delegate = self
        imgCollection.dataSource = self
        
        imgList.append(#imageLiteral(resourceName: "AddBlock"))
        
        
        
        
    }
    
    
    
    
    
    
    func updateeventinformation_api(){
        
        var imgbase64List = [String]()
        if ( imgList.count > 1 ){
            for i in 1 ... imgList.count - 1{
                imgbase64List.append(image_to_base64(select_Image: imgList[i]))
                
            }
        }
  
        
        
        let updataevent = UpdateEventData(event_id: EventListDetail!.event_id,description: EventListDetail!.information.description, landlord_id : glo_root_id, dynamic_status: UpdateEventData.Dynamic_status(sender_id: glo_account_id ,description: intro.text!, date: date.text!, image: imgbase64List))
        
        print(updataevent)
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(updataevent)
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/eventmanagement/updateeventinformation")!
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
                            
                            
                            
                            DispatchQueue.main.async {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepairerReportImgCell", for: indexPath) as! RepairerReportImgCell
        
        
        cell.img.image = imgList[indexPath.row]
        
        if (indexPath.row == 0 ){
            cell.remove_btn.isHidden = true
        }
        else{
            cell.remove_btn.isHidden = false
        }
        
        sel_Index = indexPath
        
        cell.delegate = self
        cell.remove_btn.addTarget(self, action: #selector(removeImg), for: UIControl.Event.touchUpInside)
        //cell.Icon.cornerRadius = ( cell.frame.width - 20 ) * 0.5
        
        
        
        return cell
        
        
    }
    
    @objc func removeImg(sender:UIButton){
        imgList.remove(at: sel_Index!.row)
        imgCollection.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ( ( collectionView.frame.size.width - 60 ) / 3 ) , height: ( ( collectionView.frame.size.width - 60 ) / 3 ) )
        
        
        
    }
    
    var sel_Index : IndexPath?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            photoButtonAction()
        }
        
        
        
        
        
    }
    
    func SelCellIndex(_ sender: Any){
        guard let tappedIndex = imgCollection.indexPath(for: sender as! RepairerReportImgCell) else {return}
        sel_Index = tappedIndex
        
    }
    
    
    
}



extension RepairerReportViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        
        
        imgList.append((sendData as? UIImage)!)
        imgCollection.reloadData()
        // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!
        
    }
}
