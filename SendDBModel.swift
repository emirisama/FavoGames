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
protocol DoneSendReviewContentsPS5{
    
    func checkDoneReviewPS5()
}

protocol DoneSendReviewContentsPS4{
    
    func checkDoneReviewPS4()
}

protocol DoneSendReviewContentsSwitch{
    
    func checkDoneReviewSwitch()
}


protocol SendGameTitlePS5Done{
    
    func checkDoneGameTitlePS5()
    
}

protocol SendGameTitlePS4Done{
    func checkDoneGameTitlePS4()
}

protocol SendGameTitleSwitchDone{
    func checkDoneGameTitleSwitch()
}



class SendDBModel {
    
    let db = Firestore.firestore()
    var sendProfileDone:SendProfileDone?
    var userDefaultsEX = UserDefaultsEX()
    var imageDatauser = Data()
    var myProfile = [String]()

    var rateAverageModelArray = [RateAverageModel]()
    
    var userID = String()
    var userName = String()
    var title = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    
    var sendGameTitlePS5Done:SendGameTitlePS5Done?
    var sendGameTitlePS4Done:SendGameTitlePS4Done?
    var sendGameTitleSwitchDone:SendGameTitleSwitchDone?
    var doneSendReviewContentsPS5:DoneSendReviewContentsPS5?
    var doneSendReviewContentsPS4:DoneSendReviewContentsPS4?
    var doneSendReviewContentsSwitch:DoneSendReviewContentsSwitch?
    
    
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
    
    func sendData(userName:String){
        //コンテンツの中にデータを入れる
        self.db.collection("contents").document(userName).collection("collection").document().setData(
            ["userID":self.userID as Any,"userName":self.userName as Any,"mediumImageUrl":self.mediumImageUrl as Any,"title":self.title as Any,"hardware":self.hardware as Any,"salesDate":self.salesDate as Any,"itemPrice":self.itemPrice as Any,"postDate":Date().timeIntervalSince1970])
        //どのユーザーがいるのかを名前だけ入れる(２回送信）
        self.db.collection("Users").addDocument(data: ["userName":self.userName])
    }
    
    //プロフィールをDBへ送信する
    func sendProfileDB(userName:String, email:String, id:String,profileText:String, imageData: Data){
        
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
                    
                    let profileModel = ProfileModel(userName: userName, id: id, email: email, profileText: profileText, imageURLString: url?.absoluteString, userID: Auth.auth().currentUser!.uid)
                    //アプリ内に自分のProfileを保存しておく
        self.userDefaultsEX.set(value: profileModel, forKey: "profile")
        
                    //送信
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["userName":userName,"email": email,"id":id,"userID":Auth.auth().currentUser!.uid,"Date":Date().timeIntervalSince1970,"image":url?.absoluteString,"profileText":profileText])
                    print("プロフィール画像を保存する")
        
        //画面遷移
                    
        self.sendProfileDone?.checkOK()
                }
            }
        }
    }
 
    //ゲームタイトルに紐づくデータを送信
    func sendContentsPS5(title:String,sender:ProfileModel,review:String,rate:Double,rateAverage:Double){
 
        self.myProfile.append(sender.imageURLString!)
        self.myProfile.append(sender.profileText!)
        self.myProfile.append(sender.userID!)
        self.myProfile.append(sender.userName!)
        self.myProfile.append(sender.id!)
  
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS5").document(title).setData(
            ["review":review,"rate":rate,"sender":self.myProfile,"date":Date().timeIntervalSince1970,"rateAverage":rateAverage])
        
        self.db.collection("Score").document(title).collection("review").document().setData(
            ["rate":rate])
        print("レビュー送信")
        
        self.doneSendReviewContentsPS5?.checkDoneReviewPS5()

    }
    
    func sendContentsPS4(title:String,sender:ProfileModel,review:String,rate:Double,rateAverage:Double){
 
        self.myProfile.append(sender.imageURLString!)
        self.myProfile.append(sender.profileText!)
        self.myProfile.append(sender.userID!)
        self.myProfile.append(sender.userName!)
        self.myProfile.append(sender.id!)
  
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS4").document(title).setData(
            ["review":review,"rate":rate,"sender":self.myProfile,"date":Date().timeIntervalSince1970,"rateAverage":rateAverage])
        
        self.db.collection("Score").document(title).collection("review").document().setData(
            ["rate":rate])
        print("レビュー送信")
        
        self.doneSendReviewContentsPS4?.checkDoneReviewPS4()

    }
    
    func sendContentsSwitch(title:String,sender:ProfileModel,review:String,rate:Double,rateAverage:Double){
 
        self.myProfile.append(sender.imageURLString!)
        self.myProfile.append(sender.profileText!)
        self.myProfile.append(sender.userID!)
        self.myProfile.append(sender.userName!)
        self.myProfile.append(sender.id!)
  
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Switch").document(title).setData(
            ["review":review,"rate":rate,"sender":self.myProfile,"date":Date().timeIntervalSince1970,"rateAverage":rateAverage])
        
        self.db.collection("Score").document(title).collection("review").document().setData(
            ["rate":rate])
        print("レビュー送信")
        
        self.doneSendReviewContentsSwitch?.checkDoneReviewSwitch()

    }
    
    //ゲームタイトル送信PS5
    func sendGameTitlePS5(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS5").document(title).setData(
            ["title":title,"hardware":hardware,"salesDate":salesDate,"mediumImageUrl":mediumImageUrl,"itemPrice":itemPrice,"booksGenreId":booksGenreId]
        )
        self.sendGameTitlePS5Done?.checkDoneGameTitlePS5()
    }
    
    func sendGameTitlePS4(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("PS4").document(title).setData(
            ["title":title,"hardware":hardware,"salesDate":salesDate,"mediumImageUrl":mediumImageUrl,"itemPrice":itemPrice,"booksGenreId":booksGenreId]
        )
        self.sendGameTitlePS4Done?.checkDoneGameTitlePS4()
    }
    
    func sendGameTitleSwitch(title:String,hardware:String,salesDate:String,mediumImageUrl:String,itemPrice:Int,booksGenreId:String){
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Switch").document(title).setData(
            ["title":title,"hardware":hardware,"salesDate":salesDate,"mediumImageUrl":mediumImageUrl,"itemPrice":itemPrice,"booksGenreId":booksGenreId]
        )
        self.sendGameTitleSwitchDone?.checkDoneGameTitleSwitch()
    }

    
    
    
}
