//
//  ItemViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/07/19.
//

import UIKit
import WebKit
import PKHUD

class ItemViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!

    var gameTitle = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView = WKWebView(frame: view.frame)
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
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        HUD.show(.progress)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        HUD.hide()
        
    }
    
    
}
