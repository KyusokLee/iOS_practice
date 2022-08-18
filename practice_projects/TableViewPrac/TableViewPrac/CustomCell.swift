//
//  CustomCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

enum isSelected {
    case selected
    case normal
}

class CustomCell: UITableViewCell {
    
    private var hartButtonState: isSelected = .normal
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hartButton: UIButton! {
        didSet {
            configureAppearance()
        }
    }
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.5, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = .cubic
        return bounceAnimation
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // cellの間にある、lineを消す
        self.selectionStyle = .none
        
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.blue.cgColor
        } else {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }

    }
    
    @IBAction func selectHartButton(_ sender: UIButton!) {
        if hartButtonState == .normal {
            hartButtonState = .selected
            print("normal -> select")
        } else {
            hartButtonState = .normal
            print("select -> normal")
        }
        
        configureAppearance()
    }
    
    
    private func configureAppearance() {
        if hartButtonState == .normal {
            print("it is normal")
            let normalImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
            hartButton.setImage(normalImage, for: .normal)
        } else {
            print("it is selected")
            let selectedImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
            hartButton.setImage(selectedImage, for: .normal)
        }
       
        hartButton.tintColor = .systemRed
        hartButton.layer.add(bounceAnimation, forKey: nil)
    }
    
    
    
    
}
