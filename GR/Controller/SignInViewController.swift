//
//  SignInViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/18.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = Auth.auth().currentUser!.uid

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        if textField.text == Auth.auth().currentUser!.uid{
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    //タッチしたときにキーホードを閉じる？
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textField.resignFirstResponder()
        
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
