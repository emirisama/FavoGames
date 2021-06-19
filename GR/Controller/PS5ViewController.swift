//
//  PS5ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PS5ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneCatchDataProtocol,GetrateAverageCountProtocol, GetDataProtocol {



    
 

    

    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    var index = Int()
    
    var dataSetsArray = [DataSets]()
    var db = Firestore.firestore()
    var idString = String()
    var contentModelArray = [ContentModel]()

    var loadModel = LoadModel()
    var gameTitle = String()
    var rateArray = [RateModel]()
    var rateAverage = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch index{
        
        case index:
            //皆のレビューを見れるようにさせる(ロードさせる）
            loadModel.getDataProtocol = self
            loadModel.loadContents(title: gameTitle)

            //レビュー平均値を表示させる
            loadModel.getrateAverageCountProtocol = self
            loadModel.loadrateAverageCount(title: gameTitle, rateAverage: rateAverage)

                tableView.delegate = self
                tableView.dataSource = self
                
                tableView.register(UINib(nibName: "ContentDetailCell", bundle: nil), forCellReuseIdentifier: "ContentDetailCell")
                tableView.register(UINib(nibName: "ReviewViewCell", bundle: nil), forCellReuseIdentifier: "ReviewViewCell")
            
                
                break
                
                default:
                break
        }
        
        
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

        print("あ")
        print(dataSetsArray.debugDescription)

        
        
        // Do any additional setup after loading the view.
    }
    
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
        cell.reviewCountLabel.text = String(self.rateAverage)
        print("rateArrayの中身")
        print(rateArray.debugDescription)
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
        print("arrayの中身")
        print(array.debugDescription)


        self.dataSetsArray = array
        tableView.reloadData()
    }

    func getrateAverageCount(rateArray: Double) {
        self.rateAverage = rateArray
        
        tableView.reloadData()
    }

    
    func getData(dataArray: [ContentModel]) {
        contentModelArray = []
        contentModelArray = dataArray
        tableView.reloadData()
        print("レビュー表示")
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
