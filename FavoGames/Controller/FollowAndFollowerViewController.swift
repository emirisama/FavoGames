//
//  FollowAndFollowerViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/17.
//

import UIKit

class FollowAndFollowerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tag = Int()
    var followArray = [FollowModel]()
    var followersArray = [FollowerModel]()
    
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //フォローが押されて画面遷移してきた
        if tag == 1{
            
            segmentControl.selectedSegmentIndex = 0
            
        }else if tag == 2{
                
            segmentControl.selectedSegmentIndex = 1
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentControl.selectedSegmentIndex == 0{
            //フォローしてる人の行数を合わせる
            return followArray.count
            
        }else if segmentControl.selectedSegmentIndex == 1{
            return followersArray.count
        }else{
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let label = cell.contentView.viewWithTag(2) as! UILabel
        
        if segmentControl.selectedSegmentIndex == 0{
            
            imageView.sd_setImage(with: URL(string: followArray[indexPath.row].image!), completed: nil)
            label.text = followArray[indexPath.row].userName
            
            
        }else if segmentControl.selectedSegmentIndex == 1{
            
            imageView.sd_setImage(with: URL(string: followersArray[indexPath.row].image!), completed: nil)
            label.text = followersArray[indexPath.row].userName
            
        }
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contentDetailVC = storyboard?.instantiateViewController(identifier: "contentDetailVC") as! ContentDetailViewController
        if segmentControl.selectedSegmentIndex == 0{
            //contentdetailviewControllerにuserIDを渡す
            contentDetailVC.userID = followArray[indexPath.row].userID!
         
        }else if segmentControl.selectedSegmentIndex == 1{
            
            contentDetailVC.userID = followersArray[indexPath.row].userID!
            
        }
        
        self.navigationController?.pushViewController(contentDetailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 102
        
    }
    
    
    @IBAction func changeAction(_ sender: UISegmentedControl) {
        
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
