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
    
    @IBOutlet weak var explainTitleLabel: UILabel! {
        didSet {
            explainTitleLabel.font = customFont
        }
    }
    @IBOutlet weak var musicCollectionView: UICollectionView!
    // 直接TableViewCellのheightから、contentViewのheightを引いたものを設定するようにした
    private var cellHeightWithOutCollectionViewHeight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        musicCollectionView.register(UINib(nibName: VerticalCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: VerticalCollectionViewCell.cellID)
        musicCollectionView.isScrollEnabled = false
//        debugPrintCheck()
        cellHeightWithOutCollectionViewHeight = self.frame.height - self.musicCollectionView.frame.height
    }
    
    func debugPrintCheck() {
        // awakeFromNibの段階では、Xcode上で配置したUIの値が反映される
        // 要するに、UIがmemory上に載せられる時点のviewDidLoadと似たようなcycle
        print(self.frame.height)
        print(self.musicCollectionView.frame.height)
        print("systemLayoutSizeFitting 呼び出し 1")
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
//        // 基本のContentSizeを無効化する
        // これは、ここになくていい
//        musicCollectionView.invalidateIntrinsicContentSize()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    //intrinsicContentSize -> 中の内容を基盤にする固有のSize
    // sizeToFit()と同様
    
    // contentViewのlayoutSizeを計算してくれるメッソド
    // ✍️ scrollするとき、contentViewが見えてくるたびに呼び出される
    // 見えてる部分だけのlayout値を担当する
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // このtableviewcellのsubviewのlayoutを直ちに更新する
        // これがないと、ちょっと変なlayoutになる
        self.layoutIfNeeded()
//        debugPrintCheck()
        
        // collectionViewのcontentSize
        let contentSize = self.musicCollectionView.collectionViewLayout.collectionViewContentSize
        //✍️ heightは、tableViewCellのheightにcontentSizeのheightを足すことで、heightを設定せずにtableViewでautomaticDimensionを使うことができた
        return CGSize(width: contentSize.width, height: contentSize.height + cellHeightWithOutCollectionViewHeight)
        // self.frame.heightを足すと、だんだん足されてしまうことがわかった
    }
}

extension VerticalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.cellID, for: indexPath) as! VerticalCollectionViewCell
        
        let model = models[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    
}

extension VerticalTableViewCell: UICollectionViewDelegateFlowLayout {
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

// customFlowlayout을 잘 적용할 수 없었다....
