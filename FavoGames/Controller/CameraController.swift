//
//  CameraController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/07/29.
//

import Foundation
import UIKit

class CameraController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    static let shared = CameraController()
    
    func openCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            present(cameraPicker, animated: true,completion: nil)
            
        }else{
            
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        if let pickedImage = info[.editedImage] as? UIImage{
//            imageView.image = pickedImage
//            //閉じる処理
//            picker.dismiss(animated: true, completion: nil)
//            
//        }
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        
//        picker.dismiss(animated: true, completion: nil)
//        
//    }
    
}
