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
        makeRightAlarmButton()
    }
    
    // 画面が表示されるたびに、新しく実行されるメソッド
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviBackgroundDesign()
    }
    
    func makeRightAlarmButton() {
//        // これだけだと、imageの色が元の色とは違うように見える
//        // ❗️解決: -> withRenderingMode(.alwaysOriginal)
//        // AlarmButton
//        let rightButtonImage = UIImage(systemName: "alarm.fill")?.withRenderingMode(.alwaysOriginal)
//        let rightItem = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(rightItemClick))
//
//        // Button2
//        let rightButtonImage2 = UIImage(systemName: "alarm")?.withRenderingMode(.alwaysOriginal)
//        let rightItem2 = UIBarButtonItem(image: rightButtonImage2, style: .plain, target: self, action: #selector(rightItemClick2))
//
//        // 考察: rightItem2とrightItemとのspace(間隔)を縮めたい!
//        // Way1: imageInsets
//        rightItem2.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
//        // Way1. navigationItemに BarButtonItemsを用いて配列として配置させる方法
//        // 順番は、最初の要素が最も右のところに配置される流れ
//        self.navigationItem.rightBarButtonItems = [rightItem, rightItem2]
        
        // SystemImageの大きさを決めるOption: imageを読み込むとき、大きさを調整して持ってくるようにするコード
        // font, size, style, weight調整可能
        // pointSize: imageのsizeを調整
        let config = UIImage.SymbolConfiguration(pointSize: 40)
        
        // Way2. customViewを用いたNavigationItemの配置方法
        let button1 = UIButton()
        button1.setImage(UIImage(systemName: "alarm.fill", withConfiguration: config)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button1.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
        //imageの大きさの調節
        
        let button2 = UIButton()
        button2.setImage(UIImage(systemName: "alarm", withConfiguration: config)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button2.addTarget(self, action: #selector(rightItemClick2), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [button1, button2])
        // .axis: stackViewの方向を設定
        //   .horizontal: 格納した要素が横軸に並ぶ形
        //   .vertical: 格納した要素が縦軸に並ぶ形
        stackView.axis = .horizontal
        // UIStackViewに格納した要素間の間隔の設定
        stackView.spacing = 10
        // .distribution: StackViewの軸(axis)に従い、並べたviewの大きさと位置を定義する
        // .equalSpacing: 均等な間隔の配置をさせる
        stackView.distribution = .equalSpacing
        
        let customItem = UIBarButtonItem(customView: stackView)
        self.navigationItem.rightBarButtonItem = customItem
        
    }
    
    @objc func rightItemClick() {
        print("Right Item Click")
    }
    
    @objc func rightItemClick2() {
        print("Right Item2 Click")
    }
    
    func naviBackgroundDesign() {
        // ios15以降のnavigationBarの色の設定
        // scroll中の色 : scrollEdgeAppearance
        // ⚠️注意: scrollEdgeとstandardの色を同じ色に設定しなきゃいけない
        
        // Pastel Tone Colorの設定:
        // 方法1. barAppearanceを用いた方法
//        let navigationBarAppearance = UINavigationBarAppearance()
//        // ⚠️Paste Toneの色が反映されない件について..
//        //🌈:backgroundEffectを設定するか否かによって、表示される色も異なるので、適切に設定すること
//        navigationBarAppearance.backgroundEffect = .init(style: .light)
////        navigationBarAppearance.configureWithDefaultBackground()
//
//
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationController?.navigationBar.backgroundColor = .red.withAlphaComponent(0.3)
        
//        // status 領域とnavigation領域の色を別々に設定する
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // 方法2. withAlphaComponentの設定で、pastel tone colorの実現可能
        self.statusBar?.backgroundColor = .red.withAlphaComponent(0.3)
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

