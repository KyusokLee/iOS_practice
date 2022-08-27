//
//  HorizontalTableViewCell.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/23.
//

import UIKit

// 横scrollの tableViewCellの設定
// TODO: carousel effect를 좀 더 부드러운 애니메이션 효과와 스크롤 효과를 곁들여서, 가운데로 오게끔하기
// logic: Custom flowlayout를 만들어서, collectionView가 있는 파일에, collectionViewlayout을 연동한다.

class HorizontalTableViewCell: UITableViewCell, UIScrollViewDelegate {

    static let className = "HorizontalTableViewCell"
    static let cellID = "HorizontalTableViewCellID"
//    // collection Viewに配置されるcellたちのサイズ変数
//    private let cellWidth: CGFloat = 300
//    private let cellHeight: CGFloat = 200
//    private let cellSpacing: CGFloat = 15
    private var models = [Meal]()
    
    @IBOutlet weak var explainTitleLabel: UILabel! {
        didSet {
            if let hasFont = customFont {
                explainTitleLabel.font = hasFont
            } else {
                explainTitleLabel.font = basicFont
            }
        }
    }
    
    @IBOutlet weak var mealCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCollectionView()
//        setupFlowLayout()
        mealCollectionView.register(UINib(nibName: HorizontalCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HorizontalCollectionViewCell.cellID)
        //　scrollの反応が速すぎることを防ぐ -> scrollするとき、早く減速するように
        mealCollectionView.decelerationRate = .fast
//        mealCollectionView.isPagingEnabled = false
        print(self.mealCollectionView.frame.width)
        print(self.mealCollectionView.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCollectionView() {
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        
        let customFlowLayout = CarouselFlowLayout()
        // flowLayoutを継承するように
        mealCollectionView.collectionViewLayout = customFlowLayout
        
        // scrollbar を書くす
        mealCollectionView.showsHorizontalScrollIndicator = false
    }
    
    // flowlayoutDelegateの継承なしで、cellのflowlayoutの設定を行う方法
//    func setupFlowLayout() {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        // delegate flowoutではなく、ここでsizeを指定すると、小さいcellになってしまう
//        flowLayout.itemSize = CGSize(width: 375, height: 250)
//        flowLayout.minimumLineSpacing = 15
//    }
    
    func configure(with models: [Meal]) {
        // reloadDataの部分
        self.models = models
        mealCollectionView.reloadData()
    }
    
////     🌈Corousel effectの実装__scrollの反応が速すぎることを防ぐ
////     Viewを単位にした1pageのscrollじゃなく、1つのcellを単位にしたpage Scrollにしたい場合
////     ⚠️ただし、cellの左右spacingがないか、同値でなければ適応されない
////     ScrollViewWillEndDragging: ユーザーがscrollをする際、deviceのscreenと指が離れたとき、呼び出されるメソッドである
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard let layout = self.mealCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//
//        // collectionView Item Size
//        let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludeSpacing
//        let index: Int
//
//        // scroll 方向check
//        if velocity.x > 0 {
//            index = Int(ceil(estimatedIndex))
//        } else if velocity.x < 0 {
//            index = Int(floor(estimatedIndex))
//        } else {
//            index = Int(round(estimatedIndex))
//        }
//
//        // Pagingされる座標の値をtargetContentOffsetに代入
//        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludeSpacing, y: 0)
//    }
}

// collectionViewのsizeを定めるため、UICollectionViewDelegateFlowLayoutも継承しなきゃいけない  -> これがないと、mainVCでtableViewCellのサイズは正しく表示されても、collectionViewのサイズは定められてないため、表示されないのである。

extension HorizontalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.cellID, for: indexPath) as! HorizontalCollectionViewCell
        let model = models[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

//extension HorizontalTableViewCell: UICollectionViewDelegateFlowLayout {
////         collectionViewのCellのsizeを設定する
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // horizontalも同じくrowでcellのindexにアクセスできた
////        if indexPath.row == 0 {
////            // この方法だと、naturalなscrollになってない
////            collectionView.contentInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
////        }
//
//        return CGSize(width: 300, height: 200)
//    }
//
//    // ✍️横scrollの場合は、cell間の左右spacingを指定する
//    //   縦scrollの場合は、cell間の上下spacingを指定する -> carouselFlowLayoutで設定した
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        let totalCellWidth = cellWidth * CGFloat(models.count)
////        let totalSpacingWidth = cellSpacing * CGFloat(models.count - 1)
////        let leftInset = (collectionView.frame.width - totalCellWidth + totalSpacingWidth) / 2
////        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
//    }
//
//    // ここでは、1行だけのscroll をするので、以下のコードは要らない
//    //✍️横scrollの場合は、同じ列に属するcell間の上下spacingを指定する
//    //   縦scrollの場合は、同じ行に配置されたcell間の左右spacingを指定する
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}

