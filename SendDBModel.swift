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


protocol DoneSendGames{
    
    func checkDoneGames()
    
}

protocol DoneSendCommentCounts{
    func checkDoneCommentCounts()
    
}

protocol DoneSendGameTitleWithCommentCount{
    func checkDoneGameTitleWithCommentCount()
}

protocol DoneSendLikeData{
    func checkSendLikeData()
}



class SendDBModel {
    
    let db = Firestore.firestore()
    var sendProfileDone:SendProfileDone?
    var userDefaultsEX = UserDefaultsEX()
    var imageDatauser = Data()
    var myProfile = [String]()
    var userID = String()
    var userName = String()
    var title = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    

    var doneSendReviewContents:DoneSendReviewContents?
    var doneSendGames:DoneSendGames?
    var doneSendCommentCounts:DoneSendCommentCounts?
    var doneSendGameTitleWithCommentCount:DoneSendGameTitleWithCommentCount?
    var doneSendLikeData:DoneSendLikeData?
    
    init(){
        
    }
    
    init(userID:String,mediumImageUrl:String,title:String,hardware:String,salesDate:String,itemPrice:Int,booksGenreId:String){
        
        self.userID = userID
        self.mediumImageUrl = mediumImageUrl
        self.title = title
        self.hardware = hardware
        self.salesDate = salesDate
        self.itemPrice = itemPrice
        
    }
    
    func sendLikeData(userID:String,mediumImageUrl:String,title:String,hardware:String,salesDate:String,itemPrice:Int,booksGenreId:String,likeFlag:Bool){

        //まだlikeをしていないとき
        if likeFlag == false{
            

            self.db.collection("Users").document(userID).collection("like").document(title).setData(
                ["userID":userID,"title":title,"hardware":hardware,"mediumImageUrl":mediumImageUrl,"salesDate":salesDate,"itemPrice":itemPrice,"booksGenreId":booksGenreId,"date":Date().timeIntervalSince1970,"like":false])
            print("titleのなかみ")
            print(title)
            //消す
            deleteToLike(title:title)
        }else if likeFlag == true{
 
            self.db.collection("Users").document(userID).collection("like").document(title).setData(
                ["userID":userID,"title":title,"hardware":hardware,"mediumImageUrl":mediumImageUrl,"salesDate":salesDate,"itemPrice":itemPrice,"booksGenreId":booksGenreId,"date":Date().timeIntervalSince1970,"like":true])
            self.doneSendLikeData?.checkSendLikeData()
        }
        
    }
    
    func deleteToLike(title:String){
        print("deleteTolikeが呼ばれているか")
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(title).delete()
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
    func sendContents(title:String,sender:ProfileModel,comment:String){
 
        self.myProfile.append(sender.imageURLString!)
        self.myProfile.append(sender.profileText!)
        self.myProfile.append(sender.userID!)
        self.myProfile.append(sender.userName!)
        self.myProfile.append(sender.id!)
  
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Contents").document().setData(
            ["date":Date().timeIntervalSince1970,"comment":comment,"sender":self.myProfile,])
        
        self.db.collection(title).document(Auth.auth().currentUser!.uid).collection("Contents").document(Auth.auth().currentUser!.uid).setData(
            ["comment":comment,"sender":self.myProfile,"date":Date().timeIntervalSince1970])
 
        print("レビュー送信")
        self.doneSendReviewContents?.checkDoneReview()
        
    }
    

  
    
    
 
    
}
    
   

