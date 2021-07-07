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
    var title = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    

    
    var sendDBModel = SendDBModel()
    
    init(urlString:String){
        
        self.urlString = urlString

    }
    
    init(){
        
    }
    
    //JSON解析
    func search(){
        
        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { [self] (response) in
            print("サーチ")
            
            switch response.result{
            
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    //                    print(json.debugDescription)
                    
                    let totalHitCount = json["count"].int

                    
                        self.count = totalHitCount!
                   // }else{
                   //     self.count = totalHitCount!
                        
                        for i in 0...self.count{
                            if let title = json["Items"][i]["Item"]["title"].string,let hardware = json["Items"][i]["Item"]["hardware"].string,let mediumImageUrl = json["Items"][i]["Item"]["mediumImageUrl"].string,let salesDate = json["Items"][i]["Item"]["salesDate"].string,let itemPrice = json["Items"][i]["Item"]["itemPrice"].int,let booksGenreId = json["Items"][i]["Item"]["booksGenreId"].string{
                                
                                let dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
                                //タイトル名に該当のものと一致していたら排除
                                if dataSets.title!.contains("コントローラー") == false && dataSets.title!.contains("//") == false && dataSets.title!.contains("FINAL FANTASY X/X-2 HD Remaster PS4版") == false{
                                self.dataSetsArray.append(dataSets)
                                }

                            }else{
                                print("空です。何か不足しています")
                            }
                            
                        }
                    
                    //抽出（ゲームタイトルのみ表示）
                    self.dataSetsArray = dataSetsArray.filter{ ($0.booksGenreId!.contains("006513") || $0.booksGenreId!.contains("006514") || $0.booksGenreId!.contains("006515")) && !$0.booksGenreId!.contains("006513001") && !$0.booksGenreId!.contains("006513002") && !$0.booksGenreId!.contains("006514001") && !$0.booksGenreId!.contains("006514002") && !$0.booksGenreId!.contains("006515001") && !$0.booksGenreId!.contains("006515002") }
                    let orderedSet = NSOrderedSet(array: self.dataSetsArray)
                    self.dataSetsArray = orderedSet.array as! [DataSets]
                    print("self.dataSetsArrayの数")
                    print(self.dataSetsArray.count)
                    
                    for i in 0..<self.dataSetsArray.count {
                        print("countの中身")
                        print(i)
                        title = dataSetsArray[i].title!
                        hardware = dataSetsArray[i].hardware!
                        salesDate = dataSetsArray[i].salesDate!
                        mediumImageUrl = dataSetsArray[i].mediumImageUrl!
                        itemPrice = dataSetsArray[i].itemPrice!
                        booksGenreId = dataSetsArray[i].booksGenreId!
                        print("ゲームタイトルのなかみは")
                        print(dataSetsArray[i].title!.debugDescription)
                        sendDBModel.sendGameTitle(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
                    }

            
                    //コントローラー値に値を渡す必要がある
                    self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
                    
                }catch{
                    
                }
                
            case.failure(_): break
                
            }
        }
    }
    

    
    
//    func search2(){
//
//        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//        AF.request(encodeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { [self] (response) in
//
//
//            print(response)
//
//            switch response.result{
//
//            case .success:
//                do{
//                    let json:JSON = try JSON(data: response.data!)
////                    print(json.debugDescription)
//
//                    let totalHitCount = json["count"].int
//                    if totalHitCount! < 50{
//                        self.count = totalHitCount!
//                    }else{
//                        self.count = totalHitCount!
//                    }
//                    print(self.count)
//                    if self.count == 0{
//                        return
//                    }else{
//                        self.count = totalHitCount!
//
//                        for i in 0...self.count{
//                            if let title = json["Items"][i]["Item"]["title"].string,let hardware = json["Items"][i]["Item"]["hardware"].string,let mediumImageUrl = json["Items"][i]["Item"]["mediumImageUrl"].string,let salesDate = json["Items"][i]["Item"]["salesDate"].string,let itemPrice = json["Items"][i]["Item"]["itemPrice"].int{
//
//                                //タイトル名の重複をさける（if)
//
//                                var dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
//
//
//                                    self.dataSetsArray.append(dataSets)
//
//
//
//                                print("dataSetsArrayの中身")
//                                print(dataSetsArray.debugDescription)
//                            }else{
//                                print("空です。何か不足しています")
//                            }
//
//                        }
//                    }
//                    //コントローラー値に値を渡す必要がある
//                    self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
//
//                }catch{
//
//                }
//
//            case.failure(_): break
//
//            }
//        }
//    }
    
    
    
    
    //413.誰がいいねを押しているか確認する方法の動画func loadDataの部分
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
                    if let title = data["title"] as? String,let hardware = data["hardware"] as? String,let mediumImageUrl = data["mediumImageUrl"] as? String,let salesDate = data["salesDate"] as? String,let itemPrice = data["itemPrice"] as? Int,let likeCount = data["like"] as? Int,let likeFlagDic = data["likeFlagDic"] as? Dictionary<String,Bool>, let booksGenreId = data["booksGenreId"] as? String{
                        
                        if likeFlagDic["\(doc.documentID)"] != nil{
                            
                       
                            let dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
                        
                        self.dataSetsArray.append(dataSets)
                        }
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
