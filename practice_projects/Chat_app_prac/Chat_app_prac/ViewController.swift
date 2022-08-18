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
// ---> ❗️難しい


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
    @IBOutlet weak var chatTableViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var inputCustomView: UIView!
    
    private var appearKeyboard: Bool = false
    private var dismissKeyboard: Bool = false
    
    //DataModelsを設定して、ここの内容がcellに格納されるように
    // APIによるJson Parsingを使わずにした方法
    
    // 入力されたStringを保存する場所
    var chatDatas = [String]()
    //　日付の保存
    var chatDates = [String]()

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
    
    // scroll効果は、一番下にあるときは、無視するようにしたい
    @IBAction func sendString(_ sender: UIButton) {
        // inputTextView.text -> chatDatasに格納
        chatDatas.append(inputTextView.text)
        // Sendしたら、textViewの内容を初期化する
        inputTextView.text = ""
        
        let curDate = Date()
        let formatter = DateFormatter()
        // HH: 24時間表記
        // hh: 12時間表記
        formatter.dateFormat = "HH:mm"
        
        let dateString = formatter.string(from: curDate)
        chatDates.append(dateString)
        
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
        guard appearKeyboard == false else {
            return
        }
        let notiInfo = noti.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        // これだけだと、safeAreaのheightも追加されて現れる
        let keyboardHeight = keyboardFrame.size.height
        // safeAreaのbottomのspaceを指定し、この値をheightから引くようにする
        let safeAreaBottom = self.view.safeAreaInsets.bottom
        
        let shownKeyboardHeight = keyboardHeight - safeAreaBottom
//        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: shownKeyboardHeight, right: 0)
        let moveY = chatTableView.contentOffset.y + shownKeyboardHeight
//        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
//        self.chatTableView.contentInset = insets
//        self.chatTableView.scrollIndicatorInsets = insets
        //keyboardが現れる時間を指定
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
//        // MARK: keyboardが上がるとき、chatの内容を一番下のものを表示する (Scrollになっている)
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.inputViewBottomMargin.constant = height - safeAreaBottom
//            self.view.layoutIfNeeded()
//        }) { (complete) in
//            if self.chatDatas.count > 0 {
//                self.chatTableView.scrollToRow(at: IndexPath(item: self.chatDatas.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
//                self.view.layoutIfNeeded()
//            }
//        }
        
        appearKeyboard = true
        // MARK: keyboardの高さに合わせてtableViewのoffsetも自動的に上に上がる
        UIView.animate(withDuration: animationDuration) {
            self.inputViewBottomMargin.constant = shownKeyboardHeight
            print("contentOffset.y: ", self.chatTableView.contentOffset.y)
            print("chatTableViewHeight: ", self.chatTableView.frame.height)
            print("keyboardHeight: ", keyboardHeight)
            print("shownKeyboardHeight: ", shownKeyboardHeight)
            
//            if self.chatTableView.contentOffset.y != 0 {
//                self.chatTableView.contentOffset = CGPoint(x: 0, y: moveY)
//                self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                self.chatTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            }
            self.chatTableView.contentOffset = CGPoint(x: 0, y: moveY)
            self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.chatTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            self.view.layoutIfNeeded()
            
        }
        // ⚠️ERROR: text入力をした時、再び上のcontentOffsetが上に上がる

        
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        guard appearKeyboard == true else {
            return
        }
        
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        // safeAreaのbottomのspaceを指定し、この値をheightから引くようにする
        let safeAreaBottom = self.view.safeAreaInsets.bottom
        
        let shownKeyboardHeight = keyboardHeight - safeAreaBottom
//        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: shownKeyboardHeight, right: 0)
        let moveY = chatTableView.contentOffset.y - shownKeyboardHeight

        // textViewに入力すると、その分また、以下のコードが実行され、contentOffsetが上に上げることになる
        appearKeyboard = false
        UIView.animate(withDuration: animationDuration) {
            self.inputViewBottomMargin.constant = .zero
            print("contentOffset.y: ", self.chatTableView.contentOffset.y)
            print("chatTableViewHeight: ", self.chatTableView.frame.height)
            
            if self.chatTableView.contentOffset.y != 0 {
                self.chatTableView.contentOffset = CGPoint(x: 0, y: moveY)
                self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.chatTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
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
            myBubbleCell.date.text = chatDates[indexPath.row]
            
            
            return myBubbleCell
        } else {
            // 奇数
            // 相手が送信したcell
            let yourBubbleCell = tableView.dequeueReusableCell(withIdentifier: "YourBubbleCellID", for: indexPath) as! YourBubbleCell
            yourBubbleCell.selectionStyle = .none
            yourBubbleCell.yourTextView.text = chatDatas[indexPath.row]
            yourBubbleCell.date.text = chatDates[indexPath.row]
            
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
