//
//  SingnupViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import PKHUD

    
class CreateUserViewController: UIViewController,UITextFieldDelegate,SendProfileDone{

    
        
        @IBOutlet weak var signupButton: UIButton!
        
        @IBOutlet weak var nameTextField: UITextField!
        @IBOutlet weak var idTextField: UITextField!
        
        @IBOutlet weak var passwordTextField: UITextField!
        
        @IBOutlet weak var emailTextField: UITextField!
        
        var sendDBModel = SendDBModel()
        var profileImage = UIImage()
            
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            sendDBModel.sendProfileDone = self
            
            nameTextField.delegate = self
            idTextField.delegate = self
            emailTextField.delegate = self
            passwordTextField.delegate = self
            
            
        }
        
        
        
        
        //他のところをタップするとキーボードが下がる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
    
        

    @IBAction func registerButton(_ sender: Any) {
    
    
            //アカウントを作成する
            if nameTextField.text?.isEmpty != true || idTextField.text?.isEmpty != true || emailTextField.text?.isEmpty != true || passwordTextField.text?.isEmpty != true{
                
                Auth.auth().signInAnonymously { [self] (result, error) in
                    
                    let usernoimage = UIImage(named: "userimage")
                    let usernoimagedata = usernoimage!.jpegData(compressionQuality: 1)
                    if error != nil{
                        print("エラーです")
                    }else{
                        
                        sendDBModel.sendProfileDB(name: nameTextField.text!, email: emailTextField.text!, id: idTextField.text!, profileText: "", imageData: usernoimagedata!)
                        print("データをSendDBModelへ")
                    }
                }
                
                
            }
            
            
        }
        

    
    func checkOK() {
        
        //sendDB内で呼ばれたcheckOKが呼ばれるタイミングで呼ばれる
        //画面遷移
        
        HUD.hide()
        
        //アプリ内に自分のProfileを保存しておく
        
        //Trendの画面遷移
        let tabVC = self.storyboard?.instantiateViewController(identifier: "tab") as! TabBarController
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
    
    
    @IBAction func signinButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SignInVC", sender: nil)
    }
    
    
        
}

