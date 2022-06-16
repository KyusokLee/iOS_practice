//
//  ViewController.swift
//  QueueExample
//
//  Created by Kyus'lee on 2022/06/15.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    
    // Dispatch Queue
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.timerLabel.text = Date().timeIntervalSince1970.description
            // description : timeIntervalSince1970(数字に現れる内容)をString型に変換する
        }
        
    }
    @IBAction func action1(_ sender: Any) {
        //１番目のボタン
//        finishLabel.text = "End"
        simpleClosure {
//            self.finishLabel.text = "End"
//            // UILabelみたいなのは、必ず main Threadで作動するようにしておく！
            // 下記のような書き方でもいい
            DispatchQueue.main.async {
                self.finishLabel.text = "End"
            }
            
        }
    }
    
    // closureの間数を生成
    func simpleClosure(completion: @escaping () -> Void) {
        
        // main Threadではない、他の作業者
        // 検索した結果: global()は普段、backgroundで作業されるという説明が多かった
        DispatchQueue.global().async {
            
            for index in 0..<10 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
            
//            DispatchQueue.main.async {
//                // finishLabelのtextを "End"に変えるためには main Threadが担当
//                completion()
//            }
//            // 内部から外部に出せる必要があるので、escaping必要
            completion()
            
        }
        
        
        
//        // Appに対する全てのLife Cycleを総括するのが Threadである
//        // 以下のコードままだと生じる問題:
//        // Main Threadを sleepさせたため、timeLabelを含めた全てが止まってしまう
//        // Scroll 、　ボタン押しもできたくなり、appが死んでるように見える
//
//        //そのため、作業が長いのは現在のthreadで全部作動できるようには作らない
//        // 作業者が一人だけだと、全ての動作を待ってから次の動作をするようになる
//        // 解決:-> Threadを複数作ればいい！　作業者が増える！というふうに捉えばいい!
//        // AとBという人がいれば、Aが担当する作業の現状に関わらず、Bはその作業を待たずに他の作業をすることができる
//        for index in 0..<10 {
//            // スレッドを0.2ずつ止めるコード
//            // ここでは、Main Threadを意味
//            Thread.sleep(forTimeInterval: 0.2)
//            print(index)
//        }
//
//
//        // 実行部だけここに書く
//        // main部は使おうとするところで定義する
//        completion()
    }
    
    @IBAction func action2(_ sender: Any) {
        let dispatchGroup = DispatchGroup() // Groupにすることも可能
        
        let queue1 = DispatchQueue(label: "q1")
        //では、作業者を増やしてみよう!
        let queue2 = DispatchQueue(label: "q2")
        let queue3 = DispatchQueue(label: "q3")

        
//        // 以下のように書くと、同時に処理が行われない. 順番通りに処理される
//        // 理由: queue1という一つの作業者に以下の全ての作業を一度にあげたから、順番通りに処理が行われる
//        // このようにすると、asyncではなく　syncになってしまう
//        queue1.async(group: dispatchGroup) {
//            for index in 0..<10 {
//                Thread.sleep(forTimeInterval: 0.2)
//                print(index)
//            }
//        }
//        queue1.async(group: dispatchGroup) {
//            for index in 10..<20 {
//                Thread.sleep(forTimeInterval: 0.2)
//                print(index)
//            }
//        }
//        queue1.async(group: dispatchGroup) {
//            for index in 20..<30 {
//                Thread.sleep(forTimeInterval: 0.2)
//                print(index)
//            }
//        }

        //では、作業者を増やしてから、処理を行うようにしてみよう
        // 結果: 各自に実行されるようになる
        // しかし、作業の内容は他の Threadではなく、ここで進行されるThreadであることを念頭に置くこと！
        // そのため、以下の各自のfor文が終わるまで 各自のqueueブロックは終わらない!
        
        // qos: 優先順位を表す
        // qosを用いて、優先順位を定めたとしても、必ずそのブロックが決めた優先順位通りに処理されるわけではない。
        // ただ、大体その決めた優先順位通りに作業されるよ！ということ
        queue1.async(group: dispatchGroup, qos: .background) {
            // このように書くと、もう一つのThreadが生成されたため、for文の作業が終わるまで待たずに、次のlogicの作業を進めることができる
            // つまり、次のコードブロックに移動することが可能となるっていうこと！
            
            //⬇️各自の処理の現状checkを手動的に行うコード -> 下記の❗️1の問題を防ぐため
            dispatchGroup.enter()
            // こうすることで、一番最後にEND!!が表示される
            DispatchQueue.global().async {
                // 作業を進めると同時に...!
                for index in 0..<10 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                dispatchGroup.leave()
            }
            //....ここに来る！次のlogicが進行される
        }
        queue2.async(group: dispatchGroup, qos: .userInteractive) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                // 作業を進めると同時に...!
                for index in 10..<20 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                dispatchGroup.leave()
            }
            //....ここに来る！次のlogicが進行される
//            // for文が終わるまで、次のlogicの処理が行われない
//            for index in 10..<20 {
//                Thread.sleep(forTimeInterval: 0.2)
//                print(index)
//            }
        }
        
        // qos: default
        queue3.async(group: dispatchGroup) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                // 作業を進めると同時に...!
                for index in 20..<30 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                dispatchGroup.leave()
            }
            //....ここに来る！次のlogicが進行される
//            for index in 20..<30 {
//                Thread.sleep(forTimeInterval: 0.2)
//                print(index)
//            }
        }
        
        // 上記の３つの処理が終わる時点で、終わってるかどうかを知りたい！
        // groupを用いる
        
        // notifyは作業が全部ないときに実行されるコードである
        
        // ❗️1. 各自のqueueにDispatchを入れた場合、END!!!が一番最初に表示される..
        // 理由: 上記で書いたようにDispatchを用いて次のlogicに処理を行かせると、作業すべき処理がないように認知するので、夏季のnotifyが反応してしまう
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("END!!")
        }
        
        
    }
    
    @IBAction func action3(_ sender: Any) {
        
//        // deadlock -> main threadは作業が終わらない
//        DispatchQueue.main.sync {
//            print("main sync")
//        }
        

        let queue1 = DispatchQueue(label: "q1")
        let queue2 = DispatchQueue(label: "q2")
        
        //syncの特徴: 他のThreadをlock（止める）させて、現在のThreadの作業が終わるまで待機させてしまう
        // 同じくqueue1にしても　同様
        queue1.async {
            for index in 0..<10 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
            
//            //deadlock: 相手の作業が終わるまでお互いずっと待つ状態
//            // 上位ブロックがsyncであっても、asyncであってもdeadlock状態になる
            queue1.sync {
                for index in 10..<20 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
            }
        }
        
//        // 次のlogicが重要であるため、そのLogicが実行されるまえに必ず、処理させるlogicがある場合、syncを利用
//        // 代表的な状況例: 金融系 (残高)
//        queue1.sync {
//            for index in 10..<20 {
//                Thread.sleep(forTimeInterval: 0.2)
//                print(index)
//            }
//        }
        
        print("next logic")
        
    }
    
    
    

}

