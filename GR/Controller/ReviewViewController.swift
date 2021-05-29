//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController {

    var index = Int()

    @IBOutlet weak var reviewTextField: UITextView!
    
    @IBOutlet weak var reviewScore: CosmosView!
    
    var categoryString = String()
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
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
            
            self.sendDBModel.sendGameTitle(title: title!, name: (profile?.userName)!, reView: reviewTextField.text!, userID: (profile?.userID)!, sender: profile!, rate: self.reviewScore.rating)
            

        }
    }
    

    

}
