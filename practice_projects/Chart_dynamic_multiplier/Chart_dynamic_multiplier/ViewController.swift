//
//  ViewController.swift
//  Chart_dynamic_multiplier
//
//  Created by Kyus'lee on 2022/08/09.
//

import UIKit

// ❗️各viewのmultiplier値の動的な変更 -> codeとの連動
// heightに関して multiplierを用いて調節可能とさせたいとき
// 1. 新たなNSLayoutConstraintオブジェクトを生成 -> extensionを通して
// 2. それを適応する

// 新たなNSLayoutConstraintのオブジェクト
extension NSLayoutConstraint {
    func changeMultiplier(value: CGFloat) -> NSLayoutConstraint {
        // 該当のobjectが持つconstraintを全て非活性化する
        // これがないと、新しく設定した値が累積されるので、正常に反映されない
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint.init(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: value, constant: self.constant)
        
        // 既存に持っているpriorityも指定
        newConstraint.priority = self.priority
        //　shouldBeArchived: Constraint制約を該当のobjectが所有するviewでアーカイブするかどうかを決定するBool値。
        newConstraint.shouldBeArchived = self.shouldBeArchived
        // 既存に持っているidentifierも指定
        newConstraint.identifier = self.identifier
        
        // activate: 新たに設定したconstraintsを反映(活性化)する
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var graph1Height: NSLayoutConstraint!
    @IBOutlet weak var graph2Height: NSLayoutConstraint!
    @IBOutlet weak var graph3Height: NSLayoutConstraint!
    @IBOutlet weak var graph4Height: NSLayoutConstraint!
    @IBOutlet weak var graph5Height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func graphStyle1(_ sender: Any) {
        // Storyboard上の初期値を表示
        
        // View転換するときのanimate効果を与える
        UIView.animate(withDuration: 0.4) {
            self.graph1Height = self.graph1Height.changeMultiplier(value: 0.5)
            self.graph2Height = self.graph2Height.changeMultiplier(value: 0.6)
            self.graph3Height = self.graph3Height.changeMultiplier(value: 0.7)
            self.graph4Height = self.graph4Height.changeMultiplier(value: 0.8)
            self.graph5Height = self.graph5Height.changeMultiplier(value: 0.9)
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func graphStyle2(_ sender: Any) {
        // 新たに設定したheight Multiplierが反映されたgraphがを表示
        newHeightMultiplier()
    }
    
    func newHeightMultiplier() {
      
        UIView.animate(withDuration: 0.4) {
            //        // constantとpriorityは、直接更新が容易である
            //        graph1Height.constant = 500
            //        graph1Height.priority = UILayoutPriority(rawValue: 700)
            //        // multiplierは、get-only propertyであるため、値を入力することができない
            ////        graph1Height.multiplier = 0.7
            self.graph1Height = self.graph1Height.changeMultiplier(value: 0.9)
            self.graph2Height = self.graph2Height.changeMultiplier(value: 0.8)
            self.graph3Height = self.graph3Height.changeMultiplier(value: 0.7)
            self.graph4Height = self.graph4Height.changeMultiplier(value: 0.6)
            self.graph5Height = self.graph5Height.changeMultiplier(value: 0.5)
            
            // 下記のコードがないと、animation効果が反映されない
            self.view.layoutIfNeeded()
        }
    }


}

