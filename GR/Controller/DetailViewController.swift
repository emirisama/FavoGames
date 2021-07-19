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
import FirebaseAuth
import FirebaseFirestore

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetContentsDataProtocol,DoneSendLikeData,GetLikeFlagProtocol, GetLikeDataProtocol{

    
  
    


 
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
    var memo = String()

    let sectionTitle = ["","Memo"]

    var contentDetailCell = ContentDetailCell()
   

    var rateAverage = Double()
    var dataSetsArray = [DataSets]()
    var searchAndLoadModel = SearchAndLoadModel()
    
    var likeFlag = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch index{
        
        case index:
    
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
            tableView.register(UINib(nibName: "MemoViewCell", bundle: nil), forCellReuseIdentifier: "MemoViewCell")
            
            loadModel.getContentsDataProtocol = self
            loadModel.loadContents(title: gameTitle)
            sendDBModel.doneSendLikeData = self
            loadModel.getLikeDataProtocol = self
            loadModel.loadLikeData(userID: Auth.auth().currentUser!.uid)
            loadModel.getLikeFlagProtocol = self
            loadModel.loadLikeFlag(title: gameTitle)
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
            
                return 200
   
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
            cell.memoButton.addTarget(self, action: #selector(memoButtonTap(_:)), for: .touchUpInside)
            cell.likeButton.addTarget(self, action: #selector(likeButtonTap(_:)), for: .touchUpInside)
            cell.likeButton.tag = indexPath.row
            return cell
            
        }else{
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "MemoViewCell", for: indexPath) as! MemoViewCell
            cell2.selectionStyle = .none
                cell2.userNameLabel.text = self.contentModelArray[indexPath.row].sender?[3]
                cell2.userIDLabel.text = self.contentModelArray[indexPath.row].sender?[4]
            cell2.memoLabel.text = self.contentModelArray[indexPath.row].comment
            memo = self.contentModelArray[indexPath.row].comment!
                cell2.profileImage.sd_setImage(with: URL(string: (contentModelArray[indexPath.row].sender![0])), completed: nil)
                return cell2
        }
    }


    @objc func memoButtonTap(_ sender:UIButton){
        
        let memoVC = self.storyboard?.instantiateViewController(withIdentifier: "memoVC") as! MemoViewController
        
        memoVC.array = dataSetsArray
        memoVC.gameTitle = gameTitle
        memoVC.hardware = hardware
        memoVC.memo = memo
        self.navigationController?.pushViewController(memoVC, animated: true)
        
    }
    
    @objc func likeButtonTap(_ sender:UIButton){

        if self.likeFlag == false{
            sendDBModel.sendLikeData(userID: Auth.auth().currentUser!.uid, mediumImageUrl: mediumImageUrl, title: gameTitle, hardware: hardware, salesDate: salesDate, itemPrice: itemPrice, booksGenreId: booksGenreId, likeFlag: true)
            print("likeをtrueに")
        }else{
            sendDBModel.sendLikeData(userID: Auth.auth().currentUser!.uid, mediumImageUrl: mediumImageUrl, title: gameTitle, hardware: hardware, salesDate: salesDate, itemPrice: itemPrice, booksGenreId: booksGenreId, likeFlag: false)
            print("likeを消す")
        }
        

        print("likeButtonタップしました")
    }
             
    
    func getContentsData(dataArray: [ContentModel]) {
        self.contentModelArray = []
        self.contentModelArray = dataArray
        print("DetailVCにself.contentModelArrayの値を持ってくる")
        print(self.contentModelArray.debugDescription)
        print(contentModelArray.count)
        tableView.reloadData()
//        sortNewComment(commentArray: self.contentModelArray)

    }
    

    func checkSendLikeData() {
        print("いいねしました")
    }
    
    func like(){
        Util.startAnimation(name: "heart", view: self.view)
    }
    
    func getLikeFlagData(likeFlag: Bool) {
        self.likeFlag = likeFlag
        print("likeflagの中身")
        print(self.likeFlag)
    }
    
    func getLikeData(dataArray: [LikeModel]) {
        print("いいねしました")
    }
    
}
    




    

