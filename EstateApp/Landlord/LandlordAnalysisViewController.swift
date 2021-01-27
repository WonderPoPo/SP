//
//  LandlordAnalysisViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/14.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import Charts

class LandlordAnalysisViewController : UIViewController , ChartViewDelegate{
    
   
    @IBOutlet weak var BarChartTitle: UILabel!
    @IBOutlet weak var BarChart: BarChartView!
    
    @IBOutlet weak var PieGroupChartTitle: UILabel!
    @IBOutlet weak var PieGroupChart: PieChartView!
    

    @IBOutlet weak var PieAreaChart: PieChartView!
    
    
    @IBOutlet weak var segController: UISegmentedControl!
    
    @IBAction func segAction(_ sender: Any) {
        if ( segController.selectedSegmentIndex == 0){
            BarChartTitle.text = "組別分佈"
   
            self.setGroupBarChart(sel_list: self.groupBarList)
            PieGroupChartTitle.text = "依組別分物件"

            self.setGroupPieChart(sel_list: self.groupPieList)
        }
        else if ( segController.selectedSegmentIndex == 1){
            BarChartTitle.text = "類型分佈"
            self.setTypeBarChart(sel_list: self.typeBarList)
            
            PieGroupChartTitle.text = "依類型分物件"
            self.setTypePieTypeChart(sel_list: self.typePieList)
        }
        else {
            BarChartTitle.text = "坪數分佈"
            self.setAreaBarChart(sel_list: self.areaBarList)
            PieGroupChartTitle.text = "依坪數分物件"
            self.setAreaPieTypeChart(sel_list: self.areaPieList)
            
        }
        
        
    }
    
    let list = ["已出租","未出租"]
    let amount = [81.0 , 5.0 ]
    
    var income = ["上個月","這個月"]
    var income_value  = [10000.0,13000.0,15000.0,20000.0]
    
    var pay_value  = [0.0,200.0,2000.0,500.0]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //propertyTable.dataSource = self
        //propertyTable.delegate = self
        segController.selectedSegmentTintColor = maincolor2
        segController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        
       let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
       self.navigationController?.navigationBar.titleTextAttributes = textAttributes
       //nav background color
       self.navigationController?.navigationBar.barTintColor = navbarcolor
       self.navigationController?.navigationBar.tintColor = navbartintcolor
       
        BarChart.delegate = self
        PieGroupChart.delegate = self
        PieAreaChart.delegate = self
        

        get_group_Bar_api()
        get_group_pie_api()
        
        get_type_Bar_api()
        get_type_pie_api()
        
        get_area_Bar_api()
        get_area_pie_api()
        
    }
    
    struct AnalysisGroupBarData :Decodable{
        let Message : String
        let Items : [Items]
        
        struct Items :Decodable{
            let group_name: String
            let rent: Int
            let return_on_investment : Double
            
        }
        
    }
    
    struct AnalysisGroupPieData :Decodable{
        let Message : String
        let Items : [Items]
        
        struct Items :Decodable{
            let group_name: String
            let counter: Int
            let object_id_list : [String]
        }
    }
    
    
    struct AnalysisTypeBarData :Decodable{
        let Message : String
        let Items : [Items]
        
        struct Items :Decodable{
            let type: String
            let rent: Int
            let return_on_investment : Double
            
        }
        
    }
    
    struct AnalysisTypePieData :Decodable{
        let Message : String
        let Items : [Items]
        
        struct Items :Decodable{
            let type: String
            let counter: Int
            let object_id_list : [String]
        }
    }
    
    
    struct AnalysisAreaBarData :Decodable{
        let Message : String
        let Items : [Items]
        
        struct Items :Decodable{
            let area: String
            let rent: Int
            let return_on_investment : Double
            
        }
        
    }
    
    struct AnalysisAreaPieData :Decodable{
        let Message : String
        let Items : [Items]
        
        struct Items :Decodable{
            let area: String
            var counter: Int
            var object_id_list : [String]
        }
    }
    

    var groupBarList = [AnalysisGroupBarData.Items]()
    var groupPieList = [AnalysisGroupPieData.Items]()
    
    var typeBarList = [AnalysisTypeBarData.Items]()
    var typePieList = [AnalysisTypePieData.Items]()
    
    var areaBarList = [AnalysisAreaBarData.Items]()
    var areaPieList = [AnalysisAreaPieData.Items]()
    
    func get_group_Bar_api(){

        let json: [String: Any] = ["landlord_id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/reportmanagement/getbarchartbygrouptag")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(AnalysisGroupBarData.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        self.groupBarList = eventdata.Items
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                                if (self.segController.selectedSegmentIndex == 0 ){
                                    self.setGroupBarChart(sel_list: self.groupBarList)
                                    
                                }
                                
                            }
                             
                         }
                   
               
                         print("OK")

                     
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
    
    func get_group_pie_api(){

        let json: [String: Any] = ["landlord_id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/reportmanagement/getpiechartbygrouptag")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(AnalysisGroupPieData.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        self.groupPieList = eventdata.Items
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                                if (self.segController.selectedSegmentIndex == 0 ){
                                    self.setGroupPieChart(sel_list: self.groupPieList)
                                    
                                }
                                
                            }
                             
                         }
                   
               
                         print("OK")

                     
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
    
    ///////////////////////////////type///////////////////////////////////
    
    func get_type_Bar_api(){

        let json: [String: Any] = ["landlord_id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/reportmanagement/getbarchartbyobjecttype")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(AnalysisTypeBarData.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        self.typeBarList = eventdata.Items
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                                if (self.segController.selectedSegmentIndex == 1 ){
                                    self.setTypeBarChart(sel_list: self.typeBarList)
                                    
                                }
                                
                            }
                             
                         }
                   
               
                         print("OK")

                     
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
    
    func get_type_pie_api(){

        let json: [String: Any] = ["landlord_id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/reportmanagement/getpiechartbyobjecttype")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(AnalysisTypePieData.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        self.typePieList = eventdata.Items
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                                if (self.segController.selectedSegmentIndex == 1 ){
                                    self.setTypePieTypeChart(sel_list: self.typePieList)
                                    
                                }
                                
                            }
                             
                         }
                   
               
                         print("OK")

                     
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
    
    ///////////////////////////////area///////////////////////////////////
    
    func get_area_Bar_api(){

        let json: [String: Any] = ["landlord_id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/reportmanagement/getbarchartbyarea")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(AnalysisAreaBarData.self, from: downloadedData)
                        print(eventdata.Message)
                     
                        self.areaBarList = eventdata.Items
                         
                         if (eventdata.Message == "No Error"){
                            DispatchQueue.main.sync {
                                if (self.segController.selectedSegmentIndex == 2 ){
                                    self.setAreaBarChart(sel_list: self.areaBarList)
                                    
                                }
                                
                            }
                             
                         }
                   
               
                         print("OK")

                     
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
    
    var areaseglist = [AnalysisAreaPieData.Items]()
    
    func get_area_pie_api(){

        let json: [String: Any] = ["landlord_id": glo_account_id]
                
             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             let url = URL(string: api_host + api_basePath + "/reportmanagement/getpiechartbyarea")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"

                // insert json data to the request
             request.httpBody = jsonData

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 
                 

        
                 if let downloadedData = data{
                     do{
                         let decoder = JSONDecoder()
                         let eventdata = try decoder.decode(AnalysisAreaPieData.self, from: downloadedData)
                        print(eventdata.Message)
                        print("get_area_pie_api")
                     
                        
                         
                         if (eventdata.Message == "No Error"){
                            self.areaPieList = eventdata.Items
                            self.areaseglist.append(AnalysisAreaPieData.Items(area: "0-20坪", counter: 0, object_id_list: []))
                            self.areaseglist.append(AnalysisAreaPieData.Items(area: "20-30坪", counter: 0, object_id_list: []))
                            self.areaseglist.append(AnalysisAreaPieData.Items(area: "30-50坪", counter: 0, object_id_list: []))
                            self.areaseglist.append(AnalysisAreaPieData.Items(area: "50-100坪", counter: 0, object_id_list: []))
                            self.areaseglist.append(AnalysisAreaPieData.Items(area: "100坪以上", counter: 0, object_id_list: []))
                            for i in 0..<self.areaPieList.count{
                                if ( (self.areaPieList[i].area as NSString).doubleValue <= 20 ){
                                    print("fuckcc")
                                    self.areaseglist[0].counter += 1
                                    self.areaseglist[0].object_id_list += self.areaPieList[i].object_id_list
                                }
                                else if ( (self.areaPieList[i].area as NSString).doubleValue > 20 && (self.areaPieList[i].area as! NSString).doubleValue <= 30  ){
                                    self.areaseglist[1].counter += 1
                                    self.areaseglist[1].object_id_list += self.areaPieList[i].object_id_list
                                }
                                else if ((self.areaPieList[i].area as! NSString).doubleValue > 30 && (self.areaPieList[i].area as! NSString).doubleValue <= 50){
                                    self.areaseglist[2].counter += 1
                                    self.areaseglist[2].object_id_list += self.areaPieList[i].object_id_list
                                }
                                else if ((self.areaPieList[i].area as! NSString).doubleValue > 50 && (self.areaPieList[i].area as! NSString).doubleValue <= 100){
                                    self.areaseglist[3].counter += 1
                                    self.areaseglist[3].object_id_list += self.areaPieList[i].object_id_list
                                }
                                else {
                                    self.areaseglist[4].counter += 1
                                    self.areaseglist[4].object_id_list += self.areaPieList[i].object_id_list
                                }
                            }
                            
                            print(self.areaseglist)
                            self.areaPieList = self.areaseglist

                            DispatchQueue.main.sync {
                                if (self.segController.selectedSegmentIndex == 2 ){
                                    
                                    self.setAreaPieTypeChart(sel_list: self.areaPieList)
                                    
                                }
                                
                            }
                             
                         }
                   
               
                         print("OK")

                     
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
    
    
    var GroupList = ["A","B","C","D","E","其他"]
    var rentList = [4000.0 ,2000.0 ,8000.0 ,3000.0,5000.0,10000.0  ]
    var percentList = [1.0 ,3.0 ,7.0 ,8.0,6.0,5.0  ]
    
    
    
    var AreaList = ["0-20坪","21-30坪","31-50坪","51-100坪","100坪以上"]
    var AreaAmount = [3.0 ,3.0 ,5.0 ,7.0 ,1.0 ]
    
    
    var TypeAmount = [4.0 ,2.0 ,8.0 ,3.0,5.0,10.0  ]
        
    
    func setGroupBarChart(sel_list :[AnalysisGroupBarData.Items]){
       
         
        var dataSet = BarChartData()
        var dataEntry1 = [BarChartDataEntry]()
        var dataEntry2 = [BarChartDataEntry]()
        for i in 0..<sel_list.count{
            dataEntry1.append(BarChartDataEntry(x: Double(i), y: Double(sel_list[i].rent) / 10000))
            dataEntry2.append(BarChartDataEntry(x: Double(i), y: Double(sel_list[i].return_on_investment)))
        }
             
            
        let bar1 = BarChartDataSet(entries:dataEntry1 , label: "租金/坪")
        bar1.colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]

        dataSet.addDataSet(bar1 )
        
        let bar2 = BarChartDataSet(entries:dataEntry2 , label: "投資報酬率")
        bar2.colors = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        
        let percentformatter = NumberFormatter()
        percentformatter.numberStyle = .decimal
        percentformatter.minimumIntegerDigits = 1
        percentformatter.maximumIntegerDigits = 3
        percentformatter.maximumFractionDigits = 2
        percentformatter.positiveSuffix = "%"
        
        BarChart.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: percentformatter) as IAxisValueFormatter
        
        bar2.axisDependency = Charts.YAxis.AxisDependency.right
        
        dataSet.addDataSet(bar2)

             
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = "萬 台幣"
        //dataSet.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        BarChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter) as IAxisValueFormatter
        
        let groupSpace = 0.54
        let barSpace = 0.03
        let barWidth = 0.2
        dataSet.barWidth = barWidth

        BarChart.xAxis.axisMinimum = Double(0)
        BarChart.xAxis.axisMaximum = Double(0) + dataSet.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(2)  // group count : 2
        dataSet.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        
        
      
        
        BarChart.data = dataSet
        
        
        var xAxisvalueList = [String]()

        var percentList = [Double]()
        
        if ( sel_list.count > 0) {
            for item in sel_list{
                xAxisvalueList.append(item.group_name)
                percentList.append(item.return_on_investment)
                
                print(item.return_on_investment)
            }
            
        }

        
        BarChart.leftAxis.axisMinimum = 0
        BarChart.rightAxis.axisMinimum = 0

        if (percentList.count > 0){
            BarChart.rightAxis.axisMaximum =  percentList.max()! + 10
        }
        else {
            BarChart.rightAxis.axisMaximum =   10
        }
        
        
        BarChart.xAxis.axisMaximum = Double( ( sel_list.count  ) )
        
        
     
        
        BarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisvalueList)
        
   
        
        BarChart.xAxis.centerAxisLabelsEnabled = true
      
        BarChart.xAxis.labelPosition = .bottom
        BarChart.xAxis.drawGridLinesEnabled = false
        
        BarChart.rightAxis.drawGridLinesEnabled = false
        BarChart.leftAxis.drawGridLinesEnabled = false
             
        BarChart.animate(xAxisDuration: 1,yAxisDuration: 1)

         
     }
    

   
     func setGroupPieChart(sel_list :[AnalysisGroupPieData.Items]){
         var dataEntry = [PieChartDataEntry]()
         for i in 0..<sel_list.count{
            dataEntry.append(PieChartDataEntry(value: Double(sel_list[i].counter), label: sel_list[i].group_name))
            
         }
         
         let set = PieChartDataSet(entries: dataEntry)
         set.label = ""
     
         set.colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
         let data = PieChartData(dataSet: set)
         
         let formatter = NumberFormatter()
         formatter.maximumFractionDigits = 0
         data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
         
         PieGroupChart.data = data
         PieGroupChart.holeRadiusPercent = 0
         PieGroupChart.transparentCircleColor = UIColor.clear
    
         //PieTypeChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
         PieGroupChart.animate(xAxisDuration: 1,yAxisDuration: 1)

         
     }
    
    func setTypeBarChart(sel_list :[AnalysisTypeBarData.Items]){
        
          
         var dataSet = BarChartData()
         var dataEntry1 = [BarChartDataEntry]()
         var dataEntry2 = [BarChartDataEntry]()
         for i in 0..<sel_list.count{
             dataEntry1.append(BarChartDataEntry(x: Double(i), y: Double(sel_list[i].rent) / 10000))
             dataEntry2.append(BarChartDataEntry(x: Double(i), y: Double(sel_list[i].return_on_investment)))
         }
              
             
         let bar1 = BarChartDataSet(entries:dataEntry1 , label: "租金/坪")
         bar1.colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]

         dataSet.addDataSet(bar1 )
         
         let bar2 = BarChartDataSet(entries:dataEntry2 , label: "投資報酬率")
         bar2.colors = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
         
         let percentformatter = NumberFormatter()
         percentformatter.numberStyle = .decimal
         percentformatter.minimumIntegerDigits = 1
         percentformatter.maximumIntegerDigits = 3
         percentformatter.maximumFractionDigits = 2
         percentformatter.positiveSuffix = "%"
         
         BarChart.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: percentformatter) as IAxisValueFormatter
         
         bar2.axisDependency = Charts.YAxis.AxisDependency.right
         
         dataSet.addDataSet(bar2)

              
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.maximumFractionDigits = 0
         formatter.positiveSuffix = "萬 台幣"
         //dataSet.setValueFormatter(DefaultValueFormatter(formatter: formatter))

         BarChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter) as IAxisValueFormatter
         
         let groupSpace = 0.54
         let barSpace = 0.03
         let barWidth = 0.2
         dataSet.barWidth = barWidth

         BarChart.xAxis.axisMinimum = Double(0)
         BarChart.xAxis.axisMaximum = Double(0) + dataSet.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(2)  // group count : 2
         dataSet.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
         
         
       
         
         BarChart.data = dataSet
         
         
         var xAxisvalueList = [String]()

         var percentList = [Double]()
         
         if ( sel_list.count > 0) {
             for item in sel_list{
                xAxisvalueList.append(item.type)
                 percentList.append(item.return_on_investment)
                 
                 print(item.return_on_investment)
             }
             
         }

         
         BarChart.leftAxis.axisMinimum = 0
         BarChart.rightAxis.axisMinimum = 0

         if (percentList.count > 0){
             BarChart.rightAxis.axisMaximum =  percentList.max()! + 10
         }
         else {
             BarChart.rightAxis.axisMaximum =   10
         }
         
         
         BarChart.xAxis.axisMaximum = Double( ( sel_list.count  ) )
         
         
         
         
         BarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisvalueList)
         
    
         
         BarChart.xAxis.centerAxisLabelsEnabled = true
       
         BarChart.xAxis.labelPosition = .bottom
         BarChart.xAxis.drawGridLinesEnabled = false
         
         BarChart.rightAxis.drawGridLinesEnabled = false
         BarChart.leftAxis.drawGridLinesEnabled = false
              
         BarChart.animate(xAxisDuration: 1,yAxisDuration: 1)

          
      }
     

    
      func setTypePieTypeChart(sel_list :[AnalysisTypePieData.Items]){
          var dataEntry = [PieChartDataEntry]()
          for i in 0..<sel_list.count{
            dataEntry.append(PieChartDataEntry(value: Double(sel_list[i].counter), label: propertytype_to_chinese(sel_type: sel_list[i].type)))
             
          }
          
          let set = PieChartDataSet(entries: dataEntry)
          set.label = ""
      
          set.colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
          let data = PieChartData(dataSet: set)
          
          let formatter = NumberFormatter()
          formatter.maximumFractionDigits = 0
          data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
          
          PieGroupChart.data = data
          PieGroupChart.holeRadiusPercent = 0
          PieGroupChart.transparentCircleColor = UIColor.clear
     
          //PieTypeChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
          PieGroupChart.animate(xAxisDuration: 1,yAxisDuration: 1)

          
      }
    
    
    func propertytype_to_chinese(sel_type:String)->String{
        
        if (sel_type == "Dwelling"){
            return "住宅"
        }
        else if (sel_type == "Suite"){
            return "套房"
        }
        else if (sel_type == "Storefront"){
            return "店面"
        }
        else if (sel_type == "Office"){
            return "辦公"
        }
        else if (sel_type == "DwellingOffice"){
            return "住辦"
        }
        else if (sel_type == "Factory"){
            return "廠房"
        }
        else if (sel_type == "ParkingSpace"){
            return "車位"
        }
        else if (sel_type == "LandPlace"){
            return "土地"
        }
        else if (sel_type == "Other"){
            return "其他"
        }
        else{
            return sel_type
        }
        
    }
    func setAreaBarChart(sel_list :[AnalysisAreaBarData.Items]){
        
          
         var dataSet = BarChartData()
         var dataEntry1 = [BarChartDataEntry]()
         var dataEntry2 = [BarChartDataEntry]()
         for i in 0..<sel_list.count{
             dataEntry1.append(BarChartDataEntry(x: Double(i), y: Double(sel_list[i].rent ) / 10000 ))
             dataEntry2.append(BarChartDataEntry(x: Double(i), y: Double(sel_list[i].return_on_investment)))
         }
              
             
         let bar1 = BarChartDataSet(entries:dataEntry1 , label: "租金/坪")
         bar1.colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]

         dataSet.addDataSet(bar1 )
         
         let bar2 = BarChartDataSet(entries:dataEntry2 , label: "投資報酬率")
         bar2.colors = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
         
         let percentformatter = NumberFormatter()
         percentformatter.numberStyle = .decimal
         percentformatter.minimumIntegerDigits = 1
         percentformatter.maximumIntegerDigits = 3
         percentformatter.maximumFractionDigits = 2
         percentformatter.positiveSuffix = "%"
         
         BarChart.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: percentformatter) as IAxisValueFormatter
         
         bar2.axisDependency = Charts.YAxis.AxisDependency.right
         
         dataSet.addDataSet(bar2)

              
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.maximumFractionDigits = 0
         formatter.positiveSuffix = "萬 台幣"
         //dataSet.setValueFormatter(DefaultValueFormatter(formatter: formatter))

         BarChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter) as IAxisValueFormatter
         
         let groupSpace = 0.54
         let barSpace = 0.03
         let barWidth = 0.2
         dataSet.barWidth = barWidth

         BarChart.xAxis.axisMinimum = Double(0)
         BarChart.xAxis.axisMaximum = Double(0) + dataSet.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(2)  // group count : 2
         dataSet.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
         
         
       
         
         BarChart.data = dataSet
         
         
         var xAxisvalueList = [String]()

         var percentList = [Double]()
         
         if ( sel_list.count > 0) {
             for item in sel_list{
                xAxisvalueList.append(item.area)
                 percentList.append(item.return_on_investment)
                 
                 print(item.return_on_investment)
             }
             
         }

         BarChart.leftAxis.axisMinimum = 0
         
         BarChart.rightAxis.axisMinimum = 0

         if (percentList.count > 0){
             BarChart.rightAxis.axisMaximum =  percentList.max()! + 10
         }
         else {
             BarChart.rightAxis.axisMaximum =   10
         }
         
         
         BarChart.xAxis.axisMaximum = Double( ( sel_list.count  ) )
         
         
         
         
         BarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisvalueList)
         
    
         
         BarChart.xAxis.centerAxisLabelsEnabled = true
       
         BarChart.xAxis.labelPosition = .bottom
         BarChart.xAxis.drawGridLinesEnabled = false
         
         BarChart.rightAxis.drawGridLinesEnabled = false
         BarChart.leftAxis.drawGridLinesEnabled = false
              
         BarChart.animate(xAxisDuration: 1,yAxisDuration: 1)

          
      }
     

    
      func setAreaPieTypeChart(sel_list :[AnalysisAreaPieData.Items]){
          var dataEntry = [PieChartDataEntry]()
        
          for i in 0..<sel_list.count{
            dataEntry.append(PieChartDataEntry(value: Double(sel_list[i].counter), label: sel_list[i].area + "坪"))
             
          }
          
          let set = PieChartDataSet(entries: dataEntry)
          set.label = ""
      
          set.colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
          let data = PieChartData(dataSet: set)
          
          let formatter = NumberFormatter()
          formatter.maximumFractionDigits = 0
          data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
          
          PieGroupChart.data = data
          PieGroupChart.holeRadiusPercent = 0
          PieGroupChart.transparentCircleColor = UIColor.clear
     
          //PieTypeChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
          PieGroupChart.animate(xAxisDuration: 1,yAxisDuration: 1)

          
      }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("select")
        //print(entry.description)
        //print(highlight.dataSetIndex)
        if ( chartView is BarChartView){
            return
        }
        
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex]{
            let Index = dataSet.entryIndex(entry: entry)
            print(Index)
            var sel_group_name = ""
            if (segController.selectedSegmentIndex == 0){
                sel_group_name = groupPieList[Index].group_name
                sel_object_id_list = groupPieList[Index].object_id_list
            }
            else if (segController.selectedSegmentIndex == 1){
                sel_group_name = typePieList[Index].type
                sel_object_id_list = typePieList[Index].object_id_list
            }
            else if (segController.selectedSegmentIndex == 2){
                sel_group_name = areaPieList[Index].area
                sel_object_id_list = areaPieList[Index].object_id_list
            }
   
            
            performSegue(withIdentifier: "selpropertysegue", sender: sel_group_name)
            //sel_object_id_list =
            
        }
    }
    
    var sel_object_id_list = [String]()
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "selpropertysegue" ){
             
             
             let vc = segue.destination as! PropertyListViewController
            print((sender as! String))
            vc.title = (sender as! String) + "列表"
             vc.SegueType = "preparedata"
             vc.sel_object_id_list = self.sel_object_id_list
    
             
         }
     }
       
    
}
