//
//  LoadModel.swift
//  GR
//
//  Created by 中森えみり on 2021/04/08.
//

import Foundation
import Firebase

protocol GetDataProtocol{
    
    func getData(dataArray:[ContentModel])
    
}

protocol GetProfileDataProtocol{
    
    func getProfileData(dataArray:[ProfileModel])
    
}

class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelArray:[ContentModel] = []
    var getDataProtocol:GetDataProtocol?
    var getProfileDataProtocol:GetProfileDataProtocol?
    //プロフィール
    var profileModelArray:[ProfileModel] = []
    
    //コンテンツを受信するメソッド
    func loadContents(category:String){
        
        db.collection(category).order(by: "date").addSnapshotListener { (snapShot, error) in
            
            self.contentModelArray = []
            if let snapShotDoc = snapShot?.documents{
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let userID = data["userID"] as? String,let name = data["name"] as? String,let image = data["image"] as? String,let review = data["review"] as? String,let sender = data["sender"] as? [String],let rate = data["rate"] as? Double, let date = data["date"] as? Double{
                        
                        let contentModel = ContentModel(review: review, name: name, userID: userID, sender: sender, rate: rate)
                        self.contentModelArray.append(contentModel)
                        self.getDataProtocol?.getData(dataArray: self.contentModelArray)
                    }
                }
            }
            
        }
    }
    
    
    func loadOwnContents(id:String){
        
        db.collection("Users").document(id).collection("ownContents").order(by: "date").addSnapshotListener { (snapShot, error) in
            
            self.contentModelArray = []
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    
                    let  data = doc.data()
                    if let userID = data["userID"] as? String,let name = data["name"] as? String,let image = data["image"] as? String,let review = data["review"] as? String,let sender = data["sender"] as? [String],let rate = data["rate"] as? Double,let date = data["date"] as? Double{
                        
                        
                        let contentModel = ContentModel(review: review, name: name, userID: userID, sender: sender, rate: rate)
                        
                        self.contentModelArray.append(contentModel)
                        
                        
                    }
                    
                }
            
            }
            
            self.getDataProtocol?.getData(dataArray: self.contentModelArray)
        
        }
    }
    
    
    func loadProfile(id:String){
        
        db.collection("Users").document(id).addSnapshotListener { (snapShot, error) in
            
            self.profileModelArray = []
            
            //!=nilはエラーがあったら、これ以上処理は進めない
            if error != nil{
                return
            }
            
            //スナップショットがnilでなければ{}の処理を進めてください
            if let snapShotDoc = snapShot?.data(){
                
                
                if let userID = snapShotDoc["userID"] as? String,let name = snapShotDoc["name"] as? String,let image = snapShotDoc["image"] as? String,let profileText = snapShotDoc["profileText"] as? String{
                
                let profileModel = ProfileModel(name: name, id: id,profileText: profileText, imageURLString: image, userID: userID)
                self.profileModelArray.append(profileModel)
                
                }
            }
            
            self.getProfileDataProtocol?.getProfileData(dataArray: self.profileModelArray)
            
        }
        
        
        
    }
    
    
}
