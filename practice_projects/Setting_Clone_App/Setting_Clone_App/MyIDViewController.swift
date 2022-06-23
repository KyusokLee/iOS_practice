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
    
    @IBOutlet weak var customNameTextField: UITextField!
    
    var activateTextField: UITextField!
    
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldDelegate()
//        addKeyboardNotifications()
        
        
        
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
        customNameTextField.addTarget(self, action: #selector(customNameCheckerTextField), for: .editingChanged)
        customNameCheckerTextField(sender: customNameTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //#selectorは @objc　(objective-Cのkeyword)が一緒になければならない
    @objc func textFieldDidChange(sender: UITextField) {
//        // textField.textは書かれているtextを指す
        print(sender.text ?? "")
        
        // 以下のコードだと、一番最初に表示されるとき、textFieldに何も入力されてないのに、next Buttonが押せるようになっている (Bug発生❗️)
        // なぜ？: viedDidLoad()で、emailTextFieldのコードで何もしてないからevent自体も引き渡されてない状態だから
        if sender.text?.isEmpty == true {
            // textがemptyだったら、nextButtonは使用不可能とする　（isEnabled = false）
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    @objc func customNameCheckerTextField(sender: UITextField) {
        if sender.text?.isEmpty == true {
            print("Please enter text.")
        } else {
            if sender.text == "KyuLee" {
                print("He is the owner of this App!!")
            }
        }
    }
}

extension MyIDViewController: UITextFieldDelegate {
    func setTextfieldDelegate() {
        emailTextField.delegate = self
        customNameTextField.delegate = self
        emailTextField.tag = 1
        customNameTextField.tag = 2
    }
    
    // textField 複数の場合 処理を行うtextfieldを指定する
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activateTextField = textField
        // 確認のためのtag
        print(activateTextField.tag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //return ボタン押すと仮面から消える
        activateTextField.resignFirstResponder()
        return true
    }
    
    func addKeyboardNotifications() {
        // イベント処理のobserver 登録
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //　⚠️問題: keyboardを入力すると黒い画面が上に上げる現象が生じた --> 解決!!!⭐️
    @objc func keyboardWillShow(notification: Notification) {
        //下の方にあるtextField -> keyboardにviewが隠されてしまう
        // その現象を解決するために、textFieldの条件分岐を用いて、keyboardのheight分ほどviewを上に上げる処理をする
        
        if activateTextField.tag == 2 {
            //keyboardのheightまで上げるのではなく、適切に上げる
            if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                //withDuration: 時間の間隔を設定
                UIView.animate(withDuration: 0.3, animations: {
                    // textFieldのheightを調査して適切に調査した方法
                            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 200)
                    })
                }
        }
//
//        else {
        // 少しの間の画面の揺れができちゃう
        // y方向に上に50ほどviewを移動させるということ
        // しかし、viewはここで、決まっているので上に行かない
//            self.view.transform = CGAffineTransform(translationX: 0, y: -50)
//        }
        
//        if activateTextField.tag == 2 {
//            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                let keyboardRectangle = keyboardFrame.cgRectValue
//                let keyboardHeight = keyboardRectangle.height
//                self.view.frame.origin.y -= keyboardHeight
//            }
//        } else {
//            self.view.transform = CGAffineTransform(translationX: 0, y: -50)
//        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.transform = .identity
//        //上にあげたviewを元に戻す
//        if activateTextField.tag == 2 {
//            if self.view.window?.frame.origin.y != 0 {
//                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                    let keyboardRectangle = keyboardFrame.cgRectValue
//                    let keyboardHeight = keyboardRectangle.height
//                    UIView.animate(withDuration: 1, animations: {
//                        self.view.window?.frame.origin.y += keyboardHeight
//                    })
//                }
//            }
//        } else {
//            self.view.transform = .identity
//        }
    }

    func removeKeyboardNotifications() {
        //observer解除することで、メモリを効率的に削除できる
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
