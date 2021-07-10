//
//  ProfileEditViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/06/27.
//

import UIKit
import PKHUD
import FirebaseAuth

class ProfileEditViewController: UIViewController,SendProfileDone, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GetProfileDataProtocol{


    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileTextField: UITextView!
    
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var id = String()
    var userName = String()
    var profileModelArray = [ProfileModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        profileTextField.layer.borderColor = UIColor.gray.cgColor
        profileTextField.layer.borderWidth = 0.5
        sendDBModel.sendProfileDone = self
        setUp(id: Auth.auth().currentUser!.uid)
    
        // Do any additional setup after loading the view.
    }
    
    func setUp(id:String){

        loadModel.getProfileDataProtocol = self
        //プロフィールを受信する(idにAuth.auth().currentUserが入る
        loadModel.loadProfile(id: id)

    }
    
    func getProfileData(dataArray: [ProfileModel]) {
        self.profileModelArray = dataArray
        imageView.sd_setImage(with: URL(string: dataArray[0].imageURLString!), completed: nil)
        nameTextField.text = dataArray[0].userName
        profileTextField.text = dataArray[0].profileText
        idLabel.text = dataArray[0].id
        
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
//        let profileVC = storyboard?.instantiateViewController(identifier: "profile") as! ProfileViewController
//        self.navigationController?.pushViewController(profileVC, animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func done(_ sender: Any) {
        
        sendDBModel.sendProfileDB(userName: nameTextField.text!, id: idLabel.text!, profileText: profileTextField.text!, imageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
        
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
