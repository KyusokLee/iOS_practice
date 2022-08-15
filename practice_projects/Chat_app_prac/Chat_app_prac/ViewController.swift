//
//  ViewController.swift
//  Chat_app_prac
//
//  Created by Kyus'lee on 2022/08/14.
//

import UIKit

// ❗️MARK: 追加したい機能 (途中の段階)
// TODO: 日付も現れるように
// 日付ごとのfolderを作り、その日にやりとりしたメッセージだけが保存されるmessage　TableViewを保存するような仕組み
//　しかし、全体のメッセージTableViewがそのまま、保存されるように

// TODO: Keyboardがまだ、一度も上がってないとき -> 最新にメッセージに合わせて textViewとkeyboardが表示されるように


// ⚠️Error: 送信したBubble中のtextViewに上書きができるようになっている -> コードの訂正する必要がある
// 🌈Solution: 各CellのtextViewのobjectが生成される際に、IBOutlet didSetを用いて、isEditable = falseにすればいい
// mainVCで管理することも可能ではあるが、可読性のため、cellの中のobjectのstatus管理は、cellで行うようにしておいた

class ViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView! {
        didSet {
            chatTableView.delegate = self
            chatTableView.dataSource = self
            //cell間のlineを消す
            // viewDidLoadで、tableView全体で行うと、cell間の線を消すことができる
            chatTableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var inputTextView: UITextView! {
        didSet {
            inputTextView.delegate = self
        }
    }
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextViewHeight: NSLayoutConstraint!
    
    
    //DataModelsを設定して、ここの内容がcellに格納されるように
    // APIによるJson Parsingを使わずにした方法
    
    // 入力されたStringを保存する場所
    var chatDatas = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ここで、delegateとdatasourceを渡すよりは、関連するもののIBOutletの編数にdidSetで設定してもいい
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
        registerNib()
        addkeyboardObserver()
//        dismissKeyboardByDrag()
        dismissKeyboardByTap()
        
    }
    
    // tableviewでは、なぜかできなかった
//    // tapでkeyboard dismiss
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    @IBAction func sendString(_ sender: UIButton) {
        // inputTextView.text -> chatDatasに格納
        chatDatas.append(inputTextView.text)
        // Sendしたら、textViewの内容を初期化する
        inputTextView.text = ""
        
        //dataが入っても、tableViewが自動的に更新されるわけではない
        // そのため、dataに合わせてtableViewを再び表示させ！というコード
        chatTableView.reloadData()
        
        // ここでは、section1つしか使わない
        // 最後のrowの指定
        let lastIndexPath = IndexPath(row: chatDatas.endIndex - 1, section: 0)
        
        //sendボタンを送信すると、textViewのheightも基本設定である40に自然に戻るように
        inputTextViewHeight.constant = 40
        
//        //⚠️上記のreloadData()のコードだと、たまに不自然なanimationが適用される場合がある
//        // そのため、新しく更新するrowだけを入力するようなコードの書き方を導入するのも一つの方法である。
//        chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.automatic)
        
        // 画面上で見えなくなったら、最新のメッセージに合わせてtableViewが自動にscrollされるようにする
        // TableViewが指定されたRowに合わせて、自動的にscrollされる
        // at: UITableView.ScrollPosition => 指定したindexpathのcellのどの部分に合わせるか
        // bottom -> 入力した全てのtextViewが表示されるようにする必要があるので、bottomに合わせてscrollするように
        chatTableView.scrollToRow(at: lastIndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        
//        // sendButton押した後は、keyboardが下がるように -> chat アプリは続けて入力をする場合が多いので、send buttonを押すたびに keyboardをdismissすることは、非常に非効率的であると判断した
////        dismissKeyboardBySendButton(sender)
//        sender.addTarget(self, action: #selector(dismissKeyboardBySendButton), for: .touchUpInside)
        
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
        
        //keyboardが現れる時間を指定
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        //自然なanimation効果を与える
        UIView.animate(withDuration: animationDuration) {
            // 値は、　constant
            self.inputViewBottomMargin.constant = height - safeAreaBottom
            // animationの時間に合わせて細かく分けて、更新し続けるコード
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
    
    // chat アプリは、前のチャット記録を見ながら、メッセージを入力する場合が多くある
    // そのため、 dragして keyboardをdismissするのは、非効率だと考えられる。
    func dismissKeyboardByDrag() {
        // TableView (list)をdragすると、textViewに送信してないものがあったとしても、keyboardがDismissされる
        self.chatTableView.keyboardDismissMode = .onDrag
    }
    
    func dismissKeyboardByTap() {
        // どこでもtapしたらkeyboardが表示されないように
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboardBySendButton() {
        view.endEditing(true)
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellのinitiatingが必要
        // Cell登録とは異なる
        // TODO: 状況に応じて、返すcellの情報が違う
        // 私が送った場合 ,   相手が送った場合
        if indexPath.row % 2 == 0 {
            // 偶数
            // Cellの選択にあたって、認知される作業 (type casting)
            // 私が送信したcell
            let myBubbleCell = tableView.dequeueReusableCell(withIdentifier: "MyBubbleCellID", for: indexPath) as! CustomCell
//            // cell選択時に、背景色を表示しないように
            myBubbleCell.selectionStyle = .none
            myBubbleCell.myTextView.text = chatDatas[indexPath.row]
            
            
            return myBubbleCell
        } else {
            // 奇数
            // 相手が送信したcell
            let yourBubbleCell = tableView.dequeueReusableCell(withIdentifier: "YourBubbleCellID", for: indexPath) as! YourBubbleCell
            yourBubbleCell.selectionStyle = .none
            yourBubbleCell.yourTextView.text = chatDatas[indexPath.row]
            
            return yourBubbleCell
        }
        
    }


}

// textView関連
extension ViewController: UITextViewDelegate {
    // textViewに入力する度にこのメソッドでtextViewに関する情報を持ってくることができる
    func textViewDidChange(_ textView: UITextView) {
        // contentSize: textViewに書かれている量に合わせたsize
        
        if textView.contentSize.height <= 40 {
            inputTextViewHeight.constant = 40
        } else if textView.contentSize.height >= 100 {
            inputTextViewHeight.constant = 100
        } else {
            // 40 ~ 100間では、contentSizeのheightに合わせてheightを動的に更新していく処理
            inputTextViewHeight.constant = textView.contentSize.height
        }
        
//        // このままだと、contentSizeのheightが 基本FontSizeに合わせてしまうため、不自然なheight調整処理が画面で表示される
//        inputTextViewHeight.constant = textView.contentSize.height
    }
    
    
    
    //⚠️textViewに入力する量に合わせて、textViewのheightが動的に伸びるようなコードが必要
}
