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
    
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var reviewView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImageView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
