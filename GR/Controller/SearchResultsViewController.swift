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
        
        //アプリ内に入っているユーザー名を取り出す
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
