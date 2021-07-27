//
//  ContentDetailCell.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/05/24.
//

import UIKit


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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
}
