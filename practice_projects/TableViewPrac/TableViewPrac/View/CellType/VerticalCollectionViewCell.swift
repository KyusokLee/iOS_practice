//
//  VerticalCollectionViewCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {
    
    static let className = "VerticalCollectionViewCell"
    static let cellID = "VerticalCollectionViewCellID"
//    private let customFont = UIFont(name: "BMJUAOTF", size: 20)
//    private let basicFont = UIFont.boldSystemFont(ofSize: 20)
    
    @IBOutlet weak var genreColorView: UIView!
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            self.genreLabel.textColor = .white
            if let hasFont = customFont {
                self.genreLabel.font = hasFont
            } else {
                self.genreLabel.font = basicFont
            }
        }
    }
    @IBOutlet weak var priorityLabel: UILabel! {
        didSet {
            self.priorityLabel.textColor = .black
            // 日本語は、韓国のfontがうまく適応できなじかった
//            if let hasFont = customFont {
//                self.priorityLabel.font = hasFont
//            } else {
//                self.priorityLabel.font = basicFont
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayerStyle()
    }
    
    func setLayerStyle() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public func configure(with model: MusicGenre) {
        genreColorView.backgroundColor = model.backgroundColor
        genreLabel.text = model.genre
        priorityLabel.text = model.description
    }

}
