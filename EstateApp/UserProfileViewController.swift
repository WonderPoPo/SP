//
//  UserProfileViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/7.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class UserProfileCell : UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
}

class UserProfileViewController : UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    struct UserProfileData {
        let title : String
        var content:String

        init(from title_D:String ,_ content_D:String ){
            self.title = title_D
            self.content = content_D

        }
                
    }
    
    var sel_staff_id = ""
    
    var InfoList = [UserProfileData]()
    
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var InfoTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InfoTable.delegate = self
        InfoTable.dataSource = self
        
        Icon.image = #imageLiteral(resourceName: "emptyImg")
        
        //InfoList.append(UserProfileData(from: "名字", "Jason"))
        //InfoList.append(UserProfileData(from: "電話號碼", "0988888888"))
        //InfoList.append(UserProfileData(from: "電郵信箱", "jason@gmail.com"))
        //InfoList.append(UserProfileData(from: "帳號", "0988888888"))
        //InfoList.append(UserProfileData(from: "密碼", "123456"))
        get_sel_user_info_api(sel_id: sel_staff_id)
    }
    
    
    func get_sel_user_info_api(sel_id:String){
     
        print("sel_id\(sel_id)")
        
        let json: [String: Any] = ["id": sel_id]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/accountmanagement/getuserinformation")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            
            if let downloadedData = data{
                do{
                    let data_JSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                    
                    if let data_JSON = data_JSON {
                        
                        print("data_JSON\(data_JSON)" )
                        if (data_JSON == nil){
                            print("YA")
                            return
                        }
                        
                        
                        let d_message:String = data_JSON["Message"] as Any as! String
                        if (d_message == "No Error"){
                            
                            let d_Items = data_JSON["Items"] as! Dictionary<String,Any>
                            
             
                            let d_auth = d_Items["auth"] as! String
                            
                     
                            
                            let d_information = d_Items["information"] as! Dictionary<String,Any>
                            let d_name = d_information["name"] as! String
                            let d_sex = d_information["sex"] as! String
                            let d_mail = d_information["mail"] as! String
                            let d_phone = d_information["phone"] as! String
                            let d_annual_income = d_information["annual_income"] as! String
                            let d_industry = d_information["industry"] as! String
                            let d_profession = d_information["profession"] as! String
                  
                            let d_icon = d_information["icon"] as! String
                            
                            
                            self.InfoList.append(UserProfileData(from: "姓名", d_name))
                            self.InfoList.append(UserProfileData(from: "性別", d_sex))
                            self.InfoList.append(UserProfileData(from: "電郵信箱", d_mail))
                            self.InfoList.append(UserProfileData(from: "電話號碼", d_phone))

                            var load_img = url_to_image(url: URL(string: d_icon)!)

                            
                            DispatchQueue.main.sync {
                                self.Icon.image = load_img
                                self.InfoTable.reloadData()
                                
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        return InfoList.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
               
        
        cell.title.text = InfoList[indexPath.row].title
        cell.content.text = InfoList[indexPath.row].content
    

               
        return cell
    }

    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PlaceList[section].name
    }
    */
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
    }

  
    
    
}
