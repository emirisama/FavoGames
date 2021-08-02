//
//  SingnupViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/03/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import PKHUD


class CreateUserViewController: UIViewController,UITextFieldDelegate,SendProfileDone{
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var sendDBModel = SendDBModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendDBModel.sendProfileDone = self
        nameTextField.delegate = self
        
        
    }
    
    //キーボードを下げる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    //文字数制限
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        
        let nameTextField: String = (nameTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if nameTextField.count <= 20 {
            
            return true
        }
        
        return false
        
    }
    
    //アカウントを作成する
    @IBAction func registerButton(_ sender: Any) {
        
        if nameTextField.text?.isEmpty != true {
            
            Auth.auth().signInAnonymously { [self] (result, error) in
                
                let usernoimage = UIImage(named: "userimage")
                let usernoimagedata = usernoimage?.jpegData(compressionQuality: 1)
                
                if error != nil{
                    
                }else{
                    
                    sendDBModel.sendProfile(userName: nameTextField.text!,imageData: usernoimagedata!)
                    
                }
            }
        }
        
    }
    
    func checkProfileDone() {
        
        HUD.hide()
        //Trendの画面遷移
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabVC") as! TabBarController
        performSegue(withIdentifier: "tabVC", sender: nil)
        
    }
    
    
}

