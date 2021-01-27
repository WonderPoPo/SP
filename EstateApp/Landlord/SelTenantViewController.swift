//
//  SelTenantViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/14.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

 
class SelTenant_RentrecordCell : UITableViewCell{
    
    @IBOutlet weak var Title: UILabel!
    
    
    
}



class SelTenantViewController : UIViewController, UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var RentrecordTable: UITableView!
    var Rentrecord = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        RentrecordTable.delegate = self
        RentrecordTable.dataSource = self
        
        
    }
    
    
    
      
      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
      

      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          //return total_cell_count()
    
          
          return Rentrecord.count
          
      
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SelTenant_RentrecordCell", for: indexPath) as! SelTenant_RentrecordCell
                 
          
          cell.Title.text = Rentrecord[indexPath.row]
       

                 
          return cell
      }

      /*
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          return PlaceList[section].name
      }
      */
      
     
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("select")
          
          //performSegue(withIdentifier: "propertydetailsegue", sender: self)
         
      }

    
    
    
}
