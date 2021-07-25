//
//  SignInViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/18.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, GetProfileDataProtocol{

    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var loadModel = LoadModel()
    var profileModelArray = [ProfileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid != nil{
            loadModel.getProfileDataProtocol = self

            loadModel.loadProfile()
        }else{
            
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
 
        if let email = emailTextField.text,let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard let user = result?.user,error != nil else{
                    print("サインインに失敗しました")
                    
                    return
                }
                print("サインインに成功しました")
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! TabBarController
                tabVC.modalPresentationStyle = .fullScreen
                self.present(tabVC, animated: true, completion: nil)
            }
        }
        
    }
    
    //タッチしたときにキーホードを閉じる？
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        
    }
    
    
    func getProfileData(dataArray: [ProfileModel]) {
        self.profileModelArray = dataArray
        
        if Auth.auth().currentUser?.uid != nil{
           
        }else{
            emailTextField.text = profileModelArray[0].userName
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
