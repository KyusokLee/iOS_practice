//
//  HorizontalCollectionViewCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/22.
//

import UIKit

// 横scrollができるCell

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    static let className = "HorizontalCollectionViewCell"
    static let cellID = "HorizontalCollectionViewCellID"
    
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // 途中の段階
    // data modelを入れる
    public func configure() {
        imgView.tintColor = .blue
        mealLabel.text = "Dinner"
    }

}
