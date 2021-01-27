//
//  EditUserProfileViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/21.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit


class EditUserProfileViewController : UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    @IBOutlet weak var Icon: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var phonenum: UITextField!
    @IBOutlet weak var sex_Btn: UIButton!
    @IBAction func sexAction(_ sender: Any) {
        let alertController = UIAlertController(
                title: "列表可選擇",
                message: "",
                preferredStyle: .actionSheet)
            
            
            let cancelAction = UIAlertAction(
                title: "取消",
                style: .cancel,
                handler: nil)
            
            alertController.addAction(cancelAction)
            
 
            let okAction1 = UIAlertAction(title: "男",style: .default ){ (_) in
                self.sex_Btn.setTitle("男", for: .normal)
            }
            alertController.addAction(okAction1)
            let okAction2 = UIAlertAction(title: "女",style: .default){ (_) in
                self.sex_Btn.setTitle("女", for: .normal)
            }
            alertController.addAction(okAction2)
            let okAction3 = UIAlertAction(title: "不公開",style: .default){ (_) in
                self.sex_Btn.setTitle("不公開", for: .normal)
            }
            
            alertController.addAction(okAction3)
            

            
            self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var incomeBtn: UIButton!
    @IBAction func incomeAction(_ sender: Any) {
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
                  
          
                  while ( n < incomeList.count){
                      let okAction1 = UIAlertAction(title: incomeList[n],style: .default   ){ (action:UIAlertAction!) in
                          
                      
                          print(action.title)
                          let cur_n = self.incomeList.firstIndex(where: {$0 == action.title})
                          print(cur_n)
              
                     
                          self.incomeBtn.setTitle(self.incomeList[cur_n!], for: .normal)
                          
                     
                              
                          
                      }
                      
                      alertController.addAction(okAction1)
                      
                      
                      
                      n += 1
                  }

                      
                      

                      // 顯示提示框
                  self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func sel_imageAction(_ sender: Any) {
        
        photoButtonAction()
        
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
    
        Icon.image = image!
           
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        updateuserinformation_api()
    }
    
    @IBOutlet weak var selcompanytypeBtn: UIButton!
    
    let incomeList = ["NT10萬以下","NT10萬~NT20萬","NT20萬~NT40萬","NT40萬~NT60萬","NT60萬~NT100萬","NT100萬~NT120萬","NT120萬~NT150萬","NT150萬以上"]
    let industryList = ["批發/零售/服務","製造/營造業","金融保險/租賃","政府機構/公營事業","軍警消","教育機構","醫療機構","運輸/倉儲","汽車買賣/直傳銷","律師/會計/記帳/公證/代書/估價服務","珠寶銀樓業/拍賣行/不動產相關行業","汽柴油批發零售業","國防工業","殺傷性武器工具機製造業","財團或社團法人/公會/宗教","當舖、地下金融、虛擬貨幣、博弈業、八大行業","第三方/電子支付機構、金流公司","其他"]
    let positionList = ["一般職員","中高階主管","獎佣金制人員","獎佣金制主管","勞力服務者","專業人員/四師","企業主/家族企業","學生","約聘僱人員","退休/家管","其他"]
    @IBAction func selcompanytypeAction(_ sender: Any) {

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
            
         
            while ( n < industryList.count){
                let okAction1 = UIAlertAction(title: industryList[n],style: .default   ){ (action:UIAlertAction!) in
                    
                
                    print(action.title)
                    let cur_n = self.industryList.firstIndex(where: {$0 == action.title})
                    print(cur_n)
        
               
                    self.selcompanytypeBtn.setTitle(self.industryList[cur_n!], for: .normal)
                    
               
                        
                    
                }
                
                alertController.addAction(okAction1)
                
                
                
                n += 1
            }

                
                

                // 顯示提示框
            self.present(alertController, animated: true, completion: nil)
 
 /*
        ////
        let alertController = UIAlertController(
                title: "列表可選擇",
                message: "",
                preferredStyle: .actionSheet)
            
            
            let cancelAction = UIAlertAction(
                title: "取消",
                style: .cancel,
                handler: nil)
            
            alertController.addAction(cancelAction)
       
            
            let okAction1 = UIAlertAction(title: "包租代理",style: .default ){ (_) in
                self.selcompanytypeBtn.setTitle("包租代理", for: .normal)
            }
            alertController.addAction(okAction1)
            let okAction2 = UIAlertAction(title: "資產公司",style: .default){ (_) in
                self.selcompanytypeBtn.setTitle("資產公司", for: .normal)
            }
            alertController.addAction(okAction2)
            let okAction3 = UIAlertAction(title: "銀行資產部",style: .default){ (_) in
                self.selcompanytypeBtn.setTitle("銀行資產部", for: .normal)
            }
            
            alertController.addAction(okAction3)
            
            let okAction4 = UIAlertAction(title: "仲介",style: .default){ (_) in
                self.selcompanytypeBtn.setTitle("仲介", for: .normal)
            }
            alertController.addAction(okAction4)
            
            let okAction5 = UIAlertAction(title: "代理人",style: .default){ (_) in
                self.selcompanytypeBtn.setTitle("代理人", for: .normal)
            }
            alertController.addAction(okAction5)
        
        let okAction6 = UIAlertAction(title: "宿舍",style: .default){ (_) in
            self.selcompanytypeBtn.setTitle("宿舍", for: .normal)
        }
        alertController.addAction(okAction6)
        let okAction7 = UIAlertAction(title: "物業管理",style: .default){ (_) in
            self.selcompanytypeBtn.setTitle("物業管理", for: .normal)
        }
        alertController.addAction(okAction7)
            
            self.present(alertController, animated: true, completion: nil)
            
        */
    }
    
    @IBOutlet weak var positionBtn: UIButton!
    @IBAction func positionAction(_ sender: Any) {
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
            
    
            while ( n < positionList.count){
                let okAction1 = UIAlertAction(title: positionList[n],style: .default   ){ (action:UIAlertAction!) in
                    
                
                    print(action.title)
                    let cur_n = self.positionList.firstIndex(where: {$0 == action.title})
                    print(cur_n)
        
               
                    self.positionBtn.setTitle(self.positionList[cur_n!], for: .normal)
                    
               
                        
                    
                }
                
                alertController.addAction(okAction1)
                
                
                
                n += 1
            }

                
                

                // 顯示提示框
            self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selcompanytypeBtn.setTitle("點擊選擇", for: .normal)
        button_style2(sel_button: selcompanytypeBtn)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        hideKeyboardWhenTappedAround()
        
        button_style2(sel_button: positionBtn)
        button_style2(sel_button: sex_Btn)
        button_style2(sel_button: incomeBtn)
        button_style1(sel_button: sendBtn)
        
        DispatchQueue.global().async {
            
            var t_img = url_to_image(url: URL(string: glo_account_icon_url)!)
            DispatchQueue.main.sync {
                self.Icon.image = t_img
            }
        }
        
        //Icon.image = url_to_image(url: URL(string: glo_account_icon_url)!)
        name.text = glo_account_name
        sex_Btn.setTitle(glo_account_sex, for: .normal)
        mail.text = glo_account_mail
        phonenum.text = glo_account_phone
        
        incomeBtn.setTitle(glo_account_annual_income, for: .normal)
        selcompanytypeBtn.setTitle(glo_account_industry, for: .normal)
        positionBtn.setTitle(glo_account_profession, for: .normal)
    }
    

    
    func updateuserinformation_api(){

        var icon_base64 = "nil"
        
        if (Icon.image != nil ){
            icon_base64 = image_to_base64(select_Image: Icon.image!)
            
        }

          let json: [String: Any] = ["icon": icon_base64 , "id":glo_account_id,
                                     "mail": mail.text,"sex":sex_Btn.titleLabel!.text,
                                     "name":name.text,"phone":phonenum.text,"system_id":glo_account_system_id ,"annual_income" : incomeBtn.titleLabel!.text,"industry":selcompanytypeBtn.titleLabel!.text ,"profession":positionBtn.titleLabel!.text]
                  
               let jsonData = try? JSONSerialization.data(withJSONObject: json)

               // create post request
               let url = URL(string: api_host + api_basePath + "/accountmanagement/updateuserinformation")!
               var request = URLRequest(url: url)
               request.httpMethod = "POST"

                  // insert json data to the request
               request.httpBody = jsonData

               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   
                   

          
                   if let downloadedData = data{
                       do{
                           let decoder = JSONDecoder()
                           let eventdata = try decoder.decode(landlordopenpermission_data.self, from: downloadedData)
                          print(eventdata.Message)
                       
                          //User_Login += eventdata
                           
                           if (eventdata.Message == "No Error"){
                              DispatchQueue.main.sync {
                                self.navigationController?.popViewController(animated: true)
                              }
                               
                           }
                     
                 
                           print("OK landlordopenpermission_data")

                       
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
