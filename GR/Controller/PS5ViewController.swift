//
//  PS5ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD

class PS5ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneCatchDataProtocol,GetContentsDataProtocol,GetTitlesDataProtocol,DoneSendGames,GetCommentCountDataProtocol,GetContentsDocumentIDDataProtocol{
 
    

    
 
    
  

    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var index = Int()
    var dataSetsArray = [DataSets]()
    var db = Firestore.firestore()
    var idString = String()
    
    var loadModel = LoadModel()
    var rateAverage = Double()
    var sendDBModel = SendDBModel()
    var contentModelArray = [ContentModel]()

    
    var gameTitle = String()
    var hardware = String()
    var salesDate = String()
    var mediumImageUrl = String()
    var itemPrice = Int()
    var booksGenreId = String()
    var dataSets:DataSets?
    var contentModel:ContentModel?
    var totalCount = Int()
    var titleDocumentModelArray = [TitleDocumentIDModel]()
    var documentID = String()
    var commentCountModelArray = [CommentCountModel]()
    var contentsDocumentModelArray = [ContentsDocumentIDModel]()
    var contentDocumentID = String()
    
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
        
        return dataSetsArray.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell

        cell.contentImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].mediumImageUrl!), completed: nil)
        cell.gameTitleLabel.text = dataSetsArray[indexPath.row].title
        cell.rankLabel.text = String(indexPath.row + 1)

        //dataSetsArray[indexPath.row].titleとFirebaseのタイトルが一致するものを探す
        //commentCountをコメント数に入れる
        print("コメントの総数")
        print(self.contentModelArray.count)
        
        print("dataSetsArrayの数")
        print(dataSetsArray.count)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelect")
        print(dataSetsArray.debugDescription)
        let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        DetailVC.gameTitle = dataSetsArray[indexPath.row].title!
        DetailVC.hardware = dataSetsArray[indexPath.row].hardware!
        DetailVC.salesDate = dataSetsArray[indexPath.row].salesDate!
        DetailVC.mediumImageUrl = dataSetsArray[indexPath.row].mediumImageUrl!
        DetailVC.itemPrice = dataSetsArray[indexPath.row].itemPrice!
        //LoadModel.loadTitleのdocumentIDの値を持ってくる
        DetailVC.documentID = self.titleDocumentModelArray[indexPath.row].documentID!
        self.navigationController?.pushViewController(DetailVC, animated: true)
  
    }
    
    func GetGames(){
        for i in 0..<dataSetsArray.count{
            gameTitle = dataSetsArray[i].title!
            hardware = dataSetsArray[i].hardware!
            sendDBModel.doneSendGames = self
            sendDBModel.sendGames(title: gameTitle, hardware: hardware)
        }
    }

    
    func doneCatchData(array: [DataSets]) {
        
        self.dataSetsArray = []
        self.dataSetsArray = array
        //APIで取得したゲームタイトルと機種をDBに送信
        GetGames()
        //DBからゲームタイトルのIDを受信
        loadModel.getTitlesDataProtocol = self
        loadModel.loadTitlesID()
        tableView.reloadData()
        
    }
    
    func checkDoneGames() {
        print("dataSetsをDBへ送信完了")
    }
    
    //ゲームタイトルのdocumentIDを取得
    func getTitlesData(dataArray: [TitleDocumentIDModel]) {
        self.titleDocumentModelArray = []
        self.titleDocumentModelArray = dataArray
        for i in 0..<titleDocumentModelArray.count{
            documentID = self.titleDocumentModelArray[i].documentID!
            print("documentID１")
            print(documentID.debugDescription)
        }
        //コメントのIDを受信
        loadModel.loadContentsID(documentID: documentID)
    }

    //コメントの配列を受信(loadContents)
    func getContentsData(dataArray: [ContentModel]) {
        self.contentModelArray = []
        self.contentModelArray = dataArray
        loadModel.getCommentCountDataProtocol = self
        loadModel.getContentsDocumentIDDataProtocol = self
        //コメントのdocumentIDを取得
        loadModel.loadCommentCount(documentID: contentDocumentID)
        tableView.reloadData()
    }
    
    //コメント総数を受信
    func getCommentCountData(dataArray: [CommentCountModel]) {
        self.commentCountModelArray = []
        self.commentCountModelArray = dataArray
    }
    
    //コメントのdocumentIDを受信
    func getContensDocumentIDData(dataArray: [ContentsDocumentIDModel]) {
        self.contentsDocumentModelArray = []
        self.contentsDocumentModelArray = dataArray
        for i in 0..<contentsDocumentModelArray.count{
            contentDocumentID = self.contentsDocumentModelArray[i].documentID!
        }
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
