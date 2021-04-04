//
//  MypageViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/28.
//

import UIKit
import FirebaseAuth


class MypageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileTextField: UILabel!
    @IBOutlet weak var profielImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profielImage.layer.cornerRadius = profielImage.frame.width/2
        
    }
    
    
    
    @IBAction func tap(_ sender: Any){
        
        
        //カメラを立ち上げる
        openCamera()
        
    }
    
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            //            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true, completion: nil)
            
        }else{
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            profielImage.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
