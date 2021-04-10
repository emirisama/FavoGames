//
//  CameraViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/31.
//

import UIKit
import SDWebImage
import Cosmos
import FirebaseAuth

class ContentsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GetDataProtocol {

    



    var index = Int()
    var contentModelArray = [ContentModel]()
    let loadModel = LoadModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch index{
        
        case index:
            
            //ロードするものを変更
            loadModel.getDataProtocol = self
            loadModel.loadContents(category: "\(Constants.menuArray[index])")
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            break
        default:
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //セルの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //セルの数に該当するところ
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch index{
        case index:
            return contentModelArray.count
        default:
            return contentModelArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        
        return cell
        
    }
    
    func getData(dataArray: [ContentModel]) {
        contentModelArray = []
        print(dataArray)
        contentModelArray = dataArray
        collectionView.reloadData()
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
