//
//  CustomCell.swift
//  Chat_app_prac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var myTextView: UITextView! {
        didSet {
            myTextView.isEditable = false
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
