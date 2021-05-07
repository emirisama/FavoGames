//
//  SearchViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/04/25.
//

import UIKit
import PKHUD


class SearchViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func search(_ sender: Any) {
        
        //textfieldを閉じる
        textField.resignFirstResponder()
        //ローディングを行う
        HUD.hide()
        //textfieldに入っているキーワードをもとにゲームの検索を行う
        //通信を行う
        
        //画面遷移
        let searchVC = self.storyboard?.instantiateViewController(identifier: "searchVC") as! SearchResultsViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
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
