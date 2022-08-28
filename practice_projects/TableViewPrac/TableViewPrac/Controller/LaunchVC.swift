//
//  LaunchVC.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/28.
//

import UIKit
import Lottie

class LaunchVC: UIViewController {
    private var startAnimationView = AnimationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimationView = setAnimationView()
        self.view.addSubview(startAnimationView)
        
        // animationが終わったらmainVCが表示されるように！
        startAnimationView.play { (finish) in
            print("Animation finished!")
            // animationView 削除
            self.startAnimationView.removeFromSuperview()
        }
    }
    
    func setAnimationView() -> AnimationView {
        let animationView: AnimationView = .init(name: "6052-checklist")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: self.view.bounds.height / 2)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
