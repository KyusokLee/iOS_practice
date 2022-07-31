//
//  ToDoCell.swift
//  TodoApp
//
//  Created by Kyus'lee on 2022/07/19.
//

import UIKit

class ToDoCell: UITableViewCell {
    // MARK: 📮追加したい layout
    // 1. cellの枠の色の設定(選択と未選択のときのcellのデザインの差を設定)
    // 2. cellの間隔の設定
    
    
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
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.blue.cgColor
        } else {
            // 未選択のcell
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    // ⚠️Error: contentView.frame.insetで、topの部分を6以上に設定すると、topTitleLabelが隠れるerrorが起きた
    // ->　各要素のpriorityと関係ある

}
