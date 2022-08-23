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
// 横scrollの部分は mainTableViewのcellに格納する -> HorizontalViewCell
// 縦scrollでいる部分は、既存と同じようなcell作成方法を用いればよい -> Music Cell

// tableViewCell に collection Viewを入れる感じ
// collectionViewの中に collectionViewCellが入ってる感じ


class MusicViewController: UIViewController {
    
    @IBOutlet weak var musicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        registerCell()
    }
    
    func setUpTableView() {
        musicTableView.delegate = self
        musicTableView.dataSource = self
    }
    
    func registerCell() {
        musicTableView.register(UINib(nibName: HorizontalTableViewCell.className, bundle: nil), forCellReuseIdentifier: HorizontalTableViewCell.cellID)
        musicTableView.register(UINib(nibName: VerticalTableViewCell.className, bundle: nil), forCellReuseIdentifier: VerticalTableViewCell.cellID)
    }

}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ✍️該当のfileのpropertyを代入すると、as! castingをしなくてもいいっぽい
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalTableViewCell.cellID, for: indexPath)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: VerticalTableViewCell.cellID, for: indexPath)
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
    
}
