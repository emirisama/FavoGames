//
//  DetailViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/04/11.
//

import UIKit
import SDWebImage
import Firebase


class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetCommentsDataProtocol,GetLikeFlagProtocol{

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var index = Int()
    var gameTitle = String()
    var hardware = String()
    var salesDate = String()
    var largeImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    var documentID = String()
    var memo = String()
    var itemUrl = String()
    let sectionTitle = ["","Memo"]
    var likeFlag = Bool()
    
    var commentsModel: CommentsModel?
    var profileModel: ProfileModel?
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var profileModelArray = [ProfileModel]()
    var commentsModelArray = [CommentsModel]()
    var dataSetsArray = [DataSets]()
    var searchAndLoadModel = SearchAndLoadModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid != nil {
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
            tableView.register(UINib(nibName: "MemoViewCell", bundle: nil), forCellReuseIdentifier: "MemoViewCell")
            loadModel.getCommentsDataProtocol = self
            loadModel.loadComments(title: gameTitle)
            loadModel.getLikeFlagProtocol = self
            loadModel.loadLikeFlag(title: gameTitle)
            
        } else {
            
            let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
            self.present(createVC, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if  indexPath.section == 0 {
            
            return 500
            
        }else if indexPath.section == 1{
            
            return 300
            
        }
        
        return 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitle.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            
            return 1
            
        }else if section == 1{
            
            return commentsModelArray.count
            
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
            cell.ImageView.sd_setImage(with: URL(string: largeImageUrl), completed: nil)
            cell.salesDate.text = salesDate
            cell.hardware.text = hardware
            cell.price.text = String(itemPrice)
            
            if self.likeFlag == false{
                
                cell.likeButton.setImage(UIImage(named: "heart1"),for: .normal)
                
            }else{
                
                cell.likeButton.setImage(UIImage(named: "heart2"),for: .normal)
                
            }
            
            cell.memoButton.addTarget(self, action: #selector(memoButtonTap(_:)), for: .touchUpInside)
            cell.likeButton.addTarget(self, action: #selector(likeButtonTap(_:)), for: .touchUpInside)
            cell.videoButton.addTarget(self, action: #selector(videoButtonTap(_ :)), for: .touchUpInside)
            cell.googleButton.addTarget(self, action: #selector(googleButtonTap(_ :)), for: .touchUpInside)
            
            return cell
            
        }else{
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "MemoViewCell", for: indexPath) as! MemoViewCell
            cell2.selectionStyle = .none
            cell2.memoLabel.text = self.commentsModelArray[indexPath.row].comment
            memo = self.commentsModelArray[indexPath.row].comment!
            
            return cell2
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        if indexPath.section == 0{
            return false
        }else{
            return true
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            commentsModelArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            sendDBModel.deleteToComments(title: gameTitle)
            
        }
        
    }
    
    
    @objc func memoButtonTap(_ sender: UIButton) {
        
        let memoVC = self.storyboard?.instantiateViewController(withIdentifier: "memoVC") as! MemoViewController
        memoVC.dataSetsArray = dataSetsArray
        memoVC.gameTitle = gameTitle
        memoVC.hardware = hardware
        memoVC.memo = memo
        self.navigationController?.pushViewController(memoVC, animated: true)
        
    }
    
    @objc func likeButtonTap(_ sender: UIButton) {
        
        if self.likeFlag == false{
            
            sendDBModel.sendLike(userID: Auth.auth().currentUser!.uid, largeImageUrl: largeImageUrl, title: gameTitle, hardware: hardware, salesDate: salesDate, itemPrice: itemPrice, booksGenreId: booksGenreId, likeFlag: true)
            
        }else{
            
            sendDBModel.sendLike(userID: Auth.auth().currentUser!.uid, largeImageUrl: largeImageUrl, title: gameTitle, hardware: hardware, salesDate: salesDate, itemPrice: itemPrice, booksGenreId: booksGenreId, likeFlag: false)
            
        }
        
    }
    
    @objc func videoButtonTap(_ sender: UIButton) {
        
        let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "videoVC") as! VideoViewController
        videoVC.gameTitle = gameTitle
        self.present(videoVC, animated: true)
        
    }
    
    @objc func googleButtonTap(_ sender: UIButton) {
        
        let googleVC = self.storyboard?.instantiateViewController(withIdentifier: "googleVC") as! GoogleViewController
        googleVC.gameTitle = gameTitle
        self.present(googleVC, animated: true)
        
    }
    
    
    func getCommentsData(dataArray: [CommentsModel]) {
        
        self.commentsModelArray = []
        self.commentsModelArray = dataArray
        tableView.reloadData()
        
    }
    
    
    func getLikeFlagData(likeFlag: Bool) {
        
        self.likeFlag = likeFlag
        tableView.reloadData()
    }
    
    
}
    




    

