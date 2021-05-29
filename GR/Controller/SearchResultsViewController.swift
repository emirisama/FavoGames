//
//  SearchResultsViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/05/07.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetLikeCountProtocol {

    

   

    

    
    @IBOutlet weak var tableView: UITableView!
    var dataSetsArray = [DataSets]()
    var userName = String()
    var db = Firestore.firestore()
    var userID = String()

    var idString = String()
    
    var loadModel = LoadModel()
    var likeCount = Int()
    var likeFlag = Bool()

    var imageView = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.delegate = self
        tableView.dataSource = self
        loadModel.getLikeCountProtocol = self

        
        
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
        self.navigationController?.isNavigationBarHidden = true
  
        if UserDefaults.standard.object(forKey: "documentID") != nil{
            
            idString = UserDefaults.standard.object(forKey: "documentID") as! String
            
        }else{
            
            idString = db.collection("contents").document().path
            print(idString)
            idString = String(idString.dropFirst(9))
            UserDefaults.standard.setValue(idString, forKey: "documentID")
        }
        self.navigationController?.isNavigationBarHidden = true
        loadLikeCount(likeCount: likeCount, likeFlag: likeFlag)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSetsArray.count
    }
    
    
    //Cellを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell

        
        cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
        cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
      
        //お気に入りButton（お気に入りを自分のユーザーのデータに入れる）
        
        cell.likeButton.tag = indexPath.row
        cell.countLabel.text = String(likeCount)
        cell.likeButton.addTarget(self, action: #selector(likeButtonTap(_:)), for: .touchUpInside)
    
        if likeFlag == true{
            cell.likeButton.setImage(UIImage(named: "like"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "nolike"), for: .normal)
        }


        return cell
    }
    
    @objc func likeButtonTap(_ sender:UIButton){
        
        //DBへ情報を送信する
        print(sender.tag)
        print(userID)
//        let sendDB = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, mediumImageUrl: dataSetsArray[sender.tag].mediumImageUrl!, title: dataSetsArray[sender.tag].title!, hardware: dataSetsArray[sender.tag].hardware!, salesDate: dataSetsArray[sender.tag].salesDate!, itemPrice: dataSetsArray[sender.tag].itemPrice!)
//        sendDB.sendData(userName: userName)

        
        loadLikeCount(likeCount: likeCount, likeFlag: likeFlag)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        DetailVC.gameTitle = dataSetsArray[indexPath.row].title!
        DetailVC.ImageView = dataSetsArray[indexPath.row].mediumImageUrl!
        DetailVC.salesDate = dataSetsArray[indexPath.row].salesDate!
        DetailVC.hardware = dataSetsArray[indexPath.row].hardware!
        DetailVC.price = dataSetsArray[indexPath.row].itemPrice!
        self.navigationController?.pushViewController(DetailVC, animated: true)
        print("dataSetsArrayの中身")
        print(dataSetsArray)

    }

        


    
    
    func loadLikeCount(likeCount: Int, likeFlag: Bool) {
        
        if likeFlag == true{
            
        }else if likeFlag == false{
            return
        }
       
        
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
