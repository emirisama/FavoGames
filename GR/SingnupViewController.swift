//
//  SingnupViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/24.
//

import UIKit
import Firebase
import FirebaseFirestore

struct User{
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]){
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
        
    }
    
    class SingnupViewController: UIViewController,UITextFieldDelegate{
        
        @IBOutlet weak var signupButton: UIButton!
        
        @IBOutlet weak var nameTextField: UITextField!
        @IBOutlet weak var idTextField: UITextField!
        
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            signupButton.isEnabled = false
            
            nameTextField.delegate = self
            idTextField.delegate = self
            emailTextField.delegate = self
            passwordTextField.delegate = self
            
            
        }
        
        
        
        
        //他のところをタップするとキーボードが下がる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            //??trueで空だったら自動的にTrueを返す
            let nameIsEmpty = emailTextField.text?.isEmpty ?? true
            let idIsempty = idTextField.text?.isEmpty ?? true
            let emailIsempty = emailTextField.text?.isEmpty ?? true
            let passwordIsempty = passwordTextField.text?.isEmpty ?? true
            
            if nameIsEmpty || idIsempty || emailIsempty || passwordIsempty {
                signupButton.isEnabled = false
                signupButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
            }else{
                signupButton.isEnabled = true
                signupButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
            }
            
        }
        
        @IBAction func registerButton(_ sender: Any) {
            handleAuthToFirebase()
        }
        
        
        private func handleAuthToFirebase(){
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password){ [self] (res, err) in
                if let err = err {
                    print("認証情報の保存に失敗しました\(err)")
                    return
                }
                self.addUserInfoToFirestore(email: email)
            }
        }
        
        
        private func addUserInfoToFirestore(email: String){
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let name = nameTextField.text else { return }
            let docData = ["email":email, "name": name, "createdAt": Timestamp()] as [String : Any]
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            //Firebaseへの保存
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("Firebaseへの保存に失敗しました")
                    return
                }
                print("Firestoreへの保存に成功しました")
                
                //ユーザー情報の取得
                userRef.getDocument { (snapshot, err) in
                    if let err = err{
                        print("ユーザー情報の取得に失敗しました\(err)")
                        return
                    }
                    
                    let data = snapshot?.data()
                    let user = User.init(dic: data!)
                    
                    print("ユーザー情報の取得ができました\(user.name)")
                }
                
            }
        }
        
    }
}
