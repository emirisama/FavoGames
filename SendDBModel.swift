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

class SendDBModel {
    
    let db = Firestore.firestore()
    var sendProfileDone:SendProfileDone?
    var userDefaultsEX = UserDefaultsEX()
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
            imageRef.putData(usernoimagedata!)

        }
            

        imageRef.putData(imageData, metadata: nil) { (metaData, error ) in

            if error != nil{
                return
            }

            if imageData.isEmpty{
                    usernoimagedata.putData(imageData)
                }
            }
            

            imageRef.downloadURL { (url, error) in

                if url != nil{
                    
        let profileModel = ProfileModel(name: name, id: id, email: email, profileText: profileText, imageURLString: url?.absoluteString, userID: Auth.auth().currentUser!.uid)
                    //アプリ内に自分のProfileを保存しておく
        self.userDefaultsEX.set(value: profileModel, forKey: "profile")
        
                    //送信
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["name":name,"email": email,"id":id,"userID":Auth.auth().currentUser!.uid,"Date":Date().timeIntervalSince1970,"image":url?.absoluteString,"profileText":profileText])
        
        //画面遷移
        self.sendProfileDone?.checkOK()
                }
            }
        }
 
        
    }
}
