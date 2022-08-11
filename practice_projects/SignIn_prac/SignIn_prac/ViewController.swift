//
//  ViewController.swift
//  SignIn_prac
//
//  Created by Kyus'lee on 2022/08/10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            // 入力したPasswordが表示されないように
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    // email, Pw Errorは、動的に表示されるようにする必要がある
    @IBOutlet weak var emailErrorMsg: UILabel!
    
    @IBOutlet weak var passwordErrorMsg: UILabel!
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            // buttonの生成時点で、角を丸くする
            signInButton.layer.cornerRadius = signInButton.bounds.height / 2
            
        }
    }
    
    
    @IBAction func signInPresentPopup(_ sender: Any) {
        
        
        // 作ったstoryboard fileの名前を入力
        let storyboard = UIStoryboard.init(name: "signInSuccessViewController", bundle: nil)
        // Idenfier を入力
        let popupVC = storyboard.instantiateViewController(withIdentifier: "signInSuccessViewControllerID")
        
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        
        self.present(popupVC, animated: true, completion: nil)
    }
    
    
    // 全域変数として emailErrorの heightConstraintを入れる
    var emailErrorHeight: NSLayoutConstraint!
    // passwordのheight Constraint
    var passwordErrorHeight: NSLayoutConstraint!
    
    // 全域変数にすることで、変更される値をずっと保持するように
    var emailValid: Bool = false
    var pwValid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sign in logic
        // textFieldは、textFieldが変更されるのを感知するものがない catchができない (delegateでも)
        // addTarget:当てはまるobjectをselectしたfuncに渡すことができる。つまり、 特定のeventが生じたとき、実行されるようにする
        // editingChanged: textfieldの値(入力された値)が変わるたびに、処理を行うということ。
        
        emailTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        emailErrorHeight = emailErrorMsg.heightAnchor.constraint(equalToConstant: 0)
        emailErrorHeight.isActive = true
        passwordErrorHeight = passwordErrorMsg.heightAnchor.constraint(equalToConstant: 0)
        passwordErrorHeight.isActive = true
        
        // emailとpasswordが入力されないとbuttonが活性化されないように
        // background: light Grayに
        self.completionButton(isOn: false)
    }
    
    @objc func textFieldEdited(textField: UITextField) {
        // この関数のparameterである'textField'に、addTargetを通して渡されたobjectが渡されるようになる。
        if textField == emailTextField {
            // emailのとき
            print("Email Text Field: \(textField.text ?? "Blank")")
            if isValidEmail(email: textField.text) {
                // trueのとき -> Error　表示されない
                // emailError Labelの高さを0にして、表示されないように
                // これは、ただ設定だけしたため、反映されない
                // .isActive = trueにしないと、反映されない
                // 全域変数にして、共有するsingle tone patternにする
//                let emailErrorHeight = emailErrorMsg.heightAnchor.constraint(equalToConstant: 0)
//                emailErrorHeight.isActive = true
                emailValid = true
                emailErrorHeight.isActive = true
                
            } else {
                // falseのとき -> Error　表示!
                // ⚠️しかし、こうやってheightのconstraintを errorのときとerrorじゃないときの値を異なって設定すると、constraintsが二つできちゃって、constraintsの衝突になる
//                emailErrorMsg.heightAnchor.constraint(equalToConstant: 16).isActive = true
                emailValid = false
                emailErrorHeight.isActive = false
            }
        } else if textField == passwordTextField {
            // Passwordのとき
            print("Password Text Field: \(textField.text ?? "Blank")")
            if isValidPassword(pw: textField.text) {
                // true
                pwValid = true
                passwordErrorHeight.isActive = true
            } else {
                // false
                pwValid = false
                passwordErrorHeight.isActive = false
            }
        }
        
        if emailValid && pwValid {
            self.completionButton(isOn: true)
        }
        
        // Animationの効果を与える
        UIView.animate(withDuration: 0.2) {
            // layoutIfNeeded: 時間の流れに合わせて変化し続けるように
            self.view.layoutIfNeeded()
        }
        
    }
    
    // ❗️MARK: 正規式表現 - Regular Expression_email形式の判断
    func isValidEmail(email: String?) -> Bool {
        guard email != nil else {
            return false
        }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        // %@の@のところに、設定した正規式regEXが入る
        // SELF MATCHES: 設定した正規式に合った入力値が入ったのかを判断
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: email)
    }
    
    func isValidPassword(pw: String?) -> Bool {
        if let hasPassword = pw {
            if hasPassword.count < 8 {
                return false
            }
        }
        
        return true
    }
    
    // buttonのactive statusに応じて、buttonの色を変え、活性化する
    func completionButton(isOn: Bool) {
        switch isOn {
        case true:
            signInButton.isUserInteractionEnabled = true
            signInButton.backgroundColor = .systemBlue
        case false:
            signInButton.isUserInteractionEnabled = false
            signInButton.backgroundColor = .lightGray
        }
    }


}

// MARK: crashにはならないが、consoleに長文のwarningが表示されるときのDebug
// 1. consoleの長いwarning文から、try this! の下のところに書いてあるものが肝心である。
// つまり、そこに書いてあるErrorから、どのobjectがerrorになっているのかが間接的にわかる

// 2. しかし、1で表示される文書を見ても、ピンと来ないとき(名前が同じものが複数ある、及び、検索してもでてこないとき)は、consoleに命令語を打ち、大雑把に把握することが可能
// ---> consoleの hierarchyをクリックして、メモリ上のキャプチャを行い、１で表示されたメモリアドレスを po 命令語の後に書く  ex) po
