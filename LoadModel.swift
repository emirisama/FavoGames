//
//  LoadModel.swift
//  GR
//
//  Created by 中森えみり on 2021/04/08.
//

import Foundation
import Firebase
import FirebaseFirestore



protocol GetProfileDataProtocol{
    
    func getProfileData(dataArray:[ProfileModel])
    
}

protocol GetContentsDataProtocol{
    func getContentsData(dataArray:[ContentModel])
}

protocol GetLikeDataProtocol{
    func getLikeData(dataArray: [LikeModel])
}

protocol GetLikeFlagProtocol{
    func getLikeFlagData(likeFlag:Bool)
}

class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelArray:[ContentModel] = []
    
    var getContentsDataProtocol:GetContentsDataProtocol?
    
    //プロフィール
    var profileModelArray:[ProfileModel] = []
    var getProfileDataProtocol:GetProfileDataProtocol?
    
    //コメントに関する記述
    var sendDBModel = SendDBModel()
    var profileModel = ProfileModel()
    var userDefaultsEX = UserDefaultsEX()
 

    //いいね取得
    var getLikeDataProtocol:GetLikeDataProtocol?
    var likeModelArray:[LikeModel] = []
    var getLikeFlagProtocol:GetLikeFlagProtocol?
    
    //プロフィールの受信
    func loadProfile(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapShot, error) in
            print("プロフィールの受信")
            self.profileModelArray = []
            
            //!=nilはエラーがあったら、これ以上処理は進めない
            if error != nil{
                return
            }
            
            //スナップショットがnilでなければ{}の処理を進めてください
            if let snapShotDoc = snapShot?.data(){
                print("ぷろふぃーるのsnapSHot")
                print(snapShotDoc.count)
                if let userID = snapShotDoc["userID"] as? String,let userName = snapShotDoc["userName"] as? String,let image = snapShotDoc["image"] as? String,let profileText = snapShotDoc["profileText"] as? String,let id = snapShotDoc["id"] as? String{
                    let profileModel = ProfileModel(userName: userName, id: id,profileText: profileText, imageURLString: image, userID: userID)
                    self.profileModelArray.append(profileModel)
                    print("profileModelArrayの中身")
                    print(self.profileModelArray.debugDescription)
                }
            }
            self.getProfileDataProtocol?.getProfileData(dataArray: self.profileModelArray)
            
        }
    }
    
    //コメントを受信(ゲームタイトルに紐づくコメントや名前などのデータを受信）
    func loadContents(title:String){
        db.collection(title).document(Auth.auth().currentUser!.uid).collection("Contents").order(by:"date").addSnapshotListener { (snapShot, error) in
            self.contentModelArray = []
            if error != nil{
                return
            }
            print("コンテントモデル受信1PS5")
            if let snapShotDoc = snapShot?.documents{
                
                print("コンテントモデル受信2PS5")
                print(snapShotDoc.debugDescription)
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    //                    doc.documentID
                    print("コンテントモデル受信3PS5")
                    let data = doc.data()
                    print("コンテントモデル受信4PS5")
                    //if letでもし空じゃなかったらの意味（!= nilと同じ)
                    if let comment = data["comment"] as? String,let date = data["date"] as? Double,let date = data["title"] as? String{
                        let contentModel = ContentModel(comment: comment,title: title)
                        self.contentModelArray.append(contentModel)
                        print("コメントのデータが入っている場合、コメントを入れる")
                    }
                }
                self.getContentsDataProtocol?.getContentsData(dataArray: self.contentModelArray)
            }
            
        }
    }

    
    func loadLikeData(userID:String){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").order(by: "date").addSnapshotListener { snapShot, error in
            self.likeModelArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                print("いいねのスナップショット")
                print(snapShotDoc.count)
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let title = data["title"] as? String, let hardware = data["hardware"] as? String,let salesDate = data["salesDate"] as? String,let largeImageUrl = data["largeImageUrl"] as? String,let itemPrice = data["itemPrice"] as? Int,let booksGenreId = data["booksGenreId"] as? String{
                        let likeModel = LikeModel(title: title, hardware: hardware, salesDate: salesDate, largeImageUrl: largeImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
                        self.likeModelArray.append(likeModel)
                    }
                }
                self.getLikeDataProtocol?.getLikeData(dataArray: self.likeModelArray)
                  
            }
        }
        
    }
    
    
    func loadLikeFlag(title:String){
        var likeFlag = Bool()
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(title).addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.data(){
                
                for doc in snapShotDoc{
                    print("likeFlagのsnapShotの数")
                    print(snapShotDoc.count)
                    if let like = snapShotDoc["like"] as? Bool{
                        likeFlag = like
                        print("likeFlagの中身受信")
                        print(likeFlag)
                    }
                    
                }
                self.getLikeFlagProtocol?.getLikeFlagData(likeFlag: likeFlag)
            }
            
        }
        
        
    }
    
//    func loadLikeDocumentID(){
//        db.collction("Users").
//        
//    }
}




    
    
    
    
    
    
