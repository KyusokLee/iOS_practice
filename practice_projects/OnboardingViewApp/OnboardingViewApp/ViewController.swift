//
//  ViewController.swift
//  OnboardingViewApp
//
//  Created by Kyus'lee on 2022/06/24.
//

import UIKit

// Onboarding View　（アプリ使う前の事前説明viewのようなもの）
class ViewController: UIViewController {

    //変数で状態の値を記憶させ、最後のページで"確認"ボタンを押したら、再び pageViewが表示されないようにする
    var didShowOnboardingView = false
    //⚠️永久的にこの値を保存したいなら、localにuserDefaultsを用いて記憶させるものがある -> 今後チャレンジ‼️
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewDidLoad()は、まだ画面が表示されてない状態
        // そのため、以下のようなコードだと、main VCが表示されてもないのに、onboardingVCを表せようとするから、Crashになる
//        let itemVC = OnboardingItemViewController.init(nibName: "OnboardingItemViewController", bundle: nil)
//        self.present(itemVC, animated: true, completion: nil)
    }
    
    
    //🔥viewAppear系統のlifeCycleメソッドは、main VCが見えるたびに呼び出されるメソッドである
    
    
    //画面が表示される寸前の時点に実行される lifeCycle メソッド
    override func viewWillAppear(_ animated: Bool) {
        
        //ここも、viewDidLoad()に書くとエラーが出るのと同様である。crashが発生する
        // ⁉️なんで？: まだ、画面が表示されているわけではない.寸前であるだけ
        super.viewWillAppear(animated)
//        let itemVC = OnboardingItemViewController.init(nibName: "OnboardingItemViewController", bundle: nil)
//               self.present(itemVC, animated: true, completion: nil)
    }
    
    // viewDidAppear: 画面が表示されている状態！であるよ！ということを指す lifeCycle メソッド
    //🔥画面が出たときに、処理すべきことは画面が表示されてから処理すべき!
    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if didShowOnboardingView == false {
            didShowOnboardingView = true
            // ⬇️✍️一つだけのPageを作成した場合
    //        let itemVC = OnboardingItemViewController.init(nibName: "OnboardingItemViewController", bundle: nil)
    //               self.present(itemVC, animated: true, completion: nil)
            
            // nibファイルがない場合は、直接instance化する
            // navigationOrientation: 縦方向か、横方向であるかの指定
            // horizontal: 横方向 (Left, right)
            let pageVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
            
    //        // transitionStyleは、VCとVCの間の移動(transition)のStyleに関連するメソッドである
    //        // transitionStyle: すでに生成されてからだと、変更することはできない概念。
    //        pageVC.transitionStyle = .scroll
            
            //隙間のない全体の画面 Full Screenとして表示させたい！
            //🔥Modal: ユーザーが見ている画面に他の画面を表示させる方式を意味する
            //   画面を完全に切り替えるのではなく、画面を他の画面の上にpresentingして表示する方式。 そのため、Modalは流れを表す時よりは、ユーザーの注意や注目を集める時によく使われる技法。
            // 画面を完全に切り替えるNavigationInterfaceとは全く異なる方式。
            // だからModalに見える画面はできるだけ単純でユーザーが素早く処理できる内容を表現することが良い。
            pageVC.modalPresentationStyle = .fullScreen
            
            self.present(pageVC, animated: true, completion: nil)
        }
        
    }

    
    
}

