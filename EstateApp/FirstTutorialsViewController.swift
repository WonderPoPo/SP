//
//  FirstTutorialsViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/12/7.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit

class FirstTutorialCell :UICollectionViewCell{
    
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
}

class FirstTutorialsViewController : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    struct  TutorialData {
        let Img :UIImage
        let title :String
        let content:String
    }
    
   
    
    @IBOutlet weak var tutorialCollection: UICollectionView!
    @IBOutlet weak var pagecontroller: UIPageControl!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func startAction(_ sender: Any) {
        
        
    }
    
    var TutorialList = [TutorialData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button_style1(sel_button: startBtn)
        tutorialCollection.delegate = self
        tutorialCollection.dataSource = self
        
        TutorialList.append(TutorialData(Img: #imageLiteral(resourceName: "Tutorial3"), title: "雲端數據", content: "及時，一致，正確，遠距工作"))
        TutorialList.append(TutorialData(Img: #imageLiteral(resourceName: "Tutorial2"), title: "自動化耗時工作", content: "所有修繕紀錄與稅務費用，計算報酬率，產生報告書"))
        TutorialList.append(TutorialData(Img: #imageLiteral(resourceName: "Tutorial1"), title: "分析數據", content: "幫您分析數據，找尋下一個機會"))
        TutorialList.append(TutorialData(Img: #imageLiteral(resourceName: "Tutorial4"), title: "提升房客體驗", content: "把繁瑣的事交給軟體做，把時間精神留給服務客戶，建立關係"))
        
        
        pagecontroller.numberOfPages = TutorialList.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
                    
    }
                
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return TutorialList.count
    }
                
                
                
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstTutorialCell", for: indexPath) as! FirstTutorialCell

               
        cell.Img.image = TutorialList[indexPath.row].Img
        cell.title.text = TutorialList[indexPath.row].title
        cell.content.text =  TutorialList[indexPath.row].content
               
                       
        return cell
                
               
    }
        
        
       
         
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             
        return CGSize(width:  collectionView.frame.size.width  , height:  collectionView.frame.size.height )
                
        
                 
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tutorialCollection{
            let tutorialCollectionWidth = tutorialCollection.frame.width
            let offsetX = tutorialCollection.contentOffset.x
            print(offsetX)
            print("\(tutorialCollectionWidth)AAA")
            if offsetX == tutorialCollectionWidth * 0 {
                pagecontroller.currentPage = 0
            }
            else if offsetX == tutorialCollectionWidth * 1 {
                pagecontroller.currentPage = 1
            }
            else if offsetX == tutorialCollectionWidth * 2 {
                pagecontroller.currentPage = 2
            }
            else if offsetX == tutorialCollectionWidth * 3 {
                pagecontroller.currentPage = 3
            }
            
        }
    }
    
    
}
