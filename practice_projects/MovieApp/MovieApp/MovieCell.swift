//
//  MovieCell.swift
//  MovieApp
//
//  Created by Kyus'lee on 2022/06/29.
//

import UIKit

class MovieCell: UITableViewCell {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            // weight: 太くするか、細くするか、文字を傾けるかなどに関するparameter
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    
    
    
    
    
}
