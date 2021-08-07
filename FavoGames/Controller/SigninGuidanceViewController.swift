//
//  SigninGuidanceViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/08/06.
//

import UIKit

class SigninGuidanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func signUpButton(_ sender: Any) {
   
            let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
            self.present(createVC, animated: true, completion: nil)
        
    }
        



}
