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



protocol GetTitlesDataProtocol{
    func getTitlesData(dataArray: [TitleDocumentIDModel])
}

//protocol GetContentsDocumentIDDataProtocol{
//    func getContensDocumentIDData(dataArray: [ContentsDocumentIDModel])
//}

protocol GetCommentCountDataProtocol{
    func getCommentCountData(dataArray: Int)
}

protocol GetGameTitleWithCommentCountProtocol{
    func getGameTitleWithCommentCountData(dataArray: [TitleAndCommentCountModel])
}

protocol GetTitleProtocol{
    func getTitleData(dataArray: [TitleModel])
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
    //ドキュメントID取得
    var titleDocumentModelArray:[TitleDocumentIDModel] = []
    var getTitlesDataProtocol:GetTitlesDataProtocol?
//    var contentsDocumentModelArray:[ContentsDocumentIDModel] = []
//    var getContentsDocumentIDDataProtocol:GetContentsDocumentIDDataProtocol?
    
    //コメント総数取得
    var commentCountModelArray:[CommentCountModel] = []
    var getCommentCountDataProtocol:GetCommentCountDataProtocol?
    var getGameTitleWithCommentCountProtocol:GetGameTitleWithCommentCountProtocol?
    var gameTitleWithCommentCountArray:[TitleAndCommentCountModel] = []
    
    //ゲームタイトル取得
    var titleModelArray:[TitleModel] = []
    var getTitleProtocol:GetTitleProtocol?
    
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
    
    //コメントを受信(ゲームタイトルに紐づくコメントや名前などのデータを受信）
    func loadContents(title:String){
        db.collection(title).order(by:"date").addSnapshotListener { (snapShot, error) in
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
                    if let comment = data["comment"] as? String,let sender = data["sender"] as? [String],let date = data["date"] as? Double{
                        
                        let contentModel = ContentModel(comment: comment, sender: sender,title: title)
                        self.contentModelArray.append(contentModel)
                        print("コメントのデータが入っている場合、コメントを入れる")
                        
                    }else{
                        let contentModel = ContentModel(comment: "", sender: nil,title: "")
                        self.contentModelArray.append(contentModel)
                        print("コメントのデータが入ってない場合、コメントに空を入れる")
                    }
                }
                self.getContentsDataProtocol?.getContentsData(dataArray: self.contentModelArray)
            }
            
        }
    }
    
    //コメント総数(ゲームタイトルに紐づくコメントのドキュメントの数）を受信する
    func loadCommentCount(title:String){
        db.collection(title).addSnapshotListener { [self] snapShot, error in
            if error != nil{
                return
            }
            let commentCount = snapShot?.documents.count
            self.getCommentCountDataProtocol?.getCommentCountData(dataArray: commentCount!)
            
        }
        
    }
    
    
    
    
    
    func loadGameTitleWithCommentCount(title:String){
        
        db.collection(title).document().collection("GameTitleWithCommentCount").addSnapshotListener { snapShot, error in
            self.gameTitleWithCommentCountArray = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                print("loadModelのゲームタイトルとコメント受信1")
                print(snapShotDoc.count)
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let commentCount = data["commentCount"] as? Int,let title = data["title"] as? String{
                        let titleAndCommentCountModel = TitleAndCommentCountModel(commentCount: commentCount, title: title)
                        self.gameTitleWithCommentCountArray.append(titleAndCommentCountModel)
                        print("gameTitleWithCommentCountArray受信")
                        print(self.gameTitleWithCommentCountArray.debugDescription)
                    }
                }
                self.getGameTitleWithCommentCountProtocol?.getGameTitleWithCommentCountData(dataArray: self.gameTitleWithCommentCountArray)
            }
        }
        
    }

    
    //ゲームタイトルのdocumentIDを取得
    func loadTitlesID(){
        db.collection("Games").getDocuments { snapShot, error in
            self.titleDocumentModelArray = []
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    
                    let titleDocumentIDModel = TitleDocumentIDModel(documentID: doc.documentID)
                    self.titleDocumentModelArray.append(titleDocumentIDModel)
                    
                }
                self.getTitlesDataProtocol?.getTitlesData(dataArray: self.titleDocumentModelArray)
            }
        }
    }
}


//    func loadTitle(title:String){
//        db.collection(title).getDocuments { snapShot, error in
//            self.titleModelArray = []
//            if error != nil{
//                return
//            }
//            if let snapShotDoc = snapShot?.documents{
//                for doc in snapShotDoc{
//
//                    let titleModel = TitleModel(title: doc.documentID)
//                    self.titleModelArray.append(titleModel)
//                    }
//                }
//            self.getTitleProtocol?.getTitleData(dataArray: self.titleModelArray)
//            }
//
//    }


//    //コメントのdocumentIDを取得
//    func loadContentsID(documentID:String){
//        db.collection("Games").document(documentID).collection("Contents").getDocuments { snapShot, error in
//            self.contentsDocumentModelArray = []
//            if error != nil{
//                return
//            }
//
//            if let snapShotDoc = snapShot?.documents{
//
//                //ドキュメントの数だけcontentModelの値を入れる
//                for doc in snapShotDoc{
//
//                    let contentsDocumentIDModel = ContentsDocumentIDModel(documentID: doc.documentID)
//                    self.contentsDocumentModelArray.append(contentsDocumentIDModel)
//
//                    
//                }
//                self.getContentsDocumentIDDataProtocol?.getContensDocumentIDData(dataArray: self.contentsDocumentModelArray)
//            }
//        }
//    }
    
//    //コメント総数を取得
//    func loadCommentCount(documentID:String){
//        db.collection("Games").document(documentID).collection("Contents").addSnapshotListener { snapShot, error in
//            self.commentCountModelArray = []
//            if error != nil{
//                return
//            }
//            if let snapShotDoc = snapShot?.documents{
//
//                for doc in snapShotDoc{
//                    let data = doc.data()
//
//                        if let comment = data["comment"] as? String{
//
//                        let commentCountModel = CommentCountModel(commentCount: comment)
//                        self.commentCountModelArray.append(commentCountModel)
//                    }
//                }
//                self.getCommentCountDataProtocol?.getCommentCountData(dataArray: self.commentCountModelArray)
//            }
//        }
//    }
    


    
    
    
    
    
    
