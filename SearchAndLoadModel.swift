//
//  SearchAndLoadModel.swift
//  GR
//
//  Created by 中森えみり on 2021/05/07.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON
import Alamofire
import FirebaseAuth

protocol DoneCatchDataProtocol{
    

    func doneCatchData(array:[DataSets])
    
}

protocol DoneLoadDataProtocol{
    
    func doneLoadData(array:[DataSets])
    
}

protocol DoneLoadUserNameProtocol{
    
    func doneLoadUserName(array:[String])
}

class SearchAndLoadModel {
    
    var urlString = String()
    var count = Int()
    var dataSetsArray:[DataSets] = []
    var doneCatchDataProtocol:DoneCatchDataProtocol?
    var doneLoadDataProtocol:DoneLoadDataProtocol?
    var db = Firestore.firestore()
    var userNameArray = [String]()
    var doneLoadUserNameProtocol:DoneLoadUserNameProtocol?
    
    init(urlString:String){
        
        self.urlString = urlString
    }
    
    init(){
        
    }
    
    //JSON解析
    func search(){
        
        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(encodeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            
            print(response)
            
            switch response.result{
            
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    
                    let totalHitCount = json["count"].int
                    if totalHitCount! < 50{
                        self.count = totalHitCount!
                    }else{
                        self.count = totalHitCount!
                    }
                    print(self.count)
                    for i in 0...self.count - 1{
                        if let title = json["Items"][0]["Item"]["title"].string,let hardware = json["Items"][i]["Item"]["hardware"].string,let mediumImageUrl = json["Items"][i]["Item"]["mediumImageUrl"].string,let salesDate = json["Items"][i]["Item"]["salesDate"].string,let itemPrice = json["Items"][i]["Item"]["itemPrice"].int{
                            
                            //もし、ゲームソフト以外の商品は、検索させないようにする（if)
                            let dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice)
                            
                            self.dataSetsArray.append(dataSets)
                            
                            
                        }else{
                            print("空です。何か不足しています")
                        }
                    }
                    
                    //コントローラー値に値を渡す必要がある
                    self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
                    
                }catch{
                    
                }
                
            case.failure(_): break
                
            }
        }
    }
    
    func loadMyListData(userName:String){
        
        db.collection("contents").document(userName).collection("collection").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.dataSetsArray = []
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    print(data.debugDescription)
                    if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let salesDate = data["salesDate"] as? String,let itemPrice = data["itemPrice"] as? Int{
                        
                        let dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice)
                        self.dataSetsArray.append(dataSets)
                        
                    }

                }
                
                self.doneLoadDataProtocol?.doneLoadData(array: self.dataSetsArray)
                
            }
        }
        
    }
    
    
    //ユーザー名を取得する
    func loadOtherListData(){
        
        db.collection("Users").addSnapshotListener { (snapShot, error) in
            
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let userName = data["userName"] as? String{
                        self.userNameArray.append(userName)
                    }
                }
                
                //コントローラー側にプロトコルを用いて値を渡す
                self.doneLoadUserNameProtocol?.doneLoadUserName(array: self.userNameArray)
            }
        }
        
    }
    
    
    
    
}
