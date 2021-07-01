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
import YPImagePicker
import Firebase
import FirebaseStorage
import FirebaseFirestore
import PKHUD


class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetDataProtocol,GetProfileDataProtocol{
 
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: SSSpinnerButton!
    @IBOutlet weak var profileTextField: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var contentModel:ContentModel?
    var contentModelArray = [ContentModel]()
    var userID = String()
    var userName = String()
    var email = String()
    var dataArray = [ProfileModel]()
    let db = Firestore.firestore()
    var profileModel = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "Cell")
  
        //自分のプロフィールを表示する→タブが２の場合
        
        if self.tabBarController!.selectedIndex == 2{
    
            //setUP
            setUp(id: Auth.auth().currentUser!.uid)
            
        }else{
            
            if contentModel?.sender![2] == Auth.auth().currentUser!.uid{
    
            }
            
            //setUp（自分かどうかわからない場合）
            setUp(id: (contentModel?.sender![2])!)
            imageView.sd_setImage(with: URL(string: (contentModel?.sender![0])!), completed: nil)
            imageView.clipsToBounds = true
            nameLabel.text = contentModel?.sender![3]
            profileTextField.text = contentModel?.sender![1]
            idLabel.text = contentModel?.sender![4]
            
            
        }
        
    }
    
    
    
    
    func setUp(id:String){
        
        loadModel.getDataProtocol = self
        loadModel.getProfileDataProtocol = self

        //プロフィールを受信する(idにAuth.auth().currentUserが入る
        loadModel.loadProfile(id: id)
  
        //コンテンツデータの受信機能
        loadModel.loadContents(title: id)
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentModelArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContentsCell
        //自分が投稿したレビューのゲームソフトのタイトル画像(動画：コンテンツを受信しよう）
        //        cell.contentImageView.sd_setImage(with: URL(string: contentModelArray[indexPath.row].imageURLSting!), completed: nil)
        //        cell.reviewView.rating = contentModelArray[indexPath.row].rate!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
    func getData(dataArray: [ContentModel]) {
        
        contentModelArray = []
        
        contentModelArray = dataArray
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    //プロフィールが入ったdataArray
    func getProfileData(dataArray: [ProfileModel]) {
        
        self.dataArray = dataArray
        
        imageView.sd_setImage(with: URL(string: dataArray[0].imageURLString!), completed: nil)
        nameLabel.text = dataArray[0].userName
        profileTextField.text = dataArray[0].profileText
        idLabel.text = dataArray[0].id
        
        
        
    }
    
    
    
    
    
    @IBAction func tapEdit(_ sender: Any) {
        performSegue(withIdentifier: "profileEdit", sender: nil)
        //        let profileEditVC = storyboard?.instantiateViewController(identifier: "profileEdit") as! ProfileEditViewController
        //        self.navigationController?.pushViewController(profileEditVC, animated: true)
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
