//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController,DoneSendReviewContentsPS5,DoneSendReviewContentsPS4,DoneSendReviewContentsSwitch,GetRateAverageCountProtocol{
 
 
 
 
   

    

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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendDBModel.doneSendReviewContentsPS5 = self
        sendDBModel.doneSendReviewContentsPS4 = self
        sendDBModel.doneSendReviewContentsSwitch = self
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

            if hardware == "PS5"{
                sendDBModel.sendContentsPS5(title: gameTitle,sender: profile!,review: reviewTextField.text!, rate: self.reviewScore.rating,rateAverage: self.rateAverage)
            }else if hardware == "PS4"{
                sendDBModel.sendContentsPS4(title: gameTitle,sender: profile!,review: reviewTextField.text!, rate: self.reviewScore.rating,rateAverage: self.rateAverage)
            }else if hardware == "Switch"{
                sendDBModel.sendContentsSwitch(title: gameTitle,sender: profile!,review: reviewTextField.text!, rate: self.reviewScore.rating,rateAverage: self.rateAverage)
            }
            
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
    
    func checkDoneReviewPS5() {
        HUD.hide()
        loadModel.loadContentsPS5(title: gameTitle,rateAverage: rateAverage)
        self.navigationController?.popViewController(animated: true)
        print("レビュー受信PS5")
    }
    
    func checkDoneReviewPS4() {
        HUD.hide()
        loadModel.loadContentsPS4(title: gameTitle,rateAverage: rateAverage)
        self.navigationController?.popViewController(animated: true)
        print("レビュー受信PS4")
    }
    
    func checkDoneReviewSwitch() {
        HUD.hide()
        loadModel.loadContentsSwitch(title: gameTitle,rateAverage: rateAverage)
        self.navigationController?.popViewController(animated: true)
        print("レビュー受信Switch")
    }
    
    
    
    

}
