//
//  ViewController.swift
//  Custon_Floating_button
//
//  Created by Kyus'lee on 2022/07/18.
//

import UIKit


// Custom Floating Button 作成
class ViewController: UIViewController {
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    // 後ろviewがbluc処理されるようにしたい -> visual Effect with Blurを　VCに追加する
    // segueのデータ渡し方
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopup" {
            // as!: downCasting: 含まれている様々なTypeの中、下位Typeの一つを選択する概念
            let floatingVC = segue.destination as! FloatingButtonListViewController
            
            
            
            floatingVC.modalPresentationStyle = .overCurrentContext
            
            
        }
    }


}

