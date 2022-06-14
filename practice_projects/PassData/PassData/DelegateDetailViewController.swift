//
//  DelegateDetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/05/08.
//

import UIKit

//protocol : 規約を意味
//    つまり、あるdelegateはそのprotocolに従うよ〜！ということ!
// protocolの中では、funcのmain body部分を作ることはできない .. funcの提示だけできる
protocol DelegateDetailViewControllerDelegate: AnyObject {
    func passString(string: String)
}

class DelegateDetailViewController: UIViewController {
    
    //実装される方(ところ)で、使用し終わったらなくなるようにしたいから、weak var にした。　また、このインスタンス自体がない場合もあるから、Optional にした。
    // weakにしたいなら、Anyobjectを従うProtocolでなければならない
    // あるかないか不確実なため、weakにした
    weak var delegate: DelegateDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MainVCにデータを渡す役割
    // passDatatoMainVCのインスタンスがなくても、アクセスできるようにする -> Delegate
    @IBAction func passDataToMainVC(_ sender: Any) {
        delegate?.passString(string: "delegate pass data")
        self.dismiss(animated: true, completion: nil)
    }
    

}
