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

    @IBOutlet weak var musicCollectionView: UICollectionView!
    
    func configure() {
        // reloadの部分
        musicCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        musicCollectionView.register(UINib(nibName: VerticalCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: VerticalCollectionViewCell.cellID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension VerticalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell内のpropertyを利用するので、type casting しなくていい
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.cellID, for: indexPath)
        
        return cell
    }
    
    
}
