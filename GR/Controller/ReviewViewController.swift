//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController,DoneSendReviewContents,GetRateAverageCountProtocol{
 
 
 
 
   

    

    var index = Int()

   
    var contentModel:ContentModel?
    @IBOutlet weak var reviewScore: CosmosView!
    @IBOutlet weak var reviewTextField: UITextView!
    
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var array = [DataSets]()
    var gameTitle = String()
    var hardware = String()
    var rateAverage = Double()
    var totalCount = Double()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendDBModel.doneSendReviewContents = self

        reviewScore.settings.fillMode = .half
        reviewScore.rating = 3.0
        loadModel.getRateAverageCountProtocol = self
        loadModel.loadRateAverageCount(title: gameTitle, rateAverage: self.rateAverage)
        
    }
    

    
    
    
    @IBAction func send(_ sender: Any) {
        //ぐるぐるの表示
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        //自分のプロフィールをアプリ内からとってくる
        let profile:ProfileModel? = userDefaultsEX.codable(forKey: "profile")

        //コンテンツとともに送信（動画：受信クラスを作成しよう）
        if reviewTextField.text?.isEmpty != true {

            sendDBModel.sendContents(title: gameTitle,sender: profile!,review: reviewTextField.text!, rate: self.reviewScore.rating,rateAverage: totalCount)
            print("totalCountの中身")
            print(totalCount.debugDescription)
            
            print("ゲームタイトルに紐づくレビューをSendDBModelへ")
  
            print("レビュー平均値をDBへ")
            print(self.rateAverage.debugDescription)
            
            }else{

                print("エラーです")
                HUD.hide()
            
        }
    

    }

    
    func getRateAverageCount(rateAverage: Double) {

        self.rateAverage = rateAverage
        print("レビュー平均値ALl")
        print(self.rateAverage.debugDescription)
    }
    
    func checkDoneReview() {
        HUD.hide()
        loadModel.loadContents(title: gameTitle,rateAverage: rateAverage)
        self.navigationController?.popViewController(animated: true)
        print("レビュー受信PS5")
    }

    
    
    

}
