//
//  CreateContractImgViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/29.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

var CreateContract_sel_contract_id = ""
var CreateContract_sel_landlord_id = ""

class CreateContractImgViewController : UIViewController{
    
    @IBOutlet weak var uploadtypesegController: UISegmentedControl!
    @IBOutlet weak var imgContainView: UIView!
    @IBOutlet weak var pdfContainView: UIView!
    @IBOutlet weak var templeContainView: UIView!
    
    @IBAction func BackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var delegate : DismissBackDelegate?
    
    var perty_group_index = 0
    var perty_item_index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgContainView.isHidden = false
        pdfContainView.isHidden = true
        templeContainView.isHidden = true
        
    }
    
    @IBAction func uploadtypesegAction(_ sender: Any) {
        if ( uploadtypesegController.selectedSegmentIndex == 0){
            imgContainView.isHidden = false
            pdfContainView.isHidden = true
            templeContainView.isHidden = true
            
            
        }
        else if ( uploadtypesegController.selectedSegmentIndex == 1){
            imgContainView.isHidden = true
            pdfContainView.isHidden = false
            templeContainView.isHidden = true
        }
        else {
            imgContainView.isHidden = true
            pdfContainView.isHidden = true
            templeContainView.isHidden = false
        }
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        delegate?.dismissBack(sendData: "createcontract")
    }
}

