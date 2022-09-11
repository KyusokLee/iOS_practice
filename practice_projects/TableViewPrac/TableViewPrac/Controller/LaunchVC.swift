//
//  LaunchVC.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/28.
//

import UIKit
import Lottie

class LaunchVC: UIViewController {
    
    private var startAnimationView = AnimationView()
    private var button = UIButton()
    private lazy var animationLabel: CLTypingLabel = {
        let label = CLTypingLabel()
        if let hasLabel = customFont {
            label.font = hasLabel
        } else {
            label.font = .systemFont(ofSize: 30, weight: .medium)
        }
        
        // label typing speed
        label.charInterval = 0.05
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimationView = setAnimationView()
        self.view.addSubview(startAnimationView)
        button = dismissButtonConfigure()
        // Viewを追加してから -> constraints設定
        self.view.addSubview(button)
        buttonConstraints(target: button)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.view.addSubview(animationLabel)
        
        
        // animationが終わったらmainVCが表示されるように！
        // completion (finsih後の動作を処理)
        startAnimationView.play { (finish) in
            print("Animation finished!")
            // animationView 削除
            self.startAnimationView.removeFromSuperview()
            self.labelConstraints()
        }
    }
    
    func setAnimationView() -> AnimationView {
        let animationView: AnimationView = .init(name: "6052-checklist")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: self.view.bounds.height / 2)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
    
    func dismissButtonConfigure() -> UIButton {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 100, height: 100)
        button.setTitle("Dismiss View", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        button.layer.cornerRadius = 10
        
        return button
    }
    
    func buttonConstraints(target: UIButton!) {
        // constraints 設定
        target.translatesAutoresizingMaskIntoConstraints = false
        target.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        target.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true) {
            print("dismiss animation View")
        }
    }
    
    func labelConstraints() {
        animationLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        animationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        animationLabel.text = "Check Your To Do"
        animationLabel.tintColor = .black
    }

}
