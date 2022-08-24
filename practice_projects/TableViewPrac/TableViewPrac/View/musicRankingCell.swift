//
//  musicRankingCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/24.
//

import UIKit

class musicRankingCell: UITableViewCell {
    static let className = "musicRankingCell"
    static let cellID = "musicRankingCellID"
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // data Modelの指定
    public func configure() {
//        albumImage.image
        musicTitleLabel.text = "Ah poo"
        singerNameLabel.text = "IU"
    }
}
