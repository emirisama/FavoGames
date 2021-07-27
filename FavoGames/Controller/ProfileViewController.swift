//
//  ProfileViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/04/13.
//

import UIKit
import FirebaseAuth


class ProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,GetProfileDataProtocol,GetLikeDataProtocol,UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var contentModel:ContentModel?
    var contentModelArray = [ContentModel]()
    var profileModelArray = [ProfileModel]()
    var profileModel = ProfileModel()
    var likeModelArray = [LikeModel]()
    var likeFlag = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadModel.getLikeDataProtocol = self
        loadModel.loadLikeData(userID: Auth.auth().currentUser!.uid)
        loadModel.getProfileDataProtocol = self
        loadModel.loadProfile()
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LikeCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Auth.auth().currentUser?.uid != nil{
            //サインイン
        }else{

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
    
    //プロフィールの値を取得
    func getProfileData(dataArray: [ProfileModel]) {
        
        self.profileModelArray = dataArray
        nameLabel.text = self.profileModelArray[0].userName
        imageView.sd_setImage(with: URL(string: self.profileModelArray[0].imageURLString!), completed: nil)
        
    }
    
    //プロフィール編集画面へ遷移
    @IBAction func tapEdit(_ sender: Any) {
        
        performSegue(withIdentifier: "profileEdit", sender: nil)
        
    }
    
    //いいねしたリストを取得
    func getLikeData(dataArray: [LikeModel]) {
        
        likeModelArray = dataArray
        collectionView.reloadData()
        
    }
    
    
}
