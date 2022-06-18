//
//  MyIDViewController.swift
//  Setting_Clone_App
//
//  Created by Kyus'lee on 2022/06/18.
//

import UIKit
// UIViewControllerをnib(xib)ファイルと共に新しく生成するときは、viewControllerじゃなくview　nibファイルが同時に生成される。そのため、placeholdersのFile's Ownerの Attributes Inspectorを見ると、classの名前が勝手に作ったクラスの名前になっている。
// また、Labelに書いた文字が長すぎると、linesに全部表示されず、 ... になってしまうから、linesの部分を0にすると、viewに表示されるlineが勝手に表示される。
// 指定したい場合は、1とか2とか指定しるする！
// textFieldは、基本的に1行の入力を受け取るUI
// textFieldはplaceHolderというものがあり、これは入力を受け取る前にぼんやりと表示される text Guide Lineのことを指す。
// trailingは、右　　allignは左
// 線(Line)をviewに表示したいとき -> 一般的にviewを追加し、大きさを調整して使う方法がある
//  また、そのviewから右クリックしてdragして、位置を合わせたいObjectに連結させて位置を整列する


class MyIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
}
