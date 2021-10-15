//
//  GameViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import Firebase
import PKHUD


class GameViewController: UIViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var db = Firestore.firestore()
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var dataSetsArray = [DataSets]()
    var commentsModelArray = [CommentsModel]()
    var index = Int()
    var gameTitle = String()
    var hardware = String()
    var salesDate = String()
    var largeImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    
    let semaphore = DispatchSemaphore(value: 1)
    var refleshControl:UIRefreshControl?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        
        let urlStringPs5 = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=PS5&booksGenreId=006515&sort=sales&applicationId=1078790856161658200"
        
        let urlStringPs4 = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=PS4&booksGenreId=006513&sort=sales&applicationId=1078790856161658200"
        
        let urlStringSwitch = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=Nintendo Switch&booksGenreId=006514&sort=sales&applicationId=1078790856161658200"
        
        
        if index == 0{
            
            let searchModel = SearchAndLoadModel(urlString: urlStringPs5)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()
            
        }else if index == 1{
            
            let searchModel = SearchAndLoadModel(urlString: urlStringPs4)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()
            
        }else if index == 2{
            
            let searchModel = SearchAndLoadModel(urlString: urlStringSwitch)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()
            
        }
        
        tableView.delaysContentTouches = false
        refleshControl = UIRefreshControl()
        refleshControl?.addTarget(self, action: #selector(reflesh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refleshControl
        
    }
    
    @objc func reflesh() {
        
        semaphore.wait()
        semaphore.signal()
        refleshControl?.endRefreshing()
        
    }
    
}

extension GameViewController: DoneCatchDataProtocol {
    
    func doneCatchData(array: [DataSets]) {
        
        self.dataSetsArray = []
        self.dataSetsArray = array
        tableView.reloadData()
        
    }
    
}

extension GameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 270
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSetsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell
        cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].largeImageUrl!), completed: nil)
        cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
        cell.itemPriceLabel.text = String(dataSetsArray[indexPath.row].itemPrice!)
        
        return cell
        
    }
    
}

extension GameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        detailVC.gameTitle = dataSetsArray[indexPath.row].title!
        detailVC.hardware = dataSetsArray[indexPath.row].hardware!
        detailVC.salesDate = dataSetsArray[indexPath.row].salesDate!
        detailVC.largeImageUrl = dataSetsArray[indexPath.row].largeImageUrl!
        detailVC.itemPrice = dataSetsArray[indexPath.row].itemPrice!
        detailVC.booksGenreId = dataSetsArray[indexPath.row].booksGenreId!
        detailVC.itemUrl = dataSetsArray[indexPath.row].itemUrl
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}


    

