//
//  TrendViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/28.
//

import UIKit
import AMPagerTabs


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
            
            let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
            gameVC.title = "\(Constants.menuArray[i])"
            gameVC.index = i
            vcArray.append(gameVC)
            
        }
        
        return vcArray
        
    }
    
    
}

