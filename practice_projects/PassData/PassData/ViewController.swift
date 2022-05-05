//
//  ViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/04.
//


// Passing Data (データを渡す方法)
// 6つ
// 1. instance property -> 最も基本的なStep
// 2. segue -> 複数のViewControllerが一つのstoryboardにいるとき、よく使われる方法
// 3. instance -> 持っているinstanceを全部引き渡す
// 4.
// 5.
// 6.



import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        // ① detailVC.someLabel.text = "bb" --> Error! (Crash)❗️になる
        //  🌱理由: 画面に載せる準備をしていない状態では、該当画面にあるものがメモリにまだ載せられてないから、上記の命令はnil になる
        
        
        
        // present : 画面に載せる作業を命令
        self.present(detailVC, animated: true, completion: nil)
        
        detailVC.someLabel.text = "bb" // -> Success!⭕️
        // 画面に載せる作業 (present)の後なら Crashにならない
        // 🎓ただし、このような直接な引き渡しは 上記の①のようなCrashができるミスをする可能性が高いため、直接な引き渡しを使う場合は結構少ない
    }
    
    @IBAction func moveToInstance(_ sender: Any) {
        let detailVC = instanceDetailViewController(nibName: "instanceDetailViewController", bundle: nil)
        
        //Back　ボタンみたいに 移動先のViewControllerに 移動までのViewControllerにもどるようなpropertyを　設けて、以下のようおにselfをすると、pointerが この移動前の画面に戻る
        // つまり、画面を切り替え、その画面で何かをして、元の画面にデータを引き渡したい場合 以下のようなコードを書くのである
        detailVC.mainVC = self
        // ⭐️上記のコードがないと、変更が反映されない -> instanceDetailVCに行って、変更したデータを受け取るコードである
        // instanceDetailViewControllerの mainVCインスタンス　につなげる
        // 上記のコードが self.presentの下に書いてあっても別に構わない
        
        //自分自身を表示する
        //以下のコードがないと、ボータンを押しても instanceDetailVCの画面が表示されない
        self.present(detailVC, animated: true, completion: nil)

    }
}

