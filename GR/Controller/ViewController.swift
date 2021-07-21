//
//  ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    
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
        print("新規会員登録")
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "createVC") as! CreateUserViewController
        createVC.modalPresentationStyle = .fullScreen
        self.present(createVC, animated: true, completion: nil)
    }
    
    
}


extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.pageControl.currentPage = index
    }
    
}



