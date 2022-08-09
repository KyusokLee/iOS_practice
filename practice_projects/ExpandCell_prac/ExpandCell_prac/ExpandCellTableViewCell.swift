//
//  ExpandCellTableViewCell.swift
//  ExpandCell_prac
//
//  Created by Kyus'lee on 2022/08/08.
//

import UIKit

class ExpandCellTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    // cellの間隔を設定
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16.0, left: 10.0, bottom: 16.0, right: 10.0))
//    }

}
