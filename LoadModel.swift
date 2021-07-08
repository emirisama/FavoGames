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

protocol GetGameDataPS5Protocol{
    func getGameDataPS5(dataArray:[GameTitleModel])
}

protocol GetGameDataPS4Protocol{
    func getGameDataPS4(dataArray:[GameTitleModel])
}

protocol GetGameDataSwitchProtocol{
    func getGameDataSwitch(dataArray:[GameTitleModel])
}

protocol GetContentsDataPS5Protocol{
    func getContentsDataPS5(dataArray:[ContentModel])
}

protocol GetContentsDataPS4Protocol{
    func getContentsDataPS4(dataArray:[ContentModel])
}

protocol GetContentsDataSwitchProtocol{
    func getContentsDataSwitch(dataArray:[ContentModel])
}


protocol GetRateAverageCountProtocol{
    func getRateAverageCount(rateAverage: Double)
}




class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelPS5Array:[ContentModel] = []
    var contentModelPS4Array:[ContentModel] = []
    var contentModelSwitchArray:[ContentModel] = []
    var getContentsDataPS5Protocol:GetContentsDataPS5Protocol?
    var getContentsDataPS4Protocol:GetContentsDataPS4Protocol?
    var getContentsDataSwitchProtocol:GetContentsDataSwitchProtocol?
    
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
    var gameTitleModelPS5Array:[GameTitleModel] = []
    var gameTitleModelPS4Array:[GameTitleModel] = []
    var gameTitleModelSwitchArray:[GameTitleModel] = []
    var getGameDataPS5Protocol:GetGameDataPS5Protocol?
    var getGameDataPS4Protocol:GetGameDataPS4Protocol?
    var getGameDataSwitchProtocol:GetGameDataSwitchProtocol?
    
    //コンテンツを受信するメソッド(ゲームタイトルに紐づくレビューや名前などのデータを受信する）
    func loadContentsPS5(title:String,rateAverage:Double){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS5").addSnapshotListener { [self] (snapShot, error) in
            self.contentModelPS5Array = []
            
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
                            self.contentModelPS5Array.append(contentModel)
                            print(self.contentModelPS5Array.debugDescription)
                        }else{
                            print("そうでなければそのまま進める")
                            let contentModel = ContentModel(review: review, sender: sender, rate: rate, rateAverage: rateAverage)
                            self.contentModelPS5Array.append(contentModel)
                        }
                        print("コンテントモデル受信5")
                    }else if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let salesDate = data["salesDate"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let itemPrice = data["itemPrice"] as? Int,let booksGenreId = data["booksGenreId"] as? String{
                        let contentModel = ContentModel(review: "", sender: nil, rate: 0.0, rateAverage: 0.0)
                        self.contentModelPS5Array.append(contentModel)
                        print("コンテントモデル受信6")
                        print("全てのcontentModelArrayPS5")
                        print(self.contentModelPS5Array.debugDescription)
                    }
                }
                self.getContentsDataPS5Protocol?.getContentsDataPS5(dataArray: self.contentModelPS5Array)

            }
            print("snapShotDocが空だったら")
            print(self.contentModelPS5Array.debugDescription)
        }
    }
    
    func loadContentsPS4(title:String,rateAverage:Double){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS4").addSnapshotListener { [self] (snapShot, error) in
            self.contentModelPS4Array = []
            
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
                            self.contentModelPS4Array.append(contentModel)
                            print(self.contentModelPS4Array.debugDescription)
                        }else{
                            print("そうでなければそのまま進める")
                            let contentModel = ContentModel(review: review, sender: sender, rate: rate, rateAverage: rateAverage)
                            self.contentModelPS4Array.append(contentModel)
                        }
                        print("コンテントモデル受信5")
                    }else if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let salesDate = data["salesDate"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let itemPrice = data["itemPrice"] as? Int,let booksGenreId = data["booksGenreId"] as? String{
                        let contentModel = ContentModel(review: "", sender: nil, rate: 0.0, rateAverage: 0.0)
                        self.contentModelPS4Array.append(contentModel)
                        print("コンテントモデル受信6")
                        print("全てのcontentModelArrayPS4")
                        print(self.contentModelPS4Array.debugDescription)
                    }
                }
                self.getContentsDataPS4Protocol?.getContentsDataPS4(dataArray: self.contentModelPS4Array)

            }
            print("snapShotDocが空だったら")
            print(self.contentModelPS4Array.debugDescription)
        }
    }

    
    func loadContentsSwitch(title:String,rateAverage:Double){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Switch").addSnapshotListener { [self] (snapShot, error) in
            self.contentModelSwitchArray = []
            
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
                            self.contentModelSwitchArray.append(contentModel)
                            print(self.contentModelSwitchArray.debugDescription)
                        }else{
                            print("そうでなければそのまま進める")
                            let contentModel = ContentModel(review: review, sender: sender, rate: rate, rateAverage: rateAverage)
                            self.contentModelSwitchArray.append(contentModel)
                        }
                        print("コンテントモデル受信5")
                    }else if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let salesDate = data["salesDate"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let itemPrice = data["itemPrice"] as? Int,let booksGenreId = data["booksGenreId"] as? String{
                        let contentModel = ContentModel(review: "", sender: nil, rate: 0.0, rateAverage: 0.0)
                        self.contentModelSwitchArray.append(contentModel)
                        print("コンテントモデル受信6")
                        print("全てのcontentModelArraySwitch")
                        print(self.contentModelSwitchArray.debugDescription)
                    }
                }
                self.getContentsDataSwitchProtocol?.getContentsDataSwitch(dataArray: self.contentModelSwitchArray)

            }
            print("snapShotDocが空だったら")
            print(self.contentModelSwitchArray.debugDescription)
        }
    }

    
    
    
    //ゲームタイトル受信
    func loadGameContentsPS5(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS5").addSnapshotListener { [self] (snapShot, error) in
            self.gameTitleModelPS5Array = []
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
                        self.gameTitleModelPS5Array.append(gameTitleModel)
                        print("ゲームタイトルモデルの中身PS5")
                        print(self.gameTitleModelPS5Array.debugDescription)
                    }
                    
                }
                self.getGameDataPS5Protocol?.getGameDataPS5(dataArray: self.gameTitleModelPS5Array)
            }

        }
    }
    
    
    //ゲームタイトル受信
    func loadGameContentsPS4(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS4").addSnapshotListener { [self] (snapShot, error) in
            self.gameTitleModelPS4Array = []
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
                        self.gameTitleModelPS4Array.append(gameTitleModel)
                        print("ゲームタイトルモデルの中身PS4")
                        print(self.gameTitleModelPS4Array.debugDescription)
                    }
                    
                }
                self.getGameDataPS4Protocol?.getGameDataPS4(dataArray: self.gameTitleModelPS4Array)
            }

        }
    }
    
    //ゲームタイトル受信
    func loadGameContentsSwitch(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Switch").addSnapshotListener { [self] (snapShot, error) in
            self.gameTitleModelSwitchArray = []
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
                        self.gameTitleModelSwitchArray.append(gameTitleModel)
                        print("ゲームタイトルモデルの中身Switch")
                        print(self.gameTitleModelSwitchArray.debugDescription)
                    }
                    
                }
                self.getGameDataSwitchProtocol?.getGameDataSwitch(dataArray: self.gameTitleModelSwitchArray)
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
