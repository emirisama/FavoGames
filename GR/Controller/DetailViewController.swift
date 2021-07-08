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

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetGameDataPS5Protocol,GetGameDataPS4Protocol,GetGameDataSwitchProtocol,GetContentsDataPS5Protocol,GetContentsDataPS4Protocol,GetContentsDataSwitchProtocol,GetRateAverageCountProtocol{

    

    

 
    @IBOutlet weak var tableView: UITableView!

    var index = Int()
    
    var contentModel:ContentModel?
    var profileModel:ProfileModel?
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    


    var profileModelArray = [ProfileModel]()
    
    var contentModelArray = [ContentModel]()
    
    var gameTitle = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()

    let sectionTitle = ["","スコア・レビュー"]

    var contentDetailCell = ContentDetailCell()
   
    var rateArray = [RateModel]()

    var rateAverage = Double()
    var dataSetsArray = [DataSets]()
    var searchAndLoadModel = SearchAndLoadModel()
    
    var contentModelPS5Array = [ContentModel]()
    var contentModelPS4Array = [ContentModel]()
    var contentModelSwitchArray = [ContentModel]()
    var gameTitleModelPS5Array = [GameTitleModel]()
    var gameTitleModelPS4Array = [GameTitleModel]()
    var gameTitleModelSwitchArray = [GameTitleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch index{
        
        case index:
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
            tableView.register(UINib(nibName: "ReviewViewCell", bundle: nil), forCellReuseIdentifier: "ReviewViewCell")

            loadModel.getGameDataPS5Protocol = self
            loadModel.getGameDataPS4Protocol = self
            loadModel.getGameDataSwitchProtocol = self
            loadModel.getContentsDataPS5Protocol = self
            loadModel.getContentsDataPS4Protocol = self
            loadModel.getContentsDataSwitchProtocol = self
            loadModel.getRateAverageCountProtocol = self

            if index == 0{
                loadModel.loadGameContentsPS5(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            }else if index == 1{
                loadModel.loadGameContentsPS4(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            }else if index == 2{
                loadModel.loadGameContentsSwitch(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            }

            loadModel.loadContentsPS5(title: gameTitle,rateAverage: rateAverage)
            loadModel.loadContentsPS4(title: gameTitle,rateAverage: rateAverage)
            loadModel.loadContentsSwitch(title: gameTitle,rateAverage: rateAverage)
            loadModel.loadRateAverageCount(title: gameTitle, rateAverage: rateAverage)


            tableView.reloadData()

                break
                
                default:
                break
        }
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            return 400
            
        }else if indexPath.section == 1{
            if contentModelPS5Array[indexPath.row].sender == nil{
                return 0
            }else{
                return 300
            }
            
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
        
        if index == 0{
            if section == 0{
                return 1
            }else if section == 1{
                return contentModelPS5Array.count
            }
        }else if index == 1{
            if section == 0{
                return 1
            }else if section == 1{
                return contentModelPS4Array.count
            }
        }else if index == 2{
            if section == 0{
                return 1
            }else if section == 1{
                return contentModelSwitchArray.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailCell", for: indexPath) as! ContentDetailCell
            cell.selectionStyle = .none
                print("gameTitleModelPS5Arrayの数")
                print(gameTitleModelPS5Array.count)
                cell.gameTitleLabel.text = gameTitle
                cell.ImageView.sd_setImage(with: URL(string: mediumImageUrl), completed: nil)
                cell.salesDate.text = salesDate
                cell.hardware.text = hardware
                cell.price.text = String(itemPrice)
                cell.rateAverageLabel.text = String(rateAverage)
                cell.reviewButton.addTarget(self, action: #selector(reviewButtonTap(_:)), for: .touchUpInside)

            return cell

        }else{

            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ReviewViewCell", for: indexPath) as! ReviewViewCell
            cell2.selectionStyle = .none
            if index == 0{
                print("content")
                print(contentModelPS5Array.debugDescription)

                    cell2.userNameLabel.text = self.contentModelPS5Array[indexPath.row].sender?[3]
                    cell2.userIDLabel.text = self.contentModelPS5Array[indexPath.row].sender?[4]
                    cell2.reviewViewLabel.text = self.contentModelPS5Array[indexPath.row].review
                    cell2.scoreCountLabel.text = String(self.contentModelPS5Array[indexPath.row].rate!)
                    cell2.scoreView.rating = self.contentModelPS5Array[indexPath.row].rate!
                    cell2.scoreView.settings.fillMode = .half
//                    cell2.profileImage.sd_setImage(with: URL(string: (contentModelPS5Array[indexPath.row].sender[0])), completed: nil)
                
                
            }else if index == 1{
                cell2.userNameLabel.text = contentModelPS4Array[indexPath.row].sender?[3]
                cell2.userIDLabel.text = contentModelPS4Array[indexPath.row].sender?[4]
                cell2.reviewViewLabel.text = contentModelPS4Array[indexPath.row].review
                cell2.scoreCountLabel.text = String(contentModelPS4Array[indexPath.row].rate!)
                cell2.scoreView.rating = contentModelPS4Array[indexPath.row].rate!
                cell2.scoreView.settings.fillMode = .half
                cell2.profileImage.sd_setImage(with: URL(string: contentModelPS4Array[indexPath.row].sender![0]), completed: nil)
            }else if index == 2{
                cell2.userNameLabel.text = contentModelSwitchArray[indexPath.row].sender?[3]
                cell2.userIDLabel.text = contentModelSwitchArray[indexPath.row].sender?[4]
                cell2.reviewViewLabel.text = contentModelSwitchArray[indexPath.row].review
                cell2.scoreCountLabel.text = String(contentModelSwitchArray[indexPath.row].rate!)
                cell2.scoreView.rating = contentModelSwitchArray[indexPath.row].rate!
                cell2.scoreView.settings.fillMode = .half
                cell2.profileImage.sd_setImage(with: URL(string:contentModelSwitchArray[indexPath.row].sender![0]), completed: nil)
            }
            
            
            
//            let ScoreLabel.text = String(cell2.scoreCountLabel.text! + cell2.scoreCountLabel.text!)

//            cell2.userIDLabel.text = contentModel.sender[]

//            cell2.scoreCountLabel.text = String(((contentModel?.rate)!))

            return cell2
        }
    }

    @objc func reviewButtonTap(_ sender:UIButton){
        
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "reviewVC") as! ReviewViewController
        
        reviewVC.array = dataSetsArray
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
  
    func getGameDataPS5(dataArray: [GameTitleModel]) {
        self.gameTitleModelPS5Array = []
        self.gameTitleModelPS5Array = dataArray
        print("DatailのPS5")
        print(self.gameTitleModelPS5Array.debugDescription)
    }
    
    func getGameDataPS4(dataArray: [GameTitleModel]) {
        self.gameTitleModelPS4Array = []
        self.gameTitleModelPS4Array = dataArray
    }
    
    func getGameDataSwitch(dataArray: [GameTitleModel]) {
        self.gameTitleModelSwitchArray = []
        self.gameTitleModelSwitchArray = dataArray
    }
    func getContentsDataPS5(dataArray: [ContentModel]) {
        self.contentModelPS5Array = []
        self.contentModelPS5Array = dataArray
        print("self.contentModelPS5Array")
        print(self.contentModelPS5Array.debugDescription)
    }

    
    func getContentsDataPS4(dataArray: [ContentModel]) {
        self.contentModelPS4Array = []
        self.contentModelPS4Array = dataArray
    }
    
    func getContentsDataSwitch(dataArray: [ContentModel]) {
        self.contentModelSwitchArray = []
        self.contentModelSwitchArray = dataArray
    }
    


    func getRateAverageCount(rateAverage: Double) {

        self.rateAverage = rateAverage
        print("レイト平均")
        print(self.rateAverage.debugDescription)
        tableView.reloadData()
    }
    
    
    
}
