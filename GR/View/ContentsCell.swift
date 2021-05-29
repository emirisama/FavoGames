//
//  ContentsCell.swift
//  GR
//
//  Created by 中森えみり on 2021/04/13.
//

import UIKit
import Cosmos

class ContentsCell: UITableViewCell {

    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selectionStyle = .none
        contentView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
