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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = false
        self.layoutIfNeeded()
    }
    
    // 途中の段階
    // data modelを入れる
    public func configure(with model: Meal) {
        imgView.image = UIImage(named: model.mealImage)
        mealLabel.text = model.mealType
    }

}
