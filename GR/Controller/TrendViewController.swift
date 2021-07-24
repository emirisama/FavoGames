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
        
        settings.tabBackgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        settings.tabHeight = 90
        isTabButtonShouldFit = true
        tabFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.viewControllers = getTabs()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true


    }
    
    func getTabs() -> [UIViewController]{
        
        var vcArray = [UIViewController]()
        for i in 0..<3{
            
            let ps5ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ps5") as! PS5ViewController
            ps5ViewController.title = "\(Constants.menuArray[i])"
            ps5ViewController.index = i
            vcArray.append(ps5ViewController)
            
            
        }
        return vcArray
    }
}

