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
    
    var index = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        settings.tabBackgroundColor = #colorLiteral(red: 0.2819149196, green: 0.7462226748, blue: 0.6821211576, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 0.2819149196, green: 0.7462226748, blue: 0.6821211576, alpha: 1)
        tabFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        isTabButtonShouldFit = true
        self.viewControllers = getTabs()
        
        if Auth.auth().currentUser != nil{
            //サインイン
            performSegue(withIdentifier: "CreateVC", sender: nil)
            
        }else{
            //新規会員登録
            performSegue(withIdentifier: "CreateVC", sender: nil)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
   
    func getTabs() -> [UIViewController]{
        var vcArray = [UIViewController]()
        for i in 0..<5{
            
            let trendViewController = self.storyboard?.instantiateViewController(withIdentifier: "Trend") as! TrendViewController
            trendViewController.title = ""
            trendViewController.index = i
            vcArray.append(trendViewController)
        }
        
        return vcArray
        
    }
    

}
