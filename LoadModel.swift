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

protocol GetGameDataProtocol{
    func getGameData(dataArray:[GameTitleModel])
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
    var sendDBModel = SendDBModel()
    var profileModel = ProfileModel()
    var userDefaultsEX = UserDefaultsEX()
    
    //ゲームタイトル取得
    var gameTitleModelArray:[GameTitleModel] = []
    var getGameDataProtocol:GetGameDataProtocol?
    
    //コンテンツを受信するメソッド(ゲームタイトルに紐づくレビューや名前などのデータを受信する）
    func loadContents(title:String,rateAverage:Double){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("title").addSnapshotListener { [self] (snapShot, error) in
            self.contentModelArray = []
            
            if error != nil{
                return
            }
            print("コンテントモデル受信1")
            if let snapShotDoc = snapShot?.documents{
                print("コンテントモデル受信2")
                print(snapShotDoc.debugDescription)
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    print("コンテントモデル受信3")
                    let data = doc.data()
                    print("コンテントモデル受信4")
                    //if letでもし空じゃなかったらの意味（!= nilと同じ)
                    if let review = data["review"] as? String,let rate = data["rate"] as? Double,let sender = data["sender"] as? [String],let date = data["date"] as? Double,let rateAverage = data["rateAverage"] as? Double{
                        print("rateAverageの値が入っていたら")
                        print(rateAverage.debugDescription)
                        if rateAverage.isNaN == true{
                            print("もしrateAverageがnanだったらrateを入れる")
                            let contentModel = ContentModel(review: review, sender: sender, rate: rate, rateAverage: 0.0)
                            self.contentModelArray.append(contentModel)
                            print(self.contentModelArray.debugDescription)
                        }else{
                            print("そうでなければそのまま進める")
                            let contentModel = ContentModel(review: review, sender: sender, rate: rate, rateAverage: rateAverage)
                            self.contentModelArray.append(contentModel)
                        }
                        print("コンテントモデル受信5")
                    }else if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let salesDate = data["salesDate"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let itemPrice = data["itemPrice"] as? Int,let booksGenreId = data["booksGenreId"] as? String{
                        let contentModel = ContentModel(review: "", sender: nil, rate: 0.0, rateAverage: 0.0)
                        self.contentModelArray.append(contentModel)
                        print("コンテントモデル受信6")
                        print("全てのcontentModelArray")
                        print(self.contentModelArray.debugDescription)
                    }
                }
                self.getDataProtocol?.getData(dataArray: self.contentModelArray)

            }
            print("snapShotDocが空だったら")
            print(self.contentModelArray.debugDescription)      
        }
    }
    
    func loadGameContents(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("title").addSnapshotListener { [self] (snapShot, error) in
            self.gameTitleModelArray = []
            if error != nil{
                return
            }
            print("ゲーム受信1")
            if let snapShotDoc = snapShot?.documents{
                print("ゲーム受信2")
                print(snapShotDoc.debugDescription)
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    print("ゲーム受信3")
                    let data = doc.data()
                    print("ゲーム受信4")
                    //if letでもし空じゃなかったらの意味（!= nilと同じ)
                    if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let salesDate = data["salesDate"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let itemPrice = data["itemPrice"] as? Int,let booksGenreId = data["booksGenreId"] as? String{
                        let gameTitleModel = GameTitleModel(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
                       self.gameTitleModelArray.append(gameTitleModel)
                        print("ゲームタイトルモデルの中身")
                        print(self.gameTitleModelArray.debugDescription)
                    }
                    
                }
                self.getGameDataProtocol?.getGameData(dataArray: self.gameTitleModelArray)
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
