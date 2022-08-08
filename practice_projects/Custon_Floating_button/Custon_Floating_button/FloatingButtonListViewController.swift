//
//  FloatingButtonListViewController.swift
//  Custon_Floating_button
//
//  Created by Kyus'lee on 2022/08/05.
//

import UIKit

class FloatingButtonListViewController: UIViewController {
    
//    // Buttonの回転状態を入れた変数
//    // segueを通した表示されたから、ここのviewが表示される時点で、rotate はtrueになっている
//    var isRotated: Bool = true
    
    @IBOutlet weak var btn1CenterY: NSLayoutConstraint!
    
    @IBOutlet weak var btn2CenterY: NSLayoutConstraint!
    
    @IBOutlet weak var btn3CenterY: NSLayoutConstraint!
    
    @IBOutlet weak var rotateButton: UIButton!
    
//    var rotateButtonState = ButtonState.presentFloating {
//        didSet {
//            changeDesign()
//        }
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn1CenterY.constant = 0
        btn2CenterY.constant = 0
        btn3CenterY.constant = 0
        
    }
    
    // 全部objectが描かれた後の life cycle
    // デバイスを実行して、画面が目に見える時点が、viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // animation 処理
        // closureの中は、selfの定義が絶対必要
//        UIView.animate(withDuration: 0.5) {
//            self.btn1CenterY.constant = 80
//            self.btn2CenterY.constant = 160
//            self.btn3CenterY.constant = 240
//            //画面の更新
//            self.view.layoutIfNeeded()
//        }
        
        // 🎖追加的に  Buttonにrotateのanimation効果を与えたい
        // 画面が全部表示されたときのここにするべき
        // ⚠️注意: 今回の場合、segueで連動したため、このVCが開かれるとたんに、animateが実行されるべきである。そのため、buttonのstateに関係なく、すぐ回転するようなanimationを与えた
        // ⚠️Error: 45度の回転をしたいのに、image全体が立体的に45度回転してしまう
        // なぜだ。。？
        
//        // 45度回転したあと、すぐ戻る
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAnimation.toValue = CGFloat(Double.pi / 180) * 45
//        rotationAnimation.duration = 0.3
//
//        rotateButton.layer.add(rotationAnimation, forKey: "rotationAnimation")
    
//        // 90度の場合、正常動作の確認ができた
//        UIView.animate(withDuration: 0.3) {
//            self.rotateButton.imageView?.transform = CGAffineTransform(rotationAngle: .pi / 2)
//
//        }
        
//        // 🌈 Error 解決: Core Animation効果で解決できる
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi / 4 //45度
        rotation.duration = 0.2
        // MARK: 🔥以下の fillMode と isRemovedOnCompletionを設定しないと、Core Animationは、UIKitとは違って元々の状態に戻ってしまう。
        // fillmode: duration（animationの持続時間）が終わったら、そのまま固定させるか、除去するかを決める
        // .forwards: animationがcompletedされた状態を保つように
        // isRemovedOnCompletion: completionのとき、Animationが対象のlayerのanimationから除去されるかどうかを決める -> animationが終わった後の形を保ちたいのであれば、falseに
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        rotateButton.layer.add(rotation, forKey: "rotationAnimation")
        
        
        // 揺れるようなanimation (usingSpringWithDamping)
        // usingSpringWithDampingの値が0に近いほど、大きな揺れのanimationが再現される
        // initialSpringVelocity: 自然なanimation効果を与えるのは 0.5が標準
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut) {
            self.btn1CenterY.constant = 80
            self.btn2CenterY.constant = 160
            self.btn3CenterY.constant = 240
            //画面の更新
            self.view.layoutIfNeeded()
        } completion: { Bool in
            // アニメーションが終わる時点
        }

        
    }

    @IBAction func dismissFloating(_ sender: Any) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        // viewDidAppearで書いた設定値と逆にする

        rotation.fromValue = Double.pi / 4 //45度
        rotation.toValue = 0
        rotation.duration = 0.2
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        rotateButton.layer.add(rotation, forKey: "rotationAnimation")
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut) {
            self.btn1CenterY.constant = 0
            self.btn2CenterY.constant = 0
            self.btn3CenterY.constant = 0
            //画面の更新
            self.view.layoutIfNeeded()
        } completion: { Bool in
            // アニメーションが終わる時点
            // 画面がdismissされるのをここで書けばいい
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    @IBAction func food3Action(_ sender: Any) {
        print("food3 selected")
    }
    
//    func changeDesign() {
//        // 🎖追加的に  Buttonにrotateのanimation効果を与えたい
//        // 画面が全部表示されたときのここにするべき
//        UIView.animate(withDuration: 0.25) {
//            if self.rotateButtonState == .presentFloating {
//                self.rotateButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//            } else {
//                self.rotateButton.imageView?.transform = .identity
//            }
//        }
//    }
    
    
    

}