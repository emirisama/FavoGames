//
//  LoadModel.swift
//  GR
//
//  Created by 中森えみり on 2021/04/08.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol GetDataProtocol{
    
    func getData(dataArray:[ContentModel])
    
}

protocol GetProfileDataProtocol{
    
    func getProfileData(dataArray:[ProfileModel])
    
}

protocol GetRateAverageCountProtocol{
    func getRateAverageCount(rateAverage: Double)
}



class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelArray:[ContentModel] = []
    var getDataProtocol:GetDataProtocol?
    
    //プロフィール
    var profileModelArray:[ProfileModel] = []
    var getProfileDataProtocol:GetProfileDataProtocol?

    //レビューの平均値に関する記述
    var rateModelArray:[RateModel] = []
    var getRateAverageCountProtocol:GetRateAverageCountProtocol?
    var rateAverageModelArray:[RateAverageModel] = []

    //コンテンツを受信するメソッド(ゲームタイトルに紐づくレビューや名前などのデータを受信する）
    func loadContents(title:String){
        print("コンテントモデル受信1")
        db.collection(title).order(by: "date").addSnapshotListener { (snapShot, error) in
            print("コンテントモデル受信2")
            self.contentModelArray = []
            print("コンテントモデル受信3")
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                print("コンテントモデル受信4")
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    print("コンテントモデル受信5")
                    let data = doc.data()
                    print("コンテントモデル受信6")
                    //if letでもし空じゃなかったらの意味（!= nilと同じ)
                    print("コンテントモデル受信7")
                    if let review = data["review"] as? String,let rate = data["rate"] as? Double,let sender = data["sender"] as? [String],let date = data["date"] as? Double,let rateAverage = data["rateAverage"] as? Double{
                        //rateAverageがnanになる
                        if rateAverage == Double("nan"){
                            rateAverage == 0.0
                        }else{
                        }
                        let contentModel = ContentModel(review: review, sender: sender, rate: rate, rateAverage: rateAverage)
                        self.contentModelArray.append(contentModel)
                        
                        self.getDataProtocol?.getData(dataArray: self.contentModelArray)
                    }else{
                        
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
    
    
    
    //rateの平均値を出す
    func loadRateAverageCount(title:String,rateAverage:Double){
  
        db.collection("Score").document(title).collection("review").addSnapshotListener { snapShot, error in
            self.rateModelArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
 
                for doc in snapShotDoc{
                    let data = doc.data()
                        if let rate = data["rate"] as? Double{
                            let rateArray = RateModel(rate: rate)
 
                            self.rateModelArray.append(rateArray)
                            
                        }
                    
                }
                
                var totalCount = 0.0
                var rateAverage = 0.0
                for (index, value) in self.rateModelArray.enumerated(){
       
                    totalCount = totalCount + self.rateModelArray[index].rate!
                }

                rateAverage = Double(totalCount) / Double(snapShotDoc.count)
                var rateAverageScore = (round(10*rateAverage)/10)

 
                print("rateArrayの中身")
                print(rateAverageScore.debugDescription)
                print("snapShotDocの中身")
                print(snapShotDoc.debugDescription)

                self.getRateAverageCountProtocol?.getRateAverageCount(rateAverage: rateAverageScore)
                
            }
            
            
        }
    }
    
    
    
    

    
    
}
