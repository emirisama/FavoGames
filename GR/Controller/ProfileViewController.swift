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


class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetDataProtocol,GetProfileDataProtocol,DoneSendContents,GetFollows,GetFollowers,SendProfileDone, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

 
    
 

    
    
    
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
    
    var followersArray = [FollowerModel]()
    var followArray = [FollowModel]()
    
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
        sendDBModel.doneSendContents = self


        
        
        //自分のプロフィールを表示する→タブが２の場合
        
        if self.tabBarController!.selectedIndex == 3{
            
            followButton.isHidden = true
            
            //setUP
            setUp(id: Auth.auth().currentUser!.uid)
            
        }else{
            
            if contentModel?.sender![2] == Auth.auth().currentUser!.uid{
                
                followButton.isHidden = true
 
            }

            //setUp（自分かどうかわからない場合）
            setUp(id: (contentModel?.sender![2])!)
            imageView.sd_setImage(with: URL(string: (contentModel?.sender![0])!), completed: nil)
            imageView.clipsToBounds = true
            nameLabel.text = contentModel?.sender![3]
            profileTextLabel.text = contentModel?.sender![1]
            idLabel.text = contentModel?.sender![4]


        }
        
    }
    
    
    
    
    func setUp(id:String){
        
        loadModel.getDataProtocol = self
        loadModel.getProfileDataProtocol = self
        loadModel.getFollows = self
        loadModel.getFollowers = self
        sendDBModel.sendProfileDone = self
        
        //プロフィールを受信する(idにAuth.auth().currentUserが入る
        loadModel.loadProfile(id: id)
        
        //フォロワーデータの受信機能
        loadModel.getFollowerData(id: id)
        //フォローデータの受信機能
        loadModel.getFollowData(id: id)
        
        //コンテンツデータの受信機能
        loadModel.loadContents(title: id)
        
    }
    
//    func showCamera(){
//
//        var config = YPImagePickerConfiguration()
//        config.isScrollToChangeModesEnabled = true
//        config.onlySquareImagesFromCamera = true
//        config.usesFrontCamera = false
//        config.showsPhotoFilters = true
//        config.showsVideoTrimmer = true
//        config.shouldSaveNewPicturesToAlbum = true
//        config.albumName = "DefaultYPImagePickerAlbumName"
//        //↓カメラの場合は[.photo]にする
//        config.screens = [.library]
//        config.showsCrop = .none
//        config.targetImageSize = YPImageSize.original
//        config.overlayView = UIView()
//        config.hidesStatusBar = true
//        config.hidesBottomBar = false
//        config.hidesCancelButton = false
//        config.preferredStatusBarStyle = UIStatusBarStyle.default
//        config.maxCameraZoomFactor = 1.0
//        let picker = YPImagePicker(configuration: config)
//        picker.didFinishPicking { [unowned picker] items, _ in
//            if let photo = items.singlePhoto{
//                self.imageView.image = photo.image
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//        present(picker, animated: true,completion: nil)
//        print("self.imageView.imageの中身")
//        print(self.imageView.image.debugDescription)
//
//    }
    
    
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
    
    
    @IBAction func follow(_ sender: Any) {
        
        followButton.startAnimate(spinnerType: .ballClipRotate, spinnercolor: .red, spinnerSize: 20) {
            
            if self.followButton.titleLabel?.text == "フォローをする"{
                
                self.sendDBModel.followAction(id: (self.contentModel?.sender![2])!, followOrNot: true, contentModel: self.contentModel!)
            }else if self.followButton.titleLabel?.text == "フォローをやめる"{
                
                self.sendDBModel.followAction(id: (self.contentModel?.sender![2])!, followOrNot: false, contentModel: self.contentModel!)
                
            }

        }
        
    }
    
    
    @IBAction func fwVC(_ sender: UIButton) {
        
        let followVC = storyboard?.instantiateViewController(identifier: "followVC") as! FollowAndFollowerViewController
        
        followVC.followersArray = followersArray
        followVC.followArray = followArray
        //tagのどっちがかがよばれる
        followVC.tag = sender.tag
        self.navigationController?.pushViewController(followVC, animated: true)

    }
    
    
    
    func checkDone(flag: Bool) {
        
        if flag == true{
            
            self.followButton.stopAnimatingWithCompletionType(completionType: .none) {
                self.followButton.setTitle("フォローをやめる", for: .normal)
            }
            
        }else{
            
            self.followButton.stopAnimatingWithCompletionType(completionType: .none) {
                self.followButton.setTitle("フォローをする", for: .normal)
            }

        }
    }
    
    
    func getFollows(followArray: [FollowModel], exist: Bool) {
        
        self.followArray = []
        self.followArray = followArray
        followLabel.text = String(self.followersArray.count)
        
    }
    
    func getFollowers(followersArray: [FollowerModel], exist: Bool) {
        
        self.followersArray = []
        self.followersArray = followersArray
        followerLabel.text = String(self.followersArray.count)
        if exist == true{
            
            self.followButton.setTitle("フォローをやめる", for: .normal)
        }else{
            self.followButton.setTitle("フォローをする", for: .normal)
        }
    }
  
    //プロフィールが入ったdataArray
    func getProfileData(dataArray: [ProfileModel]) {
        
        self.dataArray = dataArray
        
        imageView.sd_setImage(with: URL(string: dataArray[0].imageURLString!), completed: nil)
        nameLabel.text = dataArray[0].userName
        profileTextLabel.text = dataArray[0].profileText
        idLabel.text = dataArray[0].id

        
        
    }
    
    
    @IBAction func niceList(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "listVC") as! ListViewController
        
        if userID == Auth.auth().currentUser?.uid{
            
            //自分のリスト
            listVC.userName = userName
            
        }else{
            
            //みんなのリスト
            listVC.dataArray = self.dataArray
            
            
        }
        self.navigationController?.pushViewController(listVC, animated: true)
        
    }
    

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {

            //何も設定されていない場合
//            showCamera()
        openCamera()
        //送信
        sendDBModel.sendProfileDB(userName: userName, email: email, id: idLabel.text!, profileText: profileTextLabel.text!, imageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)

    }
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
//            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true,completion: nil)
            
        }else{
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage{
            imageView.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    
    func checkOK() {
        HUD.hide()
        dismiss(animated: true, completion: nil)
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
