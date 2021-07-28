//
//  VideoViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/07/19.
//

import UIKit
import WebKit


class VideoViewController: UIViewController,WKNavigationDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    var gameTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        let url = URL(string: "https://www.youtube.com/results?search_query=\(gameTitle)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
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
