//
//  DiagonalCustomImageView.swift
//  CodeConnectNib
//
//  Created by Kyus'lee on 2022/08/09.
//

import UIKit

// IBDesignable -> Xcode上のinterface builderで(StoryBoard上で)すぐ確認できるようにする
// classの上に書いておく
// しかし、無分別でIBDesignableコードをいっぱい書くと、memoryが遅くなる原因にもなるから、要注意
@IBDesignable
class DiagonalCustomImageView: UIImageView {

    //　斜めの四角形を描く
    // UIBezierPath
    // 描くlogic
    // 1. スタート時点を指定する
    // 2. スタート時点から x , y軸の値に合わせて描く
    
    // path -> layer化する
    // 全てのオブジェクトにはlayerが存在する
    
    // layerを maskingする
    
    // 作ったcustom code -> storyboardの編集画面で、すぐ確認できるようにする
    
    // IBInspecable -> 書いた設定値の値をstoryboard上で設定できるようにする
    // 必ず、var typeに書く
    
    @IBInspectable var innerHeight: CGFloat = 0
    
    
    func makePath() -> UIBezierPath {
        // pathを生成
        let path = UIBezierPath()
        // move: スタート時点 (座標の設定)
        // 0, 0 に設定
//        path.move(to: CGPoint.init(x: 0, y: 0))
        path.move(to: CGPoint.zero)
        
        // addLine: 描く作業
        // 例) x: imageViewのwidth分
        //     yは、動かない
        // --> こうすると、スタート時点から絵を描くとき、右に一直線で描くようになる (y値の設定ないから)
        path.addLine(to: CGPoint.init(x: self.bounds.width, y: 0))
        // imageviewのheight分下に線を繋ぐ
        path.addLine(to: CGPoint.init(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint.init(x: 0, y: self.bounds.height - innerHeight))
        // スタート時点へ自動的に線を繋ぐ
        path.close()
        
        return path
    }
    
    // maskは、layerであるため、単なるpathだけでは使用不可能
    // そのため、作ったpathをlayerの形にする必要がある
    func pathToLayer() ->  CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        // returnされたpathをcgPathに定義する
        shapeLayer.path = makePath().cgPath
        return shapeLayer
    }
    
    func makeMask() {
        self.layer.mask = pathToLayer()
    }
    
    //ここまでだと、関数の宣言だけしたが、実際に呼び出されていない状態
    // そのため、このclassのobjectが描かれるときに実行される間数が必要 ---> layoutSubViews
    // 描かれるときに実行されるようにする関数
    override func layoutSubviews() {
        makeMask()
    }

}
