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





import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
    
}

