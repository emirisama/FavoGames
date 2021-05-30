//
//  TrendViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/28.
//

import UIKit
import AMPagerTabs
import FirebaseAuth

class TrendViewController: AMPagerTabsViewController {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        settings.tabBackgroundColor = #colorLiteral(red: 0.2819149196, green: 0.7462226748, blue: 0.6821211576, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 0.2819149196, green: 0.7462226748, blue: 0.6821211576, alpha: 1)
        settings.tabHeight = 100
        isTabButtonShouldFit = true
        tabFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.viewControllers = getTabs()
        
        if Auth.auth().currentUser != nil{
            let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "signinVC") as! SignInViewController
            self.navigationController?.pushViewController(signinVC, animated: true)
        }else{
            
            //新規会員登録
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
        self.navigationController?.pushViewController(createVC, animated: true)
        }
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true


    }
    
    func getTabs() -> [UIViewController]{
        
        var vcArray = [UIViewController]()
        for i in 0..<3{
            
            let ps5ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ps5") as! PS5ViewController
            ps5ViewController.title = ""
            ps5ViewController.index = i
            vcArray.append(ps5ViewController)
            
            
        }
        return vcArray
    }
}

