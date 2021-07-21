//
//  ContentDetailCell.swift
//  GR
//
//  Created by 中森えみり on 2021/05/24.
//

import UIKit

protocol ContentDetaileCellDelegate{
    func didTapLike(isLike: Bool)
}

class ContentDetailCell: UITableViewCell{

    

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var salesDate: UILabel!
    @IBOutlet weak var hardware: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    

    var likeFlag = Bool()
    var loadModel = LoadModel()
    var contentDetaileCellDelegate:ContentDetaileCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        loadModel.getLikeFlagProtocol = self
//        loadModel.loadLikeFlag(title: gameTitleLabel.text!)
//        print("titleの中身")
//        print(gameTitleLabel.text!.debugDescription)
//        print("awakeFromNib()内のlikeFlag")
//        print(self.likeFlag)
//        if self.likeFlag == true{
//            likeButton.setImage(UIImage(named: "heart2"),for: .normal)
//            print("awakeFromNib()内のtrue画像")
//        }else{
//            likeButton.setImage(UIImage(named: "heart1"),for: .normal)
//            print("awakeFromNib()内のfalse画像")
//        }
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func likeButtonTap(_ sender: UIButton) {
        //        loadModel.getLikeFlagProtocol = self
        //        loadModel.loadLikeFlag(title: gameTitleLabel.text!)

        
        self.contentDetaileCellDelegate?.didTapLike(isLike: likeFlag)
        print("CellのlikeFlag")
        print(self.likeFlag)
        if self.likeFlag == false{
            likeButton.setImage(UIImage(named: "heart1"),for: .normal)
            print("ContentDetailCellでfalse画像に")
        }else{
            likeButton.setImage(UIImage(named: "heart2"),for: .normal)
            print("ContentDetailCellでtrue画像に")
        }
        
    }
    
//    func getLikeFlagData(likeFlag: Bool) {
//
//        self.likeFlag = likeFlag
//        print("ContentDetailCellでlikeFlagを取得")
//        print(self.likeFlag)
//        if self.likeFlag == false{
//            likeButton.setImage(UIImage(named: "heart1"),for: .normal)
//            print("ContentDetailCellでfalse画像に")
//        }else{
//            likeButton.setImage(UIImage(named: "heart2"),for: .normal)
//            print("ContentDetailCellでtrue画像に")
//        }
//
//    }
    


    
}
