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
//            performSegue(withIdentifier: "signInVC", sender: nil)
        }else{
            
            //新規会員登録
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
        self.navigationController?.pushViewController(createVC, animated: true)
//            performSegue(withIdentifier: "createVC", sender: nil)
        }
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getTabs() -> [UIViewController]{
       
//        var vcArray = [UIViewController]()

//            vcArray.append(trendviewController)
            
            let ps5ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ps5")
            let ps4ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ps4")
            let switchViewController = self.storyboard?.instantiateViewController(withIdentifier: "switch")
            let steamViewController = self.storyboard?.instantiateViewController(withIdentifier: "steam")
           
             // set the title for the tabs
            ps5ViewController?.title = "PS5"
            ps4ViewController?.title = "PS4"
            switchViewController?.title = "Switch"
            steamViewController?.title = "Steam"

        
        return [ps5ViewController!,ps4ViewController!,switchViewController!,steamViewController!]
    }
}

