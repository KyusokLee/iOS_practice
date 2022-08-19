//
//  SearchResultCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/19.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel! {
        didSet {
            countryNameLabel.textColor = .darkGray
            countryNameLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
