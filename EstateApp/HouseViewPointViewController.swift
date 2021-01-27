//
//  HouseViewPointViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/25.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import MapKit

class ViewPointCell:UITableViewCell{
    
    @IBOutlet weak var Name: UILabel!
    
}

class HouseViewPointViewController:UIViewController , MKMapViewDelegate,UITableViewDelegate , UITableViewDataSource{

    
    @IBAction func createAction(_ sender: Any) {
        
        
    }
    
    @IBOutlet weak var house_map: MKMapView!
    
    @IBOutlet weak var viewpointTable: UITableView!
    
    var viewPointList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:navbartintcolor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        //nav background color
        self.navigationController?.navigationBar.barTintColor = navbarcolor
        self.navigationController?.navigationBar.tintColor = navbartintcolor
        
        
        house_map.delegate = self
        
        viewpointTable.delegate = self
        viewpointTable.dataSource = self
        
        
        viewPointList.append("公園")
        viewPointList.append("美食街")
        viewPointList.append("公車站")
        
        
        
        show_map_local(location_latitude: 25.0509243, location_longitude: 121.575394)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewPointList.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewPointCell", for: indexPath) as! ViewPointCell
               
        
        cell.Name.text = viewPointList[indexPath.row]
    

               
        return cell
    }
    

       func show_map_local( location_latitude : NSNumber , location_longitude : NSNumber  ){
  
           let latDelta = 0.005  // 地圖大小
           let longDelta = 0.005
           let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
           
           let location_latitude = location_latitude   //24.957537   // 坐標
           let location_longitude = location_longitude  // 121.2388328
           
           print(location_latitude)
           print(location_longitude)
           print("show_map_local!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
           let center:CLLocation = CLLocation(latitude: CLLocationDegrees(location_latitude),longitude:CLLocationDegrees(location_longitude))
           let curentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
           house_map.setRegion(curentRegion, animated: false)
           //house_map.userLocation.title = "自己"
           
           let target_destination = MKPointAnnotation()
           target_destination.title = "房子地點"
           target_destination.subtitle = self.navigationItem.title
           target_destination.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location_latitude), longitude: CLLocationDegrees(location_longitude))
           house_map.addAnnotation(target_destination)
           
           
           
    }
    
}
