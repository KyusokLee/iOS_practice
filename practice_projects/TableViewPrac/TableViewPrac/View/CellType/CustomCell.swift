//
//  CustomCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

// selected caseの定義
enum isSelected {
    case selected
    case normal
}

//protocol CustomCellDelegate {
//    func hartButtonClicked(for index: Int, like: Bool)
//}

// TODO: delegate patternにRefactoring 途中

class CustomCell: UITableViewCell {
    private var hartButtonState: isSelected = .normal
//    var delegate: CustomCellDelegate?
//    var index: Int?
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.5, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = .cubic
        return bounceAnimation
    }()
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hartButton: UIButton! {
        didSet {
            configureAppearance()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellLayout()
    }
    
    func setupCellLayout() {
        // selectionされた背景の色がなくなる
        self.selectionStyle = .none
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // clickすることによる、completion eventを連動させるといい
        if selected {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.blue.cgColor
        } else {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.lightGray.cgColor
        }

    }
    
    @IBAction func selectHartButton(_ sender: UIButton) {
//        guard let hasIndex = index else {
//            print("Error fail to get index: ")
//            return
//        }
        
//        if sender.isSelected {
//            checkButtonState()
//            delegate?.hartButtonClicked(for: hasIndex, like: true)
//        } else {
//            checkButtonState()
//            delegate?.hartButtonClicked(for: hasIndex, like: false)
//        }
        checkButtonState()
        configureAppearance()
    }
    
    func checkButtonState() {
        if hartButtonState == .normal {
            hartButtonState = .selected
            print("normal -> select")
        } else {
            hartButtonState = .normal
            print("select -> normal")
        }
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
//        // Click Eventのときだけ、animation layerをaddしたいな。。
//        hartButton.layer.add(bounceAnimation, forKey: nil)

        hartButton.layer.add(bounceAnimation, forKey: nil)
        
    }
}
