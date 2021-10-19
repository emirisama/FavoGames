//
//  SearchAndLoadModel.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/05/07.
//

import Foundation
import SwiftyJSON
import Alamofire



protocol DoneCatchDataProtocol {
    
    func doneCatchData(array: [DataSets])
    
}

protocol DoneLoadDataProtocol {
    
    func doneLoadData(array: [DataSets])
    
}



class SearchAndLoadModel {
    
    var urlString = String()
    var count = Int()
    
    var dataSetsArray: [DataSets] = []
    
    var doneCatchDataProtocol: DoneCatchDataProtocol?
    var doneLoadDataProtocol: DoneLoadDataProtocol?
    
    init(urlString: String) {
        
        self.urlString = urlString
        
    }
    
    init() {
        
    }
    
    //JSON解析
    func search() {
        
        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(encodeUrlString as! URLConvertible, method: .get, parameters: nil, encoding:  JSONEncoding.default).responseJSON { [self] (response) in
            
            switch response.result {
            
            case .success:
                do {
                    let json:JSON = try JSON(data: response.data!)
                    
                    let totalHitCount = json["count"].int
                    
                    if totalHitCount != nil {
                        
                        self.count = totalHitCount!
                        
                        for i in 0...self.count {
                            if let title = json["Items"][i]["Item"]["title"].string,let hardware = json["Items"][i]["Item"]["hardware"].string,let largeImageUrl = json["Items"][i]["Item"]["largeImageUrl"].string,let salesDate = json["Items"][i]["Item"]["salesDate"].string,let itemPrice = json["Items"][i]["Item"]["itemPrice"].int,let booksGenreId = json["Items"][i]["Item"]["booksGenreId"].string,let itemUrl = json["Items"][i]["Item"]["itemUrl"].string{
                                
                                let dataSets = DataSets(title: title, hardware: hardware, salesDate: salesDate, largeImageUrl: largeImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId,itemUrl: itemUrl)
                                
                                //タイトル名に該当のものと一致していたら排除
                                if dataSets.title!.contains("/") == false {
                                    
                                    self.dataSetsArray.append(dataSets)
                                    
                                }
                                
                            } else {

                            }
                            
                        }
                        
                        //抽出（PS5,PS4,Switchのゲームソフトのみ表示）
                        self.dataSetsArray = dataSetsArray.filter { ($0.booksGenreId!.contains("006513") || $0.booksGenreId!.contains("006514") || $0.booksGenreId!.contains("006515")) && !$0.booksGenreId!.contains("006513001") && !$0.booksGenreId!.contains("006513002") && !$0.booksGenreId!.contains("006514001") && !$0.booksGenreId!.contains("006514002") && !$0.booksGenreId!.contains("006515001") && !$0.booksGenreId!.contains("006515002") }
                        //同じ名前のゲームソフトは排除
                        let orderedSet = NSOrderedSet(array: self.dataSetsArray)
                        self.dataSetsArray = orderedSet.array as! [DataSets]
                        
                        self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
                        
                    } else {
                        
                    }
                    
                } catch {
                    
                }
                
            case.failure(_): break
                
            }
        }
    }
    
    
}
