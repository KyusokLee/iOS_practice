//
//  ViewController.swift
//  Popup_complex
//
//  Created by Kyus'lee on 2022/08/04.
//

import UIKit

// 🌈透明度に関する理解
// Opacity と　Alphaの違い
// Opacityは、そのviewのみの透明度を調整する
// Alphaは、そのview上にある全てのオブジェクトの透明度を変更する


class ViewController: UIViewController {

    
    @IBAction func showPopup(_ sender: Any) {
        // PopupViewController
        let storyboard = UIStoryboard.init(name: "PopupViewController", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "PopupVC")
        
        // 🌈modalPresentaionStyle: 画面をどのような形で表示させるかのStyleを提供する。
        // 🔥overCurrentContext: 透明するとともに、後ろのviewも微かに表示されるように
        // つまり、mainVCが popupVCの後ろに見れるようにする
        // ただし、必ずOpacityの設定があってから、以下のコードを作成すること
        // そうしないと、後ろのviewが見えない
        popupVC.modalPresentationStyle = .overCurrentContext
        
        
        // 🌈modalTransitionStyle: 画面が転換されるときのStyle効果を提供する。animation Styleの設定可能
        // .crossDissolve: ゆっくりと消えるスタイルの設定
        popupVC.modalTransitionStyle = .crossDissolve
        
        // ⭐️Tip: modalTransitionStyleだけだと、ナチュラルなCrossDissolveStyleの画面の転換にならなかった。crossDissolve自体は、画面を交差するようなanimationであるため、overCurrentContextと一緒に書かないと、後ろのviewが小さくなり、popupViewが表に大きくでるような交差効果になる。
        
        self.present(popupVC, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

