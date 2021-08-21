//
//  SearchResultsViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/05/07.
//

import UIKit


class SearchResultsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataSetsArray = [DataSets]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContentsCell", bundle: nil), forCellReuseIdentifier: "ContentsCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
}

extension SearchResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
        
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

extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DetailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        DetailVC.dataSetsArray = dataSetsArray
        DetailVC.gameTitle = dataSetsArray[indexPath.row].title!
        DetailVC.hardware = dataSetsArray[indexPath.row].hardware!
        DetailVC.salesDate = dataSetsArray[indexPath.row].salesDate!
        DetailVC.largeImageUrl = dataSetsArray[indexPath.row].largeImageUrl!
        DetailVC.itemPrice = dataSetsArray[indexPath.row].itemPrice!
        DetailVC.booksGenreId = dataSetsArray[indexPath.row].title!
        self.navigationController?.pushViewController(DetailVC, animated: true)
        
    }
    
}
