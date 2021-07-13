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




protocol GetTotalCountProtocol{
    func getTotalCount(totalCount: [TotalCountModel])
}



class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelArray:[ContentModel] = []

    var getContentsDataProtocol:GetContentsDataProtocol?

    //プロフィール
    var profileModelArray:[ProfileModel] = []
    var getProfileDataProtocol:GetProfileDataProtocol?
    
    //レビューの平均値に関する記述
    var totalCountModelArray:[TotalCountModel] = []
    var getTotalCountProtocol:GetTotalCountProtocol?
    var sendDBModel = SendDBModel()
    var profileModel = ProfileModel()
    var userDefaultsEX = UserDefaultsEX()
    

    
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
 
    
    
  
    

    
    //コンテンツを受信するメソッド(ゲームタイトルに紐づくレビューや名前などのデータを受信する）
    func loadContents(title:String,totalCount:Int){
        db.collection("title").document(title).collection("Contents").order(by: "date").addSnapshotListener { (snapShot, error) in
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
                    print("コンテントモデル受信3PS5")
                    let data = doc.data()
                    print("コンテントモデル受信4PS5")
                    //if letでもし空じゃなかったらの意味（!= nilと同じ)
                    if let comment = data["comment"] as? String,let totalCount = data["totalCount"] as? Int,let sender = data["sender"] as? [String],let date = data["date"] as? Double{
                        let totalCount = snapShotDoc.count
                        
                        let contentModel = ContentModel(comment: comment, totalCount: totalCount, sender: sender)
                        self.contentModelArray.append(contentModel)
        
                    }else{
                        let contentModel = ContentModel(comment: "", totalCount: 0, sender: nil)
                        self.contentModelArray.append(contentModel)
                    }
                }
                self.getContentsDataProtocol?.getContentsData(dataArray: self.contentModelArray)

            }
            print("snapShotDocが空だったらPS5")
            print(self.contentModelArray.debugDescription)
        }
    }


    



    
    
    //rateの平均値を出す
    func loadTotalCount(title:String,totalCount:Int){
        db.collection("Total").document(title).collection("Contents").addSnapshotListener { snapShot, error in
            self.totalCountModelArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
 
                for doc in snapShotDoc{
                    let data = doc.data()
                    let total = snapShotDoc.count
                        
                            let totalCountArray = TotalCountModel(totalCount: total)
 
                            self.totalCountModelArray.append(totalCountArray)
                        print("totalCountModelArrayの中身")
                    print(self.totalCountModelArray.debugDescription)
                }
            

                self.getTotalCountProtocol?.getTotalCount(totalCount: self.totalCountModelArray)
                
            }
        }
    }
    

    
    
    

    
    
}
