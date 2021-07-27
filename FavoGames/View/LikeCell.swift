//
//  LikeCell.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/07/18.
//

import UIKit


class LikeCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = UIImageView.ContentMode.scaleToFill
        
        
    }
    
    
}
