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

protocol GetFollowers{
    
    //existがtrueなら自分のフォロワーの中にいるので、ボタンの表記を変える
    func getFollowers(followersArray:[FollowerModel],exist:Bool)
    
}

protocol GetFollows{
    
    func getFollows(followArray:[FollowModel],exist:Bool)
    
}

class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelArray:[ContentModel] = []
    var getDataProtocol:GetDataProtocol?
    
    //プロフィール
    var profileModelArray:[ProfileModel] = []
    var getProfileDataProtocol:GetProfileDataProtocol?
    
    
    //フォロワー受信に関する記述
    var followerModelArray:[FollowerModel] = []
    var getFollowers:GetFollowers?
    
    //フォロー受信に関する記述
    var followModelArray:[FollowModel] = []
    var getFollows:GetFollows?
    
    var ownFollowOrNot = Bool()
    
    
    
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
                
                self.getDataProtocol?.getData(dataArray: self.contentModelArray)
                
            }
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
    
    
    //フォロワーのみ集めてくる（受信する）
    func getFollowerData(id:String){
        db.collection("Users").document(id).collection("follower").addSnapshotListener { (snapShot, error) in
            self.followerModelArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    //フォローしているどうかを見分ける
                    if let follower = data["follower"] as? String,let followOrNot = data["followOrNot"] as? Bool,let image = data["image"] as? String,let profileText = data["profileText"] as? String,let userID = data["userID"] as? String,let name = data["name"] as? String{
                        
                        if userID == Auth.auth().currentUser!.uid{
                            self.ownFollowOrNot = followOrNot
                        }
                        //trueの数だけその人にフォロワーがいて、自分がtrueだったら、ボタン操作
                        if followOrNot == true{
                            let followerModel = FollowerModel(follower: follower, followerOrNot: followOrNot, image: image, profileText: profileText, userID: userID, name: name)
                            self.followerModelArray.append(followerModel)
                        }
                        //自分の状態だけ渡す（フォローしてるんだったら、existの情報を渡す、フォロワーのみんなを同時に渡す）
                        self.getFollowers?.getFollowers(followersArray:self.followerModelArray, exist: self.ownFollowOrNot)
                    }
                }
            }
        }
    }
    
    
    //フォローのみ集めてくる（受信する）
    func getFollowData(id:String){
        
        db.collection("Users").document(id).collection("follow").addSnapshotListener { (snapShot, error) in
            
            self.followModelArray = []
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    //フォローしているどうかを見分ける
                    if let follow = data["follow"] as? String,let followOrNot = data["followOrNot"] as? Bool,let image = data["image"] as? String,let profileText = data["profileText"] as? String,let userID = data["userID"] as? String,let name = data["name"] as? String{
                        
                        //trueの数だけその人にフォロワーがいて、自分がtrueだったら、ボタン操作
                        if followOrNot == true{
                            
                            let followModel = FollowModel(follow: follow, followOrNot: followOrNot, image: image, profileText: profileText, userID: userID, name: name)
                            
                            self.followModelArray.append(followModel)
                            
                        }
                        
                        //自分の状態だけ渡す（フォローしてるんだったら、existの情報を渡す、フォロワーのみんなを同時に渡す）
                        self.getFollows?.getFollows(followArray:self.followModelArray, exist: self.ownFollowOrNot)
                        
                    }
                }
            }
        }
    }
    
    
}
