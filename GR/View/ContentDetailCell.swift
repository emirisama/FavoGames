//
//  ContentDetailCell.swift
//  GR
//
//  Created by 中森えみり on 2021/05/24.
//

import UIKit

protocol ContentDetaileCellDelegate{
    func didTapLike(likeFlag: Bool)
}


class ContentDetailCell: UITableViewCell,GetLikeFlagProtocol {

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var salesDate: UILabel!
    @IBOutlet weak var hardware: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    
    var contentDetaileCellDelegate:ContentDetaileCellDelegate?
    var likeFlag = Bool()
    var loadModel = LoadModel()


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadModel.getLikeFlagProtocol = self
        loadModel.loadLikeFlag(title: gameTitleLabel.text!)
        print("ContentsDetailCellのawakeFromNib内のlikeFlag")
        print(self.likeFlag)
        if self.likeFlag == false{
            likeButton.setImage(UIImage(named: "heart1"),for: .normal)
            print("awakeFromNib内でfalse画像")
        }else{
            print("awakeFromNib内でtrue画像")
            likeButton.setImage(UIImage(named: "heart2"),for: .normal)
        }

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButtonTap(_ sender: Any) {
        loadModel.getLikeFlagProtocol = self
        loadModel.loadLikeFlag(title: gameTitleLabel.text!)
        
    }
    
    func getLikeFlagData(likeFlag: Bool) {
  
        self.likeFlag = likeFlag
        print("ContentDetailCellでlikeFlagを取得")
        print(self.likeFlag)
        if self.likeFlag == false{
            likeButton.setImage(UIImage(named: "heart1"),for: .normal)
            print("ContentDetailCellでfalse画像に")
        }else{
            likeButton.setImage(UIImage(named: "heart2"),for: .normal)
            print("ContentDetailCellでtrue画像に")
        }
        self.contentDetaileCellDelegate?.didTapLike(likeFlag: likeFlag)
    }

            

    
    

    
}
