//
//  ConsoleViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/2.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class ConsoleCell : UITableViewCell{
    
    @IBOutlet weak var Icon: UIImageView!
    
    @IBOutlet weak var Title: UILabel!
    
}

class ConsoleViewController :UIViewController,UITableViewDelegate , UITableViewDataSource{

    
    var consoleList_Img_List : [UIImage] = [#imageLiteral(resourceName: "LandlordMenu1"),#imageLiteral(resourceName: "LandlordMenu2"),#imageLiteral(resourceName: "LandlordMenu3"),#imageLiteral(resourceName: "LandlordMenu6"),#imageLiteral(resourceName: "LandlordMenu5"),#imageLiteral(resourceName: "LandlordMenu4")]
    var consoleList = ["物件","合約","數據","財務","線上報修","人員"]
    

    
    @IBOutlet weak var ConsoleTable: UITableView!
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "控制"
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        ConsoleTable.dataSource = self
        ConsoleTable.delegate = self
        
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
  
        return consoleList.count
        
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConsoleCell", for: indexPath) as! ConsoleCell
               
        cell.Icon.image = consoleList_Img_List[indexPath.row]
        cell.Title.text = consoleList[indexPath.row]
     

               
        return cell
    }

    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PlaceList[section].name
    }
    */
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        if ( indexPath.row == 0) {
            performSegue(withIdentifier: "propertysegue", sender: self)
        }
        else if ( indexPath.row == 1) {
            performSegue(withIdentifier: "contractsegue", sender: self)
        }
        else if ( indexPath.row == 2) {
            performSegue(withIdentifier: "datasegue", sender: self)
        }
        else if ( indexPath.row == 3) {
            performSegue(withIdentifier: "selpagesegue", sender: self)
        }
        else if ( indexPath.row == 4) {
            performSegue(withIdentifier: "repairsegue", sender: self)
        }
        else if ( indexPath.row == 5) {
            performSegue(withIdentifier: "staffsegue", sender: self)
        }
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = ConsoleTable.indexPathForSelectedRow {

            if (segue.identifier == "propertysegue" ){
                let vc = segue.destination as! BuildingListViewController
                vc.title = consoleList[indexPath.row]
            }
            else if ( segue.identifier == "contractsegue" ) {
                let vc = segue.destination as! LandlordContractViewController
                vc.title = consoleList[indexPath.row]
            }
            else if ( segue.identifier == "datasegue" ) {
                let vc = segue.destination as! LandlordAnalysisViewController
                vc.title = consoleList[indexPath.row]
            }
            else if ( segue.identifier == "selpagesegue" ) {
                //let vc = segue.destination as! BuildingListViewController
                //vc.title = consoleList[indexPath.row]
            }
            else if ( segue.identifier == "repairsegue" ) {
                let vc = segue.destination as! LandlordRepairListViewController
                vc.title = consoleList[indexPath.row]
            }
            else if ( segue.identifier == "staffsegue" ) {
                let vc = segue.destination as! StaffViewController
                vc.title = consoleList[indexPath.row]
            }
        }
        
    }

}
