//
//  SplashViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/07/04.
//

import UIKit
import FirebaseAuth


class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.chooseShouldLaunchViewController()
        
    }
    
    func chooseShouldLaunchViewController() {
        if Auth.auth().currentUser?.uid != nil{
            //サインイン
            print("ログイン後、TabBarVCへ遷移")
            let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! TabBarController
            tabVC.modalPresentationStyle = .fullScreen
            self.present(tabVC, animated: true, completion: nil)
        }else{
            // 新規登録
            print("新規登録")
            let tutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "tutorial") as! ViewController
            tutorialVC.modalPresentationStyle = .fullScreen
            self.present(tutorialVC, animated: true, completion: nil)
            
        }
        
    }
    
    
}
