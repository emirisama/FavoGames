//
//  ProfileViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/13.
//

import UIKit
import FirebaseAuth
import SDWebImage
import Cosmos
import SSSpinnerButton

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetDataProtocol,GetProfileDataProtocol{

    

    

    

    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: SSSpinnerButton!
    @IBOutlet weak var profileTextLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var contentModel:ContentModel?
    var contentModelArray = [ContentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imageView.layer.cornerRadius = imageView.frame.width/2
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "Cell")

       //自分のプロフィールを表示する→タブが２の場合
        
        if self.tabBarController!.selectedIndex == 2{
            
            followButton.isHidden = true
            
            //setUP
            
        }else{
            
            if contentModel?.userID == Auth.auth().currentUser!.uid{
                
                followButton.isHidden = true
            }
        }
        
    }
    
    
    func setUp(id:String){
        
        loadModel.getDataProtocol = self
        loadModel.getProfileDataProtocol = self
        
        //プロフィールを受信する
        
        //フォロワーデータの受信機能
        
        //フォローデータの受信機能
        
        //コンテンツデータの受信機能
        loadModel.loadOwnContents(id: id)

        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    func getData(dataArray: [ContentModel]) {
        
        contentModelArray = dataArray
        
        tableView.reloadData()
    }
    
    //プロフィールが入ったdataArray
    func getProfileData(dataArray: [ProfileModel]) {
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
