//
//  LandloadNewsViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/17.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class LandlordNewsCell : UITableViewCell{

    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var status_dot: UIView!
    @IBOutlet weak var ViewCard: UIView!
    @IBOutlet weak var color_tag: UIView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
}


struct NewsData{
    var type : String
    var content : String
    var date : String
    var img_url : String
    var status : String
    
    init(from type_D:String,_ content_D:String,_ date_D:String,_ img_url_D:String ,_ status_D :String){
        self.type = type_D
        self.content =  content_D
        self.date = date_D
        self.img_url = img_url_D
        self.status = status_D

    }
    
}




class LandlordNewsViewController : UIViewController,UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var NewsTable: UITableView!
    

    var NewsList = [NewsData]()
    
    var systemcolor : CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor

        NewsTable.delegate = self
        NewsTable.dataSource = self
        
  
        NewsList.append(NewsData(from: "1", "合約類型", "2020/12/01", "nil", ""))
        NewsList.append(NewsData(from: "2", "租金類型", "2020/12/01", "nil", ""))
        
        NewsList.append(NewsData(from: "3", "待辦類型", "2020/12/01", "nil", ""))
        
        NewsList.append(NewsData(from: "4", "維修類型", "2020/12/01", "nil", ""))
        
        NewsList.append(NewsData(from: "5", "系統類型", "2020/12/01", "nil", ""))
        
        systemcolor = CAGradientLayer()
        systemcolor.colors = [maincolor1.cgColor,maincolor2.cgColor]
        
        get_user_notice_api()
    }
    
    
    func get_user_notice_api(){
        
        
        let json: [String: Any] = ["user_id": glo_account_id]
        print(glo_account_id)
        print("get_user_notice_api")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/messagemanagement/getmessage")!
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
                            
                            let d_Items = data_JSON["Items"] as! [Dictionary<String,Any>]
                            
                            for d_Item in d_Items{
                                let d_type = d_Item["type"]  as! String
                                let d_timestmp = d_Item["timestmp"]  as! Int
                                let d_date = getdate(Date(timeIntervalSince1970: TimeInterval(d_timestmp)))
                                
                                let d_information = d_Item["information"] as! Dictionary<String,Any>
                                let d_content = d_information["content"]  as! String
                                
                                
                                self.NewsList.append(NewsData(from: d_type, d_content, d_date, "nil", ""))
                            }
                            
                            
                            
                            DispatchQueue.main.sync {
                                self.NewsTable.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordNewsCell", for: indexPath) as! LandlordNewsCell
               
        
        cell.content.text = NewsList[indexPath.row].content
  
        cell.date.text = NewsList[indexPath.row].date
        
        if ( NewsList[indexPath.row].type == "1" ){
            cell.color_tag.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3529411765, blue: 0.2352941176, alpha: 1)
        }
        else if ( NewsList[indexPath.row].type == "2" ) {
            cell.color_tag.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.8431372549, blue: 0.07843137255, alpha: 1)
        }
        else if ( NewsList[indexPath.row].type == "3" ) {
            cell.color_tag.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.7960784314, blue: 0.9725490196, alpha: 1)
        }
        else if ( NewsList[indexPath.row].type == "4" ) {
            cell.color_tag.backgroundColor = #colorLiteral(red: 0.368627451, green: 0.368627451, blue: 0.368627451, alpha: 1)
        }
        else if ( NewsList[indexPath.row].type == "5" ) {
            
            //cell.color_tag.backgroundColor = systemcolor
            systemcolor.frame = CGRect(x: 0, y: 0, width: cell.color_tag.frame.width, height: cell.color_tag.frame.height)
            cell.color_tag.layer.addSublayer(systemcolor)
        }
        else  {
            cell.color_tag.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.4980392157, blue: 0.3843137255, alpha: 1)
        }
        
        cell.status_dot.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        cell.ViewCard.cornerRadius = 5
        //cell.ViewCard.clipsToBounds = true
        //cell.ViewCard.layer.masksToBounds = true
        
 
        cell.shadow.cornerRadius = 5
        cell.shadow.layer.masksToBounds = false
        cell.shadow.layer.shadowColor = UIColor.lightGray.cgColor
        cell.shadow.layer.shadowOpacity = 0.8
        cell.shadow.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.shadow.layer.shadowRadius = 4

               
        return cell
    }
    
}
