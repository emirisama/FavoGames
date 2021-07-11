//
//  PS5ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PS5ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneCatchDataProtocol,SendGameTitlePS5Done,SendGameTitlePS4Done,SendGameTitleSwitchDone,GetGameDataPS5Protocol,GetGameDataPS4Protocol,GetGameDataSwitchProtocol,GetContentsDataPS5Protocol,GetContentsDataPS4Protocol,GetContentsDataSwitchProtocol{

    
  
    


    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var index = Int()
    var dataSetsArray = [DataSets]()
    var db = Firestore.firestore()
    var idString = String()
    
    var loadModel = LoadModel()
    var rateArray = [RateModel]()
    var rateAverage = Double()
    var sendDBModel = SendDBModel()
    var contentModelPS5Array = [ContentModel]()
    var contentModelPS4Array = [ContentModel]()
    var contentModelSwitchArray = [ContentModel]()
    var gameTitleModelPS5Array = [GameTitleModel]()
    var gameTitleModelPS4Array = [GameTitleModel]()
    var gameTitleModelSwitchArray = [GameTitleModel]()
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

        sendDBModel.sendGameTitlePS5Done = self
        sendDBModel.sendGameTitlePS4Done = self
        sendDBModel.sendGameTitleSwitchDone = self
   
        if index == 0{
            let searchModel = SearchAndLoadModel(urlString: urlStringPs5)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()
            loadModel.getGameDataPS5Protocol = self
            loadModel.loadGameContentsPS5(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            loadModel.getContentsDataPS5Protocol = self
            loadModel.loadContentsPS5(title: gameTitle,rateAverage: rateAverage)
            print("せんどげーむこんてんつ")

        }else if index == 1{
            let searchModel = SearchAndLoadModel(urlString: urlStringPs4)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()
            loadModel.getGameDataPS4Protocol = self
            loadModel.loadGameContentsPS4(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            loadModel.getContentsDataPS4Protocol = self
            loadModel.loadContentsPS4(title: gameTitle,rateAverage: rateAverage)

        }else if index == 2{
            let searchModel = SearchAndLoadModel(urlString: urlStringSwitch)
            searchModel.doneCatchDataProtocol = self
            searchModel.search()
            loadModel.getGameDataSwitchProtocol = self
            loadModel.loadGameContentsSwitch(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            loadModel.getContentsDataSwitchProtocol = self
            loadModel.loadContentsSwitch(title: gameTitle,rateAverage: rateAverage)
        }

    }
    
    
    func sendGameContents(){
        
        for i in 0..<self.dataSetsArray.count {
            print("countの中身")
            print(i)
            gameTitle = dataSetsArray[i].title!
            hardware = dataSetsArray[i].hardware!
            salesDate = dataSetsArray[i].salesDate!
            mediumImageUrl = dataSetsArray[i].mediumImageUrl!
            itemPrice = dataSetsArray[i].itemPrice!
            booksGenreId = dataSetsArray[i].booksGenreId!
            print("ゲームタイトルのなかみは")
            print(dataSetsArray[i].title!.debugDescription)
            if index == 0{
            sendDBModel.sendGameTitlePS5(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
                
            }else if index == 1{
                sendDBModel.sendGameTitlePS4(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            }else if index == 2{
                sendDBModel.sendGameTitleSwitch(title: gameTitle, hardware: hardware, salesDate: salesDate, mediumImageUrl: mediumImageUrl, itemPrice: itemPrice, booksGenreId: booksGenreId)
            }
        }
        
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
        
        if index == 0{
            return gameTitleModelPS5Array.count
        }else if index == 1{
            return gameTitleModelPS4Array.count
        }else if index == 2{
            return gameTitleModelSwitchArray.count
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell
        
        if index == 0{
            cell.contentImageView.sd_setImage(with: URL(string: gameTitleModelPS5Array[indexPath.row].mediumImageUrl!), completed: nil)
            cell.gameTitleLabel.text = gameTitleModelPS5Array[indexPath.row].title
            cell.rankLabel.text = String(indexPath.row + 1)
            cell.reviewCountLabel.text = String(self.contentModelPS5Array[indexPath.row].rateAverage!)
            //            print("PS5レビュー平均値")
            //            print(self.contentModelPS5Array[indexPath.row].rateAverage!.debugDescription)
            //
        }else if index == 1{
            cell.contentImageView.sd_setImage(with: URL(string: gameTitleModelPS4Array[indexPath.row].mediumImageUrl!), completed: nil)
            cell.gameTitleLabel.text = gameTitleModelPS4Array[indexPath.row].title
            cell.rankLabel.text = String(indexPath.row + 1)
            cell.reviewCountLabel.text = String(self.contentModelPS4Array[indexPath.row].rateAverage!)
            
        }else if index == 2{
            cell.contentImageView.sd_setImage(with: URL(string: gameTitleModelSwitchArray[indexPath.row].mediumImageUrl!), completed: nil)
            cell.gameTitleLabel.text = gameTitleModelSwitchArray[indexPath.row].title
            cell.rankLabel.text = String(indexPath.row + 1)
            cell.reviewCountLabel.text = String(self.contentModelSwitchArray[indexPath.row].rateAverage!)
            
            
        }
        
        //レビュー平均値をDBに送信したものを受信して表示
        print("レビューの平均の数")
        print(self.contentModelPS5Array.count)
        print(self.contentModelPS5Array.debugDescription)
        print(self.contentModelPS4Array.count)
        print(self.contentModelPS4Array.debugDescription)
        print(self.contentModelSwitchArray.count)
        print(self.contentModelSwitchArray.debugDescription)
        print("gameTitleModelArrayの数")
        print(gameTitleModelPS5Array.count)
        print(gameTitleModelPS4Array.count)
        print(gameTitleModelSwitchArray.count)
 
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if index == 0{
            let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
            DetailVC.gameTitle = gameTitleModelPS5Array[indexPath.row].title!
            DetailVC.hardware = gameTitleModelPS5Array[indexPath.row].hardware!
            DetailVC.salesDate = gameTitleModelPS5Array[indexPath.row].salesDate!
            DetailVC.mediumImageUrl = gameTitleModelPS5Array[indexPath.row].mediumImageUrl!
            DetailVC.itemPrice = gameTitleModelPS5Array[indexPath.row].itemPrice!
            self.navigationController?.pushViewController(DetailVC, animated: true)
        }else if index == 1{
            let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
            DetailVC.gameTitle = gameTitleModelPS4Array[indexPath.row].title!
            DetailVC.hardware = gameTitleModelPS4Array[indexPath.row].hardware!
            DetailVC.salesDate = gameTitleModelPS4Array[indexPath.row].salesDate!
            DetailVC.mediumImageUrl = gameTitleModelPS4Array[indexPath.row].mediumImageUrl!
            DetailVC.itemPrice = gameTitleModelPS4Array[indexPath.row].itemPrice!
            self.navigationController?.pushViewController(DetailVC, animated: true)
        }else if index == 2{
            let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
            DetailVC.gameTitle = gameTitleModelSwitchArray[indexPath.row].title!
            DetailVC.hardware = gameTitleModelSwitchArray[indexPath.row].hardware!
            DetailVC.salesDate = gameTitleModelSwitchArray[indexPath.row].salesDate!
            DetailVC.mediumImageUrl = gameTitleModelSwitchArray[indexPath.row].mediumImageUrl!
            DetailVC.itemPrice = gameTitleModelSwitchArray[indexPath.row].itemPrice!
            self.navigationController?.pushViewController(DetailVC, animated: true)
        }

        
    }
    
    
    func doneCatchData(array: [DataSets]) {
        
        self.dataSetsArray = []
        self.dataSetsArray = array
        sendGameContents()
        tableView.reloadData()

    }

    
    func checkDoneGameTitlePS5() {
        print("GameTitlePS5送信完了")
    }
    
    func checkDoneGameTitlePS4() {
        print("GameTitlePS4送信完了")
    }
    
    func checkDoneGameTitleSwitch() {
        print("GameTitleSwitch送信完了")
    }
    
    func getGameDataPS5(dataArray: [GameTitleModel]) {
        self.gameTitleModelPS5Array = []
        self.gameTitleModelPS5Array = dataArray

        tableView.reloadData()
    }
    
    func getGameDataPS4(dataArray: [GameTitleModel]) {
        self.gameTitleModelPS4Array = []
        self.gameTitleModelPS4Array = dataArray
        tableView.reloadData()
    }
    
    func getGameDataSwitch(dataArray: [GameTitleModel]) {
        self.gameTitleModelSwitchArray = []
        self.gameTitleModelSwitchArray = dataArray
        tableView.reloadData()
    }
    
    func getContentsDataPS5(dataArray: [ContentModel]) {
        self.contentModelPS5Array = []
        self.contentModelPS5Array = dataArray

        tableView.reloadData()
    }

    
    func getContentsDataPS4(dataArray: [ContentModel]) {
        self.contentModelPS4Array = []
        self.contentModelPS4Array = dataArray

        tableView.reloadData()
    }
    
    func getContentsDataSwitch(dataArray: [ContentModel]) {
        self.contentModelSwitchArray = []
        self.contentModelSwitchArray = dataArray
        tableView.reloadData()
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
