//
//  ViewController.swift
//  Chat_app_prac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
        registerNib()
        addkeyboardObserver()
        dismissKeyboardByDrag()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    // tableviewでは、なぜかできなかった
//    // tapでkeyboard dismiss
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    @IBAction func sendString(_ sender: Any) {
        
        
    }
    
    // 使おうとするcell全てを登録
    private func registerNib() {
        self.chatTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "MyBubbleCellID")
        self.chatTableView.register(UINib(nibName: "YourBubbleCell", bundle: nil), forCellReuseIdentifier: "YourBubbleCellID")
    }
    
    // Keyboard 関連 Observerを登録
    func addkeyboardObserver() {
        // Keyboardが上がるとき
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Keyboardが下がるとき
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(noti: Notification) {
        let notiInfo = noti.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        // これだけだと、safeAreaのheightも追加されて現れる
        let height = keyboardFrame.size.height
        // safeAreaのbottomのspaceを指定し、この値をheightから引くようにする
        let safeAreaBottom = self.view.safeAreaInsets.bottom
        
        //keyboardが現れる時間の設定
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        //自然なanimation効果を与える
        UIView.animate(withDuration: animationDuration) {
            // 値は、　constant
            self.inputViewBottomMargin.constant = height - safeAreaBottom
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.inputViewBottomMargin.constant = .zero
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func dismissKeyboardByDrag() {
        self.chatTableView.keyboardDismissMode = .onDrag
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellのinitiatingが必要
        // 登録とは異なる
        let cell = UICellConfigurationState(
        
        
        
    }


}
