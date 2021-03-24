//
//  SingnupViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/24.
//

import UIKit

class SingnupViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordconfirmTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.isEnabled = false
        
        nameTextField.delegate = self
        idTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordconfirmTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showkeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showkeyboard(notification: Notification){
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        //guard let else{return}は、nilだったらこの処理を終わりにしてくださいという意味
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let signupButtonMaxY = signupButton.frame.maxY
        let distance = signupButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {self.view.transform = transform
        })
    }
    
        @objc func hidekeyboard(){
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {self.view.transform = .identity
            })
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
        let passwordconfirmempty = passwordconfirmTextField.text?.isEmpty ?? true
        
        if nameIsEmpty || idIsempty || emailIsempty || passwordIsempty || passwordconfirmempty{
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        }else{
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
        
    }
    
}

