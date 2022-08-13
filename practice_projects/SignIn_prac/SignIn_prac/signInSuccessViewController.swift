//
//  signInSuccessViewController.swift
//  SignIn_prac
//
//  Created by Kyus'lee on 2022/08/10.
//

import UIKit

// emailとpasswordが正常な形式であるとき、sign in buttonを押すとき、表示される pop up view
// logic
// 1. email, pw が有効である値であるかを検査
// 2. Success: error labelが表示されなかったら、popup viewを表示する
// ⚠️途中の段階__ 3. Fail: error labelがまだ表示されているままに、buttonを押した -> toast message を表示

// success: popup viewを設定した時間だけ表示させる
// ただし、表示されているとき、他のviewをtapしてもpopup viewがdismiss されるように
class signInSuccessViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView! {
        didSet {
            // popupViewのborderを丸くする
            popupView.layer.cornerRadius = 30
            // popupViewのborderの太さを設定
            popupView.layer.borderWidth = 1
            // popupViewのborderの色を設定
            popupView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var successImage: UIImageView!
    
    var completeRotate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        successImageYRotate()
        
        // dismissに関して、時間のdurationを与えようとしたコード
        // ⚠️Error: 設定したwithDurationが効かない
        // 🌈 Solution: ---> まだ❗️
//        UIView.animate(withDuration: 5) {
//            self.dismiss(animated: true, completion: nil)
//        }
        
    }
    
    func successImageYRotate() {
        //Imageをy軸に180度回転するanimation　->これを再現することで、login successしたということを表す
        
        let imageYrotation = CABasicAnimation(keyPath: "transform.rotation.y")
        // 2回転するように
        imageYrotation.toValue = Double.pi * 2
        imageYrotation.repeatDuration = 3
        imageYrotation.repeatCount = 3
        imageYrotation.fillMode = .forwards
        imageYrotation.delegate = self
//        imageYrotation.isRemovedOnCompletion = false
        successImage.layer.add(imageYrotation, forKey: "rotationAnimation")
        // MARK: 回転のanimationが終わってからdismissするようにしたい
        
        // ⚠️Error: Animationが実行されている途中に completeRotate -> trueになる
        // 🌈 Solution: animationDidStopを使ってみよう
//        if !successImage.isAnimating {
//            completeRotate = true
//            print(completeRotate)
//        }
        
        
    }
    
    func tapDismiss() {
        
    }
    
    
    
    
    
}

extension signInSuccessViewController: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.dismiss(animated: true, completion: nil)
        print("dismiss - signInSuccessVC")
    }
}
