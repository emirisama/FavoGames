//
//  TutorialViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/03/21.
//

import UIKit


class TutorialViewController: UIViewController {
    
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.scroll.delegate = self
        
    }
    
    @IBAction func start(_ sender: Any) {
        
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
        self.present(createVC, animated: true, completion: nil)

    }
    
    
}

extension TutorialViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.pageControl.currentPage = index
        
    }
    
}
