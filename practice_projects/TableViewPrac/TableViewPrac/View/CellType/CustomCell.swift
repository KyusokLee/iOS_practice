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

enum BorderColor {
    static var gradientColors = [
        UIColor.systemBlue,
        UIColor.systemBlue.withAlphaComponent(0.7),
        UIColor.systemBlue.withAlphaComponent(0.4),
        UIColor.systemBlue.withAlphaComponent(0.3),
        UIColor.systemBlue.withAlphaComponent(0.7),
        UIColor.systemBlue.withAlphaComponent(0.3),
        UIColor.systemBlue.withAlphaComponent(0.4),
        UIColor.systemBlue.withAlphaComponent(0.7)
    ]
}

// NSNumber -> scalar numeric value로 바꿔줌
enum CornerConstants {
    static let gradientLocation = [Int](0..<BorderColor.gradientColors.count)
        .map { NSNumber(value: Double($0)) }
    
    static let cornerRadius: CGFloat = 20.0
    static let cornerWidth: CGFloat = 1.0
//    static let viewSize = CGSize(width: 100, height: 350)
}

//protocol CustomCellDelegate {
//    func hartButtonClicked(for index: Int, like: Bool)
//}

// TODO: delegate patternにRefactoring 途中

// TODO: // click했을때, 빙글빙글 도는 테두리 애니메이션 효과 만들기


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
    
    private var timer: Timer?
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    private var alreadyCellClicked: Bool = false
    
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
        
        // ⚠️ Error: scroll을 하게 되면 클릭해준 테두리 색깔이 안보여짐.
        if selected {
//            animateBorderGradation()
            if !alreadyCellClicked {
                alreadyCellClicked = true
                self.layer.borderWidth = 2
                self.layer.borderColor = UIColor.blue.cgColor
            } else {
                alreadyCellClicked = false
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.lightGray.cgColor
            }
        } else {
            alreadyCellClicked = false
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
    
    // 모서리 부분이 제대로 표시가 안됨..
    func animateBorderGradation() {
        // 경계선에만 색상을 넣기 위해서 CAShapeLayer를 사용
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(
            roundedRect: self.bounds.insetBy(dx: CornerConstants.cornerWidth, dy: CornerConstants.cornerWidth),
            cornerRadius: self.layer.cornerRadius
        ).cgPath
        shape.lineWidth = CornerConstants.cornerWidth
        shape.cornerRadius = CornerConstants.cornerRadius
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        // conic 그라데이션 효과를 주기 위해 CAGradientLayer 사용
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .conic
        gradient.colors = BorderColor.gradientColors.map(\.cgColor) as [Any]
        gradient.locations = CornerConstants.gradientLocation
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shape
        gradient.cornerRadius = CornerConstants.cornerRadius
        self.layer.addSublayer(gradient)
        
        // 0.2초마다 마치 circular queue처럼 색상을 번갈아가면서 바뀌도록 구현
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
            gradient.removeAnimation(forKey: "myClickAnimation")
            let previous = BorderColor.gradientColors.map(\.cgColor)
            let last = BorderColor.gradientColors.removeLast()
            BorderColor.gradientColors.insert(last, at: 0)
            let lastColors = BorderColor.gradientColors.map(\.cgColor)
            
            let colorsAnimation = CABasicAnimation(keyPath: "colors")
            colorsAnimation.fromValue = previous
            colorsAnimation.toValue = lastColors
            colorsAnimation.repeatCount = 1
            colorsAnimation.duration = 0.2
            colorsAnimation.isRemovedOnCompletion = false
            colorsAnimation.fillMode = .both
            gradient.add(colorsAnimation, forKey: "myClickAnimation")
        })
    }
    
}


