//
//  SendDBModel.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/03/28.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PKHUD

protocol SendProfileDone {
    
    func checkProfileDone()
    
}

protocol SendCommentsDone {
    
    func checkCommentsDone()
    
}

class SendDBModel {
    
    let db = Firestore.firestore()
    var imageDatauser = Data()
    var sendProfileDone:SendProfileDone?
    var sendCommentsDone:SendCommentsDone?
    
    init() {
        
    }
    
    //プロフィールをDBへ送信する
    func sendProfile(userName: String,imageData: Data) {
        
        //プロフィール画像
        let usernoimage = UIImage(named: "userimage")
        let usernoimagedata = usernoimage!.pngData()
        
        let imageRef = Storage.storage().reference().child("ProfielImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //ローディング
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        
        //（プロフィール画像が空の場合、デフォルト画像を入れる）
        if imageData.isEmpty == true {
            
            imageDatauser = usernoimagedata!
            
        } else {
            
            imageDatauser = imageData
            
        }
        
        imageRef.putData(imageDatauser, metadata: nil) { (metaData, error ) in
            
            if error != nil {
                return
            }
            
            imageRef.downloadURL { (url, error) in
                
                if url != nil {
         
                    //送信
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["userName": userName,"Date": Date().timeIntervalSince1970,"image": url?.absoluteString])
                    
                    self.sendProfileDone?.checkProfileDone()
                    
                }
            }
        }
    }
    
    //ゲームソフトに紐づくメモ（コメントをDBへ送信）
    func sendComments(title: String,comment: String) {
        
        self.db.collection(title).document(Auth.auth().currentUser!.uid).collection("Comments").document(Auth.auth().currentUser!.uid).setData(
            ["comment": comment,"date": Date().timeIntervalSince1970,"title": title])

        self.sendCommentsDone?.checkCommentsDone()
        
    }
    
    //Memo(コメント削除)
    func deleteToComments(title: String) {
        
        self.db.collection(title).document(Auth.auth().currentUser!.uid).collection("Comments").document(Auth.auth().currentUser!.uid).delete()
        
    }
    
    //ゲームソフトをいいねする（likeを送信)
    func sendLike(userID: String,largeImageUrl:  String,title: String,hardware: String,salesDate: String,itemPrice: Int,booksGenreId: String,likeFlag: Bool){
        
        if likeFlag == false {
            
            self.db.collection("Users").document(userID).collection("like").document(title).setData(
                ["userID": userID,"title": title,"hardware": hardware,"largeImageUrl": largeImageUrl,"salesDate": salesDate,"itemPrice": itemPrice,"booksGenreId": booksGenreId,"date": Date().timeIntervalSince1970,"like": false])
            
            //消す
            deleteToLike(title: title)
            
        } else if likeFlag == true {
            
            self.db.collection("Users").document(userID).collection("like").document(title).setData(
                ["userID": userID,"title": title,"hardware": hardware,"largeImageUrl": largeImageUrl,"salesDate": salesDate,"itemPrice": itemPrice,"booksGenreId": booksGenreId,"date": Date().timeIntervalSince1970,"like": true])
            
        }
    }
    
    //いいねを消す(like削除を送信)
    func deleteToLike(title: String) {
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(title).delete()
        
    }
    
}
    
   

