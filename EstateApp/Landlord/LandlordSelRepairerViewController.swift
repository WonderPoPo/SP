//
//  LandlordSelRepairerViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/21.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


struct repairerdata {
    var name : String
    var company : String
    var phonenum : String
    var repairdate :  String
    var sel : Bool
       
}



class LandlordSelRepairerCell : UICollectionViewCell{
    
    @IBOutlet weak var Icon: UIImageView!
    
    @IBOutlet weak var Name: UILabel!
    
}

class LandlordSelRepairerViewController : UIViewController, UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var repairerCollection: UICollectionView!
    

    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sel_name: UILabel!
    
    @IBOutlet weak var sel_phonenum: UILabel!
    
    @IBOutlet weak var sel_company: UILabel!
    
    @IBAction func sel_repairerAction(_ sender: Any) {
        delegate?.dismissBack(sendData: repairerList[sel_index_row])
        dismiss(animated: true, completion: nil)
        
        //self.navigationController?.popViewController(animated: true)
        
    }
   
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var repairerList : [repairerdata] = []
    
    var delegate : DismissBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        repairerCollection.delegate = self
        repairerCollection.dataSource = self
        
        collectionHeight.constant = view.frame.width / 3
        
        
        sel_name.text = "請先選擇維修工"
        sel_phonenum.text = ""
        sel_company.text = ""
        
        repairerList.append(repairerdata(name: "Jason",company: "",phonenum : "", repairdate: "2020/12/11 10:11",sel: false))
        repairerList.append(repairerdata(name: "Aiden",company: "", phonenum : "", repairdate: "2020/12/11 10:11",sel: false))
        repairerList.append(repairerdata(name: "Hugo",company: "",phonenum : "", repairdate: "2020/12/11 10:11",sel: false))
        repairerList.append(repairerdata(name: "Hugo",company: "",phonenum : "", repairdate: "2020/12/11 10:11",sel: false))
        repairerList.append(repairerdata(name: "Hugo",company: "",phonenum : "", repairdate: "2020/12/11 10:11",sel: false))
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
                  return 1
                    
              }
                
              func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

                return repairerList.count
              }
                
                
                
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandlordSelRepairerCell", for: indexPath) as! LandlordSelRepairerCell

               
               cell.Icon.image = #imageLiteral(resourceName: "ironman")
                cell.Icon.cornerRadius = ( cell.frame.width - 20 ) * 0.5
               
                cell.Name.text = repairerList[indexPath.row].name
                if (repairerList[indexPath.row].sel == false){
                    cell.contentView.alpha = 0.7
                }
                else{
                    cell.contentView.alpha = 1.0
                }
                
             
                
                //cell.clipsToBounds = true
                //cell.layer.masksToBounds = false
                //cell.layer.shadowColor = UIColor.lightGray.cgColor
                //cell.layer.shadowOpacity = 0.8
                //cell.layer.shadowOffset = CGSize(width: 0.8, height: 2.0)
                //cell.layer.shadowRadius = 2
                

                
                       
                return cell
                
               
            }
        
        
       
         
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             
            return CGSize(width: ( ( collectionView.frame.size.width - 60 ) / 3 ) , height: ( ( collectionView.frame.size.width - 60 ) / 3 ) )
                
        
                 
        }
    
    var sel_index_row  = 0
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        repairerList[sel_index_row].sel = false
        

        sel_name.text = repairerList[indexPath.row].name
        repairerList[indexPath.row].sel = true
        sel_index_row = indexPath.row
        
        repairerCollection.reloadData()
 

       
      
  
    }
    
}
