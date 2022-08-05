//
//  PopupViewController.swift
//  Popup_complex
//
//  Created by Kyus'lee on 2022/08/04.
//

import UIKit

// MARK: StoryBoardを用いたPopUp Viewの実装
// ⚠️Error1: 右上のCheck Buttonに custom imageを入れると、width, height のconstraintsを与えても大きさが設定した値通りに反映されない。
// ✍️理由: iOS15に対応したXcode13からの使用が変わってしまったのが原因であった。UIButtonに新しく Plain, Gray, Tinted, Filledという4つのタイプが追加され、そのうちStoryBoardでボタンを作成すると自動的にPlainタイプになっていることが原因である。

// 🌈Solution1 (backgroundImageに入れる方法):  buttonのimageに入れるのではなく、buttonのbackgroundImageに入れることで、解決可能であった。
// 🌈Solution2: (UIButtonのImageに入れる方法): UIButtonのTypeをCustomに変更し、また、Styleを PlainからDefaultに変更してからimageに入れる。ただし、この設定だけでは、求める通りの大きさがXcode上に表示されない。(実行前) --> 解決方法: Constraintsを設定することで、求めるサイズになっていることが確認できた。

// ⚠️Error2: Buttonにimageを入れたものなのに、ButtonのStyleがPlainだと、Warning: ios custom background for plain button ~ という警告がでる。
// 🌈Solution: 上記のError1の解決策でSolution1でbackgroundにimageを入れたとしても、UIButtonのStyleを Plainから Defaultに変える必要がある。

// 🔥⚠️Important Error3: ボタンの一部が、PopupViewの中にあると、clickの反応があるけど、PopupViewの外に出ている部分をクリックするとなんも反応がない。
// ✍️ 理由: 親のview(SuperView)との階層関係常、中にあるオブジェクトだけを管理するようになっている。そのため、オブジェクトと繋がっているイベント処理が行われない。

// 🌈Solution: PopupViewの中に入れるのではなく、main View(Popup Viewが載せられたView(Popup Viewの親View))に配置させる。つまり、Popup Viewの内からViewの境界線にわたって配置するのではなく、Main ViewからPopup Viewに向けて、境界線にわたって配置するといい。そうすると、Popup Viewの親であるMain ViewがそのbuttonオブジェクトとPopup Viewを管理し、同等な階級を持つオブジェクト同士であるため、buttonのイベントが正常に行われる。


class PopupViewController: UIViewController {
    
    @IBAction func doneAction(_ sender: Any) {
        
        print("Press Done Button")
    }
    
    
    
    
    @IBAction func closePopup(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
