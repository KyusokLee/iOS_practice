//
//  TimerView.swift
//  AnymationTimer
//
//  Created by Kyus'lee on 2023/02/24.
//

import UIKit

final class TimerView: UIView {
    private enum Constant {
        // MARK: - imageとTimerViewの間に間隔を置きたい..
        static let spacing = 4.0
        static let lineWidth = 10.0
        static let startAngle = CGFloat(-Double.pi / 2)
        static let endAngle = CGFloat(3 * Double.pi / 2)
        static let backgroundStrokeColor = UIColor.systemBlue.withAlphaComponent(0.7).cgColor
        static let progressStrokeColor = UIColor.systemGray.cgColor
    }
    
    private let backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Constant.lineWidth
        layer.strokeEnd = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Constant.backgroundStrokeColor
        
        return layer
    }()
    
    private let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Constant.lineWidth
        layer.strokeEnd = 0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Constant.progressStrokeColor
        
        return layer
    }()
    
    // Viewの枠の位置を知るために必要なUIBeizerPathを定義
    // Runtime時に動的に決定されるframeの値を知るために、computed propertyとして宣言
    private var circularPath: UIBezierPath {
        UIBezierPath(
            arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2), //円弧の中心
            radius: self.frame.size.width / 2, // 半径
            startAngle: Constant.startAngle, // 開始角度
            endAngle: Constant.endAngle, // 終了角度
            clockwise: true // true: 時計回り, false: 反時計回り
        )
    }
    
    // コードベースで実装するので、initでlayerをaddSublayerする
    required init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.backgroundLayer.path = self.circularPath.cgPath
        self.progressLayer.path = self.circularPath.cgPath
        
        self.layer.addSublayer(self.backgroundLayer)
        self.layer.addSublayer(self.progressLayer)
    }
    
    // 重要Point: Viewのlayoutが変更されるたびに、layoutSublayers(of:)をoverrideして、ここでcircularPath呼び出し、
    // frameが決まるとき、path情報を持ってきてlayerに入力する
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundLayer.path = self.circularPath.cgPath
        self.progressLayer.path = self.circularPath.cgPath
    }
    
    // 外部でも、色とlineWidthを決定できるようにinterface用途のpropertyを追加
    // 下記のpropertyは、全て特立的な状態を持たずに、単純に値を引き渡したり、setのための用途なので、Computed propertyで定義
    var backgroundLayerColor: CGColor? {
        get { self.backgroundLayer.strokeColor }
        set { self.backgroundLayer.strokeColor = newValue }
    }
    var progressLayerColor: CGColor? {
        get { self.progressLayer.strokeColor }
        set { self.progressLayer.strokeColor = newValue }
    }
    var lineWidth: CGFloat {
        get { self.backgroundLayer.lineWidth }
        set { self.backgroundLayer.lineWidth = newValue }
    }
    
    // xibを使わずに、コードで実装する場合、普通は required init?でfatalErrorを発生するように設定する
    // しかし、これはruntime errorを発生するコードである
    // 一方で、available(*, unavailable)をつけると、Compile timeにerrorを発生させるので、より良いコードである
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 入力された時間だけ、Animationが動作できるようにstart(duration)のメソッドを定義
    func startAnimation(duration: TimeInterval) {
        self.progressLayer.removeAnimation(forKey: "progress")
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        self.progressLayer.add(circularProgressAnimation, forKey: "progress")
    }
    
}
