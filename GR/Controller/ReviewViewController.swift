//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController,DoneSendContents2 {

    

    @IBOutlet weak var reviewTextField: UITextView!
    
    @IBOutlet weak var reviewScore: CosmosView!
    
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    
    
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
        //コンテンツとともに送信
        if reviewTextField.text?.isEmpty != true {
            
//            self.sendDBModel.sendDB(reView: <#T##String#>, name: <#T##String#>, id: <#T##String#>, imageData: <#T##Data#>, sender: <#T##ProfileModel#>, rate: <#T##Double#>)
//
        }
    }
    
    
    func checkDone2() {
        
        HUD.hide()
        self.tabBarController?.selectedIndex = 0
        //受信
    }
    

}
