//
//  MusicViewController.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/22.
//

import UIKit

// TODO: 1_ 横scroll collectionViewと 縦scroll tableviewを同じVCで実装したい
// 理由: 色んなアプリでよく見かける構造であるため、使いこなせるようになりたいと思ったから

// MARK: 実装Logic
// TableViewにcellを登録
// 横scrollの部分は mainTableViewのcellに格納する
// 縦scrollでいる部分は、既存と同じようなcell作成方法を用いればよい


class MusicViewController: UIViewController {
    
    @IBOutlet weak var musicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    func setUpTableView() {
        musicTableView.delegate = self
        musicTableView.dataSource = self
    }

}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
