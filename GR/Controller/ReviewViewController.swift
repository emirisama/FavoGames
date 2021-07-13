//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController,DoneSendReviewContents,GetTotalCountProtocol,GetContentsDataProtocol{

    

    

 
    @IBOutlet weak var commentTextField: UITextView!
    
    var index = Int()

   
    var contentModel:ContentModel?
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var array = [DataSets]()
    var gameTitle = String()
    var hardware = String()
    var totalCount = Int()
    var totalCountModelArray = [TotalCountModel]()
    var contentModelArray = [ContentModel]()
    var totalCountModel:TotalCountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendDBModel.doneSendReviewContents = self
        loadModel.getTotalCountProtocol = self
        loadModel.getContentsDataProtocol = self
        loadModel.loadTotalCount(title: gameTitle, totalCount: totalCount)
        loadModel.loadContents(title: gameTitle, totalCount: totalCount)
    }
    

    
    
    
    @IBAction func send(_ sender: Any) {
        //ぐるぐるの表示
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        //自分のプロフィールをアプリ内からとってくる
        let profile:ProfileModel? = userDefaultsEX.codable(forKey: "profile")

        //コンテンツとともに送信（動画：受信クラスを作成しよう）
        if commentTextField.text?.isEmpty != true {

            sendDBModel.sendContents(title: gameTitle, sender: profile!, comment: commentTextField.text, totalCount: totalCount)

            
            print("ゲームタイトルに紐づくレビューをSendDBModelへ")
  
            print("レビュー平均値をDBへ")
            print(self.totalCountModelArray.debugDescription)
            
            }else{

                print("エラーです")
                HUD.hide()
            
        }
    

    }

    
    func getTotalCount(totalCount: [TotalCountModel]) {
        self.totalCountModelArray = totalCount
        print("とーたるかうんと")
        print(totalCountModel?.totalCount.debugDescription)
        
    }
    
    func checkDoneReview() {
        HUD.hide()
        loadModel.loadContents(title: gameTitle, totalCount: totalCount)
        self.navigationController?.popViewController(animated: true)
        print("レビュー受信PS5")
    }
    
    func getContentsData(dataArray: [ContentModel]) {
        
        self.contentModelArray = dataArray
        print("totalCountの中身")
        print(self.contentModelArray)
    }

    
    

}
