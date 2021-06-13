//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController,DoneSendReviewContents{
 
 
   

    

    var index = Int()

    @IBOutlet weak var reviewTextField: UITextField!
    
    var contentModel:ContentModel?
    @IBOutlet weak var reviewScore: CosmosView!
    
    var categoryString = String()
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var array = [DataSets]()
    var gameTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendDBModel.doneSendReviewContents = self
        reviewScore.settings.fillMode = .half


        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: Any) {
        //ぐるぐるの表示
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        //自分のプロフィールをアプリ内からとってくる
        let profile:ProfileModel? = userDefaultsEX.codable(forKey: "profile")

        //コンテンツとともに送信（動画：受信クラスを作成しよう）
        if reviewTextField.text?.isEmpty != true {


            sendDBModel.sendGameTitle(title: gameTitle,sender: profile!, review: reviewTextField.text!, rate: self.reviewScore.rating)
            print("ゲームタイトルに紐づくレビューをSendDBModelへ")
                
            }else{

                print("エラーです")
        
            
        }
    

    }
    
    func checkDoneReview() {

        HUD.hide()
        //受信
        loadModel.loadContents(title: gameTitle)
        self.navigationController?.popViewController(animated: true)
        print("レビュー受信")
    }
    
    
    
    
    

}
