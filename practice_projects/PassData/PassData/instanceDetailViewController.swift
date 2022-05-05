//
//  instanceDetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/04.
//

import UIKit

class instanceDetailViewController: UIViewController {
    // また、viewControllerに戻るようなpropertyを作ることで、Back Buttonの実装ができる
    var mainVC: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func sendDataMainVC(_ sender: Any) {
        // このボタンを押すと、main ViewController の datalabel　インスタンスの文字列が some data に変わる
        // しかし、ボタンを押さず、指でただscroll downすると、文字列も変わらないし、dismiss animated効果が適用されない -> つまり、ボタンを押さなければ以下の命令は実行されないということ！
        mainVC?.dataLabel.text = "some data"
        self.dismiss(animated: true, completion: nil) //画面scroll downのメッソド
    }
    
}
