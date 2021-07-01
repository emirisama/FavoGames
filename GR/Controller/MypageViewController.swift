//
//  MypageViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/03/28.
//

import UIKit
import FirebaseAuth
import YPImagePicker


class MypageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileTextField: UILabel!
    @IBOutlet weak var profielImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profielImage.layer.cornerRadius = profielImage.frame.width/2
        
        if profielImage.image != nil{
            
        }else{
            //何も設定されていない場合
            showCamera()
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
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
            //何も設定されていない場合
            showCamera()
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
    
    
    
    
    func showCamera(){
            var config = YPImagePickerConfiguration()
            // [Edit configuration here ...]
            // Build a picker with your configuration
            config.isScrollToChangeModesEnabled = true
            config.onlySquareImagesFromCamera = true
            config.usesFrontCamera = false
            config.showsPhotoFilters = true
            config.showsVideoTrimmer = true
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = "DefaultYPImagePickerAlbumName"
            config.startOnScreen = YPPickerScreen.photo
    //        config.screens = [.photo]
            config.screens = [.library]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.hidesCancelButton = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            config.maxCameraZoomFactor = 1.0
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self.profielImage.image = photo.image
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
            
        }
    
    
    @IBAction func retake(_ sender: Any) {
        showCamera()
    }
    
    
}
