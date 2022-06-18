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

// 文字に関するコンテンツは、文字数ほど大きさが決まっているのに対し、imageの場合は、imageを入れるまでは大きさのsettingができない. そのため、imageを入れてからsizeの設定を行うこと！

// 複数のimageを同じサイズで調整したい -> 同じ系統のimage Viewをstack viewでくくり、その中の一つのobjectを選択してratioなどのsizeをいじればstack内の他のimage UIも指定したサイズに変わる。

class MyIDViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    //Outletにつながっている変数にdidSetをするということの意味: 画面が生成され、このコードが繋がる時点でdidSetが呼び出される
    //　初めて実行されるコード
    @IBOutlet weak var nextButton: UIButton!
//    {
//        didSet {
//            nextButton.isEnabled = false
//        }
//    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // next Button Debugging Way1:
//        // 最初から不可とする
//        nextButton.isEnabled = false
        

        // target: 実行すべきfunctionをどこで探すか?
        // ここのClassで探すから、self
        // 後ろのfor: UIControlのeventを起こすパラメータ
        // editingChanged -> 文字が新しく入力されたり、消されたいするたびにEventを与えるという意味
        // そのeventをselectorで選んだfuncに与える!という仕様になっている
        // ここでは、emailTextFieldのclassである UITextField!typeをそのままselectorのメソッドに引き渡す
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        // next Button Debugging Way2:
        // eventの条件checkを用いる
        // 作ったlogicをReuseする方法
        textFieldDidChange(sender: emailTextField)
        
    }
    
    //#selectorは @objc　(objective-Cのkeyword)が一緒になければならない
    
    @objc func textFieldDidChange(sender: UITextField) {
//        // textField.textは書かれているtextを指す
//        print(sender.text ?? "")
        
        // 以下のコードだと、一番最初に表示されるとき、textFieldに何も入力されてないのに、next Buttonが押せるようになっている (Bug発生❗️)
        // なぜ？: viedDidLoad()で、emailTextFieldのコードで何もしてないからevent自体も引き渡されてない状態だから
        if sender.text?.isEmpty == true {
            // textがemptyだったら、nextButtonは使用不可能とする　（isEnabled = false）
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }

    
}
