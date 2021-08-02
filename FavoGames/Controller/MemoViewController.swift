//
//  MemoViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit
import PKHUD


class MemoViewController: UIViewController,UITextViewDelegate,SendCommentsDone {
    
    
    @IBOutlet weak var commentTextField: UITextView!
    
    
    var index = Int()
    var gameTitle = String()
    var hardware = String()
    var memo = String()
    var cmmentsModel: CommentsModel?
    var sendDBModel = SendDBModel()
    var loadModel = LoadModel()
    var dataSetsArray = [DataSets]()
    var commentsModelArray = [CommentsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendDBModel.sendCommentsDone = self
        commentTextField.text = memo
        commentTextField.delegate = self
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 入力を反映させたテキストを取得する
        let commentTextField: String = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        if commentTextField.count <= 800 {
            return true
        }
        return false
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        //ローディング
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        if commentTextField.text?.isEmpty != true {
            
            sendDBModel.sendComments(title: gameTitle, comment: commentTextField.text)
            
            
        }else{
            
            HUD.hide()
            
        }
        
    }
    
    func checkCommentsDone() {
        
        HUD.hide()
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
}
