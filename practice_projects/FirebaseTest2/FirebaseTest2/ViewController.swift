//
//  ViewController.swift
//  FirebaseTest2
//
//  Created by Kyus'lee on 2022/07/05.
//

import UIKit
import SnapKit

//Firebase 練習
//SnapKit 練習
// コードでUIを実装した方法
// SnapKitを利用すると、AutoLayout設定に関するコードが簡潔になる


class ViewController: UIViewController {

    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let changeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValue()
        setUpView()
        setConstraints()

    }
    
    //ViewをTapすることで、keyboard dismissする
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UI要素の内容設定
    func setUpValue() {
        nameLabel.text = "Label"
        nameTextField.backgroundColor = .gray
        changeButton.backgroundColor = .blue
    }
    
    // ViewのUIセッティング
    func setUpView() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(changeButton)
    }
    
    // ViewのUIのConstraint（制約）設定
    func setConstraints() {
        changeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            // Viewの真ん中に配置する
        }
            
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(nameLabel)
        }
    }


}

