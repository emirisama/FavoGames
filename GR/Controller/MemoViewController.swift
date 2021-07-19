//
//  MemoViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class MemoViewController: UIViewController,DoneSendReviewContents,GetContentsDataProtocol{
 
 
 

 
    @IBOutlet weak var commentTextField: UITextView!
    
    var index = Int()

   
    var contentModel:ContentModel?
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var array = [DataSets]()
    var gameTitle = String()
    var hardware = String()
    var contentModelArray = [ContentModel]()
    var memo = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendDBModel.doneSendReviewContents = self
        loadModel.getContentsDataProtocol = self
        loadModel.loadContents(title: gameTitle)
        commentTextField.text = memo
    }
    

    
    
    
    @IBAction func send(_ sender: Any) {
        //ぐるぐるの表示
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        //自分のプロフィールをアプリ内からとってくる
        let profile:ProfileModel? = userDefaultsEX.codable(forKey: "profile")

        //コンテンツとともに送信（動画：受信クラスを作成しよう）
        if commentTextField.text?.isEmpty != true {

            sendDBModel.sendContents(title: gameTitle, sender: profile!, comment: commentTextField.text)

            print("ゲームタイトルに紐づくレビューをSendDBModelへ")
            
            }else{

                print("エラーです")
                HUD.hide()
        }
    }

    
    
    func checkDoneReview() {
        HUD.hide()

        self.navigationController?.popViewController(animated: true)
        print("レビュー受信")
    }

    
    func checkDoneCommentCounts() {
        print("CommentCounts送信完了")
        
    }
    
    func getContentsData(dataArray: [ContentModel]) {
        contentModelArray = dataArray
        
    }
    
 
    

}
