//
//  LandlordChatViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/15.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
class LandlordChatCell_Oth : UITableViewCell{
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
}
class LandlordChatCell_Self : UITableViewCell{
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
}

class LandlordChatViewController : UIViewController,UITableViewDelegate , UITableViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var ChatTable: UITableView!
    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ViewSize: UIView!
    
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
  
        
        self.TableViewHeight.constant = ViewSize.frame.size.height - inputText.frame.size.height - ChatTable.frame.origin.y
        
       
        tableViewDown = self.TableViewHeight.constant
        
        
       
    }
    


    
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordChatCell_Self", for: indexPath) as! LandlordChatCell_Self
                       
                
            cell.message.text = ChatList[indexPath.row].message
            //cell.date.text = ChatList[indexPath.row].date
            cell.date.text = ""
            

                       
                return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordChatCell_Oth", for: indexPath) as! LandlordChatCell_Oth
                       
                
                cell.message.text = ChatList[indexPath.row].message
                //cell.date.text = ChatList[indexPath.row].date
                cell.date.text = ""

                       
                return cell
            
        }
        
   
    }
    
    var tableViewDown : CGFloat?
    
       @objc func keyboardWillShow(notification: NSNotification) {  // keyboard 出現時
        
        if currentTextField == nil {
            return
        }
           
           //存起初始位置
           
           
           //得到keyboard frame
           let userInfo: NSDictionary = notification.userInfo! as NSDictionary
           let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
           let keyboardRec = (value as AnyObject).cgRectValue
           let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
          // let height = keyboardRec?.size.height
        
        
        let origin = (currentTextField?.frame.origin)!
        // 取得焦點輸入框的高度 /
        let height = (currentTextField?.frame.size.height)!
        // 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 /
        let targetY = origin.y + height
        // 計算扣除鍵盤高度後的可視高度 /
        let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height
        
 

      
           //textView bottom位置在keyboard頭頂
           UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
               print("keyboardUP")
               var frame = self.inputText.frame
    
               print(self.inputText.frame.origin.y)
               //print(height!)
               print("UP")
               if (UIScreen.main.bounds.height >= 812){
                   //self.TableViewHeight.constant = self.view.frame.size.height - (self.view.frame.size.height - self.inputText.frame.size.height - height!) - 44

                self.TableViewHeight.constant = self.view.bounds.size.height - keyboard.height - self.inputText.frame.height - self.ChatTable.frame.origin.y
                    
                   //frame.origin.y = self.view.frame.size.height - self.inputText.frame.size.height - height!
                   //self.InputView.frame.origin.y = self.view.frame.size.height - self.InputView.frame.size.height - height!
                   //print(self.view.frame.size.height)
                   //print(self.inputText.frame.size.height)
                   //print(height!)
               }
               else{
                  self.TableViewHeight.constant = self.view.bounds.size.height - keyboard.height - self.inputText.frame.height - self.ChatTable.frame.origin.y
      
                   //frame.origin.y = self.view.frame.size.height - self.inputText.frame.size.height - height!
               }
               self.inputText.frame = frame

               print("UPED")
               DispatchQueue.main.async {
                   print("!!")
                   let indexPath = IndexPath(row: self.ChatList.count-1, section: 0)
                   self.ChatTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
                   
               }


           }, completion: nil)
           



           
       }
       func move_again ( height : Any){
           
           
       }
       

       @objc func keyboardWillHide(notification: NSNotification) {  // keyboard 關閉

           print("DisShow")

           //textView bottom位置在keyboard頭頂
           UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
               print("keyboardDOWN")
               var frame = self.inputText.frame
               print(self.view.frame.size.height)
               print(self.inputText.frame.size.height)

               self.TableViewHeight.constant = self.tableViewDown!
               if (UIScreen.main.bounds.height >= 812){
                   frame.origin.y = self.view.frame.size.height - self.inputText.frame.size.height - 34
               }
               else{
                   frame.origin.y = self.view.frame.size.height - self.inputText.frame.size.height
               }
               print(frame.origin.y)
               self.inputText.frame = frame
               print(self.inputText.frame)
               
               //let indexPath = IndexPath(row: self.currentChatRoom.count-1, section: 0)
               //self.SelectChatRoomTable.scrollToRow(at: indexPath, at: .bottom, animated: true)

           }, completion: nil)
           

       }
       /*
    
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
            //self.ChatTable.frame.origin.y = 400
            //self.ChatTable.contentSize.height = 400

            UIView.animate(
                withDuration: duration,
                animations: { () -> Void in
                    self.view.frame = rect
                    self.TableViewHeight.constant = visibleRectWithoutKeyboard
                    print("12312")
                }
            )
        }
    }

    @objc func keyboardWillHide(note: NSNotification) {
       
        print("keyboardWillHide")
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)

        UIView.animate(
            withDuration: duration,
            animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
            }
        )
    }
    

    */
    
}
