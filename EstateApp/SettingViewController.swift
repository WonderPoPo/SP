//
//  SettingViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/2.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


class SettingCell: UITableViewCell {
    
    @IBOutlet weak var Option_Title: UILabel!
}


class SettingViewController : UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var name: UILabel!
    var OptionList = ["個人資訊","地區/語言","支援中心","評分APP","隱私條款","使用條款","登出"]
    
    
    @IBOutlet weak var OptionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "設定"
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        OptionTable.delegate = self
        OptionTable.dataSource = self
        
        DispatchQueue.global().async {
  
            var t_img = url_to_image(url: URL(string: glo_account_icon_url)!)
            DispatchQueue.main.sync {
                self.icon.setImage(t_img, for: .normal)
            }
        }
        name.text = glo_account_name
        
    }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          //return total_cell_count()
          
  
      
        return OptionList.count
          
      
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
                 
          
        cell.Option_Title.text = OptionList[indexPath.row]
     

                 
          return cell
      }
    


      
     
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("select")
        if (OptionList[indexPath.row] == "支援中心"){
            performSegue(withIdentifier: "supportcentersegue", sender: self)
        }
        else if ( indexPath.row == 4 ){
            
            performSegue(withIdentifier: "privacypolicysegue", sender: self)
        }
        else if ( indexPath.row == 5 ){
            performSegue(withIdentifier: "userpolicysegue", sender: self)
        }
        else if ( OptionList[indexPath.row] == "個人資訊"){
            performSegue(withIdentifier: "profilesegue", sender: self)
        }
        else if ( OptionList[indexPath.row] == "登出"){
            dismiss(animated: true, completion: nil)
        }
        
   
      }
    
 

    
      
    
}
