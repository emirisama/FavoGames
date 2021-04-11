//
//  WebViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/11.
//

import UIKit
import WebKit
import PKHUD


class WebViewController: UIViewController,WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    //ゲーム画像を押すとAmazonに遷移するための変数
    var imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        let myURL = URL(string: "https://www.google.com/search?q=\(imageView)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
