//
//  VerticalTableViewCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import UIKit

class VerticalTableViewCell: UITableViewCell {
    static let className = "VerticalTableViewCell"
    static let cellID = "VerticalTableViewCellID"
    private var models = [MusicGenre]()

    @IBOutlet weak var musicCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        musicCollectionView.register(UINib(nibName: VerticalCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: VerticalCollectionViewCell.cellID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCollectionView() {
        musicCollectionView.delegate = self
        musicCollectionView.dataSource = self
    }
    
    func configure(with models: [MusicGenre]) {
        // reloadの部分
        self.models = models
        musicCollectionView.reloadData()
    }
    
}

extension VerticalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.cellID, for: indexPath) as! VerticalCollectionViewCell
        
        let model = models[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    // collectionViewに入るcellのsizeの設定
    // sizeが小さかったら、複数の列ができる
    // sizeが大きかったら、一つの列になる
    // Collection View Cellの spacing調整に成功した
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 1行に2つのcellを表示するため、collectionView frameのwidthに3を割って、spacingを10ずつ設定した
        let rowInterval: CGFloat = 10
        let width: CGFloat = ((collectionView.frame.width - rowInterval) / 2)
        return CGSize(width: width, height: width)
    }
    
    // vertical scroll -> 上下のcell間のspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // ⚠️Error: Sizeを指定したあと、なぜか以下のcell spacingは効かない
    // vertical Scroll -> 左右のcell間のspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    
}
