//
//  CarouselFlowLayout.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/26.
//

import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    // cellの列(縦、横両方可能)の流れ(Flow)に合わせてscrollされるとき、表示されるものを担当する
    // cellのsizeも実装できるclassである
    
    // 最初に一回だけprepare設定されるようにする
    private var firstTime: Bool = false
    
    override func prepare() {
        super.prepare()
        
        guard !firstTime else { return }
        
        guard let hasCollectionView = self.collectionView else {
            return
        }
        
        let collectionViewSize = hasCollectionView.bounds
        //itemSize: cellの基本サイズの設定
        itemSize = CGSize(width: 300, height: 200)
        
        let xInset = (collectionViewSize.width - itemSize.width) / 2
        self.sectionInset = UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset)
        
        scrollDirection = .horizontal
        // cellの間に使用する最小の間隔を設定
        // cellが小さくなると、もっと遠くにあるように見えるから、そうならないように使う
        minimumLineSpacing = 15
        
        firstTime = true
    }
    
    // layoutの変更が必要なのかを聞く間数
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // layoutの要素を持ってきて調整する間数
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superAttributes = super.layoutAttributesForElements(in: rect)
        
        superAttributes?.forEach { attributes in
            guard let hasCollectionView = self.collectionView else {
                return
            }
            
            // collectionViewのcenter値であり、変動がない固定値
            let collectionViewCenter = hasCollectionView.frame.size.width / 2
            // offsetX: ユーザがscrollするとき、基準点から移動したx軸の距離
            let offsetX = hasCollectionView.contentOffset.x
            // center: 各cellの中央値
            // 基本のcenter値は、最初にcollectionViewがloadされるときの値であるため、ここからoffsetXを引いて動的に計算するように
            let center = attributes.center.x - offsetX
            // maxDistance: それぞれのアイテムの中央値と中央値間の距離
            let maxDistance = self.itemSize.width + self.minimumLineSpacing
            // distance: 現在のcollectionViewの中央値からcellの中央値を引き、中央の0を基準に１まで計算するための値
            let distance = min(abs(collectionViewCenter - center), maxDistance)
            // ratio: 比率を求め、animationを与えるための値
            let ratio = (maxDistance - distance) / maxDistance
            let scale = ratio * (1 - 0.7) + 0.7
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return superAttributes
    }
}
