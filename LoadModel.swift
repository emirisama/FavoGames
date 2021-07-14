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

protocol GetTitlesDataProtocol{
    func getTitlesData(dataArray: [TitleDocumentIDModel])
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
    var totalCountModelArray:[TotalCountModel] = []
    var getTotalCountProtocol:GetTotalCountProtocol?
    var sendDBModel = SendDBModel()
    var profileModel = ProfileModel()
    var userDefaultsEX = UserDefaultsEX()
    //ドキュメントID取得
    var titleDocumentModelArray:[TitleDocumentIDModel] = []
    var getTitlesDataProtocol:GetTitlesDataProtocol?
    

    
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
    func loadContents(title:String,totalCount:Int,documentID:String){
        db.collection("title").document(documentID).collection("Contents").order(by: "date").addSnapshotListener { (snapShot, error) in
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
                    if let comment = data["comment"] as? String,let totalCount = data["totalCount"] as? Int,let sender = data["sender"] as? [String],let date = data["date"] as? Double{
                        let totalCount = snapShotDoc.count
                        
                        let contentModel = ContentModel(comment: comment, totalCount: totalCount, sender: sender)
                        self.contentModelArray.append(contentModel)
        
                    }else{
                        let contentModel = ContentModel(comment: "", totalCount: 0, sender: nil)
                        self.contentModelArray.append(contentModel)
                        print("contentModelArrayの中身")
                        print(self.contentModelArray)
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
    
    func loadTitles(){
        db.collection("title").getDocuments(completion: { (snapShot, error) in
            self.titleDocumentModelArray = []
            if error != nil{
                return
            }
            print("ゲームタイトル受信1")
            if let snapShotDoc = snapShot?.documents{
                
                print("ゲームタイトル受信2")
                print(snapShotDoc.debugDescription)
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let titleDocumentID =  data[doc.documentID] as? String{
                        let titleDocumentIDModel = TitleDocumentIDModel(documentID: titleDocumentID)
                        self.titleDocumentModelArray.append(titleDocumentIDModel)
                        
                    }
                    
                }
                self.getTitlesDataProtocol?.getTitlesData(dataArray: self.titleDocumentModelArray)
            }
            print("snapShotDocが空だったらPS5")
            print(self.contentModelArray.debugDescription)
        }
        )
    }
}
        
    
