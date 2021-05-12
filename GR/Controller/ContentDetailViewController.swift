//
//  ContentDetailViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/17.
//

import UIKit

class ContentDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetDataProtocol {
 

    

    var loadModel = LoadModel()
    var contentModel:ContentModel?
    var contentModelArray = [ContentModel]()
    //▲
    var profileModelArray = [ProfileModel]()
    var userID = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadModel.getDataProtocol = self
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "Cell")
        loadModel.loadOwnContents(id: userID)
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContentsCell
        
        //ContentsCell.xibのゲームソフトの画像をCellに表示
        cell.contentImageView.sd_setImage(with: URL(string: contentModelArray[indexPath.row].imageURLString!), completed: nil)
        
//        cell.reviewView.rating = contentModelArray[indexPath.row].rate!
//
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 327
    }
    
    func getData(dataArray: [ContentModel]) {
        contentModelArray = []
        contentModelArray = dataArray
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
