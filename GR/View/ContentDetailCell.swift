//
//  ContentDetailCell.swift
//  GR
//
//  Created by 中森えみり on 2021/05/24.
//

import UIKit




class ContentDetailCell: UITableViewCell {

 
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var salesDate: UILabel!
    @IBOutlet weak var hardware: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    

    
}
