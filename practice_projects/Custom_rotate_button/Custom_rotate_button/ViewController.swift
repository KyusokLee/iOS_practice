//
//  ViewController.swift
//  Custom_rotate_button
//
//  Created by Kyus'lee on 2022/07/17.
//

import UIKit

class ViewController: UIViewController {
    lazy var changeViewBackgroundColor: UIView = {
        let view = UIView(frame: self.view.frame)
        
        
        
        
        return view
    }()
    
    
    
    @IBOutlet weak var customButton: RotateButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //closureの実行部をここで、作成
        customButton.selectTypeCallback = { upDownType in
            print(upDownType)
            if upDownType == .up {
                
            }
        }
        
        //MARK: コードでボタンを載せる方法
//        let myButton = RotateButton()
//        self.view.addSubview(myButton)
//
////        //MARK: Frameを用いて、画面に載せる方法
////        myButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
//
//
//
//
//
//
//        // AutoLayout　設定可能とさせる
//        myButton.translatesAutoresizingMaskIntoConstraints = false
//
//        //MARK: AutoLayoutを用いて、画面に載せる方法
//        //位置の設定
//        // self.view.centerXAnchor : このviewの画面全体のx軸の中心に合わせておくよ！という意味
//        myButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        myButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//
//        //大きさの設定
//        // constraint(equalToConstant): 他のオブジェクトを基準に合わせるのではなく、数値だけ入れたい場合
//        //❗️ widthの値は、中にあるtextとimageで定められるから、textとかimageがあれば、設定しなくていい
////        myButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        myButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        //背景色の設定
//        myButton.backgroundColor = UIColor.orange
//
//        // 入れたい文字の設定
//        myButton.setTitle("My custom button", for: .normal)
//
//        // ボタンのイメージの設定
//        myButton.setImage(UIImage(systemName: "arrowtriangle.down"), for: .normal)
//
//        // MARK: 丸角及び影生成コード
//        myButton.layer.cornerRadius = 15
//        myButton.layer.shadowColor = UIColor.gray.cgColor
//
//        // 影の透明度指定 (0 ~ 1)
//        myButton.layer.shadowOpacity = 1.0
//
//        // 影の位置: 親の位置についていく
////        // CGSize.zero にすると、親の周辺に全体的に影が生成される
////        myButton.layer.shadowOffset = CGSize.zero
//        // 横方向 3, 縦方向 3だけ影を移動させる -> こうすると、右下の影の方がより鮮明になる
//        myButton.layer.shadowOffset = CGSize(width: 3, height: 3)
//
//
//        // 影のブラー程度設定 (0の時、線のように濃い影. 数値が高いほど広がる効果)
//        myButton.layer.shadowRadius = 6

    }


}


