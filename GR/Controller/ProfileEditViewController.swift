//
//  ProfileEditViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/06/27.
//

import UIKit
import PKHUD

class ProfileEditViewController: UIViewController,SendProfileDone, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileTextField: UITextView!
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var id = String()
    var userName = String()
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        sendDBModel.sendProfileDone = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        openCamera()

    }
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
//            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true,completion: nil)
            
        }else{
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage{
            imageView.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    
    func checkOK() {
        HUD.hide()
        let profileVC = storyboard?.instantiateViewController(identifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)

    }
    
    
    
    @IBAction func done(_ sender: Any) {
        
        sendDBModel.sendProfileDB(userName: userName, email: email, id: idLabel.text!, profileText: profileTextField.text!, imageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
        
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
