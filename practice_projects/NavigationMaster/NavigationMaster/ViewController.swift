//
//  ViewController.swift
//  NavigationMaster
//
//  Created by Kyus'lee on 2022/07/31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviTitleImage()
        makeBackButton()

        
    }
    
    func makeBackButton() {
        var backImage = UIImage(named: "arrowR")
        // withRenderingMode(.alwaysOriginal)を適応すると、tintcolorなどの変更点が反映されず、指定したimageが持つoriginal 特性のみを反映することになる
        // .alwaysTemplate: 以降に設定した変更点が反映される
        //⚠️ imageが大きいすぎると、真ん中の領域に配置されてしまう
        backImage = backImage?.withRenderingMode(.alwaysOriginal)
        
        
        // 以下のコードを全部書かないと、back buttonのimageが変わらない
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
//        // 文字の色を設定可能
//        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        // backbuttonのtitleを指定可能
        self.navigationItem.backButtonTitle = ""
        
        
    }
    
    func setNaviTitleImage() {
        //        self.navigationItem.title = "Main View"
                
        //        let logo = UIImageView(image: UIImage(named: "logoSample.jpg"))
        //
        //        // imageの割合をそのまま保持する
        //        logo.contentMode = .scaleAspectFit
        //
        //        logo.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //        logo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //
        //
        //        navigationItem.titleView = logo
                
                let button = UIButton()
        //        button.backgroundColor = .blue
                button.setTitleColor(.blue, for: .normal)
                button.setTitle("custom button", for: .normal)
                button.widthAnchor.constraint(equalToConstant: 120).isActive = true
                button.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                button.addTarget(self, action: #selector(testAction), for: .touchUpInside)
                
                self.navigationItem.titleView = button
    }

    @objc func testAction() {
        print("text Action")
    }

}

