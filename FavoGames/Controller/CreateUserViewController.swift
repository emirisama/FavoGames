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


class CreateUserViewController: UIViewController,UITextFieldDelegate, SendProfileDataProtocol{
  
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var sendDBModel = SendDBModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        AuthManager.shared.sendProfileDataProtocol = self
        
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
            
            AuthManager.shared.signIn(userName: nameTextField.text!)
            
        }
        
    }
    
    @IBAction func withoutSigningButton(_ sender: Any) {
        
        transitionToTabVC()
        
    }
    
    
    func transitionToTabVC() {
        
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabVC") as! TabBarController
        self.present(tabVC, animated: true, completion: nil)
        
    }
    
    func catchProfileData() {
        
        HUD.hide()
        transitionToTabVC()
        
    }
    
    
}

