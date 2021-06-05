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

protocol GetLikeCountProtocol{
    
    func loadLikeCount(likeCount:Int,likeFlag:Bool)
    
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
    
    //いいねに受信に関する記述
    var likeCount = Int()
    var likeFlag = Bool()
    var getLikeCountProtocol:GetLikeCountProtocol?
    
    //コンテンツを受信するメソッド(ゲームタイトルに紐づくレビューや名前などのデータを受信する）
    func loadContents(title:String){
        print("レビューの受信が呼ばれない1")
        db.collection(title).order(by: "date").addSnapshotListener { (snapShot, error) in
            print("レビューの受信が呼ばれない2")
            self.contentModelArray = []
            print("レビューの受信が呼ばれない3")
            
            if let snapShotDoc = snapShot?.documents{
                print(snapShot.debugDescription)
                print("レビューの受信が呼ばれない4")
                //ドキュメントの数だけcontentModelの値を入れる
                print(snapShotDoc.debugDescription)
                for doc in snapShotDoc{
                    print("レビューの受信が呼ばれない6")
                    let data = doc.data()
                    print(data.debugDescription)
                    //if letでもし空じゃなかったらの意味（!= nilと同じ)
                    print("レビューの受信が呼ばれない7")
                    if let review = data["review"] as? String,let rate = data["rate"] as? Double,let sender = data["sender"] as? [String],let date = data["date"] as? Double{
                        
                        let contentModel = ContentModel(review: review, sender: sender, rate: rate)
                        self.contentModelArray.append(contentModel)
                        print("レビューの受信が呼ばれない8")
                        self.getDataProtocol?.getData(dataArray: self.contentModelArray)
                        print("レビューの受信が呼ばれない9")
                    }
                }
            }
            
        }
    }
    
    

    
    //プロフィールの受信
    func loadProfile(id:String){
        
        db.collection("Users").document(id).addSnapshotListener { (snapShot, error) in
            
            self.profileModelArray = []
            
            //!=nilはエラーがあったら、これ以上処理は進めない
            if error != nil{
                return
            }
            
            //スナップショットがnilでなければ{}の処理を進めてください
            if let snapShotDoc = snapShot?.data(){
                
                
                if let userID = snapShotDoc["userID"] as? String,let userName = snapShotDoc["userName"] as? String,let image = snapShotDoc["image"] as? String,let profileText = snapShotDoc["profileText"] as? String,let id = snapShotDoc["id"] as? String{
                    let profileModel = ProfileModel(userName: userName, id: id,profileText: profileText, imageURLString: image, userID: userID)
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
                    if let follower = data["follower"] as? String,let followOrNot = data["followOrNot"] as? Bool,let image = data["image"] as? String,let profileText = data["profileText"] as? String,let userID = data["userID"] as? String,let userName = data["userName"] as? String{
                        
                        if userID == Auth.auth().currentUser!.uid{
                            self.ownFollowOrNot = followOrNot
                        }
                        //trueの数だけその人にフォロワーがいて、自分がtrueだったら、ボタン操作
                        if followOrNot == true{
                            let followerModel = FollowerModel(follower: follower, followerOrNot: followOrNot, image: image, profileText: profileText, userID: userID, userName: userName)
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
                    if let follow = data["follow"] as? String,let followOrNot = data["followOrNot"] as? Bool,let image = data["image"] as? String,let profileText = data["profileText"] as? String,let userID = data["userID"] as? String,let userName = data["userName"] as? String{
                        
                        //trueの数だけその人にフォロワーがいて、自分がtrueだったら、ボタン操作
                        if followOrNot == true{
                            
                            let followModel = FollowModel(follow: follow, followOrNot: followOrNot, image: image, profileText: profileText, userID: userID, userName: userName)
                            
                            self.followModelArray.append(followModel)
                            
                        }
                        
                        //自分の状態だけ渡す（フォローしてるんだったら、existの情報を渡す、フォロワーのみんなを同時に渡す）
                        self.getFollows?.getFollows(followArray:self.followModelArray, exist: self.ownFollowOrNot)
                        
                    }
                }
            }
        }
    }
    
    //いいねを押す（受信）
    func loadLikeCount(uuid:String){
        var likeFlag = Bool()
        
        db.collection("Users").document(uuid).collection("like").addSnapshotListener { (snapShot, error) in
            
            
            if  error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    print(doc.documentID)
                    print(Auth.auth().currentUser!.uid)
                    if doc.documentID == Auth.auth().currentUser?.uid{
                        if let like = data["like"] as? Bool{
                            
                            likeFlag = like
                        }
                    }
                }
                
                let docCount = snapShotDoc.count
                self.getLikeCountProtocol?.loadLikeCount(likeCount: docCount, likeFlag: likeFlag)
                
            }
        }
        
    }
    
    //いいねを消す（受信）
    func deleteToLike(thisUserID:String){
        
        db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete() { err in
            if let err = err{
                print("Error removing document: \(err)")
            }else{
                print("Document successfully removed!")
            }
        }
        
    }
    
    
}
