//
//  SelPropertyViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/3.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


class SelPropertyCell : UITableViewCell{
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var tenant: UILabel!
    @IBOutlet weak var sel_btn: UIButton!
}

class SelPropertyViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var sel_group_btn: UIButton!
    @IBAction func sel_groupAction(_ sender: Any) {
        
        let alertController = UIAlertController(
                title: "列表可選擇",
                        message: "",
                        preferredStyle: .actionSheet)

        
                    let cancelAction = UIAlertAction(
                        title: "取消",
                        style: .cancel,
                        handler: nil)

                    alertController.addAction(cancelAction)

    

        var n = 0
        
        print(glo_BuildingList)
        while ( n < glo_BuildingList.count){
            let okAction1 = UIAlertAction(title: glo_BuildingList[n].name,style: .default   ){ (action:UIAlertAction!) in
                
            
                print(action.title)
                let cur_n = glo_BuildingList.firstIndex(where: {$0.name == action.title})
                print(cur_n)
                self.this_PropertyList = []
                self.propertyTable.reloadData()
                
           
                self.sel_group_btn.setTitle(glo_BuildingList[cur_n!].name, for: .normal)
                
                //self.getpropertybygrouptag_api(sel_title: glo_BuildingList[cur_n!].name)
                self.Unfold_group(sel_index: cur_n!)
                    
                
            }
            
            alertController.addAction(okAction1)
            
            
            
            n += 1
        }

            
            

            // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var propertyTable: UITableView!
    
    var this_PropertyList = [propertyDetailData]()
    
    func Unfold_group (sel_index : Int){
        
        self.this_PropertyList = glo_BuildingList[sel_index].property_items
        self.propertyTable.reloadData()
        
    }
    
    var delegate : DismissBackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        propertyTable.delegate = self
        propertyTable.dataSource = self
        
        button_style2(sel_button: sel_group_btn)
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
      

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          //return total_cell_count()

          return this_PropertyList.count

      
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SelPropertyCell", for: indexPath) as! SelPropertyCell
                 
        
        //cell.title.text  = this_PropertyList[indexPath.row].information.
        cell.address.text  = this_PropertyList[indexPath.row].full_address
        cell.tenant.text  = this_PropertyList[indexPath.row].tenant_id
        cell.Img.image = #imageLiteral(resourceName: "ironman")
          
        cell.sel_btn.tag = indexPath.row
        cell.sel_btn.addTarget(self, action: #selector(sel_property_function), for: UIControl.Event.touchUpInside)
      

                 
          return cell
      }
    

       
    
       
       @objc func sel_property_function(sender:UIButton){
           print("\(sender.tag) tap")
           let row = sender.tag
        delegate?.dismissBack(sendData: this_PropertyList[row])
        dismiss(animated: true, completion: nil)
           
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("select")
       }
    
    
    
    
}

