//
//  ViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD
import FirebaseUI

class ViewController: UIViewController,SendProfileDone,FUIAuthDelegate {
    
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var sendDBModel = SendDBModel()
    var profileModel = [ProfileModel]()
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIOAuth.appleAuthProvider(),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        self.authUI.delegate = self
        self.authUI.providers = providers
        sendDBModel.sendProfileDone = self
//        start.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scroll.delegate = self
        
     
    }
    

    
    
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            let usernoimage = UIImage(named: "userimage")
            let usernoimagedata = usernoimage?.jpegData(compressionQuality: 1)
            print("ユーザー名")
            print(user?.displayName?.debugDescription)
            print("ユーザーがあるのかどうか")
            print(Auth.auth().currentUser?.uid)
            if Auth.auth().currentUser?.uid != nil{
                print("ユーザーがある")
                
                checkOK()
            }else{
                sendDBModel.sendProfileDB(userName: (user?.displayName)!,imageData: usernoimagedata!)
                print("新規ユーザー")
            }
        }else{
            //失敗した場合
            print("error")
        }
    }
    
    @IBAction func start(_ sender: Any) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
        print("GoogleButtonタップ")
    }
    
    
    
    
    func checkOK() {
        
        HUD.hide()
        //Trendの画面遷移
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! TabBarController
        performSegue(withIdentifier: "tab", sender: nil)
    }
    
}


extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.pageControl.currentPage = index
    }
    
}



