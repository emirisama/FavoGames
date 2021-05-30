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

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneSendContents2,GetDataProtocol, ReviewListViewDelegate{
 
    

    

 
    
 

 
    @IBOutlet weak var tableView: UITableView!


    
    var contentModel:ContentModel?
    var profileModel:ProfileModel?
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()

    var dataSetsArray = [DataSets]()
    var loadModelArray = [ProfileModel]()
    
    var dataArray = [ContentModel]()
    
    var gameTitle = String()
    var salesDate = String()
    var ImageView = String()
    var hardware = String()
    var price = Int()
    
 
    var sectionTitle = ["","スコア・レビュー"]

    var contentDetailCell = ContentDetailCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        contentDetailCell.reviewListViewDelegate = self

        sendDBModel.doneSendContents2 = self
        tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
        tableView.register(UINib(nibName: "ReviewViewCell", bundle: nil), forCellReuseIdentifier: "ReviewViewCell")
        

        tableView.reloadData()
        print("dataSetsArrayの中身")
        print(dataSetsArray)

        //皆のレビューを見れるようにさせる(ロードさせる）
//        loadModel.loadContents(title: contentModel?.gametitle)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true

    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {


        return sectionTitle.count
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return 1

        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {
            

            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailCell", for: indexPath) as! ContentDetailCell
            cell.gameTitleLabel.text = self.dataSetsArray[indexPath.row].title
            cell.ImageView.sd_setImage(with: URL(string: self.dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
            cell.salesDate.text = self.dataSetsArray[indexPath.row].salesDate
            cell.hardware.text = self.dataSetsArray[indexPath.row].hardware
            cell.price.text = String(self.dataSetsArray[indexPath.row].itemPrice!)
            return cell
            print("numberOfSections")
            
        }else{

            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ReviewViewCell", for: indexPath) as! ReviewViewCell
//            cell2.userNameLabel.text = self.loadModelArray[indexPath.row].userName
            return cell2
        }
    }

        

//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

//        cell2.userNameLabel.text = self.loadModelArray[indexPath.row].userName
//
//        cell.salesDate.text = self.salesDate

//        cell.ImageView.sd_setImage(with: URL(string: self.dataArray[indexPath.row].imageURLString!, relativeTo: nil))
//
//        cell.gameTitleLabel.text = self.dataArray[indexPath.row].gametitle

        

//        cell..text = self.dataArray[indexPath.row].userID
        
//        let reviewView = cell.contentView.viewWithTag(4) as! CosmosView
//        reviewView.rating = self.dataArray[indexPath.row].rate!
//        
//        let reViewTextView = cell.contentView.viewWithTag(5) as! UITextView
//        reviewView.text = self.dataArray[indexPath.row].review
//        
        

        
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let webVC = segue.destination as! WebViewController
        //↓？ゲーム画像を押すと自動検索の画面遷移
        webVC.gametitle = (contentModel?.gametitle)!
    }

    
    @IBAction func toWebView(_ sender: Any) {
        
        performSegue(withIdentifier: "webVC", sender: nil)
    }

    
    
    @IBAction func toProfileVC(_ sender: Any) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        
        profileVC.contentModel = contentModel
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
    func checkDone2() {
        
        HUD.hide()
        self.tabBarController?.selectedIndex = 0
        //受信
        loadModel.loadContents(title: "\(Constants.menuArray[0])")
        
    }
    
    func getData(dataArray: [ContentModel]) {
        self.dataArray = dataArray
        tableView.reloadData()
    }
    
    func reviewSendTap() {

        let ReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "reviewVC") as! ReviewViewController
        self.navigationController?.pushViewController(ReviewVC, animated: true)

    }
    
    
}
