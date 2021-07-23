//
//  SingnupViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD
import FirebaseUI
    
class CreateUserViewController: UIViewController,UITextFieldDelegate,SendProfileDone,FUIAuthDelegate{
    
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    

    
        var sendDBModel = SendDBModel()
        var profileImage = UIImage()
 
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),

    ]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.authUI.delegate = self
            self.authUI.providers = providers
            authButton.addTarget(self, action: #selector(authButtonTapped(_:)), for: .touchUpInside)
            sendDBModel.sendProfileDone = self
            nameTextField.delegate = self
            idTextField.delegate = self

            print("サインアウトしてるかどうか")
            print(Auth.auth().currentUser?.uid.debugDescription)
        }

        //他のところをタップするとキーボードが下がる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    

    @objc func authButtonTapped(_ sender:UIButton) {
            // FirebaseUIのViewの取得
            let authViewController = self.authUI.authViewController()
            // FirebaseUIのViewの表示
            self.present(authViewController, animated: true, completion: nil)
        print("GoogleButtonタップ")
        }
    
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            let usernoimage = UIImage(named: "userimage")
            let usernoimagedata = usernoimage?.jpegData(compressionQuality: 1)
            print("ユーザー名")
            print(user?.displayName?.debugDescription)
            sendDBModel.sendProfileDB(userName: (user?.displayName)!, id: "", profileText: "", imageData: usernoimagedata!)
//            self.performSegue(withIdentifier: "toNextView", sender: nil)
        }else{
            //失敗した場合
                print("error")
            
        }
    }

    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{

        var maxLength: Int = 0
        switch (textField.tag){
        case 1:
            maxLength = 20
        case 2:
            maxLength = 15
        default:
            break
        }
        let nameTextFieldCount = textField.text?.count ?? 0
        let stringCount = string.count
        return nameTextFieldCount + stringCount <= maxLength
        
        
//        let nameTextField: String = (nameTextField.text! as NSString).replacingCharacters(in: range, with: string)
//        let idTextField: String = (idTextField.text! as NSString).replacingCharacters(in: range, with: string)
//        if nameTextField.count <= 20{
//
//            return true
//        }
//
//        return false
        
    }
    

        
    
        

    @IBAction func registerButton(_ sender: Any) {
            //アカウントを作成する
            if nameTextField.text?.isEmpty != true || idTextField.text?.isEmpty != true{
                
                Auth.auth().signInAnonymously { [self] (result, error) in
                    
                    let usernoimage = UIImage(named: "userimage")
                    let usernoimagedata = usernoimage?.jpegData(compressionQuality: 1)
                    if error != nil{
                        print("エラーです")
                    }else{
                        
                        sendDBModel.sendProfileDB(userName: nameTextField.text!, id: idTextField.text!, profileText: "", imageData: usernoimagedata!)
                        print("データをSendDBModelへ")
                    }
                }
            }
            
        }
    
    

    

    
    func checkOK() {
        
        HUD.hide()
        //Trendの画面遷移
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! TabBarController
        performSegue(withIdentifier: "tab", sender: nil)
        
    }
    
    
    @IBAction func signinButton(_ sender: Any) {
        print("メールアドレスでログインをたっぷ")
            let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "signinVC") as! SignInViewController
            self.navigationController?.pushViewController(signinVC, animated: true)
        
    }
    
    
}

