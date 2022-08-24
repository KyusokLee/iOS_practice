//
//  HorizontalTableViewCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import UIKit

// 横scrollの tableViewCellの設定
class HorizontalTableViewCell: UITableViewCell {

    static let className = "HorizontalTableViewCell"
    static let cellID = "HorizontalTableViewCellID"
    
    @IBOutlet weak var mealCollectionView: UICollectionView!
    private var models = [Meal]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCollectionView()
        mealCollectionView.register(UINib(nibName: HorizontalCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HorizontalCollectionViewCell.cellID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCollectionView() {
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        // scrollbar を書くす
        mealCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func configure(with models: [Meal]) {
        // reloadDataの部分
        self.models = models
        mealCollectionView.reloadData()
    }
}

// collectionViewのsizeを定めるため、UICollectionViewDelegateFlowLayoutも継承しなきゃいけない  -> これがないと、mainVCでtableViewCellのサイズは正しく表示されても、collectionViewのサイズは定められてないため、表示されないのである。

extension HorizontalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.cellID, for: indexPath) as! HorizontalCollectionViewCell
        let model = models[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    // collectionViewのsizeを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    // ✍️横scrollの場合は、cell間の左右spacingを指定する
    //   縦scrollの場合は、cell間の上下spacingを指定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
//    // ここでは、1行だけのscroll をするので、以下のコードは要らない
//    //✍️横scrollの場合は、同じ列に属するcell間の上下spacingを指定する
//    //   縦scrollの場合は、同じ行に配置されたcell間の左右spacingを指定する
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}
