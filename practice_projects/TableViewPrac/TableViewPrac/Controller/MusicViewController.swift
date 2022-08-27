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

// sectionごとにtableviewcellを一つずつ入れる感じ


class MusicViewController: UIViewController {
    
    @IBOutlet weak var musicTableView: UITableView!
    private let mealArray = mealModels
    private let musicGenreArray = musicGenreModels
    // section Titleを格納したArray
    private let sectionTitle: NSArray = [
        "오늘은 무엇을 드실껀가요?",
        "Music Genre",
        "Music Ranking"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        registerCell()
    }
    
    func setUpTableView() {
        musicTableView.delegate = self
        musicTableView.dataSource = self
//        // cell間のlineを無くす
//        musicTableView.separatorStyle = .none
        //区分線を見るために、singlelineを一応設定しておいた
        musicTableView.separatorStyle = .singleLine
        musicTableView.reloadData()
    }
    
    func registerCell() {
        musicTableView.register(UINib(nibName: HorizontalTableViewCell.className, bundle: nil), forCellReuseIdentifier: HorizontalTableViewCell.cellID)
        musicTableView.register(UINib(nibName: VerticalTableViewCell.className, bundle: nil), forCellReuseIdentifier: VerticalTableViewCell.cellID)
        musicTableView.register(UINib(nibName: musicRankingCell.className, bundle: nil), forCellReuseIdentifier: musicRankingCell.cellID)
    }
    
    

}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    // sectionごとに入るrowの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 10
        } else {
            return 1
        }
    }
    
    // sectionの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ✍️該当のfileのpropertyを代入すると、as! castingをしなくてもいいっぽい
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalTableViewCell.cellID, for: indexPath) as! HorizontalTableViewCell
            cell.configure(with: mealArray)
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: VerticalTableViewCell.cellID, for: indexPath) as! VerticalTableViewCell
            cell.configure(with: musicGenreArray)
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: musicRankingCell.cellID, for: indexPath) as! musicRankingCell
            cell.configure()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return UITableView.automaticDimension
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    // cellのheightの定義が必要
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ここのintervalは、cell nibファイルで設定したtrailing、leading spaceにする
//        let interval: CGFloat = 10
//        let width: CGFloat = (UIScreen.main.bounds.width - interval * 2) / 2
        
        switch indexPath.section {
        case 0:
            // carousel collectionViewのところは、heightSizeを直接与える
            return 250
        case 1:
//            return (width + interval * 2) * CGFloat(musicGenreArray.count) / 2
            // ⚠️画面が新しく表示されるたびに、scrollが増えているerror
            return UITableView.automaticDimension
        case 2:
            return 70
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section] as? String
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            return
        case 1:
            return
        case 2:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
    
    
}
