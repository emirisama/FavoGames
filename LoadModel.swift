//
//  LoadModel.swift
//  GR
//
//  Created by 中森えみり on 2021/04/08.
//

import Foundation
import Firebase

protocol GetDataProtocol{
    
    func getData(dataArray:[ContentModel])
    
}

class LoadModel{
    
    let db = Firestore.firestore()
    
    //受信された値のかたまりが入る配列
    var contentModelArray:[ContentModel] = []
    var getDataProtocol:GetDataProtocol?
    
    //コンテンツを受信するメソッド
    func loadContents(category:String){
        
        db.collection(category).order(by: "date").addSnapshotListener { (snapShot, error) in
            
            self.contentModelArray = []
            if let snapShotDoc = snapShot?.documents{
                //ドキュメントの数だけcontentModelの値を入れる
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let userID = data["userID"] as? String,let name = data["name"] as? String,let review = data["review"] as? String,let sender = data["sender"] as? [String],let rate = data["rate"] as? Double{
                        
                        let contentModel = ContentModel(review: review, name: name, userID: userID, sender: sender, rate: rate)
                        self.contentModelArray.append(contentModel)
                        self.getDataProtocol?.getData(dataArray: self.contentModelArray)
                    }
                }
            }
            
        }
    }
    
}
