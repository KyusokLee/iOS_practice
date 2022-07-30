//
//  ToDoCell.swift
//  TodoApp
//
//  Created by Kyus'lee on 2022/07/19.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var priorityView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // 選択、未選択ごとにcellの枠の色を違くするlogic
        // borderWidth: 枠の線の厚さ
        // ⚠️contentViewで設定を変える
        
        if selected {
            // 選択されたcell
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = UIColor.blue.cgColor
        } else {
            // 未選択のcell
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }

        // Configure the view for the selected state
    }

}
