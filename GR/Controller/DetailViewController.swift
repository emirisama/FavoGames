//
//  DetailViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/11.
//

import UIKit
import SDWebImage
import Cosmos

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

 
    @IBOutlet weak var tableView: UITableView!
    var contentModel:ContentModel?
    var profileModel:ProfileModel?
    var loadModel = LoadModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        loadModel.loadContents(category: <#T##String#>)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: (contentModel?.sender![0])!), completed: nil)
        profileImageView.layer.cornerRadius = 20

        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = contentModel?.sender![3]
        
        
        let id = cell.contentView.viewWithTag(3) as! UILabel
        id.text = contentModel?.sender![2]
        
        let reviewView = cell.contentView.viewWithTag(4) as! CosmosView
        reviewView.rating = (contentModel?.rate)!
        
        let reviewTextView = cell.contentView.viewWithTag(5) as! UITextView
        reviewTextView.text = contentModel?.review

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 996
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let webVC = segue.destination as! WebViewController
        //↓？ゲーム画像を押すと自動検索の画面遷移
        webVC.imageView = UIImageView()
    }

   
    @IBAction func toWebView(_ sender:Any){
        
        performSegue(withIdentifier: "webVC", sender: nil)
        
    }
    
    
    
    @IBAction func toProfileVC(_ sender: Any) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        
        profileVC.contentModel = contentModel
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
}
