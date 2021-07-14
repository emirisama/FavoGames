//
//  SendDBModel.swift
//  GR
//
//  Created by 中森えみり on 2021/03/28.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseStorage
import PKHUD

protocol SendProfileDone{
    
    func checkOK()
    
}

//レビューを投稿し終えたら画面遷移
protocol DoneSendReviewContents{
    
    func checkDoneReview()
}


protocol SendGamesDone{
    
    func checkDoneGames()
    
}




class SendDBModel {
    
    let db = Firestore.firestore()
    var sendProfileDone:SendProfileDone?
    var userDefaultsEX = UserDefaultsEX()
    var imageDatauser = Data()
    var myProfile = [String]()

    var totalCountModelArray = [TotalCountModel]()
    
    var userID = String()
    var userName = String()
    var title = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    

    var doneSendReviewContents:DoneSendReviewContents?
    var sendGamesDone:SendGamesDone?
    
    init(){
        
    }
    
    init(userID:String,userName:String,mediumImageUrl:String,title:String,hardware:String,salesDate:String,itemPrice:Int){
        
        self.userID = userID
        self.userName = userName
        self.mediumImageUrl = mediumImageUrl
        self.title = title
        self.hardware = hardware
        self.salesDate = salesDate
        self.itemPrice = itemPrice
        
    }
    

    
    //プロフィールをDBへ送信する
    func sendProfileDB(userName:String,id:String,profileText:String, imageData: Data){
        
        //プロフィール画像
        let usernoimage = UIImage(named: "userimage")
        let usernoimagedata = usernoimage!.pngData()

        let imageRef = Storage.storage().reference().child("ProfielImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        //処理
        HUD.show(.progress)
        HUD.dimsBackground = true
        

        //プロフィール画像が空の場合、デフォルト画像を入れる

        if imageData.isEmpty == true{
            imageDatauser = usernoimagedata!

        }else{
            imageDatauser = imageData
        }
            

        imageRef.putData(imageDatauser, metadata: nil) { (metaData, error ) in

            if error != nil{
                return
            }


            imageRef.downloadURL { (url, error) in

                if url != nil{
                    
                    let profileModel = ProfileModel(userName: userName, id: id,profileText: profileText, imageURLString: url?.absoluteString, userID: Auth.auth().currentUser!.uid)
                    //アプリ内に自分のProfileを保存しておく
        self.userDefaultsEX.set(value: profileModel, forKey: "profile")
        
                    //送信
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["userName":userName,"id":id,"userID":Auth.auth().currentUser!.uid,"Date":Date().timeIntervalSince1970,"image":url?.absoluteString,"profileText":profileText])
                    print("プロフィール画像を保存する")
        
        //画面遷移
                    
        self.sendProfileDone?.checkOK()
                }
            }
        }
    }
    

    //ゲームタイトルに紐づくデータを送信
    func sendContents(documentID:String,sender:ProfileModel,comment:String,totalCount:Int){
 
        self.myProfile.append(sender.imageURLString!)
        self.myProfile.append(sender.profileText!)
        self.myProfile.append(sender.userID!)
        self.myProfile.append(sender.userName!)
        self.myProfile.append(sender.id!)
  
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Contents").document(title).setData(
            ["date":Date().timeIntervalSince1970,"comment":comment,"totalCount":totalCount,"sender":self.myProfile,])
        
        self.db.collection("title").document(documentID).collection("Contents").document(Auth.auth().currentUser!.uid).setData(
            ["date":Date().timeIntervalSince1970,"comment":comment,"totalCount":totalCount,"sender":self.myProfile])
        
        self.db.collection("title").document().setData(
            ["totalCount":totalCount,"title":title])

        print("レビュー送信")
        self.doneSendReviewContents?.checkDoneReview()
    
    }
    
    

    
    func sendTitle(documentID: String, totalCount: Int){
        self.db.collection("title").document(documentID).updateData(
            ["totalCount":totalCount]
        )
        self.sendGamesDone?.checkDoneGames()
        print("ゲーム送信PS5")
    }
    
    
    
}
