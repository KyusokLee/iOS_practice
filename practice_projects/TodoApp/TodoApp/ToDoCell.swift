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

        // Configure the view for the selected state
    }

}
