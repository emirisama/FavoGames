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


class ProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,GetProfileDataProtocol,GetLikeDataProtocol,UICollectionViewDelegateFlowLayout{

    

 
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileTextLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var contentModel:ContentModel?
    var contentModelArray = [ContentModel]()
    var dataArray = [ProfileModel]()
    let db = Firestore.firestore()
    var profileModel = ProfileModel()
    var userDefaultsEX = UserDefaultsEX()
    var likeModelArray = [LikeModel]()
    var likeFlag = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        collectionView.register(UINib(nibName: "LikeCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        
        loadModel.getLikeDataProtocol = self
        loadModel.loadLikeData(userID: Auth.auth().currentUser!.uid)
        
        //自分のプロフィールを表示する→タブが２の場合
        loadModel.getProfileDataProtocol = self
        loadModel.loadProfile()
        imageView.clipsToBounds = true


        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Auth.auth().currentUser?.uid != nil{
            
        }else{
            print("新規会員登録")
            let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
            createVC.modalPresentationStyle = .fullScreen
            self.present(createVC, animated: true, completion: nil)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return likeModelArray.count
        
    }
    
    func collectionView(_ tableView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LikeCell
        cell.imageView.sd_setImage(with: URL(string: likeModelArray[indexPath.row].largeImageUrl!), completed: nil)
        //自分が投稿したレビューのゲームソフトのタイトル画像(動画：コンテンツを受信しよう）
        //        cell.contentImageView.sd_setImage(with: URL(string: contentModelArray[indexPath.row].imageURLSting!), completed: nil)
        //        cell.reviewView.rating = contentModelArray[indexPath.row].rate!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailVC.gameTitle = likeModelArray[indexPath.row].title!
        detailVC.hardware = likeModelArray[indexPath.row].hardware!
        detailVC.itemPrice = likeModelArray[indexPath.row].itemPrice!
        detailVC.booksGenreId = likeModelArray[indexPath.row].booksGenreId!
        detailVC.salesDate = likeModelArray[indexPath.row].salesDate!
        detailVC.largeImageUrl = likeModelArray[indexPath.row].largeImageUrl!
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    

    


    //プロフィールが入ったdataArray
    func getProfileData(dataArray: [ProfileModel]) {
        print("dataArrayが渡っているか")
        print(dataArray.debugDescription)
        self.dataArray = dataArray
        nameLabel.text = self.dataArray[0].userName
        imageView.sd_setImage(with: URL(string: self.dataArray[0].imageURLString!), completed: nil)
        profileTextLabel.text = self.dataArray[0].profileText
        idLabel.text = self.dataArray[0].id
        
    }
    
    
    
    
    
    @IBAction func tapEdit(_ sender: Any) {
        performSegue(withIdentifier: "profileEdit", sender: nil)
        //        let profileEditVC = storyboard?.instantiateViewController(identifier: "profileEdit") as! ProfileEditViewController
        //        self.navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
    
  
    
    func getLikeData(dataArray: [LikeModel]) {
        print("いいねのリスト")
        print(likeModelArray.debugDescription)
        likeModelArray = dataArray
        collectionView.reloadData()
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
