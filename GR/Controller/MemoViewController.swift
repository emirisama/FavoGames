//
//  MemoViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD


class MemoViewController: UIViewController,SendContentsDone{
    
    
    @IBOutlet weak var commentTextField: UITextView!
    
    
    var index = Int()
    var gameTitle = String()
    var hardware = String()
    var memo = String()
    var contentModel:ContentModel?
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var dataSetsArray = [DataSets]()
    var contentModelArray = [ContentModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendDBModel.sendContentsDone = self
        commentTextField.text = memo
        
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        //ローディング
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        if commentTextField.text?.isEmpty != true {
            
            sendDBModel.sendContents(title: gameTitle, comment: commentTextField.text)
            
            print("ゲームタイトルに紐づくコメントをSendDBModelへ")
            
        }else{
            
            print("エラーです")
            HUD.hide()
            
        }
        
    }
    
    func checkContentsDone() {
        
        HUD.hide()
        
        self.navigationController?.popViewController(animated: true)
        print("コメント送信しました")
    }
    
    
}
