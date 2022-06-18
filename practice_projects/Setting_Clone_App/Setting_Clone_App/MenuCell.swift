//
//  MenuCell.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/17.
//

import UIKit

// cellの大きさのlayout調整において
// 複数のobject(labelとかimage)を選択し、一斉にその間隔を整列したいとき、priorityの値が大きい順に決まる。それに加えて、同じpriorityの場合は直接大きさを調整したものが優先されて、大きさや間隔が決まる。

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var middleTitle: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
