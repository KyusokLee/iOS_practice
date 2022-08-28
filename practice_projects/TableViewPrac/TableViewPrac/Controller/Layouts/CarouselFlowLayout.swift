//
//  CarouselFlowLayout.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/26.
//

import UIKit

// ⚠️Error: ここで、modifying attributes Errorが出てしまった
//CarouselFlowLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them

// ⚠️Error2: mismatch for index path <NSIndexPath: 0x9eb6fc73f647a0b1> {length = 2, path = 0 - 1} - cached value: {{405, 40}, {210, 140}}; expected value: {{360, 10}, {300, 200}}

class CarouselFlowLayout: UICollectionViewFlowLayout {
    // cellの列(縦、横両方可能)の流れ(Flow)に合わせてscrollされるとき、表示されるものを担当する
    // cellのsizeも実装できるclassである
    
    // 最初に一回だけprepare設定されるようにする
    private var firstTime: Bool = false
    public var spacing: CGFloat = 15
    public var sideItemScale: CGFloat = 0.7
    public var sideItemAlpha: CGFloat = 0.7
    
    override func prepare() {
        super.prepare()
        guard !firstTime else { return }
        
        guard let hasCollectionView = self.collectionView else {
            return
        }
        
        let collectionViewSize = hasCollectionView.bounds
        //itemSize: cellの基本サイズの設定
        itemSize = CGSize(width: 300, height: 200)
//
//        let totalCellWidth = cellWidth * models.count
//        let totalSpacingWidth = cellSpacing * (models.count - 1)
//        let xInset = (mealCollectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        
        self.sectionInset = UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset)
        
        let scaledItemOffset = (itemSize.width - itemSize.width * sideItemScale) / 2
        // cellの間に使用する最小の間隔を設定
        // cellが小さくなると、もっと遠くにあるように見えるから、そうならないように使う
        self.minimumLineSpacing = spacing - scaledItemOffset
        scrollDirection = .horizontal
        
        // 한번 cache 설정이 되고나서는 prepare 메소드를 다시 호출하지 않게끔!
        firstTime = true
    }
    
    // layoutの変更が必要なのかを聞く間数
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // layoutの要素を持ってきて調整する間数
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let hasCollectionView = collectionView, let superAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        // NSArray는 얕은 복사와 깊은 복사를 지원한다.
        // 얕은 복사: 메모리 주소를 복사한다 -> 즉, 2개의 포인터가 똑같은 인스턴스를 가리키게 되는것
        // 깊은 복사: 새로운 메모리 공간을 할당하여 인스턴스의 값을 복사한다는 것 -> 서로 다른 공간의 메모리가 생기고, 두개의 포인터는 각각의 메모리 공간을 가리킴

        // copied 새로운 할당
        // 이 방법 이외의 방법이 없었다
        let copied = NSArray.init(array: superAttributes, copyItems: true) as! [UICollectionViewLayoutAttributes]
        copied.forEach { attributes in
            // collectionViewのcenter値であり、変動がない固定値
            let collectionViewCenter = hasCollectionView.frame.size.width / 2
            // offsetX: ユーザがscrollするとき、基準点から移動したx軸の距離
            let offsetX = hasCollectionView.contentOffset.x
            // center: 各cellの中央値
            // 基本のcenter値は、最初にcollectionViewがloadされるときの値であるため、ここからoffsetXを引いて動的に計算するように
            let center = attributes.center.x - offsetX
            // maxDistance: それぞれのアイテム間の中央値と中央値間の距離
            let maxDistance = self.itemSize.width + self.minimumLineSpacing
            // distance: 現在のcollectionViewの中央値からcellの中央値を引き、中央の0を基準に１まで計算するための値
            let distance = min(abs(collectionViewCenter - center), maxDistance)
            // ratio: 比率を求め、animationを与えるための値
            let ratio = (maxDistance - distance) / maxDistance
            
            let alpha = ratio * (1 - sideItemAlpha) + self.sideItemAlpha
            let scale = ratio * (1 - sideItemScale) + self.sideItemScale
            attributes.alpha = alpha
            
            let visibleRect = CGRect(origin: hasCollectionView.contentOffset, size: hasCollectionView.bounds.size)
            let dist = attributes.frame.midX - visibleRect.midX
            var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            transform = CATransform3DTranslate(transform, 0, 0, -abs(dist / 1000))
            attributes.transform3D = transform
//            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return copied
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let hasCollectionView = self.collectionView else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: hasCollectionView.frame.width, height: hasCollectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + hasCollectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

//// 에러가 난 방법
//override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    guard let hasCollectionView = collectionView else {
//        return nil
//    }
//
//    guard let superAttributes = super.layoutAttributesForElements(in: rect) else {
//        return nil
//    }
//
//    superAttributes.forEach { attributes in
//        // collectionViewのcenter値であり、変動がない固定値
//        let collectionViewCenter = hasCollectionView.frame.size.width / 2
//        // offsetX: ユーザがscrollするとき、基準点から移動したx軸の距離
//        let offsetX = hasCollectionView.contentOffset.x
//        // center: 各cellの中央値
//        // 基本のcenter値は、最初にcollectionViewがloadされるときの値であるため、ここからoffsetXを引いて動的に計算するように
//        let center = attributes.center.x - offsetX
//        // maxDistance: それぞれのアイテムの中央値と中央値間の距離
//        let maxDistance = self.itemSize.width + self.minimumLineSpacing
//        // distance: 現在のcollectionViewの中央値からcellの中央値を引き、中央の0を基準に１まで計算するための値
//        let distance = min(abs(collectionViewCenter - center), maxDistance)
//        // ratio: 比率を求め、animationを与えるための値
//        let ratio = (maxDistance - distance) / maxDistance
//        let scale = ratio * (1 - 0.7) + 0.7
//        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
//    }
//
//    return superAttributes
//}



//override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let collectionView = collectionView,
//            let origin = super.layoutAttributesForElements(in: rect) else { return nil }
//        // copy一份原数据
//        let copied = NSArray.init(array: origin, copyItems: true) as! [UICollectionViewLayoutAttributes]
//        for atts in copied {
//            /**
//             在这里对Attributes进行修改。
//             修改的是copy后的Attributes，不是直接通过super.layoutAttributesForElements(in: rect)获取的数据，
//             也就不会有警告了。
//             */
//        }
//
//        return copied
//    }
