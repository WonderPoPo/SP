//
//  NewsViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/3.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class NewsCell :UITableViewCell{
    
    @IBOutlet weak var content: UILabel!
    
    
}

class NewsViewController : UIViewController,UITableViewDelegate , UITableViewDataSource {

    

    
   
    @IBOutlet weak var NewsTable: UITableView!
    
    
     var content_List = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        NewsTable.delegate = self
        NewsTable.dataSource = self
        
        content_List.append("2020年12月5日房租到期")
        content_List.append("冷氣機維修\n已完成")
        content_List.append("萬聖節快樂~~")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
               
        
        cell.content.text = content_List[indexPath.row]
  
               
        return cell
    }
    
}
