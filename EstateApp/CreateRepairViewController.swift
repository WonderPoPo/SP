//
//  CreateRepairViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/18.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

protocol DemoTableViewCellDelegate: class {


 //func didEndEditing(onCell cell: CreateRepairCell)


}

class CreateRepairInfoCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
}

class CreateRepairCell : UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var text_field: UITextField!
    
    weak var delegate: DemoTableViewCellDelegate?



    override func awakeFromNib() {


    super.awakeFromNib()


        
    text_field.delegate = self
        
    
    
    }



}

extension CreateRepairCell: UITextFieldDelegate {


    func textFieldDidEndEditing(_ textField: UITextField) {

      print("111")
      //delegate!.didEndEditing(onCell: self)

    }

 }




class CreateRepairViewController : UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var send_Button: UIButton!
    
    
    @IBAction func sendAction(_ sender: Any) {
        
        
    }
    
    
    
    /*
    struct repair_group_data{
        var title : String
        var items : [repairtable_item]
        
        init(from title_D:String ,_ items_D :[repairtable_item]){
            self.title = title_D
            self.items = items_D
           
            
        }
        
        
    }
    
    struct repairtable_item{
        var title : String
        var type : String
        var content : String
        
        init(from title_D:String ,_ type_D :String ,_ content_D :String){
            self.title = title_D
            self.type = type_D
            self.content = content_D
            
        }
        
        
    }
    
    var Repair_Group_List = [repair_group_data]()
    var Repair_List  = [repairtable_item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "創建維修"

        tableView.delegate = self
        tableView.dataSource = self
        
        
       UITableView.setAnimationsEnabled(false)
        
          
        


        
        let footerView = UIView()
        footerView.backgroundColor = .clear
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
        tableView.tableFooterView = footerView
        
        
        
 
        //Question_List += [question_item.init(from: "A or B", "1", ["A","B","C"])]
        //Question_List += [question_item.init(from: "C or D", "1", ["C"])]
        //Question_List += [question_item.init(from: "C or D", "2", ["C"])]
          


        hideKeyboardWhenTappedAround()

        
        
        send_Button.isHidden = false

      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UITableView.setAnimationsEnabled(false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UITableView.setAnimationsEnabled(true)
 
    }

    /*
     func post_questionnaire_api( ){
              
       //present_loading_VC()
        
        var already_ans = [[Any]]()
        
        var i = 0
        while( i < Question_List.count ){
            if (Question_List[i].type == "Short"){
                //var short = tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! QuestionCell2
                
                if (Question_List[i].short_ans == ""){
                    alert_warning()
                    return
                }
                
                already_ans += [[Question_List[i].short_ans]]
            }
            else{
                var j = 0
                var temp = [String]()
                if (Question_List[i].sel_ans.count == 0){
                    alert_warning()
                    return
                }
                if (Question_List[i].sel_ans[0] == -1){
                    alert_warning()
                    return
                }
                while( j < Question_List[i].sel_ans.count ){
    
                    var string_ans = String(  Question_List[i].ans_list[Question_List[i].sel_ans[j]] )
                    temp += [string_ans]
            
                    j += 1
                }
                already_ans += [temp]
            }
            
            i += 1
        }
        

        
     
              print(already_ans)
              print("questionnaire")
        let json: [String: Any] = [ "id":user_id,"student_id": user_Sid ,"ans": already_ans, "prefix" : sel_prefix ]
              
              let jsonData = try? JSONSerialization.data(withJSONObject: json)

              // create post request
              let url = URL(string: api_front + "/questionnaire/post-questionnaire")!
              var request = URLRequest(url: url)
              request.httpMethod = "POST"

              // insert json data to the request
              request.httpBody = jsonData

              let task = URLSession.shared.dataTask(with: request) { data, response, error in
                  guard let data = data, error == nil else {
                      print(error?.localizedDescription ?? "No data")
                    self.dismiss_loading_VC()
                      return
                  }
                  let nsstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!


                  print(nsstr)
                  print("!!")
                  
                  if ( nsstr as String == api_error_message1 ){
                    self.dismiss_loading_VC()
                      return
                  }
                  else if ( nsstr as String == api_error_message2 ){
                    self.dismiss_loading_VC()
                      return
                  }
                else if ( nsstr as String == api_noerror ){
                  self.dismiss_loading_VC()
                    DispatchQueue.main.async {
                    self.alert_done()
                    }
                    return
                }
                
                  else if ( nsstr as String == "[{\"message\": \"Questionnaire Already Completed\"}]" ){
             
                    
                    self.dismiss_loading_VC()
                 
                    DispatchQueue.main.async {
                    self.alert_notagain()
                    }
                    return
                }
                  
                  let data_JSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>]
                                
                  if let data_JSON = data_JSON {
                    
                    
                         
    
                  }
                  
              }

              task.resume()
              
          }
*/
      
      func reload_tablecell(){
               
          DispatchQueue.main.async {
             
              self.tableView.reloadData()
          }
          
      }
          

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if (Repair_List[indexPath.section].type == "Info"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRepairInfoCell") as! CreateRepairInfoCell
       
              let sectionItems = self.getSectionCell(section: indexPath.section)

          
    

              return cell
            
        }
        else if (Repair_List[indexPath.section].type == "Must"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRepairCell") as! CreateRepairCell
              print(String(indexPath.row) + "cell")

              let sectionItems = self.getSectionCell(section: indexPath.section)

     

                   
              return cell
            
        }
        else if (Repair_List[indexPath.section].type == "Free"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRepairCell") as! CreateRepairCell
              print(String(indexPath.row) + "cell")

              let sectionItems = self.getSectionCell(section: indexPath.section)

              cell.text_field.placeholder = "必填"

            let check_question = String(indexPath.section + 1) + ". " + "學號"
            if (Question_List[indexPath.section].question == check_question){
                cell.text_field.isUserInteractionEnabled = false
            }
            else{
                cell.text_field.isUserInteractionEnabled = true
            }
              cell.text_field.text = Question_List[indexPath.section].short_ans


            //cell.text_field.delegate = self
            cell.delegate = self
                   
              return cell
            
            /////////////////////
            
            
        
            
            
        }
      }
      
    func check_sel_list( sel_list: [Int]  , index_row : Int) -> Bool {
        var  i = 0
        while i < sel_list.count  {
            if ( sel_list[i] == index_row) {
                return true
                
            }
            i += 1
        }
        
        return false
    }
    

      

           
      func numberOfSections(in tableView: UITableView) -> Int {
          // #warning Incomplete implementation, return the number of sections
          return Repair_List.count
      }
      
      
      
      func getSectionCell(section:Int) -> [repairtable_item]{
          //if(record_list[section].hasPrefix(record_list[0]){
          var sectionItems = [repairtable_item]()

       
          //print(String(work_record[section].in_time) + "numberOfSections")
          for  item in Repair_List{
              //if item.in_time.prefix(10) == sectionsInTable[section].prefix(10){
            
                  sectionItems.append(item)
              //}
          }
        
        

          return sectionItems
          
          
          //}
      }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (Question_List[indexPath.section].type == "Multiple"){
            print(Question_List[indexPath.section].sel_ans)
            if (check_sel_list(sel_list: Question_List[indexPath.section].sel_ans, index_row: indexPath.row) == true) {
                if let index = Question_List[indexPath.section].sel_ans.firstIndex(of: indexPath.row){
                    Question_List[indexPath.section].sel_ans.remove(at: index)
                }
   
            }
            else{
                Question_List[indexPath.section].sel_ans.append(indexPath.row)
            }
            print(Question_List[indexPath.section].sel_ans)
        }
        else if (Question_List[indexPath.section].type == "Short"){
            save_input_ready = true
            return
        }
        else{
            if ( Question_List[indexPath.section].sel_ans.count > 0 ){
                Question_List[indexPath.section].sel_ans[0] = indexPath.row
            }
            
        }
          
    
        print(indexPath.row)
        
        self.tableView.beginUpdates()

        var i = 0
        while ( i < Question_List[indexPath.section].ans_list.count){
            //self.tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .none)
            
            i += 1
        }
        self.tableView.reloadSections( [indexPath.section], with: .none)
        self.tableView.endUpdates()
        //reload_tablecell()
    }
           
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          // #warning Incomplete implementation, return the number of rows
          //print(self.getSectionCell(section: section).count)
          //var aaa = self.getSectionCell(section: section).count
          //print(String(aaa) + "numberOfRowsInSection")
          
          
        return Question_List[section].ans_list.count
      }
      
    
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          //return nil
          
      
          print("titleForHeaderInSection")
          //let head_title = String(sectionsInTable[section].in_time.prefix(10))
        
        return Repair_Group_List[section].title
        
      }
    
/*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.numberOfLines = 0
      
        label.font.withSize(15)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.text = Question_List[section].question

        return label
        
        
        let headercell = Bundle.main.loadNibNamed("QuestionHeaderCell", owner: self, options: nil)?.first as! QuestionHeaderCell
        
        
        headercell.title.text = Question_List[section].question
        
        return headercell

    }
    
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
*/
    
    
    var save_input_ready = false
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if (save_input_ready == true){
            save_input_ready = false
            //save_input()
            print("save")
        }
   
        view.endEditing(true)
    }
    
    func save_input(){
        var i = 0
        while(i<Repair_Group_List[0].items.count){
            
            if ( Repair_Group_List[i].type == "Short" ){
                var short = tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! QuestionCell2
                Question_List[i].short_ans = short.text_field.text!
           
            }
            
            
            i += 1
        }
        
    }
    


    func textFieldDidEndEditing(_ textField: UITextField) {
        print("@@##")
      
    
        
        
    }
    
  */

    
}

/*
extension QuestionCell2: UITextFieldDelegate {


 func textFieldDidEndEditing(_ textField: UITextField) {

print("111")
    delegate!.didEndEditing(onCell: self)


 }


}


extension CreateRepairViewController: DemoTableViewCellDelegate {


 func didEndEditing(onCell cell: QuestionCell2) {


//Indexpath for the cell in which editing have ended.


//Now do whatever you want to do with the text and indexpath.


 let indexPath = tableView.indexPath(for: cell)


 let text = cell.text_field.text
    
    Question_List[indexPath!.section].short_ans = text!
    print(text!)


 }


}
*/
