//
//  SearchResultsViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/05/07.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var array = [DataSets]()
    var profileModelArray = [ProfileModel]()
    var contentModelArray = [ContentModel]()
    var userName = String()
    var db = Firestore.firestore()
    var userID = String()
    var idString = String()
    var loadModel = LoadModel()
    var imageView = String()
    var sendDBModel = SendDBModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.delegate = self
        tableView.dataSource = self
        //カステムCellを作るためにはregisternibを記載する必要がある。
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        
        //アプリ内に入っているユーザーIDを取り出す
        if UserDefaults.standard.object(forKey: "documentID") != nil{
            idString = UserDefaults.standard.object(forKey: "documentID") as! String
        }
        
        

        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //高さを揃える
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
  
        if UserDefaults.standard.object(forKey: "documentID") != nil{
            
            idString = UserDefaults.standard.object(forKey: "documentID") as! String
            
        }else{
            
            idString = db.collection("contents").document().path
            print(idString)
            idString = String(idString.dropFirst(9))
            UserDefaults.standard.setValue(idString, forKey: "documentID")
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    
    //Cellを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell
        cell.contentImageView.sd_setImage(with: URL(string: array[indexPath.row].mediumImageUrl!), completed: nil)
        cell.gameTitleLabel.text = array[indexPath.row].title
        cell.rankLabel.isHidden = true
        return cell
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        DetailVC.gameTitle = array[indexPath.row].title!
        DetailVC.hardware = array[indexPath.row].hardware!
        DetailVC.salesDate = array[indexPath.row].salesDate!
        DetailVC.mediumImageUrl = array[indexPath.row].mediumImageUrl!
        DetailVC.itemPrice = array[indexPath.row].itemPrice!
        DetailVC.booksGenreId = array[indexPath.row].booksGenreId!
        if DetailVC.hardware == "PS5"{
            sendDBModel.sendGameTitlePS5(title: DetailVC.gameTitle, hardware: DetailVC.hardware, salesDate: DetailVC.salesDate, mediumImageUrl: DetailVC.mediumImageUrl, itemPrice: DetailVC.itemPrice, booksGenreId: DetailVC.booksGenreId)
        }else if DetailVC.hardware == "PS4"{
            sendDBModel.sendGameTitlePS4(title: DetailVC.gameTitle, hardware: DetailVC.hardware, salesDate: DetailVC.salesDate, mediumImageUrl: DetailVC.mediumImageUrl, itemPrice: DetailVC.itemPrice, booksGenreId: DetailVC.booksGenreId)
        }else if DetailVC.hardware == "Switch"{
            sendDBModel.sendGameTitleSwitch(title: DetailVC.gameTitle, hardware: DetailVC.hardware, salesDate: DetailVC.salesDate, mediumImageUrl: DetailVC.mediumImageUrl, itemPrice: DetailVC.itemPrice, booksGenreId: DetailVC.booksGenreId)
        }
        self.navigationController?.pushViewController(DetailVC, animated: true)
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
