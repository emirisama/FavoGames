//
//  VideoViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/07/19.
//

import UIKit
import WebKit
import PKHUD


class VideoViewController: UIViewController,WKNavigationDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    var gameTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        let url = URL(string: "https://www.youtube.com/results?search_query=\(gameTitle)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    
    @IBAction func go(_ sender: Any) {
        
        webView.goForward()
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        webView.goBack()
        
    }
    
    //ロードしている時に呼ばれる
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        HUD.show(.progress)
        
    }
    //ロードが完了したときに呼ばれる
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        HUD.hide()
        
    }
    
    
}
