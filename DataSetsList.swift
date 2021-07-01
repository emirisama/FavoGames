//
//  DataSetsList.swift
//  GR
//
//  Created by 中森えみり on 2021/06/09.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON
import Alamofire
import FirebaseAuth

class DataSetsList{
    
    var urlString = String()
    var db = Firestore.firestore()
    var dataSetsArray:[DataSets] = []
    
    init(urlString:String){
        
        self.urlString = urlString
    }
    
    init(){
        
    }
let urlString = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&title=\(textField.text!)&booksGenreId=006&applicationId=1078790856161658200"

let searchModel = SearchAndLoadModel(urlString: urlString)
searchModel.doneCatchDataProtocol = self
searchModel.search()

}
