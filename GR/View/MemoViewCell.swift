//
//  MemoViewCell.swift
//  GR
//
//  Created by 中森えみり on 2021/05/29.
//

import UIKit
import Cosmos

class MemoViewCell: UITableViewCell {


    @IBOutlet weak var memoLabel: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
