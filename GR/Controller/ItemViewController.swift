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

    var itemUrl = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        let url = URL(string: "\(itemUrl)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if url != nil{

            let request = URLRequest(url: url!)
            webView.load(request)
        }else{
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
//    func alert(title:String,message:String) {
//        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK",
//                                                style: .default,
//                                                handler: nil))
//        present(alertController, animated: true)
//    }
    
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
