//
//  LandlordContractViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/13.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import Charts


class LandlordContractPropertyCell : UITableViewCell{
    
    @IBOutlet weak var Title: UILabel!
}


class LandlordContractViewController : UIViewController , UITableViewDelegate , UITableViewDataSource,ChartViewDelegate{
    
    
    
    @IBOutlet weak var ChartViewTitle: UILabel!
    @IBOutlet weak var ChartView: LineChartView!
    @IBOutlet weak var PieAreaChartTitle: UILabel!
    @IBOutlet weak var PieAreaChart: PieChartView!
    
    @IBOutlet weak var PieTypeChartTitle: UILabel!
    @IBOutlet weak var PieTypeChart: PieChartView!
    
    @IBOutlet weak var propertyTable: UITableView!
    
    @IBOutlet weak var pick_btn: UIButton!
    
    @IBOutlet weak var segController: UISegmentedControl!
    
    @IBAction func segAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func pick_typeAction(_ sender: Any) {
        
  
        // 建立一個提示框
                let alertController = UIAlertController(
                    title: "列表可選擇",
                    message: "",
                    preferredStyle: .actionSheet)

    
                let cancelAction = UIAlertAction(
                    title: "取消",
                    style: .cancel,
                    handler: nil)

                alertController.addAction(cancelAction)


        let okAction1 = UIAlertAction(title: "到期日",style: .default ){ (_) in
            self.pick_btn.setTitle("到期日", for: .normal)
        }
        alertController.addAction(okAction1)
        let okAction2 = UIAlertAction(title: "類型",style: .default){ (_) in
            self.pick_btn.setTitle("類型", for: .normal)
        }
        alertController.addAction(okAction2)
        let okAction3 = UIAlertAction(title: "金額",style: .default){ (_) in
            self.pick_btn.setTitle("金額", for: .normal)
        }
        
        alertController.addAction(okAction3)
        
        let okAction4 = UIAlertAction(title: "坪數",style: .default){ (_) in
            self.pick_btn.setTitle("坪數", for: .normal)
        }
        alertController.addAction(okAction4)
        

        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    let Piechart = PieChartView()
    
    let list = ["11/26","12/26","1/26","2/26"]
    let amount = [2.0 , 5.0 , 16.0 , 18.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChartView.delegate = self
        PieAreaChart.delegate = self
        PieTypeChart.delegate = self
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        propertyTable.dataSource = self
        propertyTable.delegate = self
        

        
        
        //Piechart.frame = ChartView.frame
        setLineChart(sel_list: list, sel_amount: amount)
        
        //view.addSubview(Piechart)
        
        setPieAreaChart(sel_list: AreaList, sel_amount: AreaAmount)
        
        setPieTypeChart(sel_list: TypeList, sel_amount: TypeAmount)
        
        
    }
    
    func setLineChart(sel_list :[String], sel_amount:[Double]){
      
        
        var dataSet = LineChartData()
            var dataEntry = [ChartDataEntry]()
            for i in 0..<4{
                dataEntry.append(ChartDataEntry(x: Double(i), y: Double(amount[i])))
               
            }
            
           
            let line1 = LineChartDataSet(entries:dataEntry , label: "到期日")
            line1.colors = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]

            line1.lineWidth = 3
            dataSet.addDataSet(line1 )
            
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        dataSet.setValueFormatter(DefaultValueFormatter(formatter: formatter))
   
        
        ChartView.data = dataSet
        ChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
        ChartView.xAxis.labelPosition = .bottom
        ChartView.xAxis.drawGridLinesEnabled = false
        ChartView.animate(xAxisDuration: 1,yAxisDuration: 1)
        
       
        
    }
    
    var AreaList = ["0-20坪","21-30坪","31-50坪","51-100坪"]
    var AreaAmount = [3.0 ,3.0 ,5.0 ,7.0  ]
    
    func setPieAreaChart(sel_list :[String], sel_amount:[Double]){
        var dataEntry = [PieChartDataEntry]()
        for i in 0..<AreaList.count {
            dataEntry.append(PieChartDataEntry(value: sel_amount[i], label: sel_list[i]))
           
        }
        
        let set = PieChartDataSet(entries: dataEntry)
        set.label = ""
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        
        PieAreaChart.data = data
        PieAreaChart.holeRadiusPercent = 0
        PieAreaChart.transparentCircleColor = UIColor.clear
        

        //PieAreaChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
        PieAreaChart.animate(xAxisDuration: 1,yAxisDuration: 1)
        
    }
    
    var TypeList = ["停車位","辦公室","店面","套房"]
    var TypeAmount = [4.0 ,2.0 ,8.0 ,3.0  ]
    
    func setPieTypeChart(sel_list :[String], sel_amount:[Double]){
        var dataEntry = [PieChartDataEntry]()
        for i in 0..<TypeList.count{
            dataEntry.append(PieChartDataEntry(value: sel_amount[i], label: sel_list[i]))
           
        }
        
        let set = PieChartDataSet(entries: dataEntry)
        set.label = ""
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        PieTypeChart.data = data
        PieTypeChart.holeRadiusPercent = 0
        PieTypeChart.transparentCircleColor = UIColor.clear
   
        //PieTypeChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: sel_list)
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        

        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return total_cell_count()
      
            
            return list.count
            
        
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandlordContractPropertyCell", for: indexPath) as! LandlordContractPropertyCell
                   
            
            cell.Title.text = list[indexPath.row]
         

                   
            return cell
        }

        /*
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return PlaceList[section].name
        }
        */
        
       
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("select")
            
            performSegue(withIdentifier: "propertydetailsegue", sender: self)
           
        }

    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("select")
        //print(entry.description)
        
        if ( chartView is LineChartView){
            return
        }
        
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex]{
            let Index = dataSet.entryIndex(entry: entry)
            performSegue(withIdentifier: "selpropertysegue", sender: self)
            print(Index)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selpropertysegue" ){
            
            
            let vc = segue.destination as! PropertyListViewController
            vc.SegueType = "preparedata"
         
   
            
        }
    }
      
        
}
