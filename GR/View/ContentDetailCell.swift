//
//  ContentDetailCell.swift
//  GR
//
//  Created by 中森えみり on 2021/05/24.
//

import UIKit

protocol ReviewListViewDelegate{
    
    func reviewSendTap()
}


class ContentDetailCell: UITableViewCell {

    var reviewListViewDelegate:ReviewListViewDelegate? = nil
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var salesDate: UILabel!
    @IBOutlet weak var hardware: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func reviewSend(_ sender: Any) {
        print("1")
        reviewListViewDelegate?.reviewSendTap()
        print("2")
    }
    

    
}
