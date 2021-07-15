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

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetContentsDataProtocol{


    


    

    

 
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
    var documentID = String()


    let sectionTitle = ["","掲示板"]

    var contentDetailCell = ContentDetailCell()
   

    var rateAverage = Double()
    var dataSetsArray = [DataSets]()
    var searchAndLoadModel = SearchAndLoadModel()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch index{
        
        case index:
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
            tableView.register(UINib(nibName: "ReviewViewCell", bundle: nil), forCellReuseIdentifier: "ReviewViewCell")
     
            
            
            loadModel.getContentsDataProtocol = self
            

            loadModel.loadContents(title: gameTitle,documentID: documentID)
            tableView.reloadData()
            
            break
            
        default:
            break
        }
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            return 350
            
        }else if indexPath.section == 1{
            if contentModelArray[indexPath.row].sender == nil{
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
        
        
        if section == 0{
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
            cell.selectionStyle = .none
            cell.gameTitleLabel.text = gameTitle
            cell.ImageView.sd_setImage(with: URL(string: mediumImageUrl), completed: nil)
            cell.salesDate.text = salesDate
            cell.hardware.text = hardware
            cell.price.text = String(itemPrice)
//            cell.commentCountLabel.text = String(self.totalCountModelArray.count)
            cell.reviewButton.addTarget(self, action: #selector(reviewButtonTap(_:)), for: .touchUpInside)
            return cell
            
        }else{
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ReviewViewCell", for: indexPath) as! ReviewViewCell
            cell2.selectionStyle = .none
 
                cell2.userNameLabel.text = self.contentModelArray[indexPath.row].sender?[3]
                cell2.userIDLabel.text = self.contentModelArray[indexPath.row].sender?[4]
                cell2.reviewViewLabel.text = self.contentModelArray[indexPath.row].comment
                cell2.profileImage.sd_setImage(with: URL(string: (contentModelArray[indexPath.row].sender![0])), completed: nil)
                return cell2
        }
    }


    @objc func reviewButtonTap(_ sender:UIButton){
        
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "reviewVC") as! ReviewViewController
        
        reviewVC.array = dataSetsArray
        reviewVC.gameTitle = gameTitle
        reviewVC.hardware = hardware
        self.navigationController?.pushViewController(reviewVC, animated: true)
        
    }
             
    
    func getContentsData(dataArray: [ContentModel]) {
        self.contentModelArray = []
        self.contentModelArray = dataArray
        print("self.contentModelArray")
        print(self.contentModelArray.debugDescription)
    }



    
    
    
}
