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
    
    //規則
    func doneCatchData(array:[DataSets])
    
}

class SearchAndLoadModel {
    
    var urlString = String()
    var count = Int()
    var dataSetsArray:[DataSets] = []
    var doneCatchDataProtocol:DoneCatchDataProtocol?
    
    init(urlString:String){
        
        self.urlString = urlString
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
                        if let title = json["items"][i]["item"]["title"].string,let hardware = json["items"][i]["item"]["hardware"].string,let mediumImageUrl = json["items"][i]["item"]["mediumImageUrl"].string,let salesDate = json["items"][i]["item"]["salesDate"].string,let itemPrice = json["items"][i]["item"]["itemPrice"].int{
                            
                            //もし、ゲームソフト以外の商品は、検索させないようにする（if)
                            let dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice)
                            
                            self.dataSetsArray.append(dataSets)
                        
                            
                        }else{
                            print("空です。何か不足しています")
                        }
                    }
                    
                }catch{
                    
                }
            
            case.failure(_): break
                
            }
        }
        
        //コントローラー値に値を渡す必要がある
        self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
    }
}
