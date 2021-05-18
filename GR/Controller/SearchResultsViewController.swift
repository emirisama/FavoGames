//
//  SearchResultsViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/05/07.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   

    

    
    @IBOutlet weak var tableView: UITableView!
    var dataSetsArray = [DataSets]()
    var userName = String()
    var db = Firestore.firestore()
    var userID = String()

    var idString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カステムCellを作るためにはregisternibを記載する必要がある。
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        //アプリ内に入っているユーザー名を取り出す
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
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
        
        let favButton = UIButton(frame: CGRect(x: 100, y: 200, width: 40, height: 40))
        favButton.setImage(UIImage(named:"fav"), for: .normal)
        favButton.addTarget(self, action: #selector(favButtonTap(_:)), for: .touchUpInside)
        cell.contentView.addSubview(favButton)
        favButton.tag = indexPath.row

        


        return cell
    }
    
    @objc func favButtonTap(_ sender:UIButton){
        
        //DBへ情報を送信する
        print(sender.tag)
        print(userID)
        let sendDB = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, mediumImageUrl: dataSetsArray[sender.tag].mediumImageUrl!, title: dataSetsArray[sender.tag].title!, hardware: dataSetsArray[sender.tag].hardware!, salesDate: dataSetsArray[sender.tag].salesDate!, itemPrice: dataSetsArray[sender.tag].itemPrice!)
        sendDB.sendData(userName: userName)
             
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
