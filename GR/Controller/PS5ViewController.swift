//
//  PS5ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PS5ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneCatchDataProtocol,GetDataProtocol,SendGameTitleDone,GetGameDataProtocol{
 
    
 
    
 
    
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var index = Int()
    var dataSetsArray = [DataSets]()
    var db = Firestore.firestore()
    var idString = String()
    var contentModelArray = [ContentModel]()
    var loadModel = LoadModel()
    var rateArray = [RateModel]()
    var rateAverage = Double()
    var sendDBModel = SendDBModel()
    var gameTitleModelArray = [GameTitleModel]()
    var gameTitle = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        
        let urlStringPs5 = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=PS5&booksGenreId=006515&applicationId=1078790856161658200"
        let urlStringPs4 = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=PS4&booksGenreId=006513&applicationId=1078790856161658200"
        let urlStringSwitch = "https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404?format=json&hardware=Nintendo Switch&booksGenreId=006514&applicationId=1078790856161658200"
        
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
        
        loadModel.getDataProtocol = self
        sendDBModel.sendGameTitleDone = self
        loadModel.getGameDataProtocol = self
        loadModel.loadGameContents(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
        loadModel.loadContents(title: gameTitle,rateAverage: rateAverage)

    }
    
    
    
    
    // Do any additional setup after loading the view.
    
    //高さを揃える
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 350
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentModelArray.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell
        
        cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
        cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
        
        cell.rankLabel.text = String(indexPath.row + 1)
        
        //レビュー平均値をDBに送信したものを受信して表示
        print("レビューの平均の数")
        print(self.contentModelArray.count)
        print(self.contentModelArray.debugDescription)
        print("gameTitleModelArrayの数")
        print(gameTitleModelArray.count)
        cell.reviewCountLabel.text = String(self.contentModelArray[indexPath.row].rateAverage!)
  
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        DetailVC.gameTitle = dataSetsArray[indexPath.row].title!
        DetailVC.hardware = dataSetsArray[indexPath.row].hardware!
        DetailVC.salesDate = dataSetsArray[indexPath.row].salesDate!
        DetailVC.mediumImageUrl = dataSetsArray[indexPath.row].mediumImageUrl!
        DetailVC.itemPrice = dataSetsArray[indexPath.row].itemPrice!
        self.navigationController?.pushViewController(DetailVC, animated: true)
        
    }
    
    
    func doneCatchData(array: [DataSets]) {
        
        self.dataSetsArray = []
        self.dataSetsArray = array

        tableView.reloadData()

    }
    
    func getData(dataArray: [ContentModel]) {
        
        self.contentModelArray = []
        self.contentModelArray = dataArray
  
        print("contentModelArrayの中身")
        print(self.contentModelArray.debugDescription)
        tableView.reloadData()
    }
 
    func checkDoneGameTitle() {
        print("GameTitle送信完了")

    }
    

    
    func getGameData(dataArray: [GameTitleModel]) {
        self.gameTitleModelArray = []
        self.gameTitleModelArray = dataArray
        print("gameTitleModelArrayの中身(PS5）")
        print(gameTitleModelArray.debugDescription)
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
