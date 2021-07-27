//
//  OtherListViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/05/15.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OtherListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoadDataProtocol{


    @IBOutlet weak var tableView: UITableView!
    
    var userName = String()
    var dataSetsArray = [DataSets]()
    var userID = String()
    var db = Firestore.firestore()
    var searchAndLoad = SearchAndLoadModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        searchAndLoad.doneLoadDataProtocol = self
        searchAndLoad.loadMyListData(userName: userName)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for:indexPath) as! ContentsCell
            
            cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
            cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
            return cell
        
        
    }

    
    func doneLoadData(array: [DataSets]) {
        dataSetsArray = array
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
