//
//  DetailViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/11.
//

import UIKit
import SDWebImage
import Cosmos
import PKHUD

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetDataProtocol{
 
 
    

    

 
    
 

 
    @IBOutlet weak var tableView: UITableView!

    var index = Int()
    
    var contentModel:ContentModel?
    var profileModel:ProfileModel?
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()

    var array = [DataSets]()
    var loadModelArray = [ProfileModel]()
    
    var contentModelArray = [ContentModel]()
    
    var gameTitle = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()

    
 
    var sectionTitle = ["","スコア・レビュー"]

    var contentDetailCell = ContentDetailCell()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch index{
        
        case index:
            //皆のレビューを見れるようにさせる(ロードさせる）
            loadModel.getDataProtocol = self
            loadModel.loadContents(title: gameTitle)


                tableView.delegate = self
                tableView.dataSource = self
                
                tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
                tableView.register(UINib(nibName: "ReviewViewCell", bundle: nil), forCellReuseIdentifier: "ReviewViewCell")
                
                break
                
                default:
                break
        }
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            return 300
        }else if indexPath.section == 1{
            return 300
        }
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false

    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {


        return sectionTitle.count
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0 {
            return 1
        }else if section == 1{
            return contentModelArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {
            

            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailCell", for: indexPath) as! ContentDetailCell
            cell.gameTitleLabel.text = self.gameTitle
            cell.ImageView.sd_setImage(with: URL(string: self.mediumImageUrl), completed: nil)
            cell.salesDate.text = self.salesDate
            cell.hardware.text = self.hardware
            cell.price.text = String(self.itemPrice)
            
            cell.reviewButton.addTarget(self, action: #selector(reviewButtonTap(_:)), for: .touchUpInside)
 
            return cell

        }else{

            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ReviewViewCell", for: indexPath) as! ReviewViewCell
            cell2.userNameLabel.text = self.contentModelArray[indexPath.row].sender![3]
            cell2.userIDLabel.text = self.contentModelArray[indexPath.row].sender![4]
            cell2.reviewViewLabel.text = self.contentModelArray[indexPath.row].review
            cell2.scoreCountLabel.text = String(self.contentModelArray[indexPath.row].rate!)
            cell2.scoreView.rating = self.contentModelArray[indexPath.row].rate!
            cell2.profileImage.sd_setImage(with: URL(string: self.contentModelArray[indexPath.row].sender![0]), completed: nil)
//            cell2.userIDLabel.text = contentModel.sender[]

//            cell2.scoreCountLabel.text = String(((contentModel?.rate)!))

            return cell2
        }
    }

    @objc func reviewButtonTap(_ sender:UIButton){
        
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "reviewVC") as! ReviewViewController
        
        reviewVC.array = array
        reviewVC.gameTitle = gameTitle
        self.navigationController?.pushViewController(reviewVC, animated: true)
        
    }
        

//        cell..text = self.dataArray[indexPath.row].userID
        
//        let reviewView = cell.contentView.viewWithTag(4) as! CosmosView
//        reviewView.rating = self.dataArray[indexPath.row].rate!
//        
//        let reViewTextView = cell.contentView.viewWithTag(5) as! UITextView
//        reviewView.text = self.dataArray[indexPath.row].review
//        
        

        
    
    

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let webVC = segue.destination as! WebViewController
//        //↓？ゲーム画像を押すと自動検索の画面遷移
////        webVC.contentModel = contentModelArray[sender as! Int]
//    }

    
    @IBAction func toWebView(_ sender: Any) {
        
        performSegue(withIdentifier: "webVC", sender: nil)
    }

    
    
    @IBAction func toProfileVC(_ sender: Any) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        profileVC.contentModel = contentModel
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    

    
    
    
    func getData(dataArray: [ContentModel]) {

        contentModelArray = []
        contentModelArray = dataArray
        tableView.reloadData()
        print("レビュー表示")

    }
    
    



    
    
}
