//
//  SearchViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import PKHUD


class SearchViewController: UIViewController,DoneCatchDataProtocol {

    
    @IBOutlet weak var textField: UITextField!
    var dataSetsArray = [DataSets]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func search(_ sender: Any) {
        
        //textfieldを閉じる
        textField.resignFirstResponder()
        //ローディングを行う
        HUD.hide()
        //textfieldに入っているキーワードをもとにゲームの検索を行う
        let urlString = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&title=\(textField.text!)&booksGenreId=006&applicationId=1078790856161658200"
        
        let searchModel = SearchAndLoadModel(urlString: urlString)
        searchModel.doneCatchDataProtocol = self
        searchModel.search()
        //通信を行う
        
        //画面遷移
        let searchVC = self.storyboard?.instantiateViewController(identifier: "searchVC") as! SearchResultsViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    func doneCatchData(array: [DataSets]) {
        print(array.debugDescription)
        dataSetsArray = array

        
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
