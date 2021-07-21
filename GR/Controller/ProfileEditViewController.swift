//
//  ProfileEditViewController.swift
//  GR
//
//  Created by 中森えみり on 2021/06/27.
//

import UIKit
import PKHUD
import FirebaseAuth

class ProfileEditViewController: UIViewController,SendProfileDone, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GetProfileDataProtocol,UITextViewDelegate,UITextFieldDelegate{


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileTextField: UITextView!
    @IBOutlet weak var idLabel: UILabel!
    
    var loadModel = LoadModel()
    var sendDBModel = SendDBModel()
    var id = String()
    var userName = String()
    var profileModelArray = [ProfileModel]()
    let maxLength: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTextField.delegate = self
        nameTextField.delegate = self
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        profileTextField.layer.borderColor = UIColor.gray.cgColor
        profileTextField.layer.borderWidth = 0.5
        sendDBModel.sendProfileDone = self
        setUp(id: Auth.auth().currentUser!.uid)
    }
    //文字数制限のときは、TextViewとTexFiledのdelegateを呼ぶ。TextViewとTexFiledは別々で設定。
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let profileTextField: String = (profileTextField.text! as NSString).replacingCharacters(in: range, with: text)
        if profileTextField.count <= 60{
            
            return true
        }
        
        return false
        
    }
    

    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        // 入力を反映させたテキストを取得する
        let nameTextField: String = (nameTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if nameTextField.count <= 20{
            
            return true
        }
        
        return false
        
    }
    
    
    
    func setUp(id:String){

        loadModel.getProfileDataProtocol = self
        //プロフィールを受信する(idにAuth.auth().currentUserが入る
        loadModel.loadProfile()

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
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func done(_ sender: Any) {
        sendDBModel.sendProfileDB(userName: nameTextField.text!, id: idLabel.text!, profileText: profileTextField.text!, imageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        
        //アラートOK
        let alert = UIAlertController(title: "ログアウトしますか？", message: "ログアウトすると全データが削除されますがよろしいですか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            //ログアウト処理
            do {
                
                let firebaseAuth = Auth.auth()
                try firebaseAuth.signOut()
                let tutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "tutorial") as! ViewController
                self.present(tutorialVC, animated: true,completion: nil)
                print("ログアウトしました")
            } catch {
                print ("Error")
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
    



        
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
