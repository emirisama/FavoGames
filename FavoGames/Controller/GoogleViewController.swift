//
//  GoogleViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/07/19.
//

import UIKit
import WebKit


class GoogleViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    var gameTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.frame = CGRect(x: 0,y: 0,width: view.frame.size.width,height: view.frame.size.height - toolBar.frame.size.height * 2.3)
        view.addSubview(webView)
        
        let url = URL(string: "https://www.google.com/search?q=\(gameTitle)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        if url != nil{
            
            let request = URLRequest(url: url!)
            webView.load(request)
            
        }else{
            
        }
        
        
    }
    
    @IBAction func go(_ sender: Any) {
        
        webView.goForward()
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        webView.goBack()
        
    }
    
    
}

extension GoogleViewController: WKNavigationDelegate {
    
    
    
}
