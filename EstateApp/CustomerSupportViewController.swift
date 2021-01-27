//
//  CustomerSupportViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/6.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class CustomerSupporterCell :UICollectionViewCell{
    
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
}
class SupportChatCell_Oth : UITableViewCell{
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    
}
class SupportChatCell_Self : UITableViewCell{
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    
}

struct Chatdata{
    let sender : String
    let message : String
    let date:String

    init(from sender_D:String ,_ message_D: String ,_ date : String ){
        self.sender = sender_D
        self.message = message_D
        self.date = date

    }
        
}

class CustomerSupportViewController : UIViewController, UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UITableViewDelegate , UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var StaffCollection: UICollectionView!
    
    
    @IBOutlet weak var ChatTable: UITableView!
    
    @IBOutlet weak var inputText: UITextField!
    

  
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var intro: UILabel!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (inputText.text == ""){
                 return true
             }
        
             
             ChatList.append(Chatdata(from: "Self",inputText.text!,getdate(Date())))
             
        self.ChatTable.insertRows(at: [IndexPath(row: ChatList.count - 1, section: 0)], with: .automatic)
                                  
             let indexPath = IndexPath(row: self.ChatList.count-1, section: 0)
        self.ChatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
             
        inputText.text = ""
        
        return true
    }
    
    var staffList = ["Aiden","Jason","Hugo","Hugo","Hugo","Hugo"]
    
    var ChatList : [Chatdata] = []
    
    
    var currentTextField: UITextField?
  
    var rect: CGRect?

    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        currentTextField = textField
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        inputText.delegate = self
        
        StaffCollection.delegate = self
        StaffCollection.dataSource = self
        
        ChatTable.delegate = self
        ChatTable.dataSource = self
        
        hideKeyboardWhenTappedAround()
        
        ChatList.append(Chatdata(from: "Other","你好,我叫Aiden","12/01"))
        ChatList.append(Chatdata(from: "Other","請問有什麼可以幫到你","12/01"))
        ChatList.append(Chatdata(from: "Self","請問房租怎麼付款","12/01"))
        
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

      
        rect = view.bounds
        
        inputText.returnKeyType = UIReturnKeyType.send
        
        collectionHeight.constant = view.frame.width / 3
        
        intro.text = "親愛的xxx君，\n我們正在努力的協助處理客人的問題中。 如果沒能即時回應您，請您先稍後片刻。在等待的同時，您可輸入“關鍵字”，或許可以從我們已經為您整理過的“常見問題”中找到您的要的答案。\n\n我們的上班時間：\nMon ~ Sun： 0900 - 18：00"
    }
    
    
           func numberOfSections(in collectionView: UICollectionView) -> Int {
               return 1
                 
           }
             
           func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

             return staffList.count
           }
             
             
             
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerSupporterCell", for: indexPath) as! CustomerSupporterCell

            
            cell.Icon.image = #imageLiteral(resourceName: "ironman")
            cell.Icon.cornerRadius = ( cell.frame.width - 20 ) * 0.5
            
            cell.name.text = staffList[indexPath.row]
             
             //cell.clipsToBounds = true
             //cell.layer.masksToBounds = false
             //cell.layer.shadowColor = UIColor.lightGray.cgColor
             //cell.layer.shadowOpacity = 0.8
             //cell.layer.shadowOffset = CGSize(width: 0.8, height: 2.0)
             //cell.layer.shadowRadius = 2
             

             
                    
             return cell
             
            
         }
     
     
    
      
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
         return CGSize(width: ( ( collectionView.frame.size.width - 60 ) / 3 ) , height: ( ( collectionView.frame.size.width - 60 ) / 3 ) )
             
     
              
     }
    
    //////////////////////////////////////////////
    
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return total_cell_count()
        
        return ChatList.count
        
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (ChatList[indexPath.row].sender == "Self"){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SupportChatCell_Self", for: indexPath) as! SupportChatCell_Self
                       
                
            cell.message.text = ChatList[indexPath.row].message
            //cell.date.text = ChatList[indexPath.row].date
            cell.date.text = ""
            

                       
                return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SupportChatCell_Oth", for: indexPath) as! SupportChatCell_Oth
                       
                
                cell.message.text = ChatList[indexPath.row].message
                //cell.date.text = ChatList[indexPath.row].date
                cell.date.text = ""

                       
                return cell
            
        }
        
   
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selsupportersegue", sender: self)
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        if currentTextField == nil {
            return
        }

        let userInfo = note.userInfo!
        // 取得鍵盤尺寸 /
        let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        // 取得焦點輸入框的位置 /
        let origin = (currentTextField?.frame.origin)!
        // 取得焦點輸入框的高度 /
        let height = (currentTextField?.frame.size.height)!
        // 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 /
        let targetY = origin.y + height
        // 計算扣除鍵盤高度後的可視高度 /
        let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height

        // 如果輸入框Y座標在可視高度外，表示鍵盤已擋住輸入框 /
        if targetY >= visibleRectWithoutKeyboard {
            var rect = self.rect!
            // 計算上移距離，若想要鍵盤貼齊輸入框底部，可將 + 5 部分移除 /
            rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + 0

            UIView.animate(
                withDuration: duration,
                animations: { () -> Void in
                    self.view.frame = rect
                }
            )
        }
    }

    @objc func keyboardWillHide(note: NSNotification) {
       
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)

        UIView.animate(
            withDuration: duration,
            animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
            }
        )
    }
    

    
    
}
