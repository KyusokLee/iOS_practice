//
//  ClosureDetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/06/15.
//

import UIKit

class ClosureDetailViewController: UIViewController {
    
    // funcでは、returnがない場合に何も書かなくてよかったが、closureでは Voidを書くことで returnがないことを表す必要がある。Voidの代わりに () -> ()でもいいが、最近はVoidの方が使われている雰囲気
    // 何も受け取らない(引数なし) 、 return なし
//    let myClosure: () -> Void = {
//
//    }
    var myClosure: ((String) -> Void)?
    // typeがclosureである　closure変数
    // delegateと似たように、データがない場合も、ある場合もあり得るので、optionalにしておく

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func closurePassData(_ sender: Any) {
        // ❗️データを引き渡すclosureの呼び出し部分はあるが、main　（定義した部分）がない
        myClosure?("closure string")
        self.dismiss(animated: true, completion: nil)
    }
    

}
