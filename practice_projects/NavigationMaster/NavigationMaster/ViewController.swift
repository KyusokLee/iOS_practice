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
    
    // 画面が表示されるたびに、新しく実行されるメソッド
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviBackgroundDesign()
    }
    
    func naviBackgroundDesign() {
        // ios15以降のnavigationBarの色の設定
        // scroll中の色 : scrollEdgeAppearance
        // ⚠️注意: scrollEdgeとstandardの色を同じ色に設定しなきゃいけない
        
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithDefaultBackground()
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationController?.navigationBar.backgroundColor = .red
        
//        // status 領域とnavigation領域の色を別々に設定する
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.statusBar?.backgroundColor = .red
    }
    
    
    
    func makeBackButton() {
        // @3x -> 解像度を３倍するということで、実際使われてない文字
        // そのため、arrowRまでが使われるファイルの名前となる
        // 方法1. imageファイル自体のサイズを変更してから、適応した場合
//        var backImage = UIImage(named: "arrowR")
        
        // 方法2. 大きいimageファイルをコード上で設定する場合
        guard let backImage = UIImage(named: "blueCircleArrowR")?.withRenderingMode(.alwaysOriginal) else {
            return
        }
        // withRenderingMode(.alwaysOriginal)を適応すると、tintcolorなどの変更点が反映されず、指定したimageが持つoriginal 特性のみを反映することになる
        // .alwaysTemplate: 以降に設定した変更点が反映される
        //⚠️ imageが大きいすぎると、真ん中の領域に配置されてしまう
//        backImage = backImage?.withRenderingMode(.alwaysOriginal)
        
        let newImage = resizeImage(image: backImage, newWidth: 20, newHeight: 20)
  
        // 以下のコードを全部書かないと、back buttonのimageが変わらない
        self.navigationController?.navigationBar.backIndicatorImage = newImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = newImage
        
//        // 文字の色を設定可能
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        // backbuttonのtitleを指定可能
        self.navigationItem.backButtonTitle = ""
        
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        let newImageRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        // UIGraphicsBeginImageContext(CGSize ~ )絵(image)を描くために、優先的に空の用紙を生成するという概念
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        // imageを用紙に載せる
        image.draw(in: newImageRect)
        
        // renderingmodeをしないままだと、orangeの円だけが表示される
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        // 空の用紙にimageを載せたから、draw作業を終わらせるendに関するコードを書く
        UIGraphicsEndImageContext()
        
        return newImage
        
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

