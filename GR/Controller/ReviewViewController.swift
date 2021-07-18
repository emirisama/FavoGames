//
//  ReviewViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD
import Cosmos

class ReviewViewController: UIViewController,DoneSendReviewContents,GetTitlesDataProtocol,GetCommentCountDataProtocol,DoneSendGameTitleWithCommentCount{
 
 

 
    @IBOutlet weak var commentTextField: UITextView!
    
    var index = Int()

   
    var contentModel:ContentModel?
    var userDefaultsEX = UserDefaultsEX()
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var array = [DataSets]()
    var gameTitle = String()
    var hardware = String()


    var titleDocumentModelArray = [TitleDocumentIDModel]()
    var documentID = String()
    var commentCountModelArray = [CommentCountModel]()
    var CommentDocumentID = String()
    var contentsDocumentModelArray = [ContentsDocumentIDModel]()
    var commentCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendDBModel.doneSendReviewContents = self
        loadModel.getCommentCountDataProtocol = self
        loadModel.loadCommentCount(title: gameTitle)
        sendDBModel.doneSendGameTitleWithCommentCount = self
        //ゲームのタイトルのdocumentIDを受信
//        loadModel.getTitlesDataProtocol = self
//        loadModel.loadTitlesID()

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
        
            
//            sendDBModel.doneSendCommentCounts = self
//            sendDBModel.sendCommentCount(documentID: documentID, CommentCount: self.contentsDocumentModelArray.count, title: gameTitle,hardware: hardware)
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
    


    //ゲームタイトルのdocumentIDを受信
    func getTitlesData(dataArray: [TitleDocumentIDModel]) {
        self.titleDocumentModelArray = []
        self.titleDocumentModelArray = dataArray
        for i in 0..<titleDocumentModelArray.count{
            documentID = titleDocumentModelArray[i].documentID!
        }
        //コメントのdocumentIDを受信
//        loadModel.loadContentsID(documentID: documentID)

    }
    
    func checkDoneCommentCounts() {
        print("CommentCounts送信完了")
        
    }
    

    
    func checkDoneGameTitleWithCommentCount() {
        print("GameTitleWithCommentCount送信完了")
    }
    
    func getCommentCountData(dataArray: Int) {
        commentCount = dataArray
        print("contentCountとは")
        print(commentCount)
        sendDBModel.sendGametTitleWithCommentCount(title: gameTitle, commentCount: commentCount)
        
    }
    
//    //コメントのdocumentIDを受信
//    func getContensDocumentIDData(dataArray: [ContentsDocumentIDModel]) {
//        self.contentsDocumentModelArray = []
//        self.contentsDocumentModelArray = dataArray
//        for i in 0..<contentsDocumentModelArray.count{
//            CommentDocumentID = contentsDocumentModelArray[i].documentID!
//            print("commentドキュメントIDは？")
//            print(CommentDocumentID.debugDescription)
//        }
//    }
    
//    //コメント総数を受信
//    func getCommentCountData(dataArray: [CommentCountModel]) {
//        self.commentCountModelArray = []
//        self.commentCountModelArray = dataArray
//    }
    

}
