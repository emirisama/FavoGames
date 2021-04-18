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
protocol DoneSendContents2{
    func checkDone2()
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
    var doneSendContents2:DoneSendContents2?
    var doneSendContents:DoneSendContents?
    
    //プロフィールをDBへ送信する
    func sendProfileDB(name:String, email:String, id:String,profileText:String, imageData: Data){
        
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
                    
        let profileModel = ProfileModel(name: name, id: id, email: email, profileText: profileText, imageURLString: url?.absoluteString, userID: Auth.auth().currentUser!.uid)
                    //アプリ内に自分のProfileを保存しておく
        self.userDefaultsEX.set(value: profileModel, forKey: "profile")
        
                    //送信
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["name":name,"email": email,"id":id,"userID":Auth.auth().currentUser!.uid,"Date":Date().timeIntervalSince1970,"image":url?.absoluteString,"profileText":profileText])
                    print("保存する")
        
        //画面遷移
        self.sendProfileDone?.checkOK()
                }
            }
        }
    }
    
    //カテゴリーとUsersのOwndContentsの中に入れるメソッド（関数）
    func sendDB(category:String,name:String,reView:String,userID:String,sender:ProfileModel,rate:Double,imageData:Data){
        
        
        
        var imageRef = Storage.storage().reference().child("contentImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        
        imageRef.putData(imageData, metadata: nil) { (metaData, error ) in
            
            if error != nil{
                return
            }
            
            
            imageRef.downloadURL { (url, error) in
                
                if error != nil{
                    return
                }
                if url != nil{
                    self.myProfile.append(sender.imageURLString!)
                    self.myProfile.append(sender.profileText!)
                    self.myProfile.append(sender.userID!)
                    self.myProfile.append(sender.name!)
                    
                    //送信（ownContentsの中に入れる）
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownContents").document().setData(["name":name,"userID":Auth.auth().currentUser!.uid,"review":reView,"sender":self.myProfile,"rate":rate,"date":Date().timeIntervalSince1970,"image":url?.absoluteString])
                    
                    self.db.collection(category).document().setData(["name":name,"userID":Auth.auth().currentUser!.uid,"review":reView,"sender":self.myProfile,"rate":rate,"date":Date().timeIntervalSince1970,"image":url?.absoluteString])
                    
                    self.doneSendContents2?.checkDone2()
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
                
                ["follower":Auth.auth().currentUser!.uid,"followOrNot":followOrNot,"userID":profile?.userID,"name":profile?.name,"image":profile?.imageURLString,"profileText":profile?.profileText]
            )
            
        }
        
        //
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("follow").document(id).setData(
        
            ["follower":id,"followOrNot":followOrNot,"userID":contentModel.userID,"name":contentModel.sender![3],"image":contentModel.sender![0],"profileText":contentModel.sender![1]]
        )
        
        self.doneSendContents?.checkDone(flag: followOrNot)
        
        
        
    }
    
    
}

