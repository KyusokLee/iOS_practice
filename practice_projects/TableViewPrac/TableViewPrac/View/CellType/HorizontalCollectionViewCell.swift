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
        setUpCellLayout()
    }
    
    func setUpCellLayout() {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = false
    }
    
    //　cell の中にあるviewのlayoutを調整する
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        self.layoutIfNeeded()
    }
    // 途中の段階
    // data modelを入れる
    public func configure(with model: Meal) {
        imgView.image = UIImage(named: model.mealImage)
        mealLabel.text = model.mealType
    }

}
