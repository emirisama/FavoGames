//
//  ProfileEditViewController.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/06/27.
//

import UIKit
import PKHUD
import FirebaseAuth


class ProfileEditViewController: UIViewController,SendProfileDone, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GetProfileDataProtocol,UITextFieldDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var userName = String()
    var profileModelArray = [ProfileModel]()
    let maxLength: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadModel.getProfileDataProtocol = self
        loadModel.loadProfile()
        nameTextField.delegate = self
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        sendDBModel.sendProfileDone = self
        
    }
    
    //名前の文字数制限
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        
        let nameTextField: String = (nameTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if nameTextField.count <= 20{
            
            return true
        }
        
        return false
        
    }
    
    func getProfileData(dataArray: [ProfileModel]) {
        
        profileModelArray = dataArray
        imageView.sd_setImage(with: URL(string: profileModelArray[0].imageURLString!), completed: nil)
        nameTextField.text = profileModelArray[0].userName
        
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
    
    @IBAction func done(_ sender: Any) {
        
        sendDBModel.sendProfile(userName: nameTextField.text!,imageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        
        //アラートOK
        let alert = UIAlertController(title: "ログアウトしますか？", message: "ログアウトすると全データが削除されますがよろしいですか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: { [self]
            (action: UIAlertAction!) -> Void in
            
            //ログアウト処理
            do {
                
                let firebaseAuth = Auth.auth()
                try firebaseAuth.signOut()
                
                let tutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "tutorialVC") as! TutorialViewController
                self.present(tutorialVC, animated: true,completion: nil)

                
            } catch {

                
            }
        })
        
        //アラートキャンセル
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: {
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(okAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func checkProfileDone() {
        
        HUD.hide()
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
