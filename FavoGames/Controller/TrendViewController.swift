//
//  TrendViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/03/28.
//

import UIKit
import AMPagerTabs


class TrendViewController: AMPagerTabsViewController {
    
    let menuArray = ["PS5","PS4","Switch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.tabBackgroundColor = #colorLiteral(red: 0.3333052099, green: 0.3333491981, blue: 0.3332902193, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 0.3333052099, green: 0.3333491981, blue: 0.3332902193, alpha: 1)
        settings.tabHeight = 100
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
            gameVC.title = "\(menuArray[i])"
            gameVC.index = i
            vcArray.append(gameVC)
            
        }
        
        return vcArray
        
    }
    
    
}

