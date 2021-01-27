//
//  CreateContractInfoViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/23.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class CreateContractInfoViewController : UIViewController,UITextFieldDelegate{
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var Rent: UITextField!
    
    @IBOutlet weak var deposit: UITextField!
    
    @IBOutlet weak var currencyBtn: UIButton!
    
    @IBAction func currencyAction(_ sender: Any) {
        return
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        let okAction1 = UIAlertAction(title: "TWD",style: .default ){ (_) in
            self.currencyBtn.setTitle("TWD", for: .normal)
        }
        alertController.addAction(okAction1)
        
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func startBtnAction(_ sender: Any) {
        pickDateAction(sel_btn: startBtn)
    }
    
    
    @IBOutlet weak var enddate: UITextField!
    
    
    
    @IBOutlet weak var paytimesBtn: UIButton!
    @IBAction func paytimesAction(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        
        var n = 1
        
        
        print(glo_BuildingList)
        while ( n < 100){
            let okAction1 = UIAlertAction(title: String(n),style: .default   ){ (action:UIAlertAction!) in
                
                
                print(action.title)
                let cur_n =  action.title
                
                self.sel_pay_times = Int((cur_n as! NSString).intValue)
                self.paytimesBtn.setTitle(String(cur_n!), for: .normal)
                
                
                self.sel_end_timestamp = self.countcontractend_timestamp()
                if (self.sel_end_timestamp == 0){
                    self.enddate.text = ""
                }
                else{
                    self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                }
                
                
            }
            
            alertController.addAction(okAction1)
            
            
            
            n += 1
        }
        
        
        
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var paycycleBtn: UIButton!
    @IBAction func paycycleAction(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "列表可選擇",
            message: "",
            preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        let okAction1 = UIAlertAction(title: "月繳",style: .default ){ (_) in
            self.paycycleBtn.setTitle("月繳", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.sel_end_timestamp = self.countcontractend_timestamp()
                
                if (self.sel_end_timestamp == 0){
                    self.enddate.text = ""
                }
                else{
                    self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                }
            }
        }
        alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "季繳",style: .default){ (_) in
            
                self.paycycleBtn.setTitle("季繳", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.sel_end_timestamp = self.countcontractend_timestamp()
                
                if (self.sel_end_timestamp == 0){
                    self.enddate.text = ""
                }
                else{
                    self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                }
            }
        }
        alertController.addAction(okAction2)
        let okAction3 = UIAlertAction(title: "半年繳",style: .default){ (_) in
   
                self.paycycleBtn.setTitle("半年繳", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.sel_end_timestamp = self.countcontractend_timestamp()
                
                if (self.sel_end_timestamp == 0){
                    self.enddate.text = ""
                }
                else{
                    self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                }
            }
        }
        
        alertController.addAction(okAction3)
        
        let okAction4 = UIAlertAction(title: "年繳",style: .default){ (_) in

                self.paycycleBtn.setTitle("年繳", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.sel_end_timestamp = self.countcontractend_timestamp()
                
                if (self.sel_end_timestamp == 0){
                    self.enddate.text = ""
                }
                else{
                    self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                }
            }
        }
        
        alertController.addAction(okAction4)
        
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func sendAction(_ sender: Any) {
        sendcontractInfo_api()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyBtn.setTitle("TWD", for: .normal)
        hideKeyboardWhenTappedAround()
        
        
        button_style2(sel_button: startBtn)
        button_style2(sel_button: paytimesBtn)
        button_style2(sel_button: currencyBtn)
        button_style2(sel_button: paycycleBtn)
        button_style1(sel_button: sendBtn)
        
        
        datematter.dateFormat = "yyyy/MM/dd"
    }
    
    var delegate : DismissBackDelegate?
    var sel_object_id = ""
    var tenant_id = ""
    var sel_start_timestamp = 0
    var sel_end_timestamp = 0
    var sel_pay_times = 0
    let datematter = DateFormatter()
    
    
    var datepicker = UIDatePicker()
    var label = UILabel()
    let WIDTH = UIScreen.main.bounds.size.width
    
    
    
    
    func sendcontractInfo_api(){
        
     
        
        
        var paycycle_eng = "nil"
        if(paycycleBtn.titleLabel!.text == "月繳"){
            paycycle_eng = "Permonth"
        }
        else if (paycycleBtn.titleLabel!.text == "季繳"){
            paycycle_eng = "Perseason"
        }
        else if (paycycleBtn.titleLabel!.text == "半年繳"){
            paycycle_eng = "Perhalfyear"
        }
        else if (paycycleBtn.titleLabel!.text == "年繳"){
            paycycle_eng = "Peryear"
        }
        /*
         {
         "object_id": "106971151111105748554916085751788788395",
         "tenant_id": "YH52F9",
         "landlord_id": "jason9071",
         "currency": "TWD",
         "rent": 5000,
         "deposit": 15000,
         "start_date": 1609217882,
         "end_date": 1640753882,
         "payment_method": "Perhalfyear"
         }
         */
        
        let json: [String: Any] = ["object_id": sel_object_id,"tenant_id": tenant_id,"landlord_id": glo_account_id,"currency": currencyBtn.titleLabel!.text,"rent": Int(Rent.text!)!, "deposit": Int(deposit.text!)!,"start_date": sel_start_timestamp,"end_date": sel_end_timestamp,  "payment_method": paycycle_eng ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        print("OKOK")
        
        // create post request
        let url = URL(string: api_host + api_basePath + "/contractmanagement/createcontract")!
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
                            let d_Items = data_JSON["Items"] as! Dictionary<String,Any>
                            
                            let d_contract_id = d_Items["contract_id"] as! String
                            //self.delegate?.dismissBack(sendData: <#T##Any#>)
                            DispatchQueue.main.sync {
                                
                                self.delegate?.dismissBack(sendData: d_contract_id)
                                self.dismiss(animated: true, completion: nil)
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
    
    
    
    func pickDateAction(sel_btn :UIButton) {
        let datealert = UIAlertController(title: "\n\n\n\n",
                                          message: "",
                                          preferredStyle: .actionSheet)
        // frame
        datepicker.frame = CGRect(x: 0,
                                  y: 0,
                                  width: datealert.view.frame.width - 2.5 * 8,
                                  height: 130)
        // 語言
        datepicker.locale = Locale(identifier:"zh_CN")
        // 分鐘間隔
        //datepicker.minuteInterval = 5
        // 預設日期為今天
        datepicker.date = NSDate() as Date
        // 輸入格式
        //DateFormatter().dateFormat = "yyyy-MM-dd"
        // 最早日期
        //datepicker.minimumDate = DateFormatter().date(from: "2015-01-01")
        // 最晚日期
        //datepicker.maximumDate = DateFormatter().date(from: "2017-12-31")
        // 選擇模式
        datepicker.datePickerMode = .date
        /*
         UIDatePickerMode
         .countDownTimer      小時, 分鐘
         .date                日期
         .dateAndTime         日期, 時間
         .time                時間
         */
        // 加入動作
        datepicker.addTarget(self,
                             action: #selector(self.dateChanged),
                             for: .valueChanged)
        datealert.view.addSubview(self.datepicker)
        
        let cancel = UIAlertAction(title: "取消",
                                   style: .cancel,
                                   handler: {(action: UIAlertAction!) -> Void in
                                    sel_btn.titleLabel!.text = "點擊選擇日期"
        })
        datealert.addAction(cancel)
        
        let selection = UIAlertAction(title: "確定",
                                      style: .default,
                                      handler: {(action: UIAlertAction!) -> Void in
                                        
                                        self.sel_start_timestamp = Int(self.datepicker.date.timeIntervalSince1970)
                                        self.sel_end_timestamp = self.countcontractend_timestamp()
                                        self.startBtn.setTitle(self.datematter.string(from: self.datepicker.date), for: .normal)
                                        self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                                        
                                        if (self.sel_end_timestamp == 0){
                                            self.enddate.text = ""
                                        }
                                        else{
                                            self.enddate.text = self.datematter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sel_end_timestamp)))
                                        }
        })
        datealert.addAction(selection)
        present(datealert,
                animated: true,
                completion: nil)
    }
    
    func countcontractend_timestamp() -> Int{
        if (sel_start_timestamp == 0  || sel_pay_times == 0  ){
            return 0
        }
        if(paycycleBtn.titleLabel!.text == "月繳"){
            return sel_start_timestamp + (31536000 / 12 ) * sel_pay_times
        }
        else if (paycycleBtn.titleLabel!.text == "季繳"){
            return sel_start_timestamp + (31536000 / 4 ) * sel_pay_times
        }
        else if (paycycleBtn.titleLabel!.text == "半年繳"){
            return sel_start_timestamp + (31536000 / 2 ) *  sel_pay_times
        }
        else if (paycycleBtn.titleLabel!.text == "年繳"){
            return sel_start_timestamp + 31536000 * sel_pay_times
        }
        return 0
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //DateFormatter().dateFormat = "yyyy 年 MM 月 dd 日"
        /*
         yyyy     ex. 2017, 2016
         yy       ex. 17, 16 (西元末兩位數字)
         MMMM     ex. January, February
         MMM      ex. Jan, Feb
         MM       ex. 01, 02 (月份)
         dd       ex. 01, 02 (日期)
         EEEE     ex. Sunday, Monday
         EEE      ex. Sun, Mon
         HH       ex. 13, 14 (24小時制)
         hh       ex. 01, 02 (12小時制)
         mm       ex. 分
         ss       ex. 秒
         */
        //let datematter = DateFormatter()
        //datematter.dateFormat = "yyyy年MM月dd日"
        //startBtn.setTitle(datematter.string(from: self.datepicker.date), for: .normal)
    }
    
    
    
    
}
