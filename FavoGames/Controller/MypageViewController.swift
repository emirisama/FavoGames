//
//  MypageViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/08/06.
//

import UIKit
import Firebase
import AMPagerTabs

class MypageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser?.uid != nil {
            
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
            self.addChild(profileVC)
            self.view.addSubview(profileVC.view)
            profileVC.didMove(toParent: self)
            
        } else {
            
            let signinGuidanceVC = self.storyboard?.instantiateViewController(withIdentifier: "signinGuidanceVC") as! SigninGuidanceViewController
            self.addChild(signinGuidanceVC)
            self.view.addSubview(signinGuidanceVC.view)
            signinGuidanceVC.didMove(toParent: self)
            
        }
        
    }
    

}
