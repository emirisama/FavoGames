//
//  LoadModel.swift
//  FavoGames
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
    
    //Firebase
    let db = Firestore.firestore()
    
    //Memo
    var contentModelArray:[ContentModel] = []
    var getContentsDataProtocol:GetContentsDataProtocol?
    
    //プロフィール
    var profileModelArray:[ProfileModel] = []
    var getProfileDataProtocol:GetProfileDataProtocol?
    
    //いいね取得
    var getLikeDataProtocol:GetLikeDataProtocol?
    var likeModelArray:[LikeModel] = []
    var getLikeFlagProtocol:GetLikeFlagProtocol?
    
    //プロフィールの受信
    func loadProfile(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapShot, error) in
            
            self.profileModelArray = []
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.data(){
                
                if let userName = snapShotDoc["userName"] as? String,let image = snapShotDoc["image"] as? String{
                    let profileModel = ProfileModel(userName: userName, imageURLString: image)
                    self.profileModelArray.append(profileModel)
                    
                }
            }
            
            self.getProfileDataProtocol?.getProfileData(dataArray: self.profileModelArray)
            
        }
    }
    
    //コメントの受信
    func loadContents(title:String){
        db.collection(title).document(Auth.auth().currentUser!.uid).collection("Contents").order(by:"date").addSnapshotListener { (snapShot, error) in
            self.contentModelArray = []
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    
                    if let comment = data["comment"] as? String,let date = data["date"] as? Double,let date = data["title"] as? String{
                        let contentModel = ContentModel(comment: comment,title: title)
                        self.contentModelArray.append(contentModel)
                        
                    }
                }
                
                self.getContentsDataProtocol?.getContentsData(dataArray: self.contentModelArray)
                
            }
        }
    }
    
    //いいねの受信
    func loadLikeData(userID:String){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").order(by: "date").addSnapshotListener { snapShot, error in
            
            self.likeModelArray = []
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
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
    
    //いいねの真偽の値を受信
    func loadLikeFlag(title:String){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(title).addSnapshotListener { snapShot, error in
            
            var likeFlag = Bool()
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.data(){
                
                for doc in snapShotDoc{
                    
                    if let like = snapShotDoc["like"] as? Bool{
                        likeFlag = like
                        
                    }
                }
                
                self.getLikeFlagProtocol?.getLikeFlagData(likeFlag: likeFlag)
                
            }
        }
    }
    
    
}




    
    
    
    
    
    
