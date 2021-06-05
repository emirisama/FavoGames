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


protocol DoneSendContents{
    
    func checkDone(flag:Bool)
    
}



class SendDBModel {
    
    let db = Firestore.firestore()
    var sendProfileDone:SendProfileDone?
    var userDefaultsEX = UserDefaultsEX()
    var imageDatauser = Data()
    var myProfile = [String]()
    var doneSendReviewContents:DoneSendReviewContents?
    var doneSendContents:DoneSendContents?
    
    var userID = String()
    var userName = String()
    var title = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    
    
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
        let usernoimagedata = usernoimage?.jpegData(compressionQuality: 1)
        var imageRef = Storage.storage().reference().child("ProfielImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
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
                    print("保存する")
        
        //画面遷移
        self.sendProfileDone?.checkOK()
                }
            }
        }
    }
    



    
    
    
    //フォローに関するアクション
    func followAction(id:String,followOrNot:Bool,contentModel:ContentModel){
        
        
        let profile:ProfileModel? = userDefaultsEX.codable(forKey: "profile")
        
        //もしidが自分であれば
        if id != Auth.auth().currentUser!.uid{
            
            //フォロワーの数(自分のデータを入れる）
            self.db.collection("Users!").document(id).collection("follower").document(Auth.auth().currentUser!.uid).setData(
                ["follower":Auth.auth().currentUser!.uid,"followOrNot":followOrNot,"userID":profile?.userID,"userName":profile?.userName,"image":profile?.imageURLString,"profileText":profile?.profileText]
            )
            
        }
        
        //
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("follow").document(id).setData(
            ["follower":id,"followOrNot":followOrNot,"userID":contentModel.sender![2],"userName":contentModel.sender![3],"image":contentModel.sender![0],"profileText":contentModel.sender![1]]
        )
        
        self.doneSendContents?.checkDone(flag: followOrNot)
        
        
    }
    
    //ゲームタイトルに紐づくデータを送信
    func sendGameTitle(title:String,sender:ProfileModel,review:String,rate:Double){
        
        print("レビュー保存する1")

        self.myProfile.append(sender.imageURLString!)
        self.myProfile.append(sender.profileText!)
        self.myProfile.append(sender.userID!)
        self.myProfile.append(sender.userName!)
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("reviewContents").document().setData(
            ["review":review,"rate":rate,"sender":self.myProfile,"date":Date().timeIntervalSince1970])
        
        self.db.collection(title).document(Auth.auth().currentUser!.uid).setData(
            ["review":review,"rate":rate,"sender":self.myProfile,"date":Date().timeIntervalSince1970])
        
        print("レビュー保存する2")
        self.doneSendReviewContents?.checkDoneReview()
        print("レビュー保存する3")
        
    }
    
    
    
    
}
