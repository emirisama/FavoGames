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
    
    
    var sendDBModel = SendDBModel()
    var profileImage = UIImage()
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    var profileModel = [ProfileModel]()
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
            authButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)

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
            print("ユーザーがあるのかどうか")
     print(Auth.auth().currentUser?.uid)
            if Auth.auth().currentUser?.uid != nil{
                print("ユーザーがある")
 
                checkOK()
            }else{
            sendDBModel.sendProfileDB(userName: (user?.displayName)!,imageData: usernoimagedata!)
                print("新規ユーザー")
            }
        }else{
            //失敗した場合
                print("error")
        }
    }

    func checkOK() {
        
        HUD.hide()
        //Trendの画面遷移
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! TabBarController
        performSegue(withIdentifier: "tab", sender: nil)
    }
    
    
    
    
}

