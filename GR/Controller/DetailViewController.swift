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

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneSendContents2,GetDataProtocol {
 
    
 

 
    @IBOutlet weak var tableView: UITableView!

    
    var contentModel:ContentModel?
    var profileModel:ProfileModel?
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()

    var dataSetsArray = [DataSets]()
    
    var dataArray = [ContentModel]()
    
    var gameTitle = String()
    var salesDate = String()
    var ImageView = String()
    var hardware = String()
    var price = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        sendDBModel.doneSendContents2 = self
        tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
        

        tableView.reloadData()
        print("確認")
        print(gameTitle)

        //皆のレビューを見れるようにさせる(ロードさせる）
//        loadModel.loadContents(title: contentModel?.gametitle)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailCell", for: indexPath) as! ContentDetailCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.gameTitleLabel.text = self.gameTitle
        cell.ImageView.sd_setImage(with: URL(string: self.ImageView), completed: nil)
        cell.salesDate.text = self.salesDate
        cell.hardware.text = self.hardware
        cell.price.text = String(self.price)
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
        return cell


        
    }
    

    
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
    
    
}
