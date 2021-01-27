//
//  MainPageViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit




class MainPageToolsCell : UICollectionViewCell{
    
    @IBOutlet weak var Tool_Img: UIImageView!
    @IBOutlet weak var Tool_Title: UILabel!
    
    
}


class MainPageViewController :UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var News: UILabel!
    
    @IBOutlet weak var Greet: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var temp_Img: UIImageView!
    @IBOutlet weak var temp_Label: UILabel!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    @IBAction func qrcodeScanAction(_ sender: Any) {
        let storyboard = UIStoryboard( name: "QrcodeScanner", bundle: .main )
        
        let VC = storyboard.instantiateViewController( withIdentifier: "QrcodeScannerViewController" ) as! QrcodeScannerViewController
        
        VC.delegate = self
        present(VC, animated: true, completion: nil)
        
    }
    let present_IntroViewController_service = Present_IntroViewController()
    
    var Tools_Img_List = [UIImage]()
    var Tools_List = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchTextField.backgroundColor = .white
        
        hideKeyboardWhenTappedAround()
     
        let present_VC = present_IntroViewController_service.present_message_VC()
        
        self.present( present_VC, animated: false )
        
        News.text = "2020年12月5日房租到期\n冷氣機維修\n已完成\n萬聖節快樂~~"
        
        if (glo_account_auth == "technician"){
            Tools_List = ["維修列表"]
            Tools_Img_List = [#imageLiteral(resourceName: "TenantMainPage6")]
        }
        else{
            Tools_List = ["住屋守則","房租水電","設備手冊","房子合約","周邊景點","故障報修"]
            Tools_Img_List = [#imageLiteral(resourceName: "TenantMainPage1"),#imageLiteral(resourceName: "TenantMainPage2"),#imageLiteral(resourceName: "TenantMainPage4"),#imageLiteral(resourceName: "TenantMainPage3"),#imageLiteral(resourceName: "TenantMainPage5"),#imageLiteral(resourceName: "TenantMainPage6")]
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
          func numberOfSections(in collectionView: UICollectionView) -> Int {
              return 1
                
          }
            
          func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return Tools_List.count
          }
            
            
            
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageToolsCell", for: indexPath) as! MainPageToolsCell

            cell.Tool_Img.image = Tools_Img_List[indexPath.row]
            cell.Tool_Title.text = Tools_List[indexPath.row]
            
            //cell.clipsToBounds = true
            //cell.layer.masksToBounds = false
            //cell.layer.shadowColor = UIColor.lightGray.cgColor
            //cell.layer.shadowOpacity = 0.8
            //cell.layer.shadowOffset = CGSize(width: 0.8, height: 2.0)
            //cell.layer.shadowRadius = 2
            //cell.layer.cornerRadius = cell.layer.frame.width * 0.5

            //cell.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                   
            return cell
            
           
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (glo_account_auth == "tenant"){
            if (indexPath.row == 0){
                print("didSelectItemAt\(Tools_List[indexPath.row])") // 住屋守則
                performSegue(withIdentifier: "houserulesegue", sender: self)
            }
            else if(indexPath.row == 1){
                print("didSelectItemAt\(Tools_List[indexPath.row])") // 付房租水電
                performSegue(withIdentifier: "paymentsegue", sender: self)
            }
            else if(indexPath.row == 2){
                print("didSelectItemAt\(Tools_List[indexPath.row])")  // 設備手冊
                performSegue(withIdentifier: "equipsegue", sender: self)
            }
            else if(indexPath.row == 3){
                print("didSelectItemAt\(Tools_List[indexPath.row])") // 你的房子合約
                performSegue(withIdentifier: "contractsegue", sender: self)
            }
            else if(indexPath.row == 4){
                print("didSelectItemAt\(Tools_List[indexPath.row])")  // 周邊景點
                performSegue(withIdentifier: "houseviewpointsegue", sender: self)
            }
            else if(indexPath.row == 5){
                print("didSelectItemAt\(Tools_List[indexPath.row])") // 報修
                performSegue(withIdentifier: "maintainsegue", sender: self)
            }
        }
        else{
            if(indexPath.row == 0){
                print("didSelectItemAt\(Tools_List[indexPath.row])") // 報修
                performSegue(withIdentifier: "repairersegue", sender: self)
            }
        }
        
   
    }

   
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        return CGSize(width: ( collectionView.frame.size.width / 3 ) -  40 , height: ( collectionView.frame.size.width / 3 ) - 40 )
            
    
             
    }
    
    
    
    
}



extension MainPageViewController : DismissBackDelegate{
    
    func dismissBack(sendData: Any) {
        searchBar.text = sendData as? String
       // SignImg.image?.imageOrientation = UIImage.Orientation(rawValue: 3)!

    }
    

}
