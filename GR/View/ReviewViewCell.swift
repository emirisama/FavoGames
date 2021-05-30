//
//  ReviewViewCell.swift
//  GR
//
//  Created by 中森えみり on 2021/05/29.
//

import UIKit
import Cosmos

class ReviewViewCell: UITableViewCell {



    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet weak var scoreView: CosmosView!
    @IBOutlet weak var reviewViewLabel: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}