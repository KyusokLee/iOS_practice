//
//  ViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/04.
//


// Passing Data (データを引き渡す方法)

       
// 以下の6つは全部使う方式なので、状況に合わせて使う必要がある。
// そのため、開発する時にちゃんと工夫して状況によってどっちがいいものかを決めてから、使うことが良い
// 1. Instance Property -> 最も基本的なStep
// 2. Segue -> 複数のViewControllerが一つのstoryboardにいるとき、よく使われる方法
// 3. Instance -> 持っているinstanceを全部引き渡す

// ⬇️　以下の方式は、呼び出し部とmain部が異なるVCで実装される形
// 4. Delegate (delegation) pattern -> 権限の委任、代理
// 5. Closure pattern (delegateと似ている)
// 6. Notification (4, 5と似ている) ->
//  どこかに（IBActionfuncなどの) 従属している部分を作る方式ではなく、独自に実装部分を作る方式



import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ⭐️Notificationの実装部(main部)
        // ❗️他のVCで呼び出し部を定義することにする
        
        // Notification.Name(" ~~~ ")の ~~~部分がkey pointとなる
        // ~~~で何かが呼び出されたら, @objc func showSomeStringが実行される構造となっている
        // ここで、addObserverの objectの意味は、受け取りたい通知を発行するオブジェクトである。すなわち、nilにすると、全部のオブジェクトが発行する通知する対象とするということ！
        
        let notificationName = Notification.Name("sendSomeString")
        NotificationCenter.default.addObserver(self, selector: #selector(showSomeString), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow() {
        print("will show")
    }
    
    @objc func keyboardDidShow() {
        print("did show")
    }
    
    @objc func showSomeString(notification: Notification) {
        // Notificationにselectされることが可能な間数である！ことを指定!!
        //
        //usefInfo は、key, value　形式のdictionary型である
        if let str = notification.userInfo?["str"] as? String {
            self.dataLabel.text = str
        }
    }
    
    @IBOutlet weak var dataLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 一つのstoryboardからは複数のsegue(繋げてあげた矢印)が出ることが可能
        // segueの名前を指定することで、segueの識別が容易になる
        if segue.identifier == "segueDetail" {
            // データを引き渡す時には、該当するviewControllerが必要である
            // つまり、目的地のinstanceがなければいけない
            if let detailVC = segue.destination as? SegueDetailViewController {
                //detailVC.dataLabel.text = "abcd" // -> Error! になる 理由: 画面に出る準備ができてない状態でIBOutletにアクセスしたから
                
                //IBOutletに直接アクセスせずに、普通のproperyにアクセスしてデータを引き渡す方法
                detailVC.dataString = "abcd"
            }
        }
    }
    

    @IBAction func MovetoDetail(_ sender: Any) {
        // 画面のinstance　生成
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        
        detailVC.someString = "aaa String"
        // 下記で書いた someLabelがなかったら、これが表示される
        // ① detailVC.someLabel.text = "bb" --> Error! (Crash)❗️になる
        //  🌱理由: 画面に載せる準備をしていない状態では、該当画面にあるものがメモリにまだ載せられてないから、上記の命令はnil になる
        
        
        
        // present : 画面に載せる作業を命令
        self.present(detailVC, animated: true, completion: nil)
        
        detailVC.someLabel.text = "bb" // -> Success!⭕️
        // detailVC.someLabel.text = detailVC.someString だったら、上記で入れといた aaa Stringが表示される
        
        // 画面に載せる作業 (present)の後なら Crashにならない
        // 🎓ただし、このような直接な引き渡しは 上記の①のようなCrashができるミスをする可能性が高いため、直接な引き渡しを使う場合は結構少ない
    }
    
    @IBAction func moveToInstance(_ sender: Any) {
        let detailVC = instanceDetailViewController(nibName: "instanceDetailViewController", bundle: nil)
        
        //Back　ボタンみたいに 移動先のViewControllerに 移動前のViewControllerにもどるようなpropertyを　設けて、以下のようにselfをすると、pointerが この移動前の画面に戻る
        // つまり、画面を切り替え、その画面で何かをして、元の画面にデータを引き渡したい場合 以下のようなコードを書くのである
        // detailVC.mainVCの　Type: ViewController
        detailVC.mainVC = self
        // 自分自身（ViewController）を引き渡す。そのため、自分自身に関する全てにアクセス、使用可能となる
        
        // ⭐️上記のコードがないと、変更が反映されない -> instanceDetailVCに行って、変更したデータを受け取るコードである
        // instanceDetailViewControllerの mainVCインスタンス　につなげる
        // 上記のコードが self.presentの下に書いてあっても別に構わない
        
        //自分自身を表示する
        //以下のコードがないと、ボータンを押しても instanceDetailVCの画面が表示されない
        self.present(detailVC, animated: true, completion: nil)

    }
    
    @IBAction func moveToDelegate(_ sender: Any) {
        //インスタンス化
        // Mainからdetailに移動できるインスタンスのコード
        let detailVC = DelegateDetailViewController(nibName: "DelegateDetailViewController", bundle: nil)
        
        //delegateと他のpassing dataの方法との違い
        // 上記で書いた detailVC.mainVC = selfのような 文法は、そのselfの当てはまるtypeの全てがアクセス可能となる
        
        // 一方、delegateは　下記のextensionで書いたように、selfの当てはまる特定したProtocol typeの内容だけアクセス可能とする。
        // つまり、このdelegateは、extensionの方だけアクセスできることになる
        detailVC.delegate = self
        
        //画面表示
        self.present(detailVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func moveToClosure(_ sender: Any) {
        let detailVC = ClosureDetailViewController(nibName: "ClosureDetailViewController", bundle: nil)
        // xibで作ったから、nib基盤のnameを書く
        
        //⭐️ここで、closureのmain部を定義する
        //✍️すなわち、closureとdelegateの場合、呼び出し先は、それぞれのviewcontrollerであっても、その内容を定義したのは、mainVCであるため、mainVCで表示されるのである。
        // 今回の場合、その証明をmainVCの datalabel (UILabel)で確認できる
        
        detailVC.myClosure = { str in
            self.dataLabel.text = str
        }
        
        self.present(detailVC, animated: true, completion: nil)
        
    }
    
    @IBAction func moveToNoti(_ sender: Any) {
        // Notificationも同じく、画面の移動の部分はbutton action部分で定義する
        // ただし、その実装部はここの間数に従属されるのではなく、独自に作られた部分にある
        let detailVC = NotiDetailViewController(nibName: "NotiDetailViewController", bundle: nil)
        self.present(detailVC, animated: true, completion: nil)
    }
    
    
}



// class ViewController: UIViewController, DelegateDetailViewController { ~ にしても構わない
//上に一緒に書いてもいいけど、こっちの方が綺麗に見れるからこの方法で作成した
// ここで、protocolがもつ関数のbodyが生成される
extension ViewController: DelegateDetailViewControllerDelegate {
    
    func passString(string: String) {
        self.dataLabel.text = string
    }
    
    
    
}
