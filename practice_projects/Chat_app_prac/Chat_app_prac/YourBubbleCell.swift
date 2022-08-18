//
//  YourBubbleCell.swift
//  Chat_app_prac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

class YourBubbleCell: UITableViewCell {

    @IBOutlet weak var yourTextView: UITextView! {
        didSet {
            // 一度入力された後は、該当のcellのtextViewは編集不可にする
            // CustomCellのtextViewも同様な処理をする
            yourTextView.isEditable = false
        }
    }
    
    @IBOutlet weak var date: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
