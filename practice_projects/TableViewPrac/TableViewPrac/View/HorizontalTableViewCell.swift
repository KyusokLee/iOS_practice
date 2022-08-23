//
//  HorizontalTableViewCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import UIKit

class HorizontalTableViewCell: UITableViewCell {

    static let className = "HorizontalTableViewCell"
    static let cellID = "HorizontalTableViewCellID"
    
    @IBOutlet weak var mealCollectionView: UICollectionView!
    
    func configure() {
        // reloadDataの部分
        mealCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mealCollectionView.register(UINib(nibName: HorizontalCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HorizontalCollectionViewCell.cellID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HorizontalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.cellID, for: indexPath) as! HorizontalCollectionViewCell
        cell.configure()
        return cell
    }
    
    
}
