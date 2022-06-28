//
//  OnboardingItemViewController.swift
//  OnboardingViewApp
//
//  Created by Kyus'lee on 2022/06/24.
//

import UIKit


//ここは、一つのPage Viewを modelingしたclass扱い
// pageが複数の場合、このような仕様のVCを作成すればいい
class OnboardingItemViewController: UIViewController {
    
    var mainText = ""
    var subText = ""
    var topImage: UIImage? = UIImage() // Imageがない場合もあるから、Optional値
    
    // privateを用いるこどえ、外部からのアクセスを防ぐ
    // やむをえず、名前が似たような変数になってしまったとすると、混乱するかもしれないから
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var mainTitleLabel: UILabel! {
        didSet {
            mainTitleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            // fontに変化を与えたい場合
            descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topImageView.image = topImage
        mainTitleLabel.text = mainText //　画面のLabelの部分に入力された内容を入れる
        descriptionLabel.text = subText
//        // このようにすると、もともと何も入力されてないと、Labelが表示されるのに、わざわざ空列をいれたため、何も表示されないようになる
//        descriptionLabel.text = subText
        


    }
}
