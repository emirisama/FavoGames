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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        //アプリ内に入っているユーザー名を取り出す
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        //tableViewをどこで更新するか
        
        cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
        cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
      
        //お気に入りButton（お気に入りを自分のユーザーのデータに入れる）
        let favButton = UIButton(frame: CGRect(x: 300, y: 30, width: 40, height: 40))
        favButton.setImage(UIImage(named:"fav"), for: .normal)
        favButton.addTarget(self, action: #selector(favButtonTap(_:)), for: .touchUpInside)
        favButton.tag = indexPath.row
        cell.contentView.addSubview(favButton)
        
        return cell
    }
    
    @objc func favButtonTap(_ sender:UIButton){
        
        //DBへ情報を送信する
        print(sender.tag)
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
