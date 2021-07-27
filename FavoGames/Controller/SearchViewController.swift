//
//  SearchViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import PKHUD


class SearchViewController: UIViewController,UISearchBarDelegate,DoneCatchDataProtocol {
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    
    
    var dataSetsArray = [DataSets]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        //ローディング
        HUD.hide()
        
        //textfieldに入っているキーワードをもとにゲームの検索を行う
        let urlString = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&title=\(searchBar.text!)&booksGenreId=006&applicationId=1078790856161658200"
        
        let searchModel = SearchAndLoadModel(urlString: urlString)
        searchModel.doneCatchDataProtocol = self
        searchModel.search()
    }
    
    
    func doneCatchData(array: [DataSets]) {
        
        //dataSetsの値を渡して画面遷移
        let searchVC = self.storyboard?.instantiateViewController(identifier: "searchVC") as! SearchResultsViewController
        searchVC.dataSetsArray = array
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    
}
