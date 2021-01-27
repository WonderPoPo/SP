//
//  LandlordChatListViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/17.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

struct LandlordChatData{
    let icon_url : String
    let name: String
    let lastmessage:String

    init(from icon_url_D:String ,_ name_D:String ,_ lastmessage_D:String ){
        self.icon_url = icon_url_D
        self.name = name_D
        self.lastmessage = lastmessage_D

    }
        
}
class LandlordChatListCell :UITableViewCell{
    
    @IBOutlet weak var Icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var lastmessage: UILabel!
    
}

class LandlordChatListViewController :UIViewController,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var ChatTable: UITableView!
    
         var ChatList = [LandlordChatData]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "聊天"
            
            let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            //nav background color
            self.navigationController?.navigationBar.barTintColor = navbarcolor
            self.navigationController?.navigationBar.tintColor = navbartintcolor
            
            ChatTable.delegate = self
            ChatTable.dataSource = self
            
            ChatList.append(LandlordChatData(from: "","Jason","你好"))
            ChatList.append(LandlordChatData(from: "","Aiden","你好"))
            ChatList.append(LandlordChatData(from: "","Hugo","你好"))
            
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ChatList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordChatListCell", for: indexPath) as! LandlordChatListCell
                   
            cell.Icon.image = #imageLiteral(resourceName: "ironman")
            cell.name.text = ChatList[indexPath.row].name
            cell.lastmessage.text = ChatList[indexPath.row].lastmessage
      
                   
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selchatsegue", sender: self)
    }
        
    }
