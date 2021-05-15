//
//  ListViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/05/13.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoadDataProtocol,DoneLoadUserNameProtocol {


    


    var tag = Int()
    var userName = String()
    var userID = String()
    var dataSetsArray = [DataSets]()
    var userNameArray = [String]()
    var searchAndLoad = SearchAndLoadModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        tableView.register(UINib(nibName: "userNameCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        searchAndLoad.doneLoadDataProtocol = self
        searchAndLoad.doneLoadUserNameProtocol = self
        //受信
        if userID == Auth.auth().currentUser?.uid{
           
            //自分のリスト
            searchAndLoad.loadMyListData(userName: userName)
            
        }else{
            
            //みんなのリスト
            searchAndLoad.loadOtherListData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if userID == Auth.auth().currentUser?.uid{
            
            self.navigationItem.title = "自分のリスト"
            
        }else{
            self.navigationItem.title = "みんなのリスト"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userID == Auth.auth().currentUser?.uid{
            return dataSetsArray.count
        }else{
            return userNameArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userID == Auth.auth().currentUser?.uid{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for:indexPath) as! ContentsCell
            
            cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
            cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! UserNameCell
            cell.userNameLabel.text = userNameArray[indexPath.row]
            return cell
        }
    }
    

    //受信ができるようになる（TableViewに表示する準備が完了）
    func doneLoadData(array: [DataSets]) {
        
        dataSetsArray = array
        tableView.reloadData()
        
        
    }
    
    func doneLoadUserName(array: [String]) {
        userNameArray = []
        //重複を消す
        let orderdSet = NSOrderedSet(array: array)
        print(orderdSet.debugDescription)
        userNameArray = orderdSet.array as! [String]
        
        tableView.reloadData()
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
