//
//  Global.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/10/15.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//
import UIKit
import CoreData



let api_host = "https://64lz06kei0.execute-api.ap-southeast-1.amazonaws.com"
let api_basePath = "/Alpha"

var glo_account_icon_url = "nil"
var glo_account_auth = ""
var glo_account_sex = ""
var glo_account_id = ""
var glo_account_pw = ""
var glo_account_name = ""
var glo_account_mail = ""
var glo_account_phone = ""
var glo_account_annual_income = ""
var glo_account_industry = ""
var glo_account_profession = ""

var glo_account_system_id = ""
var glo_tenant_object_id = ""   // 租客object_id
var glo_root_id = "" // 租客的房東


var glo_staff_tenant_id_list = [String]()
var glo_staff_technician_id_list = [String]()
var glo_staff_agent_id_list = [String]()
var glo_staff_accountant_id_list = [String]()

var maincolor1 = #colorLiteral(red: 0.05882352941, green: 0.8392156863, blue: 0.6156862745, alpha: 1)
var maincolor2 = #colorLiteral(red: 0.1254901961, green: 0.4980392157, blue: 0.3843137255, alpha: 1)
var maincolor3 = #colorLiteral(red: 0.1960784314, green: 0.6274509804, blue: 0.737254902, alpha: 1)

var tabbartint = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
var navbartintcolor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
var navbarcolor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
var buttonbackgroundcolor = #colorLiteral(red: 0.1960784314, green: 0.6274509804, blue: 0.737254902, alpha: 1)
var buttontintcolor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

var editactionbackgroundcolor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)

var color0 = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
var color1 = #colorLiteral(red: 0.8196078431, green: 0.9058823529, blue: 0.9490196078, alpha: 1)  // D1E7F2
var color2 = #colorLiteral(red: 0.1254901961, green: 0.4980392157, blue: 0.3843137255, alpha: 1)


struct passdata1{
    var type : String
    var any_data : Any
}

func button_style1( sel_button:UIButton){
    sel_button.backgroundColor = buttonbackgroundcolor
    sel_button.tintColor = buttontintcolor
    sel_button.cornerRadius = 4
    
    
}

func button_style2( sel_button:UIButton){
    sel_button.backgroundColor = buttontintcolor
    sel_button.tintColor = buttonbackgroundcolor
    sel_button.cornerRadius = 4
    sel_button.borderWidth = 1
    sel_button.borderColor = buttonbackgroundcolor
    
    
}


func button_style3( sel_button:UIButton){
    
    sel_button.backgroundColor = buttonbackgroundcolor
    sel_button.tintColor = buttontintcolor
    sel_button.cornerRadius = sel_button.frame.height * 0.5
 
    
}

func label_style3( sel_label:UILabel){
    
    sel_label.clipsToBounds = true
    sel_label.backgroundColor = buttonbackgroundcolor
    sel_label.textColor = buttontintcolor
    sel_label.cornerRadius = sel_label.frame.height * 0.5
 
    
}





var color3 = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)


func InAPPMessage(title:String,message:String){
    
    var rect = CGRect(x: 10, y: -150, width: UIScreen.main.bounds.width - 20, height: 100)
    let view = UIView(frame: rect)
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    view.clipsToBounds = true
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.8
    view.layer.shadowOffset = CGSize(width: 0.8, height: 2.0)
    view.layer.shadowRadius = 2
    view.layer.cornerRadius = 10
    view.alpha = 0.9

    rect = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 40, height: 80)
    let messagelabel = UILabel(frame: rect)

    //print(userInfo)
    

    messagelabel.text = title + "\n" + message
          
    
          
    messagelabel.numberOfLines = 3
    view.addSubview(messagelabel)
          
    //view.frame = CGRect.init(x: 0, y: -150, width: UIScreen.main.bounds.width, height: 100)
          
          
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

    if var topController = keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController

        }

        topController.view.addSubview(view)
        UIView.animate(withDuration:0.5){
            view.frame = CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 100)
                  
        }
              
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
            UIView.animate(withDuration:0.5){
                view.frame = CGRect(x: 10, y: -150, width: UIScreen.main.bounds.width - 20, height: 100)
            }
        }
    print("2")
    // topController should now be your topmost view controller
    }
}

func auth_chinese_to_eng (sel_auth:String) -> String{
    if (sel_auth == "房東"){
        return "landlord"
    }
    else if (sel_auth == "租客"){
        return "tenant"
    }
    else if (sel_auth == "維修人員"){
        return "technician"
    }
    else if (sel_auth == "會計師"){
        return "accountant"
    }
    else if (sel_auth == "管理"){
        return "agent"
    }
    else if (sel_auth == "admin"){
        return "admin"
    }
    else {
        return ""
    }
}


struct Message_data : Decodable{
    let Message :String
}


//Parameter Error = "{\"Message\":\"Parameter Error\" }"

//{ "Message" : "No Error" }

//{ "Message" : "Login Failed" }

//{ "Message" : "Unxpected Error" }

func gettimestmp()->Double{
    let now = Date().timeIntervalSince1970
    return now
}

func getdate(_ date:Date, dateFormat:String = "yyyy/MM/dd HH:mm") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}


func reduceSizeImage(image:UIImage , scale:CGFloat)->UIImage {  //減解析度
    var img_width = image.size.width
    var img_height = image.size.height

    print(img_width)
    print(img_height)
    while ( img_width > scale || img_height > scale ) {
        if ( img_width * 0.8 > scale || img_height * 0.8 > scale ) {
            img_width = img_width * 0.8
            img_height = img_height * 0.8
        }
        else if ( img_width * 0.85 > scale || img_height * 0.85 > scale ) {
            img_width = img_width * 0.85
            img_height = img_height * 0.85
        }
        else if ( img_width * 0.9 > scale || img_height * 0.9 > scale ) {
            img_width = img_width * 0.9
            img_height = img_height * 0.9
        }
        else{
            img_width = img_width * 0.95
            img_height = img_height * 0.95
        }
    }
    print(img_width)
    print(img_height)
    
    let reSize = CGSize(width: img_width, height: img_height)
    
    //UIGraphicsBeginImageContext(reSize);
    UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
    image.draw(in: CGRect(x: 0, y: 0, width: img_width, height: img_height));
    let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return reSizeImage;
}



func image_to_base64(select_Image:UIImage) -> String{  // image->base64
    
    
    //let aaa = UIImage(contentsOfFile: "image.png")

    var reduce_Image = reduceSizeImage(image: select_Image, scale: 1200)
    var image_Data : NSData
    if (reduce_Image.size.width >= 200 ) {   // big pic
        image_Data = reduce_Image.jpegData(compressionQuality: 0.5)! as NSData
    }
    else{
        image_Data = reduce_Image.jpegData(compressionQuality: 0.5)! as NSData
    }
    print(image_Data.count )
    let strBase64 = image_Data.base64EncodedString(options: [])
    //print(strBase64)
    return strBase64
    
}

func url_to_image(url: URL ) ->UIImage{
    
    
    
    var coredata_image_base64 : String?
    //DispatchQueue.main.sync{
        coredata_image_base64 = CoreData_getImage(url: url.absoluteString )
    //}
    
    if ( coredata_image_base64 != "nil"){
        let image = UIImage(data: Data(base64Encoded: coredata_image_base64!)!)
        return image!
    }
  
    let url_string = try? String(contentsOf: url)
    print(url_string)
    print("@@@")
    if ( url_string == "nil" || url_string == ""){
        print("url_to_image break 1")
        return #imageLiteral(resourceName: "ironman")

    }
    else{
        print(url)
        print("TTT")
        if ( url.absoluteString == "nil" || url.absoluteString == "") {
            print("url_to_image 2")
            return #imageLiteral(resourceName: "emptyImg")
        }
    let data = try? Data(contentsOf: url)

    if ( data == nil) {
        print("url_to_image 3")
        return #imageLiteral(resourceName: "emptyImg")
    }
    
    let image = try? UIImage(data: data!)

    let data_str = data!.base64EncodedString(options: [])
    
    //DispatchQueue.main.async{
    CoreData_saveImage(url: url.absoluteString, image_base64: data_str)
    //}
    //print(nsstr )
    print("url oK")
    return image!

    }
}

func CoreData_saveImage(url:String,image_base64:String){

    if (url == "" || url == "nil"){
        return
    }
    print(url)
    //print(image_base64)
    print("????")

    var context : NSManagedObjectContext?
    DispatchQueue.main.sync {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    
   
    
    let Image_item = NSEntityDescription.insertNewObject(forEntityName: "ImageRecord", into: context!) as! ImageRecord
    
    
    do{
   
        //print("fuckc\(image_base64)")
        Image_item.url = url
        Image_item.image_base64 = image_base64
        try context!.save()
        //item.append(Artical_item)
        print("CoreData_ImageRecord")
        //self.context[appdelegate].saveContext
    }catch let error as NSError {
        print(url)
        //print(image_base64)
        print("Could not save")
    }

    }
}



func CoreData_getImage( url:String)->String{

    var context : NSManagedObjectContext?
    
    DispatchQueue.main.sync{
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageRecord")
    request.returnsObjectsAsFaults = false
    request.predicate = NSPredicate(format: "url = %@", url)
    //request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    request.fetchLimit = 1
    do{

        var fetch_count = 0
        print("fetch123\(request)")
        //print("fetch444\(request.value(forKey: "image_base64")as! String)")
        let result = try context!.fetch(request)
        //print(result)
        //print(url)

        for data in result as! [NSManagedObject]{
            
            
            var image_base64 = data.value(forKey: "image_base64") as! String
            
            return image_base64
            
            
        }
        
        //return "nil"
        
    }catch{
        print("fail getdata")
    }
    
    
    return "nil"

}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    

    @IBInspectable var cornerRadius: CGFloat {
    get {
    return layer.cornerRadius
    }
    set {
    layer.cornerRadius = newValue
    layer.masksToBounds = newValue > 0
    }}

    @IBInspectable var borderWidth: CGFloat {
    get {
    return layer.borderWidth
    }
    set {
    layer.borderWidth = newValue
    }}

    @IBInspectable var borderColor: UIColor? {
    get {
    return UIColor(cgColor: layer.borderColor!)
    }
    set {
    layer.borderColor = newValue?.cgColor
    }}
    
}

extension UIViewController {
func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}

@objc func dismissKeyboard() {
    view.endEditing(true)
}


}
