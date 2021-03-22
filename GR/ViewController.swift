//
//  ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/21.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.scroll.delegate = self
        
    }
}
    
    
extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.pageControl.currentPage = index
    }
}



