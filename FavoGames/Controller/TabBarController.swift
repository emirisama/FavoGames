//
//  TabBarController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/04/06.
//

import UIKit


class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBar.items![0].image = UIImage(named: "tab1-1")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.items![0].selectedImage = UIImage(named: "tab1-2")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        tabBar.items![1].image = UIImage(named: "tab2-1")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.items![1].selectedImage = UIImage(named: "tab2-2")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        tabBar.items![2].image = UIImage(named: "tab3-1")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.items![2].selectedImage = UIImage(named: "tab3-2")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.items![2].imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        self.tabBar.tintColor = UIColor.black
        
    }
    
    
}
